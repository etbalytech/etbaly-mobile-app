import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ─── Public packages (dashboard "internal packages" catalogue) ───────────────

/// A package from the dashboard catalogue (`api-dashboard/internal-packages.php`).
/// It is the single source of truth for what the website's services page shows.
class InternalPackage {
  const InternalPackage({
    required this.id,
    required this.category,
    required this.categoryEn,
    required this.categoryOrder,
    required this.subcategory,
    required this.subcategoryEn,
    required this.subcategoryOrder,
    required this.packageOrder,
    required this.packageCode,
    required this.packageType,
    required this.title,
    required this.titleEn,
    required this.subtitle,
    required this.subtitleEn,
    required this.price,
    required this.oldPrice,
    required this.currency,
    required this.duration,
    required this.durationEn,
    required this.features,
    required this.featuresEn,
    required this.badge,
    required this.badgeEn,
    required this.sortOrder,
    required this.isMostRequested,
    required this.mostRequestedLabel,
    required this.mostRequestedLabelEn,
    required this.isActive,
  });

  final int id;
  final String category;
  final String categoryEn;
  final int categoryOrder;
  final String subcategory;
  final String subcategoryEn;
  final int subcategoryOrder;
  final int packageOrder;
  final String packageCode;

  /// `fixed`, `custom_days` or `custom_details`.
  final String packageType;
  final String title;
  final String titleEn;
  final String subtitle;
  final String subtitleEn;
  final double price;
  final double? oldPrice;
  final String currency;
  final String duration;
  final String durationEn;
  final List<String> features;
  final List<String> featuresEn;
  final String badge;
  final String badgeEn;
  final int sortOrder;
  final bool isMostRequested;
  final String mostRequestedLabel;
  final String mostRequestedLabelEn;
  final bool isActive;

  bool get isCustom => packageType == 'custom_days' || packageType == 'custom_details';

  String titleFor(bool isAr) => isAr ? title : (titleEn.isNotEmpty ? titleEn : title);
  String subtitleFor(bool isAr) => isAr ? subtitle : (subtitleEn.isNotEmpty ? subtitleEn : subtitle);
  String durationFor(bool isAr) => isAr ? duration : (durationEn.isNotEmpty ? durationEn : duration);
  String badgeFor(bool isAr) => isAr ? badge : (badgeEn.isNotEmpty ? badgeEn : badge);
  String categoryFor(bool isAr) => isAr ? category : (categoryEn.isNotEmpty ? categoryEn : category);
  String subcategoryFor(bool isAr) =>
      isAr ? subcategory : (subcategoryEn.isNotEmpty ? subcategoryEn : subcategory);

  List<String> featuresFor(bool isAr) {
    final list = isAr ? features : featuresEn;
    return list.isNotEmpty ? list : features;
  }

  /// The label of the "most requested" / custom badge, or '' when there is none.
  String badgeLabel(bool isAr) {
    if (isMostRequested) {
      return isAr
          ? (mostRequestedLabel.isNotEmpty ? mostRequestedLabel : 'الأكثر طلبًا')
          : (mostRequestedLabelEn.isNotEmpty ? mostRequestedLabelEn : 'Most requested');
    }
    return badgeFor(isAr);
  }

  factory InternalPackage.fromJson(Map<String, dynamic> json) {
    String text(String key) => '${json[key] ?? ''}'.trim();
    int whole(String key) => (num.tryParse('${json[key] ?? 0}') ?? 0).toInt();
    double decimal(String key) => (num.tryParse('${json[key] ?? 0}') ?? 0).toDouble();

    List<String> list(String key) {
      var raw = json[key];
      if (raw is String && raw.trim().startsWith('[')) {
        try {
          raw = jsonDecode(raw);
        } catch (_) {}
      }
      return raw is List
          ? [for (final item in raw) if ('$item'.trim().isNotEmpty) '$item'.trim()]
          : const <String>[];
    }

    final oldPrice = num.tryParse('${json['old_price'] ?? ''}');
    return InternalPackage(
      id: whole('id'),
      category: text('category'),
      categoryEn: text('category_en'),
      categoryOrder: whole('category_order'),
      subcategory: text('subcategory'),
      subcategoryEn: text('subcategory_en'),
      subcategoryOrder: whole('subcategory_order'),
      packageOrder: whole('package_order'),
      packageCode: text('package_code'),
      packageType: text('package_type'),
      title: text('title'),
      titleEn: text('title_en'),
      subtitle: text('subtitle'),
      subtitleEn: text('subtitle_en'),
      price: decimal('price'),
      oldPrice: oldPrice?.toDouble(),
      currency: text('currency').isEmpty ? 'EGP' : text('currency'),
      duration: text('duration'),
      durationEn: text('duration_en'),
      features: list('features'),
      featuresEn: list('features_en'),
      badge: text('badge'),
      badgeEn: text('badge_en'),
      sortOrder: whole('sort_order'),
      isMostRequested: whole('is_most_requested') == 1,
      mostRequestedLabel: text('most_requested_label'),
      mostRequestedLabelEn: text('most_requested_label_en'),
      isActive: whole('is_active') == 1,
    );
  }
}

/// Packages of one category / subcategory, shown as one filter tab.
class PackageGroup {
  const PackageGroup({
    required this.key,
    required this.category,
    required this.categoryEn,
    required this.categoryOrder,
    required this.subcategory,
    required this.subcategoryEn,
    required this.subcategoryOrder,
    required this.packages,
  });

  final String key;
  final String category;
  final String categoryEn;
  final int categoryOrder;
  final String subcategory;
  final String subcategoryEn;
  final int subcategoryOrder;
  final List<InternalPackage> packages;

  /// `Category — Subcategory`, like the website's tabs.
  String label(bool isAr) {
    final cat = isAr ? category : (categoryEn.isNotEmpty ? categoryEn : category);
    final sub = isAr ? subcategory : (subcategoryEn.isNotEmpty ? subcategoryEn : subcategory);
    return sub.isNotEmpty ? '$cat — $sub' : cat;
  }
}

int _byOrder(InternalPackage a, InternalPackage b) =>
    a.categoryOrder - b.categoryOrder != 0
        ? a.categoryOrder - b.categoryOrder
        : a.subcategoryOrder - b.subcategoryOrder != 0
            ? a.subcategoryOrder - b.subcategoryOrder
            : a.packageOrder - b.packageOrder != 0
                ? a.packageOrder - b.packageOrder
                : a.sortOrder - b.sortOrder != 0
                    ? a.sortOrder - b.sortOrder
                    : a.id - b.id;

/// Active packages in the dashboard's display order.
List<InternalPackage> sortedActivePackages(Iterable<InternalPackage> packages) =>
    packages.where((p) => p.isActive).toList()..sort(_byOrder);

/// Groups packages by category + subcategory (the services page tabs).
List<PackageGroup> groupPackages(List<InternalPackage> packages) {
  final groups = <String, List<InternalPackage>>{};
  for (final pkg in packages) {
    final key = '${pkg.categoryOrder}:${pkg.subcategoryOrder}:${pkg.category}:${pkg.subcategory}';
    groups.putIfAbsent(key, () => []).add(pkg);
  }
  final result = [
    for (final entry in groups.entries)
      PackageGroup(
        key: entry.key,
        category: entry.value.first.category,
        categoryEn: entry.value.first.categoryEn,
        categoryOrder: entry.value.first.categoryOrder,
        subcategory: entry.value.first.subcategory,
        subcategoryEn: entry.value.first.subcategoryEn,
        subcategoryOrder: entry.value.first.subcategoryOrder,
        packages: entry.value..sort(_byOrder),
      ),
  ];
  result.sort((a, b) =>
      a.categoryOrder - b.categoryOrder != 0
          ? a.categoryOrder - b.categoryOrder
          : a.subcategoryOrder - b.subcategoryOrder != 0
              ? a.subcategoryOrder - b.subcategoryOrder
              : a.category.compareTo(b.category));
  return result;
}

// ─── Services shown on the "Our services" tab ────────────────────────────────

/// One card of the services grid (same 15 services and copy as the website).
/// Each one is a filter over the packages catalogue, matched by category name.
class CatalogService {
  const CatalogService({
    required this.slug,
    required this.number,
    required this.icon,
    required this.accent,
    required this.titleAr,
    required this.titleEn,
    required this.descAr,
    required this.descEn,
    required this.featuresAr,
    required this.featuresEn,
    required this.categoryNames,
    this.catalogPage = false,
  });

  final String slug;
  final String number;
  final FaIconData icon;
  final Color accent;
  final String titleAr;
  final String titleEn;
  final String descAr;
  final String descEn;
  final List<String> featuresAr;
  final List<String> featuresEn;

  /// Category names (Arabic and/or English) that identify this service's packages.
  final List<String> categoryNames;

  /// `true` for services without a dedicated detail screen in the app: they open
  /// the catalogue-driven page instead.
  final bool catalogPage;

  String title(bool isAr) => isAr ? titleAr : titleEn;
  String desc(bool isAr) => isAr ? descAr : descEn;
  List<String> features(bool isAr) => isAr ? featuresAr : featuresEn;

  bool matches(InternalPackage pkg) {
    String norm(String s) => s.trim().toLowerCase();
    final ar = norm(pkg.category);
    final en = norm(pkg.categoryEn);
    return categoryNames.any((name) {
      final n = norm(name);
      return ar == n || en == n;
    });
  }
}

CatalogService? catalogServiceBySlug(String slug) {
  for (final service in catalogServices) {
    if (service.slug == slug) return service;
  }
  return null;
}

const catalogServices = <CatalogService>[
  CatalogService(
    slug: 'design',
    number: '01',
    icon: FontAwesomeIcons.paintbrush,
    accent: Color(0xFFD4AF37),
    titleAr: 'تصميمات احترافية',
    titleEn: 'Professional Design',
    descAr: 'نبني هويتك البصرية الكاملة — شعار، موشن جرافيك، بوستات، وكل ما يعكس روح علامتك التجارية باحترافية.',
    descEn: 'We build your complete visual identity — logo, motion graphics, social posts, and everything that reflects your brand professionally.',
    featuresAr: ['تصميم شعار وهوية بصرية كاملة', 'بوستات سوشيال ميديا وموشن جرافيك', 'ملفات بجميع الصيغ جاهزة للنشر'],
    featuresEn: ['Logo & complete visual identity design', 'Social media posts & motion graphics', 'Files in all formats ready to publish'],
    categoryNames: ['Page Creation', 'انشاء الصفحات'],
  ),
  CatalogService(
    slug: 'social',
    number: '02',
    icon: FontAwesomeIcons.shareNodes,
    accent: Color(0xFF25D366),
    titleAr: 'إدارة السوشيال ميديا',
    titleEn: 'Social Media Management',
    descAr: 'محتوى إبداعي يومي، إدارة احترافية لحساباتك على جميع المنصات، وتفاعل حقيقي مع جمهورك.',
    descEn: 'Daily creative content, professional account management across all platforms, and genuine engagement with your audience.',
    featuresAr: ['إدارة 3 منصات سوشيال ميديا', '30 منشور شهرياً + ستوريز', 'تقارير أداء أسبوعية وشهرية'],
    featuresEn: ['Manage 3 social media platforms', '30 posts per month + stories', 'Weekly & monthly performance reports'],
    categoryNames: ['Page Establishment', 'تاسيس الصفحات'],
  ),
  CatalogService(
    slug: 'ads',
    number: '03',
    icon: FontAwesomeIcons.bullhorn,
    accent: Color(0xFFFC814A),
    titleAr: 'الإعلانات الممولة',
    titleEn: 'Paid Advertising',
    descAr: 'حملات إعلانية مستهدفة على Google و Meta و TikTok تحقق أعلى عائد على الاستثمار.',
    descEn: 'Targeted ad campaigns on Google, Meta & TikTok delivering the highest return on investment.',
    featuresAr: ['حملات Google Ads و Meta Ads', 'إعلانات TikTok وسناب شات', 'تحليل مستمر وتحسين العائد'],
    featuresEn: ['Google Ads & Meta Ads campaigns', 'TikTok & Snapchat ads', 'Continuous analysis & ROI optimization'],
    categoryNames: ['Facebook & Instagram Paid Ads', 'اعلانات فيسبوك وانستجرام الممولة'],
  ),
  CatalogService(
    slug: 'web',
    number: '04',
    icon: FontAwesomeIcons.laptopCode,
    accent: Color(0xFF63B3ED),
    titleAr: 'تصميم وتطوير المواقع',
    titleEn: 'Website Design & Development',
    descAr: 'مواقع ويب سريعة، متجاوبة، ومحسّنة لمحركات البحث تحوّل الزوار إلى عملاء.',
    descEn: 'Fast, responsive, SEO-optimized websites that convert visitors into customers.',
    featuresAr: ['تصميم UI/UX متميز وعصري', 'متجاوب مع جميع الأجهزة', 'تحسين محركات البحث SEO من الأساس'],
    featuresEn: ['Modern & distinctive UI/UX design', 'Fully responsive on all devices', 'SEO optimization from the ground up'],
    categoryNames: ['Web Packages', 'باقات الويب'],
  ),
  CatalogService(
    slug: 'google-ads',
    number: '05',
    icon: FontAwesomeIcons.magnifyingGlassChart,
    accent: Color(0xFF4285F4),
    titleAr: 'إعلانات جوجل ويوتيوب الممولة',
    titleEn: 'Google & YouTube Paid Ads',
    descAr: 'حملات إعلانية مستهدفة على Google Search و YouTube بأعلى معايير الاحترافية لزيادة المبيعات والتحويلات.',
    descEn: 'Targeted advertising campaigns on Google Search and YouTube with professional standards to increase sales, conversions, and brand awareness.',
    featuresAr: ['حملات إعلانية على Google Search وYouTube', 'استهداف دقيق للكلمات المفتاحية والجمهور', 'تحليل وتحسين مستمر لتعظيم العائد'],
    featuresEn: ['Ad campaigns on Google Search and YouTube', 'Precise keyword and audience targeting', 'Continuous analysis to maximize ROI'],
    categoryNames: ['Google & YouTube Paid Ads', 'اعلانات جوجل ويوتيوب الممولة'],
    catalogPage: true,
  ),
  CatalogService(
    slug: 'video',
    number: '06',
    icon: FontAwesomeIcons.film,
    accent: Color(0xFF48BB78),
    titleAr: 'إنشاء وتعديل الفيديوهات',
    titleEn: 'Video Creation & Editing',
    descAr: 'إنتاج وتحرير فيديوهات احترافية — ريلز، إعلانات، UGC — تجذب جمهورك وتحقق نتائج ملموسة.',
    descEn: 'Professional production and editing of Reels, ad videos, and UGC content that captivates your audience and drives results.',
    featuresAr: ['مونتاج ريلز وفيديوهات إعلانية', 'إنتاج محتوى UGC بأسلوب موثوق', 'مؤثرات وانتقالات وتصحيح ألوان'],
    featuresEn: ['Reels & ad video editing', 'UGC content production', 'Effects, transitions & color grading'],
    categoryNames: ['Content Packages', 'باكدجات المحتوى'],
  ),
  CatalogService(
    slug: 'seo',
    number: '07',
    icon: FontAwesomeIcons.chartLine,
    accent: Color(0xFF63B3ED),
    titleAr: 'تحسين محركات البحث SEO',
    titleEn: 'SEO – Search Engine Optimization',
    descAr: 'نُحسّن ظهور موقعك وصفحاتك على جوجل لتحصل على زيارات عضوية مجانية ومستمرة.',
    descEn: 'We optimize your website and pages on Google to attract free, sustainable organic traffic.',
    featuresAr: ['تحسين ظهور الموقع على جوجل', 'بحث كلمات مفتاحية وتحسين المحتوى', 'تقارير أداء SEO شهرية'],
    featuresEn: ['Improve Google search ranking', 'Keyword research & content optimization', 'Monthly SEO performance reports'],
    categoryNames: ['SEO', 'تحسين محركات البحث'],
  ),
  CatalogService(
    slug: 'telegram',
    number: '08',
    icon: FontAwesomeIcons.paperPlane,
    accent: Color(0xFF25D366),
    titleAr: 'إعلانات تيليجرام الممولة',
    titleEn: 'Telegram Paid Ads',
    descAr: 'استهدف جمهورك المستهدف على تيليجرام بإعلانات ممولة فعالة تحقق أفضل النتائج والعائد.',
    descEn: 'Reach your target audience on Telegram with effective paid advertising that delivers results and maximum ROI.',
    featuresAr: ['حملات إعلانية ممولة على تيليجرام', 'استهداف القنوات والمجموعات المناسبة', 'تقارير أداء ومتابعة نتائج الحملة'],
    featuresEn: ['Paid ad campaigns on Telegram', 'Targeting the right channels and groups', 'Performance reports and campaign tracking'],
    categoryNames: ['Telegram Paid Ads', 'اعلانات تيليجرام الممولة'],
    catalogPage: true,
  ),
  CatalogService(
    slug: 'mobile-app',
    number: '09',
    icon: FontAwesomeIcons.mobileScreenButton,
    accent: Color(0xFF6F3FF5),
    titleAr: 'تصميم وتطوير تطبيقات موبايل',
    titleEn: 'Mobile App Design & Development',
    descAr: 'نقوم بتصميم وتطوير تطبيقات موبايل احترافية لأندرويد وiOS لزيادة تفاعل عملائك وتوسيع نطاق علامتك التجارية.',
    descEn: 'We design and develop professional Android and iOS mobile apps that expand your brand reach and improve customer engagement.',
    featuresAr: ['تصميم واجهة مستخدم جذابة وسهلة الاستخدام', 'تطوير تطبيقات أندرويد وiOS متكاملة', 'دعم وصيانة مستمرة للتطبيقات'],
    featuresEn: ['Attractive, easy-to-use UI design', 'Full-featured Android & iOS app development', 'Ongoing app support and maintenance'],
    categoryNames: ['Mobile Packages', 'باقات الموبايل'],
  ),
  CatalogService(
    slug: 'boost',
    number: '10',
    icon: FontAwesomeIcons.rocket,
    accent: Color(0xFF9F7AEA),
    titleAr: 'تزويد منصات السوشيال ميديا',
    titleEn: 'Social Media Boosting',
    descAr: 'نزوّد حساباتك بمتابعين ولايكات وتعليقات ومشاهدات حقيقية ومستهدفة لتعزيز حضورك الرقمي.',
    descEn: 'We grow your accounts with real, targeted followers, likes, comments, and views to strengthen your digital presence.',
    featuresAr: ['متابعين حقيقيين ومستهدفين', 'لايكات وتعليقات ومشاهدات', 'تحديد الدولة والجنسية متاح'],
    featuresEn: ['Real & targeted followers', 'Likes, comments & views', 'Country & nationality targeting available'],
    categoryNames: [
      'TikTok Views, Followers & Engagement (Egypt Promotion)',
      'تيك توك للمشاهدات والمتابعات والتفاعلات (ترويج داخل مصر)',
    ],
  ),
  CatalogService(
    slug: 'google-business-profile',
    number: '11',
    icon: FontAwesomeIcons.locationDot,
    accent: Color(0xFF4285F4),
    titleAr: 'Google Business Profile',
    titleEn: 'Google Business Profile',
    descAr: 'نُنشئ ونُدير ملفك على خرائط جوجل لزيادة ظهورك المحلي وثقة العملاء واستقبال تقييمات حقيقية.',
    descEn: 'We create and manage your Google Maps listing to boost local visibility, build customer trust, and gather genuine reviews.',
    featuresAr: ['إنشاء وتوثيق ملف Google Business Profile', 'إدارة التقييمات والردود على العملاء', 'تحسين الظهور في نتائج البحث المحلي'],
    featuresEn: ['Google Business Profile setup & verification', 'Review management & customer responses', 'Improved local search visibility'],
    categoryNames: ['Google Business Profile'],
    catalogPage: true,
  ),
  CatalogService(
    slug: 'shopify',
    number: '12',
    icon: FontAwesomeIcons.cartShopping,
    accent: Color(0xFF95D071),
    titleAr: 'شوبيفاي',
    titleEn: 'Shopify',
    descAr: 'إنشاء وتجهيز وإدارة متجرك على شوبيفاي بالكامل — من التصميم إلى ربط الدفع والمنتجات.',
    descEn: 'Full Shopify store setup and management — from design to payment gateways and product listings.',
    featuresAr: ['إنشاء متجر شوبيفاي من الصفر', 'ربط بوابات الدفع والشحن', 'تجهيز المنتجات وتصميم المتجر'],
    featuresEn: ['Shopify store built from scratch', 'Payment & shipping gateway integration', 'Product listing & store design'],
    categoryNames: ['Shopify', 'شوبيفاي'],
    catalogPage: true,
  ),
  CatalogService(
    slug: 'startup-class',
    number: '13',
    icon: FontAwesomeIcons.lightbulb,
    accent: Color(0xFFFFB142),
    titleAr: 'باقات الانطلاق StartUp Class',
    titleEn: 'StartUp Class Packages',
    descAr: 'باقات مخصصة للمشاريع الناشئة تجهزك بالحضور الرقمي والهوية والتسويق من أول يوم.',
    descEn: 'Tailored packages for early-stage businesses, setting up your digital presence, identity, and marketing from day one.',
    featuresAr: ['هوية بصرية وحضور رقمي متكامل', 'باقات مرنة حسب حجم المشروع الناشئ', 'دعم وتوجيه في أول مراحل الانطلاق'],
    featuresEn: ['Full digital identity & presence', 'Flexible packages sized for your startup', 'Support & guidance through your launch'],
    categoryNames: ['Startup Business Packages', 'باكدجات الانشطة المبتدئة StartUp Class'],
    catalogPage: true,
  ),
  CatalogService(
    slug: 'tiktok',
    number: '14',
    icon: FontAwesomeIcons.tiktok,
    accent: Color(0xFF25F4EE),
    titleAr: 'خدمات تيك توك المتكاملة',
    titleEn: 'Complete TikTok Services',
    descAr: 'ترويج ومتابعين وتفاعل واعلانات ممولة على تيك توك داخل مصر وخارجها، وإنشاء أنشطة تجارية على المنصة.',
    descEn: 'Growth, followers, engagement, and sponsored ads on TikTok inside and outside Egypt, plus setting up business activities on the platform.',
    featuresAr: ['متابعين وتفاعل حقيقي على تيك توك', 'إعلانات ممولة داخل مصر وخارجها', 'إنشاء أنشطة تجارية وخدمية على المنصة'],
    featuresEn: ['Real followers & engagement on TikTok', 'Sponsored ads inside & outside Egypt', 'Setting up business & service activities'],
    categoryNames: [
      'TikTok Business & Service Activities in Egypt',
      'تيك توك انشطة تجارية وخدمية داخل مصر',
      'Sponsored TikTok – Outside Egypt',
      'تيك توك ممول - خارج مصر',
    ],
    catalogPage: true,
  ),
  CatalogService(
    slug: 'platform-growth',
    number: '15',
    icon: FontAwesomeIcons.layerGroup,
    accent: Color(0xFF9F7AEA),
    titleAr: 'تزويد المنصات',
    titleEn: 'Platform Growth Services',
    descAr: 'تعزيز حضورك على مختلف منصات التواصل بمتابعين وتفاعل حقيقي ومستهدف لتوسيع نطاق علامتك التجارية.',
    descEn: 'Boosting your presence across social platforms with real, targeted followers and engagement to expand your brand\'s reach.',
    featuresAr: ['متابعين وتفاعل حقيقي ومستهدف', 'تغطية لأغلب منصات التواصل الاجتماعي', 'تنفيذ سريع وتحديد الدولة متاح'],
    featuresEn: ['Real, targeted followers & engagement', 'Coverage across most social platforms', 'Fast delivery with country targeting available'],
    categoryNames: ['Platform Growth Services', 'تزويد المنصات'],
    catalogPage: true,
  ),
];
