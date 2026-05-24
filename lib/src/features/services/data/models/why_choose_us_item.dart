class WhyChooseUsItem {
  const WhyChooseUsItem({
    required this.slug,
    required this.titleAr,
    required this.titleEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.icon,
    required this.imageUrl,
    required this.color,
    required this.detailedPointsAr,
    required this.detailedPointsEn,
  });

  final String slug;
  final String titleAr;
  final String titleEn;
  final String descriptionAr;
  final String descriptionEn;
  final String icon;
  final String imageUrl;
  final String color; // Hex color code
  final List<String> detailedPointsAr;
  final List<String> detailedPointsEn;

  // Sample data with 6 why-choose-us items
  static const List<WhyChooseUsItem> items = [
    WhyChooseUsItem(
      slug: 'transparent-reports',
      titleAr: 'تقارير شفافة',
      titleEn: 'Transparent Reports',
      descriptionAr: 'نقدم لك تقارير دقيقة وشفافة تعكس كل جانب من جوانب استثمارك التسويقي.',
      descriptionEn:
          'We provide accurate and transparent reports that reflect every aspect of your marketing investment.',
      icon: 'fa-chart-bar',
      imageUrl:
          'https://raw.githubusercontent.com/etbaly/assets/main/services/transparent-reports.png',
      color: '#D4AF37',
      detailedPointsAr: [
        'تقارير شهرية مفصلة تشمل جميع المقاييس المهمة',
        'لوحة تحكم حية لمتابعة النتائج في الوقت الفعلي',
        'شفافية كاملة في التكاليف والنتائج',
        'تحليل عميق لأداء كل حملة',
      ],
      detailedPointsEn: [
        'Detailed monthly reports with all key metrics',
        'Live dashboard to track results in real-time',
        'Complete transparency in costs and results',
        'In-depth analysis of each campaign performance',
      ],
    ),
    WhyChooseUsItem(
      slug: 'guaranteed-results',
      titleAr: 'نتائج مضمونة',
      titleEn: 'Guaranteed Results',
      descriptionAr: 'نضمن لك نتائج ملموسة وقابلة للقياس في كل حملة نقوم بها.',
      descriptionEn:
          'We guarantee measurable and tangible results in every campaign we execute.',
      icon: 'fa-bullseye',
      imageUrl:
          'https://raw.githubusercontent.com/etbaly/assets/main/services/guaranteed-results.png',
      color: '#68D391',
      detailedPointsAr: [
        'ضمان تحقيق أهدافك المحددة مسبقاً',
        'زيادة مثبتة في المبيعات والعملاء',
        'تحسن واضح في معدلات التحويل',
        'عائد استثمار محسوب ومضمون',
      ],
      detailedPointsEn: [
        'Guarantee to achieve your pre-defined goals',
        'Proven increase in sales and customers',
        'Clear improvement in conversion rates',
        'Calculated and guaranteed return on investment',
      ],
    ),
    WhyChooseUsItem(
      slug: 'twelve-years-experience',
      titleAr: 'خبرة +12 عام',
      titleEn: '12+ Years Experience',
      descriptionAr: 'فريق متخصص بخبرة تمتد لأكثر من 12 سنة في مجال التسويق الرقمي.',
      descriptionEn:
          'A specialized team with over 12 years of experience in digital marketing.',
      icon: 'fa-star',
      imageUrl:
          'https://raw.githubusercontent.com/etbaly/assets/main/services/experience.png',
      color: '#63B3ED',
      detailedPointsAr: [
        'فريق متخصص في مختلف جوانب التسويق الرقمي',
        'خبرة عملية في التعامل مع مئات الشركات',
        'تدريب مستمر وتطور المهارات',
        'معرفة عميقة بأحدث الاتجاهات والأدوات',
      ],
      detailedPointsEn: [
        'Specialized team in all aspects of digital marketing',
        'Hands-on experience working with hundreds of companies',
        'Continuous training and skills development',
        'Deep knowledge of latest trends and tools',
      ],
    ),
    WhyChooseUsItem(
      slug: 'documented-achievements',
      titleAr: 'إنجازات موثقة',
      titleEn: 'Documented Achievements',
      descriptionAr: 'مئات المشاريع الناجحة والعملاء الراضين يشهدون على جودة عملنا.',
      descriptionEn:
          'Hundreds of successful projects and satisfied clients testify to the quality of our work.',
      icon: 'fa-trophy',
      imageUrl:
          'https://raw.githubusercontent.com/etbaly/assets/main/services/achievements.png',
      color: '#F6AD55',
      detailedPointsAr: [
        'أكثر من 400,000 مشروع منجز بنجاح',
        '93% معدل رضا العملاء',
        'عملاء في دول خليجية متعددة',
        'حالات نجاح موثقة وقابلة للتحقق',
      ],
      detailedPointsEn: [
        'Over 400,000 successfully completed projects',
        '93% client satisfaction rate',
        'Clients across multiple GCC countries',
        'Documented and verifiable success cases',
      ],
    ),
    WhyChooseUsItem(
      slug: 'security-guarantee',
      titleAr: 'حماية وأمان تام',
      titleEn: 'Full Protection & Security',
      descriptionAr: 'نحمي بيانات عملائنا بأعلى معايير الأمان والخصوصية العالمية.',
      descriptionEn:
          'We protect our clients\' data with the highest international security and privacy standards.',
      icon: 'fa-shield-alt',
      imageUrl:
          'https://raw.githubusercontent.com/etbaly/assets/main/services/security.png',
      color: '#FC8181',
      detailedPointsAr: [
        'عقود قانونية واضحة تحمي حقوقك',
        'سرية كاملة على جميع البيانات والاستراتيجيات',
        'التزام بمعايير حماية البيانات الدولية',
        'ضمان حماية بيانات عملائك',
      ],
      detailedPointsEn: [
        'Clear legal contracts protecting your rights',
        'Complete confidentiality on all data and strategies',
        'Compliance with international data protection standards',
        'Guarantee of client data protection',
      ],
    ),
    WhyChooseUsItem(
      slug: 'support-24-7',
      titleAr: 'دعم على مدار الساعة',
      titleEn: '24/7 Support',
      descriptionAr: 'فريق الدعم لدينا متاح لك في أي وقت تحتاج فيه إلى مساعدة.',
      descriptionEn:
          'Our support team is available to you whenever you need assistance.',
      icon: 'fa-headset',
      imageUrl:
          'https://raw.githubusercontent.com/etbaly/assets/main/services/support.png',
      color: '#9F7AEA',
      detailedPointsAr: [
        'الرد على الاستفسارات خلال 24 ساعة كحد أقصى',
        'قنوات تواصل متعددة (واتس، ايميل، هاتف)',
        'متابعة مستمرة لحملاتك',
        'فريق مختص وودي دائماً',
      ],
      detailedPointsEn: [
        'Response to inquiries within 24 hours maximum',
        'Multiple communication channels (WhatsApp, email, phone)',
        'Continuous follow-up on your campaigns',
        'Specialized and friendly team',
      ],
    ),
  ];
}
