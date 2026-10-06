import 'package:etbaly/src/imports/core_imports.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Keeps only digits, converting Arabic-Indic / Persian digits to Latin ones.
String latinDigitsOnly(String value) {
  const arabic = '٠١٢٣٤٥٦٧٨٩';
  const persian = '۰۱۲۳۴۵۶۷۸۹';
  final out = StringBuffer();
  for (final rune in value.runes) {
    final ch = String.fromCharCode(rune);
    final a = arabic.indexOf(ch);
    final p = persian.indexOf(ch);
    if (a >= 0) {
      out.write(a);
    } else if (p >= 0) {
      out.write(p);
    } else if (rune >= 0x30 && rune <= 0x39) {
      out.write(ch);
    }
  }
  return out.toString();
}

String _two(int value) => value.toString().padLeft(2, '0');

/// `YYYY-MM-DD` for a real date that is not in the future nor over 120 years
/// ago, or an empty string. [today] is the date in Cairo.
String birthdayIso(String day, String month, String year, DateTime today) {
  if (day.isEmpty || month.isEmpty || year.length != 4) return '';
  final d = int.tryParse(day);
  final m = int.tryParse(month);
  final y = int.tryParse(year);
  if (d == null || m == null || y == null) return '';
  final probe = DateTime.utc(y, m, d);
  if (probe.year != y || probe.month != m || probe.day != d) return '';
  final iso = '${year.padLeft(4, '0')}-${_two(m)}-${_two(d)}';
  final todayIso =
      '${today.year.toString().padLeft(4, '0')}-${_two(today.month)}-${_two(today.day)}';
  if (iso.compareTo(todayIso) > 0 || y < today.year - 120) return '';
  return iso;
}

/// Whole years between [iso] (`YYYY-MM-DD`) and [today], or null when [iso] is
/// not a real date in the past.
int? birthdayAge(String? iso, DateTime today) {
  final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(iso ?? '');
  if (match == null) return null;
  final y = int.parse(match.group(1)!);
  final m = int.parse(match.group(2)!);
  final d = int.parse(match.group(3)!);
  final probe = DateTime.utc(y, m, d);
  if (probe.year != y || probe.month != m || probe.day != d) return null;
  final todayDate = DateTime.utc(today.year, today.month, today.day);
  if (probe.isAfter(todayDate)) return null;
  final hadBirthday = today.month > m || (today.month == m && today.day >= d);
  return today.year - y - (hadBirthday ? 0 : 1);
}

/// The website's accepted range for job applicants.
bool validApplicantBirthDate(String iso, DateTime today) {
  final age = birthdayAge(iso, today);
  return age != null && age >= 18 && age <= 40;
}

const _signs = <(int, String, String, String)>[
  (120, 'الجدي', 'Capricorn', '♑'),
  (219, 'الدلو', 'Aquarius', '♒'),
  (321, 'الحوت', 'Pisces', '♓'),
  (420, 'الحمل', 'Aries', '♈'),
  (521, 'الثور', 'Taurus', '♉'),
  (621, 'الجوزاء', 'Gemini', '♊'),
  (723, 'السرطان', 'Cancer', '♋'),
  (823, 'الأسد', 'Leo', '♌'),
  (923, 'العذراء', 'Virgo', '♍'),
  (1023, 'الميزان', 'Libra', '♎'),
  (1122, 'العقرب', 'Scorpio', '♏'),
  (1222, 'القوس', 'Sagittarius', '♐'),
];

/// "♑ الجدي" for a date `YYYY-MM-DD`; empty when the date is not valid.
String birthdaySign(String iso, {required bool arabic}) {
  if (iso.length != 10) return '';
  final monthDay = int.tryParse(iso.substring(5).replaceAll('-', ''));
  if (monthDay == null) return '';
  final sign =
      _signs.firstWhere((s) => monthDay < s.$1, orElse: () => _signs.first);
  return '${sign.$4} ${arabic ? sign.$2 : sign.$3}';
}

const _monthsAr = [
  'يناير',
  'فبراير',
  'مارس',
  'أبريل',
  'مايو',
  'يونيو',
  'يوليو',
  'أغسطس',
  'سبتمبر',
  'أكتوبر',
  'نوفمبر',
  'ديسمبر',
];
const _monthsEn = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

/// Date of birth as three boxes — day, month and year — like the website's
/// application form. Typing moves on by itself, Backspace in an empty box steps
/// back, and the age and zodiac sign appear once the date is complete.
///
/// [onChanged] gets `YYYY-MM-DD` once the boxes make a real date in the past
/// and an empty string otherwise.
class BirthdayField extends StatefulWidget {
  const BirthdayField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.today,
    required this.isArabic,
    required this.label,
    required this.hint,
    this.invalid = false,
    this.errorText = '',
  });

  /// `YYYY-MM-DD`, or empty. Anything set here that the field did not just
  /// report itself (like a form reset) replaces the boxes.
  final String value;
  final ValueChanged<String> onChanged;

  /// Today in Cairo; decides what counts as the future and the age.
  final DateTime today;
  final bool isArabic;
  final String label;
  final String hint;

  /// A problem the form found (for example "age must be 18–40").
  final bool invalid;
  final String errorText;

  @override
  State<BirthdayField> createState() => _BirthdayFieldState();
}

class _BirthdayFieldState extends State<BirthdayField> {
  final _day = TextEditingController();
  final _month = TextEditingController();
  final _year = TextEditingController();
  final _dayFocus = FocusNode();
  final _monthFocus = FocusNode();
  final _yearFocus = FocusNode();

  String _lastEmitted = '';

  /// The three boxes are full but are not a real date in the past.
  bool _malformed = false;

  @override
  void initState() {
    super.initState();
    _syncFrom(widget.value.trim());
    _monthFocus.addListener(() => _padOnBlur(_month, _monthFocus));
    _dayFocus.addListener(() => _padOnBlur(_day, _dayFocus));
  }

  @override
  void didUpdateWidget(covariant BirthdayField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final incoming = widget.value.trim();
    if (incoming != _lastEmitted) _syncFrom(incoming);
  }

  @override
  void dispose() {
    for (final c in [_day, _month, _year]) {
      c.dispose();
    }
    for (final f in [_dayFocus, _monthFocus, _yearFocus]) {
      f.dispose();
    }
    super.dispose();
  }

  void _syncFrom(String incoming) {
    _lastEmitted = incoming;
    final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(incoming);
    _day.text = match?.group(3) ?? '';
    _month.text = match?.group(2) ?? '';
    _year.text = match?.group(1) ?? '';
    _malformed = false;
  }

  String get _iso =>
      birthdayIso(_day.text, _month.text, _year.text, widget.today);

  void _update() {
    final iso = _iso;
    final filled = _day.text.isNotEmpty &&
        _month.text.isNotEmpty &&
        _year.text.length == 4;
    // Only call it wrong once all three boxes are complete; half-typed is
    // just unfinished.
    setState(() => _malformed = filled && iso.isEmpty);
    if (iso != _lastEmitted) {
      _lastEmitted = iso;
      widget.onChanged(iso);
    }
  }

  void _onDay(String raw) {
    var day = latinDigitsOnly(raw);
    // A first digit above 3 can only be a single-digit day: pad it and move on.
    if (day.length == 1 && int.parse(day) > 3) day = '0$day';
    _setText(_day, day);
    _update();
    if (day.length == 2) _monthFocus.requestFocus();
  }

  void _onMonth(String raw) {
    var month = latinDigitsOnly(raw);
    if (month.length == 1 && int.parse(month) > 1) month = '0$month';
    _setText(_month, month);
    _update();
    if (month.length == 2) _yearFocus.requestFocus();
  }

  void _onYear(String raw) {
    _setText(_year, latinDigitsOnly(raw));
    _update();
  }

  void _setText(TextEditingController controller, String text) {
    if (controller.text == text) return;
    controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  void _padOnBlur(TextEditingController controller, FocusNode node) {
    if (node.hasFocus) return;
    final text = controller.text;
    if (text.length == 1 && text != '0') {
      _setText(controller, '0$text');
      _update();
    }
  }

  KeyEventResult _onKey(
      FocusNode previous, TextEditingController own, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        own.text.isEmpty) {
      previous.requestFocus();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.etbalyColors;
    final ar = widget.isArabic;
    final showError = widget.invalid || _malformed;
    final iso = _iso;
    final age = iso.isEmpty ? null : birthdayAge(iso, widget.today);
    final sign = iso.isEmpty ? '' : birthdaySign(iso, arabic: ar);

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: c.bgCard,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: showError
              ? const Color(0xFFEF4444)
              : c.gold.withValues(alpha: 0.42),
          width: showError ? 1.4 : 1,
        ),
        boxShadow: showError
            ? [BoxShadow(color: const Color(0x29EF4444), blurRadius: 10.r)]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13.r),
                  gradient: LinearGradient(
                    colors: [
                      c.gold.withValues(alpha: 0.28),
                      const Color(0x387E57C2)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                    child:
                        Icon(Icons.cake_rounded, color: c.gold, size: 20.sp)),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: widget.label,
                        children: const [
                          TextSpan(
                              text: ' *',
                              style: TextStyle(color: Color(0xFFEF4444))),
                        ],
                      ),
                      style: TextStyle(
                        color: showError ? const Color(0xFFEF4444) : c.textMain,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      widget.hint,
                      style: TextStyle(
                          color: c.textMuted, fontSize: 10.5.sp, height: 1.45),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          // Day first, as it is read: on the right in Arabic, on the left in English.
          Directionality(
            textDirection: ar ? TextDirection.rtl : TextDirection.ltr,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  flex: 2,
                  child: _Box(
                    label: ar ? 'اليوم' : 'Day',
                    hint: 'DD',
                    maxLength: 2,
                    controller: _day,
                    focusNode: _dayFocus,
                    invalid: showError,
                    onChanged: _onDay,
                    onKey: (_) => KeyEventResult.ignored,
                  ),
                ),
                const _Slash(),
                Expanded(
                  flex: 2,
                  child: _Box(
                    label: ar ? 'الشهر' : 'Month',
                    hint: 'MM',
                    maxLength: 2,
                    controller: _month,
                    focusNode: _monthFocus,
                    invalid: showError,
                    onChanged: _onMonth,
                    onKey: (e) => _onKey(_dayFocus, _month, e),
                  ),
                ),
                const _Slash(),
                Expanded(
                  flex: 3,
                  child: _Box(
                    label: ar ? 'السنة' : 'Year',
                    hint: 'YYYY',
                    maxLength: 4,
                    controller: _year,
                    focusNode: _yearFocus,
                    invalid: showError,
                    onChanged: _onYear,
                    onKey: (e) => _onKey(_monthFocus, _year, e),
                  ),
                ),
              ],
            ),
          ),
          if (age != null) ...[
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 6.h,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _Chip(
                  icon: Icons.hourglass_bottom_rounded,
                  text: '$age ${ar ? 'سنة' : 'years'}',
                  color: c.gold,
                ),
                if (sign.isNotEmpty) _Chip(text: sign, color: c.primary),
                _Chip(
                    text: _longDate(iso, ar), color: c.textMuted, plain: true),
              ],
            ),
          ],
          if (showError) ...[
            SizedBox(height: 10.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 1.h),
                  child: Icon(Icons.error_outline_rounded,
                      size: 14.sp, color: const Color(0xFFEF4444)),
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    widget.errorText.isNotEmpty
                        ? widget.errorText
                        : (ar
                            ? 'اكتب تاريخ ميلاد صحيحًا (يوم وشهر وسنة).'
                            : 'Enter a real date of birth (day, month and year).'),
                    style: TextStyle(
                      color: const Color(0xFFEF4444),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _longDate(String iso, bool ar) {
    final year = int.parse(iso.substring(0, 4));
    final month = int.parse(iso.substring(5, 7));
    final day = int.parse(iso.substring(8, 10));
    return '$day ${(ar ? _monthsAr : _monthsEn)[month - 1]} $year';
  }
}

class _Slash extends StatelessWidget {
  const _Slash();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 12.h),
      child: Text(
        '/',
        style: TextStyle(
          color: context.etbalyColors.textMuted.withValues(alpha: 0.6),
          fontSize: 22.sp,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}

class _Box extends StatelessWidget {
  const _Box({
    required this.label,
    required this.hint,
    required this.maxLength,
    required this.controller,
    required this.focusNode,
    required this.invalid,
    required this.onChanged,
    required this.onKey,
  });

  final String label;
  final String hint;
  final int maxLength;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool invalid;
  final ValueChanged<String> onChanged;
  final KeyEventResult Function(KeyEvent event) onKey;

  @override
  Widget build(BuildContext context) {
    final c = context.etbalyColors;
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
              color: c.textMuted, fontSize: 11.sp, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 6.h),
        Focus(
          onKeyEvent: (_, event) => onKey(event),
          skipTraversal: true,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            onChanged: onChanged,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            maxLength: maxLength,
            buildCounter: (context,
                    {required currentLength, required isFocused, maxLength}) =>
                null,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9٠-٩۰-۹]')),
            ],
            style: TextStyle(
              color: c.textMain,
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: c.textMuted.withValues(alpha: 0.4),
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              filled: true,
              fillColor: c.bgSubtle,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 6.w, vertical: 13.h),
              border: _border(c.borderColor),
              enabledBorder:
                  _border(invalid ? const Color(0xFFEF4444) : c.borderColor),
              focusedBorder: _border(invalid ? const Color(0xFFEF4444) : c.gold,
                  width: 1.6),
            ),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(color: color, width: width),
      );
}

class _Chip extends StatelessWidget {
  const _Chip(
      {required this.text, required this.color, this.icon, this.plain = false});

  final String text;
  final Color color;
  final IconData? icon;

  /// A neutral outline instead of a tinted fill (the date).
  final bool plain;

  @override
  Widget build(BuildContext context) {
    final c = context.etbalyColors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999.r),
        color: plain ? c.bgSubtle : color.withValues(alpha: 0.13),
        border: Border.all(
            color: plain ? c.borderColor : color.withValues(alpha: 0.42)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13.sp, color: color),
            SizedBox(width: 5.w),
          ],
          Text(
            text,
            style: TextStyle(
              color: plain ? color : c.textMain,
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
