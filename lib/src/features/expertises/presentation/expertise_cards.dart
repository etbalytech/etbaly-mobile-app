import 'package:flutter/painting.dart';

import '../../../routing/app_routes.dart';

const _artworkBase = 'https://etba3ly-dm.com/expertises';

/// One of the twelve "Our Expertise" platform cards. Like on the website, the
/// card is a single artwork (title, text and tags are drawn into it) in the
/// app language and theme; the text here is for screen readers.
class ExpertiseCard {
  const ExpertiseCard({
    required this.id,
    required this.accent,
    required this.secondary,
    required this.titleAr,
    required this.titleEn,
    required this.descriptionAr,
    required this.descriptionEn,
    this.route,
  });

  final String id;
  final Color accent;
  final Color secondary;
  final String titleAr;
  final String titleEn;
  final String descriptionAr;
  final String descriptionEn;

  /// The samples page the card opens; cards without samples are not tappable.
  final String? route;

  String artworkUrl({
    required bool arabic,
    required bool dark,
    required double pixelWidth,
  }) {
    final width = pixelWidth <= 480
        ? 480
        : pixelWidth <= 960
            ? 960
            : 1440;
    return '$_artworkBase/cards-calm/$id-${arabic ? 'ar' : 'en'}'
        '-${dark ? 'dark' : 'light'}-$width.webp';
  }
}

/// A hero statistic. The number and label are drawn into the artwork.
class ExpertiseStat {
  const ExpertiseStat(this.id, this.value, this.labelAr, this.labelEn);

  final String id;
  final String value;
  final String labelAr;
  final String labelEn;

  String artworkUrl({
    required bool arabic,
    required bool dark,
    required double pixelWidth,
  }) {
    final width = pixelWidth <= 320 ? 320 : 640;
    return '$_artworkBase/stats/$id-${arabic ? 'ar' : 'en'}'
        '-${dark ? 'dark' : 'light'}-$width.webp';
  }
}

const expertiseStats = [
  ExpertiseStat('projects', '400,000+', 'مشروع منجز', 'Projects Done'),
  ExpertiseStat('clients', '5,000+', 'عميل راضٍ', 'Happy Clients'),
  ExpertiseStat('years', '12+', 'سنوات خبرة', 'Years Experience'),
  ExpertiseStat(
    'satisfaction',
    '93%',
    'معدل رضا العملاء',
    'Client Satisfaction Rate',
  ),
];

const expertiseCards = [
  ExpertiseCard(
    id: 'facebook',
    accent: Color(0xFF3688FF),
    secondary: Color(0xFF60C8FF),
    titleAr: 'نماذج من صفحات فيسبوك',
    titleEn: 'Facebook page samples',
    descriptionAr:
        'بنرتّب شكل صفحتك، ونكتب محتوى مناسب لجمهورك، ونتابع الرسائل والتعليقات.',
    descriptionEn:
        'Page presentation, audience-focused content, and everyday message and comment management.',
    route: AppRoutes.expertiseFacebook,
  ),
  ExpertiseCard(
    id: 'tiktok',
    accent: Color(0xFF24D6CE),
    secondary: Color(0xFFFB6086),
    titleAr: 'نماذج من تيك توك',
    titleEn: 'TikTok samples',
    descriptionAr:
        'أفكار فيديوهات قصيرة، وتصوير ومونتاج بإيقاع يناسب تيك توك ويحكي حكاية براندك.',
    descriptionEn:
        'Short-form ideas, filming, and editing with a TikTok rhythm that tells your brand story.',
  ),
  ExpertiseCard(
    id: 'instagram',
    accent: Color(0xFFEE71BD),
    secondary: Color(0xFFFFC16A),
    titleAr: 'نماذج من إنستجرام',
    titleEn: 'Instagram samples',
    descriptionAr:
        'بنظبط شكل الحساب، ونجهّز بوستات وريلز وستوريز تحافظ على شخصية البراند.',
    descriptionEn:
        'A cohesive account identity through posts, Reels, and Stories that feel like your brand.',
    route: AppRoutes.expertiseInstagram,
  ),
  ExpertiseCard(
    id: 'telegram',
    accent: Color(0xFF38B6EF),
    secondary: Color(0xFF8FE5FF),
    titleAr: 'نماذج من تيليجرام',
    titleEn: 'Telegram samples',
    descriptionAr:
        'تجهيز قنوات ومحتوى منظم، مع أفكار حملات توصل رسالتك للجمهور المناسب.',
    descriptionEn:
        'Organized channels, clear content, and campaign ideas for the audience you want to reach.',
  ),
  ExpertiseCard(
    id: 'design',
    accent: Color(0xFFBE97FF),
    secondary: Color(0xFFF5B6EB),
    titleAr: 'نماذج تصميمات',
    titleEn: 'Design samples',
    descriptionAr:
        'من الهوية البصرية لبوستات السوشيال: تصميمات واضحة، متناسقة، وشبه براندك.',
    descriptionEn:
        'From brand identity to social posts: clear, consistent design with your own character.',
    route: AppRoutes.expertiseDesigns,
  ),
  ExpertiseCard(
    id: 'video-ugc',
    accent: Color(0xFFFFAE6C),
    secondary: Color(0xFFFF748D),
    titleAr: 'نماذج مونتاج وUGC',
    titleEn: 'Video editing & UGC samples',
    descriptionAr:
        'بنحوّل الفكرة لفيديو مفهوم: مونتاج، ريلز، وUGC يتكلم بلغة جمهورك.',
    descriptionEn:
        'Ideas turned into clear stories through editing, Reels, and UGC in your audience’s language.',
    route: AppRoutes.expertiseReels,
  ),
  ExpertiseCard(
    id: 'campaigns',
    accent: Color(0xFFF1CA64),
    secondary: Color(0xFFFF976A),
    titleAr: 'نماذج من حملات إعلانية',
    titleEn: 'Advertising campaign samples',
    descriptionAr:
        'تخطيط للحملة، واختيار للجمهور، ومتابعة للأداء عشان كل خطوة تبقى محسوبة.',
    descriptionEn:
        'Campaign planning, audience selection, and performance monitoring to guide the next step.',
    route: AppRoutes.expertiseCampaigns,
  ),
  ExpertiseCard(
    id: 'google',
    accent: Color(0xFF67C596),
    secondary: Color(0xFF79ADFF),
    titleAr: 'نماذج من جوجل',
    titleEn: 'Google samples',
    descriptionAr:
        'من إعلانات البحث لملف النشاط على خرائط جوجل، بنساعد الناس تلاقي شغلك بسهولة.',
    descriptionEn:
        'Search advertising and Google Business Profile work that helps people find your business.',
  ),
  ExpertiseCard(
    id: 'web',
    accent: Color(0xFF77A6FF),
    secondary: Color(0xFFAC8CFF),
    titleAr: 'نماذج من مواقع ويب',
    titleEn: 'Website samples',
    descriptionAr:
        'مواقع واضحة وسهلة الاستخدام، متظبطة للموبايل والكمبيوتر وتعرض شغلك زي ما يستاهل.',
    descriptionEn:
        'Clear, accessible websites that present your work well on phones and computers.',
    route: AppRoutes.expertiseWebsites,
  ),
  ExpertiseCard(
    id: 'mobile',
    accent: Color(0xFF62D8BA),
    secondary: Color(0xFF94B9FF),
    titleAr: 'نماذج من تطبيقات موبايل',
    titleEn: 'Mobile app samples',
    descriptionAr:
        'من تجربة المستخدم للتطوير: تطبيقات موبايل سهلة تناسب فكرة مشروعك واحتياج عملائك.',
    descriptionEn:
        'User experience and app development shaped around your project and your customers.',
    route: AppRoutes.expertiseMobileApps,
  ),
  ExpertiseCard(
    id: 'snapchat',
    accent: Color(0xFFE8D857),
    secondary: Color(0xFFFFE6A0),
    titleAr: 'نماذج من سناب شات',
    titleEn: 'Snapchat samples',
    descriptionAr: 'محتوى رأسي وستوريز وأفكار إعلانات تناسب سناب شات وطبيعة جمهوره.',
    descriptionEn:
        'Vertical content, Stories, and advertising ideas shaped for Snapchat and its audience.',
  ),
  ExpertiseCard(
    id: 'youtube',
    accent: Color(0xFFFF7A85),
    secondary: Color(0xFFFFAF93),
    titleAr: 'نماذج من يوتيوب',
    titleEn: 'YouTube samples',
    descriptionAr:
        'تجهيز القناة، وأفكار فيديوهات وشورتس، ومونتاج يخلّي المحتوى واضح ومترابط.',
    descriptionEn:
        'Channel setup, video and Shorts ideas, and editing that gives your content a clear thread.',
  ),
];
