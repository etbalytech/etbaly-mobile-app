import 'package:flutter/material.dart';

/// A coloured bullet shown under the CEO's name (edited from the dashboard).
class CeoHighlight {
  const CeoHighlight({required this.ar, required this.en, required this.color});

  final String ar;
  final String en;
  final Color color;

  String text(bool isArabic) => isArabic ? ar : en;
}

/// One of the three figures under the CEO biography.
class CeoStat {
  const CeoStat({required this.num, required this.labelAr, required this.labelEn});

  final String num;
  final String labelAr;
  final String labelEn;

  String label(bool isArabic) => isArabic ? labelAr : labelEn;
}

/// The CEO profile served by `api-services/ceo.php`, managed from the dashboard.
///
/// Every field falls back to [CeoProfile.fallback] when the API leaves it empty,
/// exactly like the website's `mapCeoProfile`.
class CeoProfile {
  const CeoProfile({
    required this.nameAr,
    required this.nameEn,
    required this.titleAr,
    required this.titleEn,
    required this.bioAr,
    required this.bioEn,
    required this.avatar,
    required this.highlights,
    required this.stats,
    required this.expNum,
    required this.expLabelAr,
    required this.expLabelEn,
    required this.projectBadgeAr,
    required this.projectBadgeEn,
    required this.signatureAr,
    required this.signatureEn,
  });

  /// The bundled portrait; also what the dashboard stores by default.
  static const defaultAvatar = 'about/team/ceo.webp';
  // This version of the dashboard upload is also included in the app.
  static const _bundledUpload =
      'uploads/packages/team/eng--mohamed-elmasrawy-20261021-175142-cd37d1fd.png';

  static final _founderName = RegExp(
    r'\bMohamed (?:Al-Masrawi|Elmasrawy)\b',
    caseSensitive: false,
  );

  static const fallback = CeoProfile(
    nameAr: 'مهندس/ محمد المصراوي',
    nameEn: 'Eng. Mohamed Elmasrawy',
    titleAr: 'المدير التنفيذي والمؤسس',
    titleEn: 'Chief Executive Officer & Founder',
    bioAr:
        'رائد أعمال ومسوق رقمي بخبرة تمتد لأكثر من 12 عاماً في تحويل الأفكار إلى علامات تجارية ناجحة. أسس اطْبَعَلِيٌّ لتكون جسر النجاح بين الشركات وعملائها، بأسلوب يجمع بين الإبداع العلمي والنتائج القابلة للقياس.',
    bioEn:
        'Entrepreneur and digital marketing leader with 12+ years of experience transforming ideas into thriving brands. Founded Etba3ly to bridge businesses with their audiences, blending creative strategy with measurable, data-driven results.',
    avatar: defaultAvatar,
    highlights: [
      CeoHighlight(
        ar: 'رؤية إبداعية تجمع بين الفن والبيانات',
        en: 'Creative vision combining art and data',
        color: Color(0xFFD4AF37),
      ),
      CeoHighlight(
        ar: 'استراتيجيات مُخصَّصة لكل عميل على حدة',
        en: 'Tailored strategies for each client individually',
        color: Color(0xFF68D391),
      ),
      CeoHighlight(
        ar: 'شفافية كاملة في التقارير والنتائج',
        en: 'Full transparency in reporting and results',
        color: Color(0xFF63B3ED),
      ),
    ],
    stats: [
      CeoStat(num: '+5K', labelAr: 'عميل راضٍ', labelEn: 'Happy Clients'),
      CeoStat(num: '93%', labelAr: 'رضا العملاء', labelEn: 'Satisfaction'),
      CeoStat(num: '4', labelAr: 'دول خليجية', labelEn: 'GCC Countries'),
    ],
    expNum: '12+',
    expLabelAr: 'سنة خبرة',
    expLabelEn: 'Years Exp.',
    projectBadgeAr: '+400K مشروع',
    projectBadgeEn: '+400K Projects',
    signatureAr: 'مهندس/ محمد المصراوي',
    signatureEn: 'Eng. Mohamed Elmasrawy',
  );

  final String nameAr;
  final String nameEn;
  final String titleAr;
  final String titleEn;
  final String bioAr;
  final String bioEn;
  final String avatar;
  final List<CeoHighlight> highlights;
  final List<CeoStat> stats;
  final String expNum;
  final String expLabelAr;
  final String expLabelEn;
  final String projectBadgeAr;
  final String projectBadgeEn;
  final String signatureAr;
  final String signatureEn;

  String name(bool isArabic) => isArabic ? nameAr : nameEn;
  String title(bool isArabic) => isArabic ? titleAr : titleEn;
  String bio(bool isArabic) => isArabic ? bioAr : bioEn;
  String expLabel(bool isArabic) => isArabic ? expLabelAr : expLabelEn;
  String projectBadge(bool isArabic) => isArabic ? projectBadgeAr : projectBadgeEn;
  String signature(bool isArabic) => isArabic ? signatureAr : signatureEn;

  /// The name without its last word — the last word is drawn in gold.
  String nameMain(bool isArabic) {
    final parts = _words(name(isArabic));
    return parts.length <= 1 ? name(isArabic) : parts.sublist(0, parts.length - 1).join(' ');
  }

  String nameHighlight(bool isArabic) {
    final parts = _words(name(isArabic));
    return parts.length > 1 ? parts.last : '';
  }

  static List<String> _words(String value) =>
      value.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();

  factory CeoProfile.fromJson(Map<String, dynamic> json) {
    const base = CeoProfile.fallback;
    String text(String key, String fallback) {
      final value = json[key];
      return value is String && value.trim().isNotEmpty ? value : fallback;
    }

    // Older dashboard records and their cached copies use a different spelling.
    String englishName(String key, String fallback) =>
        text(key, fallback).replaceFirst(_founderName, 'Mohamed Elmasrawy');

    final avatar = text('avatar', base.avatar);
    return CeoProfile(
      nameAr: text('name_ar', base.nameAr),
      nameEn: englishName('name_en', base.nameEn),
      titleAr: text('title_ar', base.titleAr),
      titleEn: text('title_en', base.titleEn),
      bioAr: text('bio_ar', base.bioAr),
      bioEn: text('bio_en', base.bioEn),
      avatar: avatar == _bundledUpload ? defaultAvatar : avatar,
      highlights: _highlights(json['highlights'], base.highlights),
      stats: _stats(json['stats'], base.stats),
      expNum: text('exp_num', base.expNum),
      expLabelAr: text('exp_label_ar', base.expLabelAr),
      expLabelEn: text('exp_label_en', base.expLabelEn),
      projectBadgeAr: text('project_badge_ar', base.projectBadgeAr),
      projectBadgeEn: text('project_badge_en', base.projectBadgeEn),
      signatureAr: text('signature_ar', base.signatureAr),
      signatureEn: englishName('signature_en', base.signatureEn),
    );
  }

  static List<CeoHighlight> _highlights(Object? raw, List<CeoHighlight> fallback) {
    final List<dynamic> rows = raw is List ? raw.take(3).toList() : const <dynamic>[];
    final out = <CeoHighlight>[];
    for (var i = 0; i < rows.length; i++) {
      final row = rows[i] is Map ? Map<String, dynamic>.from(rows[i] as Map) : <String, dynamic>{};
      final ar = '${row['ar'] ?? ''}'.trim().isNotEmpty
          ? '${row['ar']}'
          : (i < fallback.length ? fallback[i].ar : '');
      final en = '${row['en'] ?? ''}'.trim().isNotEmpty
          ? '${row['en']}'
          : (i < fallback.length ? fallback[i].en : '');
      if (ar.isEmpty && en.isEmpty) continue;
      out.add(CeoHighlight(
        ar: ar,
        en: en,
        color: _parseColor('${row['color'] ?? ''}') ??
            (i < fallback.length ? fallback[i].color : const Color(0xFFD4AF37)),
      ));
    }
    return out.isEmpty ? fallback : out;
  }

  static List<CeoStat> _stats(Object? raw, List<CeoStat> fallback) {
    final List<dynamic> rows = raw is List ? raw.take(3).toList() : const <dynamic>[];
    final out = <CeoStat>[];
    for (var i = 0; i < rows.length; i++) {
      final row = rows[i] is Map ? Map<String, dynamic>.from(rows[i] as Map) : <String, dynamic>{};
      String pick(String key, String Function(CeoStat) fromFallback) {
        final value = '${row[key] ?? ''}'.trim();
        if (value.isNotEmpty) return '${row[key]}';
        return i < fallback.length ? fromFallback(fallback[i]) : '';
      }

      final stat = CeoStat(
        num: pick('num', (s) => s.num),
        labelAr: pick('label_ar', (s) => s.labelAr),
        labelEn: pick('label_en', (s) => s.labelEn),
      );
      if (stat.num.isEmpty && stat.labelAr.isEmpty && stat.labelEn.isEmpty) continue;
      out.add(stat);
    }
    return out.isEmpty ? fallback : out;
  }

  static Color? _parseColor(String value) {
    final hex = value.trim().replaceFirst('#', '');
    if (hex.length != 6) return null;
    final parsed = int.tryParse(hex, radix: 16);
    return parsed == null ? null : Color(0xFF000000 | parsed);
  }
}

/// A public team member from `api-services/team.php`.
class TeamMember {
  const TeamMember({
    required this.nameAr,
    required this.nameEn,
    required this.roleAr,
    required this.roleEn,
    required this.avatar,
  });

  final String nameAr;
  final String nameEn;
  final String roleAr;
  final String roleEn;
  final String avatar;

  String name(bool isArabic) => isArabic ? nameAr : nameEn;
  String role(bool isArabic) => isArabic ? roleAr : roleEn;

  factory TeamMember.fromJson(Map<String, dynamic> json) => TeamMember(
        nameAr: '${json['name_ar'] ?? ''}',
        nameEn: '${json['name_en'] ?? ''}',
        roleAr: '${json['role_ar'] ?? ''}',
        roleEn: '${json['role_en'] ?? ''}',
        avatar: '${json['avatar'] ?? ''}',
      );
}
