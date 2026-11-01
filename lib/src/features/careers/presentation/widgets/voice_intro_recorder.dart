import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:etbaly/src/imports/core_imports.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart'
    show openAppSettings;
import 'package:record/record.dart';

/// A finished voice introduction, kept in the app's temporary folder until the
/// recorder that made it is disposed.
class VoiceIntroRecording {
  const VoiceIntroRecording({
    required this.path,
    required this.recordedAt,
    required this.duration,
  });

  final String path;

  /// When the recording was finished, in UTC.
  final DateTime recordedAt;
  final Duration duration;

  /// AAC in an MP4 container, which the careers API accepts on every platform.
  String get fileName => 'introduction.m4a';
}

/// `2026-11-01T09:30:12.345Z` — the exact shape the careers API reads for
/// `voice_recorded_at` (it ignores anything else and uses the receipt time).
String voiceRecordedAtIso(DateTime time) {
  final u = time.toUtc();
  String two(int v) => v.toString().padLeft(2, '0');
  return '${u.year.toString().padLeft(4, '0')}-${two(u.month)}-${two(u.day)}'
      'T${two(u.hour)}:${two(u.minute)}:${two(u.second)}'
      '.${u.millisecond.toString().padLeft(3, '0')}Z';
}

/// `mm:ss`, for the recording timer and the preview player.
String voiceClock(Duration d) {
  final total = d.inSeconds < 0 ? 0 : d.inSeconds;
  final minutes = total ~/ 60;
  final seconds = total % 60;
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}

/// The careers form's voice introduction, like the website's recorder: record,
/// stop, listen back and record again. Works the same on Android and iOS
/// (microphone permission, AAC `.m4a` output).
class VoiceIntroRecorder extends StatefulWidget {
  const VoiceIntroRecorder({
    super.key,
    required this.isArabic,
    required this.onChanged,
    required this.onRecordingChanged,
    this.showRequiredError = false,
    this.enabled = true,
  });

  final bool isArabic;

  /// The finished recording, or null when there is none (yet).
  final ValueChanged<VoiceIntroRecording?> onChanged;

  /// True while the microphone is recording.
  final ValueChanged<bool> onRecordingChanged;

  /// The form was submitted without a finished recording.
  final bool showRequiredError;
  final bool enabled;

  @override
  State<VoiceIntroRecorder> createState() => _VoiceIntroRecorderState();
}

class _VoiceIntroRecorderState extends State<VoiceIntroRecorder>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  /// Long enough for any introduction while keeping the upload small
  /// (about 0.5 MB a minute at 64 kbps).
  static const _maxDuration = Duration(minutes: 5);
  static const _barCount = 24;
  static const _green = Color(0xFF22C55E);

  final _recorder = AudioRecorder();
  final _player = AudioPlayer();
  late final AnimationController _motion;

  final _subscriptions = <StreamSubscription<dynamic>>[];
  StreamSubscription<Amplitude>? _amplitude;
  Timer? _ticker;

  /// Bumped whenever an in-flight start must be abandoned.
  int _generation = 0;
  DateTime? _startedAt;
  Duration _elapsed = Duration.zero;
  bool _starting = false;
  bool _recording = false;
  bool _autoStopped = false;
  bool _permissionBlocked = false;
  String _error = '';
  final List<double> _levels = List<double>.filled(_barCount, 0);

  VoiceIntroRecording? _result;
  bool _playing = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  bool get _ar => widget.isArabic;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _motion = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 950));
    // Keep the source loaded after it finishes so it can be played again.
    unawaited(_player.setReleaseMode(ReleaseMode.stop));
    _subscriptions.addAll([
      _player.onPlayerStateChanged.listen((state) {
        if (mounted) setState(() => _playing = state == PlayerState.playing);
      }),
      _player.onPositionChanged.listen((position) {
        if (mounted) setState(() => _position = position);
      }),
      _player.onDurationChanged.listen((duration) {
        if (mounted && duration > Duration.zero) {
          setState(() => _duration = duration);
        }
      }),
      _player.onPlayerComplete.listen((_) {
        if (mounted) {
          setState(() {
            _playing = false;
            _position = Duration.zero;
          });
        }
      }),
    ]);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Leaving the app ends the take (the system would mute the microphone in
    // the background anyway); what was recorded so far is kept.
    if (state == AppLifecycleState.paused) {
      if (_recording) unawaited(_stop());
      if (_playing) unawaited(_player.pause());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _generation++;
    _ticker?.cancel();
    _amplitude?.cancel();
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _motion.dispose();
    if (_recording) unawaited(_recorder.cancel());
    unawaited(_recorder.dispose());
    unawaited(_player.dispose());
    _deleteFile(_result?.path);
    super.dispose();
  }

  void _deleteFile(String? path) {
    if (path == null) return;
    unawaited(() async {
      try {
        final file = File(path);
        if (await file.exists()) await file.delete();
      } catch (_) {
        // A leftover temporary file is harmless; the OS clears the cache.
      }
    }());
  }

  /// Drops the current take (if any) before a new one.
  Future<void> _discard() async {
    final previous = _result;
    if (previous == null) return;
    try {
      await _player.stop();
    } catch (_) {}
    _deleteFile(previous.path);
    setState(() {
      _result = null;
      _playing = false;
      _position = Duration.zero;
      _duration = Duration.zero;
    });
    widget.onChanged(null);
  }

  Future<void> _start() async {
    if (_starting || _recording || !widget.enabled) return;
    await _discard();
    final generation = ++_generation;
    setState(() {
      _starting = true;
      _error = '';
      _permissionBlocked = false;
      _autoStopped = false;
    });
    try {
      final allowed = await _recorder.hasPermission();
      if (!mounted || generation != _generation) return;
      if (!allowed) {
        setState(() {
          _starting = false;
          _permissionBlocked = true;
          _error = _ar
              ? 'اسمح للتطبيق باستخدام الميكروفون علشان تقدر تسجّل تعريفك الصوتي.'
              : 'Allow microphone access so you can record your voice introduction.';
        });
        return;
      }
      final dir = await getTemporaryDirectory();
      final path =
          '${dir.path}/career_voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 64000,
          sampleRate: 44100,
          numChannels: 1,
        ),
        path: path,
      );
      if (!mounted || generation != _generation) {
        unawaited(_recorder.cancel());
        return;
      }
      _startedAt = DateTime.now();
      _levels.fillRange(0, _barCount, 0);
      _amplitude = _recorder
          .onAmplitudeChanged(const Duration(milliseconds: 110))
          .listen(_onAmplitude, onError: (_) {});
      _ticker = Timer.periodic(const Duration(milliseconds: 250), (_) {
        final started = _startedAt;
        if (!mounted || started == null) return;
        final elapsed = DateTime.now().difference(started);
        if (elapsed >= _maxDuration) {
          unawaited(_stop(auto: true));
          return;
        }
        if (elapsed.inSeconds != _elapsed.inSeconds) {
          setState(() => _elapsed = elapsed);
        }
      });
      setState(() {
        _starting = false;
        _recording = true;
        _elapsed = Duration.zero;
      });
      _motion.repeat(reverse: true);
      widget.onRecordingChanged(true);
    } catch (_) {
      if (!mounted || generation != _generation) return;
      setState(() {
        _starting = false;
        _recording = false;
        _error = _ar
            ? 'تعذر تسجيل الصوت، حاول مرة تانية.'
            : 'Recording failed. Please try again.';
      });
      widget.onRecordingChanged(false);
    }
  }

  void _onAmplitude(Amplitude amplitude) {
    if (!mounted || !_recording) return;
    // dBFS: about -45 is quiet speech, 0 is the loudest.
    final level = ((amplitude.current + 45) / 45).clamp(0.0, 1.0).toDouble();
    setState(() {
      _levels.removeAt(0);
      _levels.add(level);
    });
  }

  Future<void> _stop({bool auto = false}) async {
    if (!_recording) return;
    _ticker?.cancel();
    _ticker = null;
    await _amplitude?.cancel();
    _amplitude = null;
    final started = _startedAt ?? DateTime.now();
    String? path;
    try {
      path = await _recorder.stop();
    } catch (_) {
      path = null;
    }
    final elapsed = DateTime.now().difference(started);
    _motion.stop();
    if (!mounted) {
      _deleteFile(path);
      return;
    }

    var usable = false;
    if (path != null) {
      try {
        final file = File(path);
        usable = await file.exists() && await file.length() > 0;
      } catch (_) {
        usable = false;
      }
    }
    if (!mounted) return;

    final result = usable
        ? VoiceIntroRecording(
            path: path!, recordedAt: DateTime.now().toUtc(), duration: elapsed)
        : null;
    if (!usable) _deleteFile(path);
    setState(() {
      _recording = false;
      _result = result;
      _autoStopped = auto && usable;
      _error = usable
          ? ''
          : (_ar
              ? 'التسجيل فارغ. حاول تاني.'
              : 'The recording is empty. Try again.');
      _position = Duration.zero;
      _duration = elapsed;
      _playing = false;
    });
    widget.onRecordingChanged(false);
    widget.onChanged(result);
    if (result != null) {
      try {
        await _player.setSourceDeviceFile(result.path);
      } catch (_) {}
    }
  }

  Future<void> _togglePlayback() async {
    final result = _result;
    if (result == null || _recording) return;
    try {
      if (_playing) {
        await _player.pause();
      } else {
        if (_player.source == null) {
          await _player.setSourceDeviceFile(result.path);
        }
        await _player.resume();
      }
    } catch (_) {
      if (mounted) {
        setState(() => _error =
            _ar ? 'تعذر تشغيل التسجيل.' : 'The recording could not be played.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.etbalyColors;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final iconGreen = dark ? _green : const Color(0xFF15803D);
    final requiredError =
        widget.showRequiredError && _result == null && !_recording;
    final message = _error.isNotEmpty
        ? _error
        : requiredError
            ? (_ar
                ? 'التسجيل الصوتي مطلوب قبل إرسال الطلب.'
                : 'A voice introduction is required before submitting.')
            : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Introduction
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: requiredError
                  ? const Color(0xFFEF4444)
                  : _green.withValues(alpha: 0.25),
              width: requiredError ? 1.4 : 1,
            ),
            gradient: LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: [
                _green.withValues(alpha: 0.10),
                _green.withValues(alpha: 0)
              ],
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: _green.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Center(
                    child:
                        Icon(Icons.mic_rounded, color: iconGreen, size: 24.sp)),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: _ar
                            ? 'سجّل تعريف صوتي عن نفسك'
                            : 'Record your voice introduction',
                        children: const [
                          TextSpan(
                              text: ' *',
                              style: TextStyle(color: Color(0xFFEF4444))),
                        ],
                      ),
                      style: TextStyle(
                        color: c.textMain,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      _ar
                          ? 'عرّفنا بنفسك وخبرتك وراجع التسجيل قبل إرسال الطلب.'
                          : 'Introduce yourself and your experience, then review your recording before submitting.',
                      style: TextStyle(
                          color: c.textMuted, fontSize: 11.5.sp, height: 1.7),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_recording) ...[
          SizedBox(height: 12.h),
          _buildWave(context),
        ],
        SizedBox(height: 12.h),
        Wrap(
          spacing: 12.w,
          runSpacing: 10.h,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _RecorderButton(
              icon: _recording ? Icons.stop_rounded : Icons.mic_rounded,
              label: _recording
                  ? (_ar ? 'إيقاف التسجيل' : 'Stop recording')
                  : _starting
                      ? (_ar
                          ? 'جاري فتح الميكروفون...'
                          : 'Opening microphone...')
                      : _result != null
                          ? (_ar ? 'إعادة التسجيل' : 'Record again')
                          : (_ar ? 'ابدأ التسجيل' : 'Start recording'),
              busy: _starting,
              enabled: widget.enabled && !_starting,
              onTap: _recording
                  ? () => unawaited(_stop())
                  : () => unawaited(_start()),
            ),
          ],
        ),
        if (_result != null && !_recording) ...[
          SizedBox(height: 12.h),
          _buildPreview(context),
        ],
        if (_autoStopped) ...[
          SizedBox(height: 8.h),
          Text(
            _ar
                ? 'وقفنا التسجيل عند ${_maxDuration.inMinutes} دقايق. تقدر تسمعه أو تسجّل من جديد.'
                : 'Recording stopped at ${_maxDuration.inMinutes} minutes. You can listen to it or record again.',
            style: TextStyle(color: c.textMuted, fontSize: 11.sp, height: 1.5),
          ),
        ],
        if (message.isNotEmpty) ...[
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: Icon(Icons.error_outline_rounded,
                    size: 14.sp, color: const Color(0xFFEF4444)),
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: const Color(0xFFEF4444),
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
          if (_permissionBlocked)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                onPressed: () => unawaited(openAppSettings()),
                icon: Icon(Icons.settings_rounded, size: 16.sp),
                label: Text(_ar ? 'فتح إعدادات التطبيق' : 'Open app settings'),
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildWave(BuildContext context) {
    final c = context.etbalyColors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Color.lerp(c.borderColor, _green, 0.3)!),
        color: _green.withValues(alpha: 0.07),
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _motion,
            builder: (context, _) => Container(
              width: 9.r,
              height: 9.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _green,
                boxShadow: [
                  BoxShadow(
                    color:
                        _green.withValues(alpha: 0.13 + 0.17 * _motion.value),
                    spreadRadius: 4.r,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            _ar ? 'جاري التسجيل' : 'Recording',
            style: TextStyle(
                color: c.textMain,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: SizedBox(
              height: 32.h,
              child: RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _motion,
                  builder: (context, _) => CustomPaint(
                    painter: _WavePainter(
                      levels: List<double>.of(_levels),
                      phase: _motion.value,
                      color: const Color(0xFF36CF80),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            voiceClock(_elapsed),
            textDirection: TextDirection.ltr,
            style: TextStyle(
              color: const Color(0xFF42DC91),
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview(BuildContext context) {
    final c = context.etbalyColors;
    final total = _duration > Duration.zero
        ? _duration
        : (_result?.duration ?? Duration.zero);
    final maxMs = math.max(1, total.inMilliseconds).toDouble();
    final value = _position.inMilliseconds.clamp(0, maxMs.toInt()).toDouble();

    return Container(
      padding: EdgeInsets.fromLTRB(6.w, 6.h, 12.w, 6.h),
      decoration: BoxDecoration(
        color: c.bgSubtle,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: c.borderColor),
      ),
      child: Directionality(
        // Playback controls read left to right in both languages.
        textDirection: TextDirection.ltr,
        child: Row(
          children: [
            Semantics(
              button: true,
              label: _ar
                  ? 'معاينة التسجيل التعريفي'
                  : 'Preview voice introduction',
              child: Material(
                color: c.primary,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => unawaited(_togglePlayback()),
                  child: SizedBox(
                    width: 40.r,
                    height: 40.r,
                    child: Icon(
                      _playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 3,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 12.r),
                ),
                child: Slider(
                  value: value,
                  max: maxMs,
                  activeColor: c.primary,
                  inactiveColor: c.borderColor,
                  onChanged: (v) {
                    setState(
                        () => _position = Duration(milliseconds: v.round()));
                    unawaited(_player.seek(Duration(milliseconds: v.round())));
                  },
                ),
              ),
            ),
            Text(
              '${voiceClock(_position)} / ${voiceClock(total)}',
              style: TextStyle(
                color: c.textMuted,
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecorderButton extends StatelessWidget {
  const _RecorderButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.busy = false,
    this.enabled = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool busy;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF1A0A3A);
    return Opacity(
      opacity: enabled ? 1 : 0.6,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        behavior: HitTestBehavior.opaque,
        child: Container(
          constraints: BoxConstraints(minHeight: 48.h),
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFD4AF37), Color(0xFFFBBF24), Color(0xFFD4AF37)],
            ),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                  color: const Color(0x44D4AF37),
                  blurRadius: 14.r,
                  offset: Offset(0, 5.h)),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (busy)
                SizedBox(
                  width: 16.r,
                  height: 16.r,
                  child: const CircularProgressIndicator(
                      strokeWidth: 2, color: ink),
                )
              else
                Icon(icon, color: ink, size: 19.sp),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                      color: ink,
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Live level bars: each bar is a recent microphone level, with a gentle idle
/// motion so the bars never look frozen during a pause.
class _WavePainter extends CustomPainter {
  const _WavePainter(
      {required this.levels, required this.phase, required this.color});

  final List<double> levels;
  final double phase;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (levels.isEmpty) return;
    const barWidth = 3.0;
    final gap = (size.width - barWidth * levels.length) / (levels.length - 1);
    final spacing = gap.clamp(1.5, 6.0);
    final used = barWidth * levels.length + spacing * (levels.length - 1);
    var x = (size.width - used) / 2;
    final paint = Paint()..color = color;
    for (var i = 0; i < levels.length; i++) {
      final idle =
          0.2 + 0.16 * (0.5 + 0.5 * math.sin(2 * math.pi * (phase + i * 0.13)));
      final level = math.max(idle, levels[i]);
      final height = (size.height * level).clamp(4.0, size.height);
      final top = (size.height - height) / 2;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(x, top, barWidth, height), const Radius.circular(2)),
        paint..color = color.withValues(alpha: 0.6 + 0.4 * level),
      );
      x += barWidth + spacing;
    }
  }

  @override
  bool shouldRepaint(_WavePainter old) =>
      old.phase != phase || old.levels != levels;
}
