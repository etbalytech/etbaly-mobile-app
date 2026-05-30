import 'package:easy_localization/easy_localization.dart';

class WhyChooseUsItem {
  WhyChooseUsItem({
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
  static List<WhyChooseUsItem> items = [
    WhyChooseUsItem(
      slug: 'transparent-reports',
      titleAr: 'auto.t_8470b479cf'.tr(),
      titleEn: 'Transparent Reports',
      descriptionAr: 'auto.t_48441d345e'.tr(),
      descriptionEn:
          'We provide accurate and transparent reports that reflect every aspect of your marketing investment.',
      icon: 'fa-chart-bar',
      imageUrl:
          'https://raw.githubusercontent.com/etbaly/assets/main/services/transparent-reports.png',
      color: '#D4AF37',
      detailedPointsAr: [
        'auto.t_7d4afb5049'.tr(),
        'auto.t_4e800408ed'.tr(),
        'auto.t_1a0690d65c'.tr(),
        'auto.t_7725403e49'.tr(),
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
      titleAr: 'auto.t_28e6b6b446'.tr(),
      titleEn: 'Guaranteed Results',
      descriptionAr: 'auto.t_64c1b70c01'.tr(),
      descriptionEn:
          'We guarantee measurable and tangible results in every campaign we execute.',
      icon: 'fa-bullseye',
      imageUrl:
          'https://raw.githubusercontent.com/etbaly/assets/main/services/guaranteed-results.png',
      color: '#68D391',
      detailedPointsAr: [
        'auto.t_259c35bbf6'.tr(),
        'auto.t_80b2ed7b88'.tr(),
        'auto.t_61339b6425'.tr(),
        'auto.t_d20bd0ed5a'.tr(),
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
      titleAr: 'auto.t_553f73c9cf'.tr(),
      titleEn: '12+ Years Experience',
      descriptionAr: 'auto.t_c496d8ec9f'.tr(),
      descriptionEn:
          'A specialized team with over 12 years of experience in digital marketing.',
      icon: 'fa-star',
      imageUrl:
          'https://raw.githubusercontent.com/etbaly/assets/main/services/experience.png',
      color: '#63B3ED',
      detailedPointsAr: [
        'auto.t_98bb951e65'.tr(),
        'auto.t_2fb161cc87'.tr(),
        'auto.t_a056fad7b2'.tr(),
        'auto.t_6bf2e5912b'.tr(),
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
      titleAr: 'auto.t_cf044d61d6'.tr(),
      titleEn: 'Documented Achievements',
      descriptionAr: 'auto.t_3540771351'.tr(),
      descriptionEn:
          'Hundreds of successful projects and satisfied clients testify to the quality of our work.',
      icon: 'fa-trophy',
      imageUrl:
          'https://raw.githubusercontent.com/etbaly/assets/main/services/achievements.png',
      color: '#F6AD55',
      detailedPointsAr: [
        'auto.t_1b0eb89acb'.tr(),
        'auto.t_447499bcdf'.tr(),
        'auto.t_252f71e248'.tr(),
        'auto.t_5772e509ba'.tr(),
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
      titleAr: 'auto.t_b6b5d39eee'.tr(),
      titleEn: 'Full Protection & Security',
      descriptionAr: 'auto.t_a3b86c382d'.tr(),
      descriptionEn:
          'We protect our clients\' data with the highest international security and privacy standards.',
      icon: 'fa-shield-alt',
      imageUrl:
          'https://raw.githubusercontent.com/etbaly/assets/main/services/security.png',
      color: '#FC8181',
      detailedPointsAr: [
        'auto.t_8e0c6b58e0'.tr(),
        'auto.t_5179b4d4c8'.tr(),
        'auto.t_0a8a802f9b'.tr(),
        'auto.t_9c2d9c3c7a'.tr(),
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
      titleAr: 'auto.t_f5b5bccbee'.tr(),
      titleEn: '24/7 Support',
      descriptionAr: 'auto.t_219ab2555a'.tr(),
      descriptionEn:
          'Our support team is available to you whenever you need assistance.',
      icon: 'fa-headset',
      imageUrl:
          'https://raw.githubusercontent.com/etbaly/assets/main/services/support.png',
      color: '#9F7AEA',
      detailedPointsAr: [
        'auto.t_db488a348c'.tr(),
        'auto.t_dbfdf55cac'.tr(),
        'auto.t_45228641be'.tr(),
        'auto.t_d11e0677d1'.tr(),
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
