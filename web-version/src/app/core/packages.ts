import { Injectable } from '@angular/core';
import { PackageItem } from '../models/packageitem';

@Injectable({
  providedIn: 'root',
})
export class Packages {
  /** Class C — Local Egypt Paid Ads (Facebook & Instagram) */
  localAdsPackages: PackageItem[] = [
    {
      nameKey: 'PACKAGES.LOCAL_5D_NAME',
      price: '1,200',
      duration: '5',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.LOCAL_5D_DESC',
      featured: false,
      adBudget: '1,000',
      managementFee: '200',
      features: ['PACKAGES.FEAT_TARGETING', 'PACKAGES.FEAT_PERFORMANCE'],
      category: 'local',
    },
    {
      nameKey: 'PACKAGES.LOCAL_7D_NAME',
      price: '2,300',
      duration: '7',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.LOCAL_7D_DESC',
      featured: false,
      adBudget: '1,950',
      managementFee: '350',
      features: [
        'PACKAGES.FEAT_TARGETING',
        'PACKAGES.FEAT_PERFORMANCE',
        'PACKAGES.FEAT_BUDGET_MGMT',
      ],
      category: 'local',
    },
    {
      nameKey: 'PACKAGES.LOCAL_10D_NAME',
      price: '3,500',
      duration: '10',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.LOCAL_10D_DESC',
      featured: false,
      adBudget: '3,200',
      managementFee: '300',
      features: ['PACKAGES.FEAT_TARGETING', 'PACKAGES.FEAT_PERFORMANCE', 'PACKAGES.FEAT_PRO_MGMT'],
      category: 'local',
    },
    {
      nameKey: 'PACKAGES.LOCAL_15D_NAME',
      price: '5,500',
      duration: '15',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.LOCAL_15D_DESC',
      featured: false,
      adBudget: '5,000',
      managementFee: '500',
      features: [
        'PACKAGES.FEAT_ADV_TARGETING',
        'PACKAGES.FEAT_PERFORMANCE',
        'PACKAGES.FEAT_FULL_MGMT',
      ],
      category: 'local',
    },
    {
      nameKey: 'PACKAGES.LOCAL_30D_NAME',
      price: '11,000',
      duration: '30',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.LOCAL_30D_DESC',
      featured: true,
      badge: 'PACKAGES.BEST_VALUE',
      adBudget: '10,000',
      managementFee: '1,000',
      features: [
        'PACKAGES.FEAT_PRO_ADV_TARGETING',
        'PACKAGES.FEAT_PERFORMANCE',
        'PACKAGES.FEAT_FULL_MGMT',
        'PACKAGES.FEAT_SMART_BUDGET',
      ],
      category: 'local',
    },
  ];

  /** International Ads — Outside Egypt (Facebook / Instagram) */
  internationalAdsPackages: PackageItem[] = [
    {
      nameKey: 'PACKAGES.INTL_STARTER_NAME',
      price: '2,000',
      duration: '3',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.INTL_STARTER_DESC',
      featured: false,
      adBudget: '1,500',
      managementFee: '500',
      features: ['PACKAGES.FEAT_GEO_TARGETING', 'PACKAGES.FEAT_AD_SETUP'],
      category: 'international',
    },
    {
      nameKey: 'PACKAGES.INTL_LAUNCH_NAME',
      price: '4,500',
      duration: '5',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.INTL_LAUNCH_DESC',
      featured: false,
      adBudget: '4,000',
      managementFee: '500',
      features: ['PACKAGES.FEAT_GEO_TARGETING', 'PACKAGES.FEAT_AD_SETUP'],
      category: 'international',
    },
    {
      nameKey: 'PACKAGES.INTL_SMALL_NAME',
      price: '8,500',
      duration: '7',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.INTL_SMALL_DESC',
      featured: false,
      adBudget: '7,500',
      managementFee: '1,000',
      features: [
        'PACKAGES.FEAT_GEO_TARGETING',
        'PACKAGES.FEAT_AD_SETUP',
        'PACKAGES.FEAT_PERFORMANCE',
      ],
      category: 'international',
    },
    {
      nameKey: 'PACKAGES.INTL_MED_NAME',
      price: '13,000',
      duration: '10',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.INTL_MED_DESC',
      featured: false,
      adBudget: '12,000',
      managementFee: '1,000',
      features: [
        'PACKAGES.FEAT_GEO_TARGETING',
        'PACKAGES.FEAT_AD_SETUP',
        'PACKAGES.FEAT_PERFORMANCE',
      ],
      category: 'international',
    },
    {
      nameKey: 'PACKAGES.INTL_ABOVE_MED_NAME',
      price: '20,000',
      duration: '15',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.INTL_ABOVE_MED_DESC',
      featured: true,
      badge: 'PACKAGES.MOST_REQUESTED',
      adBudget: '19,000',
      managementFee: '1,000',
      features: [
        'PACKAGES.FEAT_GEO_TARGETING',
        'PACKAGES.FEAT_AD_SETUP',
        'PACKAGES.FEAT_PERFORMANCE',
        'PACKAGES.FEAT_FULL_MGMT',
      ],
      category: 'international',
    },
  ];

  /** Page Management Packages */
  pageManagementPackages: PackageItem[] = [
    {
      nameKey: 'PACKAGES.MGMT_START_NAME',
      price: '1,500',
      duration: '30',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.MGMT_START_DESC',
      featured: false,
      features: [
        'PACKAGES.MGMT_7_POSTS',
        'PACKAGES.MGMT_7_STORIES',
        'PACKAGES.MGMT_CONTENT_DESIGN',
        'PACKAGES.MGMT_FB_IG',
      ],
      category: 'management',
    },
    {
      nameKey: 'PACKAGES.MGMT_BOOST_NAME',
      price: '2,500',
      duration: '30',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.MGMT_BOOST_DESC',
      featured: false,
      features: [
        'PACKAGES.MGMT_8_POSTS',
        'PACKAGES.MGMT_8_STORIES',
        'PACKAGES.MGMT_1_REEL',
        'PACKAGES.MGMT_CONTENT_DESIGN',
        'PACKAGES.MGMT_FB_IG',
      ],
      category: 'management',
    },
    {
      nameKey: 'PACKAGES.MGMT_PRO_NAME',
      price: '4,000',
      duration: '30',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.MGMT_PRO_DESC',
      featured: false,
      features: [
        'PACKAGES.MGMT_13_POSTS',
        'PACKAGES.MGMT_13_STORIES',
        'PACKAGES.MGMT_1_REEL',
        'PACKAGES.MGMT_CONTENT_DESIGN',
        'PACKAGES.MGMT_FB_IG',
        'PACKAGES.MGMT_COMPETITORS',
        'PACKAGES.MGMT_MARKETING_PLAN',
      ],
      category: 'management',
    },
    {
      nameKey: 'PACKAGES.MGMT_PRO_MAX_NAME',
      price: '8,000',
      duration: '30',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.MGMT_PRO_MAX_DESC',
      featured: true,
      features: [
        'PACKAGES.MGMT_30_POSTS',
        'PACKAGES.MGMT_30_STORIES',
        'PACKAGES.MGMT_2_REELS',
        'PACKAGES.MGMT_CONTENT_DESIGN',
        'PACKAGES.MGMT_FB_IG_TT',
        'PACKAGES.MGMT_MESSENGER',
        'PACKAGES.MGMT_COMPETITORS',
        'PACKAGES.MGMT_MARKETING_PLAN',
      ],
      category: 'management',
    },
  ];

  /** Design & Content Services */
  designPackages: PackageItem[] = [
    {
      nameKey: 'PACKAGES.DESIGN_ABOUT_NAME',
      price: '1,000',
      duration: '',
      durationKey: '',
      descKey: 'PACKAGES.DESIGN_ABOUT_DESC',
      featured: false,
      features: [
        'PACKAGES.DESIGN_ABOUT_F1',
        'PACKAGES.DESIGN_ABOUT_F2',
        'PACKAGES.DESIGN_ABOUT_F3',
      ],
      category: 'design',
    },
    {
      nameKey: 'PACKAGES.DESIGN_LOGO_NAME',
      price: '500',
      duration: '',
      durationKey: '',
      descKey: 'PACKAGES.DESIGN_LOGO_DESC',
      featured: false,
      features: ['PACKAGES.DESIGN_LOGO_F1', 'PACKAGES.DESIGN_LOGO_F2', 'PACKAGES.DESIGN_LOGO_F3'],
      category: 'design',
    },
    {
      nameKey: 'PACKAGES.DESIGN_POST_NAME',
      price: '250',
      duration: '',
      durationKey: '',
      descKey: 'PACKAGES.DESIGN_POST_DESC',
      featured: false,
      features: ['PACKAGES.DESIGN_POST_F1', 'PACKAGES.DESIGN_POST_F2', 'PACKAGES.DESIGN_POST_F3'],
      category: 'design',
    },
    {
      nameKey: 'PACKAGES.DESIGN_BRAND_NAME',
      price: '1,200',
      duration: '',
      durationKey: '',
      descKey: 'PACKAGES.DESIGN_BRAND_DESC',
      featured: false,
      features: [
        'PACKAGES.DESIGN_BRAND_F1',
        'PACKAGES.DESIGN_BRAND_F2',
        'PACKAGES.DESIGN_BRAND_F3',
      ],
      category: 'design',
    },
    {
      nameKey: 'PACKAGES.DESIGN_VIDEO_NAME',
      price: '1,500',
      duration: '',
      durationKey: '',
      descKey: 'PACKAGES.DESIGN_VIDEO_DESC',
      featured: false,
      features: [
        'PACKAGES.DESIGN_VIDEO_F1',
        'PACKAGES.DESIGN_VIDEO_F2',
        'PACKAGES.DESIGN_VIDEO_F3',
      ],
      category: 'design',
    },
    {
      nameKey: 'PACKAGES.DESIGN_UGC_NAME',
      price: '3,000',
      duration: '',
      durationKey: '',
      descKey: 'PACKAGES.DESIGN_UGC_DESC',
      featured: false,
      features: ['PACKAGES.DESIGN_UGC_F1', 'PACKAGES.DESIGN_UGC_F2', 'PACKAGES.DESIGN_UGC_F3'],
      category: 'design',
    },
  ];

  /** Class A — Premium Egypt Ads */
  classAPackages: PackageItem[] = [
    {
      nameKey: 'PACKAGES.CLASSA_7D_NAME',
      price: '10,000',
      duration: '7',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.CLASSA_7D_DESC',
      featured: false,
      adBudget: '9,100',
      managementFee: '900',
      features: [
        'PACKAGES.CLASSA_BASIC_TARGETING',
        'PACKAGES.FEAT_PERFORMANCE',
        'PACKAGES.FEAT_SAFE_ACCESS',
      ],
      category: 'classA',
    },
    {
      nameKey: 'PACKAGES.CLASSA_10D_NAME',
      price: '16,000',
      duration: '10',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.CLASSA_10D_DESC',
      featured: false,
      adBudget: '15,000',
      managementFee: '1,000',
      features: [
        'PACKAGES.CLASSA_FOCUSED_TARGETING',
        'PACKAGES.FEAT_PERFORMANCE',
        'PACKAGES.FEAT_SAFE_ACCESS',
      ],
      category: 'classA',
    },
    {
      nameKey: 'PACKAGES.CLASSA_15D_NAME',
      price: '33,000',
      duration: '15',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.CLASSA_15D_DESC',
      featured: false,
      adBudget: '30,000',
      managementFee: '3,000',
      features: [
        'PACKAGES.CLASSA_PRECISE_TARGETING',
        'PACKAGES.FEAT_PERFORMANCE',
        'PACKAGES.FEAT_SAFE_ACCESS',
      ],
      category: 'classA',
    },
    {
      nameKey: 'PACKAGES.CLASSA_30D_NAME',
      price: '65,000',
      duration: '30',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.CLASSA_30D_DESC',
      featured: true,
      badge: 'PACKAGES.STRONGEST',
      adBudget: '60,000',
      managementFee: '5,000',
      features: [
        'PACKAGES.CLASSA_IDEAL_TARGETING',
        'PACKAGES.FEAT_PERFORMANCE',
        'PACKAGES.FEAT_FULL_MGMT',
        'PACKAGES.FEAT_SAFE_ACCESS',
      ],
      category: 'classA',
    },
  ];

  /** Class B — Mid-Range Egypt Ads (Facebook & Instagram) */
  classBPackages: PackageItem[] = [
    {
      nameKey: 'PACKAGES.CLASSB_TRIAL_NAME',
      price: '5,400',
      duration: '7',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.CLASSB_TRIAL_DESC',
      featured: false,
      adBudget: '4,900',
      managementFee: '500',
      features: [
        'PACKAGES.FEAT_GEO_TARGETING',
        'PACKAGES.FEAT_SAFE_ACCESS',
        'PACKAGES.FEAT_PERFORMANCE',
      ],
      category: 'classB',
    },
    {
      nameKey: 'PACKAGES.CLASSB_STARTER_NAME',
      price: '7,500',
      duration: '10',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.CLASSB_STARTER_DESC',
      featured: false,
      adBudget: '7,000',
      managementFee: '500',
      features: [
        'PACKAGES.FEAT_GEO_TARGETING',
        'PACKAGES.FEAT_SAFE_ACCESS',
        'PACKAGES.FEAT_PERFORMANCE',
        'PACKAGES.FEAT_BUDGET_MGMT',
      ],
      category: 'classB',
    },
    {
      nameKey: 'PACKAGES.CLASSB_ESSENTIAL_NAME',
      price: '16,000',
      duration: '15',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.CLASSB_ESSENTIAL_DESC',
      featured: false,
      adBudget: '15,000',
      managementFee: '1,000',
      features: [
        'PACKAGES.FEAT_ADV_TARGETING',
        'PACKAGES.FEAT_SAFE_ACCESS',
        'PACKAGES.FEAT_PERFORMANCE',
        'PACKAGES.FEAT_FULL_MGMT',
      ],
      category: 'classB',
    },
    {
      nameKey: 'PACKAGES.CLASSB_ADVANCED_NAME',
      price: '33,000',
      duration: '30',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.CLASSB_ADVANCED_DESC',
      featured: true,
      badge: 'PACKAGES.MOST_REQUESTED',
      adBudget: '30,000',
      managementFee: '3,000',
      features: [
        'PACKAGES.FEAT_PRO_ADV_TARGETING',
        'PACKAGES.FEAT_SAFE_ACCESS',
        'PACKAGES.FEAT_PERFORMANCE',
        'PACKAGES.FEAT_FULL_MGMT',
        'PACKAGES.FEAT_SMART_BUDGET',
      ],
      category: 'classB',
    },
  ];

  /** Website Design Packages */
  websitePackages: PackageItem[] = [
    {
      nameKey: 'PACKAGES.WEB_INTRO_NAME',
      price: '9,000',
      duration: '',
      durationKey: '',
      descKey: 'PACKAGES.WEB_INTRO_DESC',
      featured: false,
      features: [
        'PACKAGES.WEB_FEAT_RESPONSIVE',
        'PACKAGES.WEB_FEAT_SEO',
        'PACKAGES.WEB_FEAT_HOSTING',
        'PACKAGES.WEB_FEAT_SUPPORT_4M',
      ],
      category: 'website',
    },
    {
      nameKey: 'PACKAGES.WEB_STORE_NAME',
      price: '12,000',
      duration: '',
      durationKey: '',
      descKey: 'PACKAGES.WEB_STORE_DESC',
      featured: true,
      badge: 'PACKAGES.MOST_REQUESTED',
      features: [
        'PACKAGES.WEB_FEAT_RESPONSIVE',
        'PACKAGES.WEB_FEAT_SEO',
        'PACKAGES.WEB_FEAT_HOSTING',
        'PACKAGES.WEB_FEAT_SUPPORT_4M',
        'PACKAGES.WEB_FEAT_PAYMENT',
      ],
      category: 'website',
    },
    {
      nameKey: 'PACKAGES.WEB_FULL_NAME',
      price: '15,000',
      duration: '',
      durationKey: '',
      descKey: 'PACKAGES.WEB_FULL_DESC',
      featured: false,
      features: [
        'PACKAGES.WEB_FEAT_RESPONSIVE',
        'PACKAGES.WEB_FEAT_SEO',
        'PACKAGES.WEB_FEAT_HOSTING',
        'PACKAGES.WEB_FEAT_SUPPORT_6M',
        'PACKAGES.WEB_FEAT_ANALYTICS',
        'PACKAGES.WEB_FEAT_BILINGUAL',
        'PACKAGES.WEB_FEAT_SECURITY',
      ],
      category: 'website',
    },
  ];

  /** TikTok Ads Packages (Outside Egypt) */
  tiktokPackages: PackageItem[] = [
    {
      nameKey: 'PACKAGES.TIKTOK_5D_NAME',
      price: '3,000',
      duration: '5',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.TIKTOK_5D_DESC',
      featured: false,
      features: [
        'PACKAGES.TIKTOK_FEAT_TARGETING',
        'PACKAGES.TIKTOK_FEAT_GOALS',
        'PACKAGES.FEAT_PERFORMANCE',
      ],
      category: 'tiktok',
    },
    {
      nameKey: 'PACKAGES.TIKTOK_7D_NAME',
      price: '4,200',
      duration: '7',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.TIKTOK_7D_DESC',
      featured: false,
      features: [
        'PACKAGES.TIKTOK_FEAT_TARGETING',
        'PACKAGES.TIKTOK_FEAT_GOALS',
        'PACKAGES.FEAT_PERFORMANCE',
      ],
      category: 'tiktok',
    },
    {
      nameKey: 'PACKAGES.TIKTOK_14D_NAME',
      price: '8,400',
      duration: '14',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.TIKTOK_14D_DESC',
      featured: true,
      badge: 'PACKAGES.BEST_VALUE',
      features: [
        'PACKAGES.TIKTOK_FEAT_TARGETING',
        'PACKAGES.TIKTOK_FEAT_GOALS',
        'PACKAGES.FEAT_PERFORMANCE',
        'PACKAGES.FEAT_FULL_MGMT',
      ],
      category: 'tiktok',
    },
    {
      nameKey: 'PACKAGES.TIKTOK_30D_NAME',
      price: '18,000',
      duration: '30',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.TIKTOK_30D_DESC',
      featured: false,
      features: [
        'PACKAGES.TIKTOK_FEAT_TARGETING',
        'PACKAGES.TIKTOK_FEAT_GOALS',
        'PACKAGES.FEAT_PERFORMANCE',
        'PACKAGES.FEAT_FULL_MGMT',
        'PACKAGES.FEAT_SMART_BUDGET',
      ],
      category: 'tiktok',
    },
  ];

  /** TikTok Views Packages */
  tiktokViewsPackages: PackageItem[] = [
    {
      nameKey: 'PACKAGES.TIKTOK_VIEWS_5D_NAME',
      price: '2,450',
      duration: '5',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.TIKTOK_VIEWS_5D_DESC',
      featured: false,
      features: ['PACKAGES.TIKTOK_VIEWS_TARGETED', 'PACKAGES.TIKTOK_VIEWS_GOAL'],
      category: 'tiktokViews',
    },
    {
      nameKey: 'PACKAGES.TIKTOK_VIEWS_6D_NAME',
      price: '2,900',
      duration: '6',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.TIKTOK_VIEWS_6D_DESC',
      featured: false,
      features: ['PACKAGES.TIKTOK_VIEWS_TARGETED', 'PACKAGES.TIKTOK_VIEWS_GOAL'],
      category: 'tiktokViews',
    },
    {
      nameKey: 'PACKAGES.TIKTOK_VIEWS_7D_NAME',
      price: '3,200',
      duration: '7',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.TIKTOK_VIEWS_7D_DESC',
      featured: true,
      badge: 'PACKAGES.BEST_VALUE',
      features: ['PACKAGES.TIKTOK_VIEWS_TARGETED', 'PACKAGES.TIKTOK_VIEWS_GOAL'],
      category: 'tiktokViews',
    },
    {
      nameKey: 'PACKAGES.TIKTOK_VIEWS_14D_NAME',
      price: '6,500',
      duration: '14',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.TIKTOK_VIEWS_14D_DESC',
      featured: false,
      features: ['PACKAGES.TIKTOK_VIEWS_TARGETED', 'PACKAGES.TIKTOK_VIEWS_GOAL'],
      category: 'tiktokViews',
    },
    {
      nameKey: 'PACKAGES.TIKTOK_VIEWS_30D_NAME',
      price: '12,500',
      duration: '30',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.TIKTOK_VIEWS_30D_DESC',
      featured: false,
      features: ['PACKAGES.TIKTOK_VIEWS_TARGETED', 'PACKAGES.TIKTOK_VIEWS_GOAL'],
      category: 'tiktokViews',
    },
  ];

  /** Google Ads Packages */
  googleAdsPackages: PackageItem[] = [
    {
      nameKey: 'PACKAGES.GOOGLE_1D_NAME',
      price: '950',
      duration: '1',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.GOOGLE_1D_DESC',
      featured: false,
      features: ['PACKAGES.GOOGLE_FEAT_GOALS', 'PACKAGES.FEAT_PERFORMANCE'],
      category: 'google',
    },
    {
      nameKey: 'PACKAGES.GOOGLE_2D_NAME',
      price: '1,800',
      duration: '2',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.GOOGLE_2D_DESC',
      featured: false,
      features: ['PACKAGES.GOOGLE_FEAT_GOALS', 'PACKAGES.FEAT_PERFORMANCE'],
      category: 'google',
    },
    {
      nameKey: 'PACKAGES.GOOGLE_3D_NAME',
      price: '2,600',
      duration: '3',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.GOOGLE_3D_DESC',
      featured: false,
      features: [
        'PACKAGES.GOOGLE_FEAT_GOALS',
        'PACKAGES.FEAT_PERFORMANCE',
        'PACKAGES.FEAT_BUDGET_MGMT',
      ],
      category: 'google',
    },
    {
      nameKey: 'PACKAGES.GOOGLE_7D_NAME',
      price: '5,000',
      duration: '7',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.GOOGLE_7D_DESC',
      featured: true,
      badge: 'PACKAGES.BEST_VALUE',
      features: [
        'PACKAGES.GOOGLE_FEAT_GOALS',
        'PACKAGES.FEAT_PERFORMANCE',
        'PACKAGES.FEAT_FULL_MGMT',
        'PACKAGES.FEAT_SMART_BUDGET',
      ],
      category: 'google',
    },
  ];

  /** Snapchat Ads Packages */
  snapchatPackages: PackageItem[] = [
    {
      nameKey: 'PACKAGES.SNAP_PKG_NAME',
      price: '70',
      duration: '7',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.SNAP_PKG_DESC',
      featured: false,
      features: [
        'PACKAGES.SNAP_FEAT_GULF',
        'PACKAGES.SNAP_FEAT_GOAL',
        'PACKAGES.SNAP_FEAT_10PER_DAY',
      ],
      category: 'snapchat',
    },
  ];

  /** YouTube Ads Packages */
  youtubePackages: PackageItem[] = [
    {
      nameKey: 'PACKAGES.YOUTUBE_PKG_NAME',
      price: '750',
      duration: '',
      durationKey: '',
      descKey: 'PACKAGES.YOUTUBE_PKG_DESC',
      featured: false,
      features: [
        'PACKAGES.YOUTUBE_FEAT_VIEWS',
        'PACKAGES.YOUTUBE_FEAT_SUBS',
        'PACKAGES.YOUTUBE_FEAT_SPEED',
      ],
      category: 'youtube',
    },
  ];

  /** Telegram Ads Packages */
  telegramPackages: PackageItem[] = [
    {
      nameKey: 'PACKAGES.TG_1D_NAME',
      price: '800',
      duration: '1',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.TG_1D_DESC',
      featured: false,
      features: ['PACKAGES.TG_FEAT_SEARCH', 'PACKAGES.TG_FEAT_CHANNELS', 'PACKAGES.TG_FEAT_BOTS'],
      category: 'telegram',
    },
    {
      nameKey: 'PACKAGES.TG_2D_NAME',
      price: '1,500',
      duration: '2',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.TG_2D_DESC',
      featured: false,
      features: ['PACKAGES.TG_FEAT_SEARCH', 'PACKAGES.TG_FEAT_CHANNELS', 'PACKAGES.TG_FEAT_BOTS'],
      category: 'telegram',
    },
    {
      nameKey: 'PACKAGES.TG_3D_NAME',
      price: '2,250',
      duration: '3',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.TG_3D_DESC',
      featured: true,
      badge: 'PACKAGES.BEST_VALUE',
      features: ['PACKAGES.TG_FEAT_SEARCH', 'PACKAGES.TG_FEAT_CHANNELS', 'PACKAGES.TG_FEAT_BOTS'],
      category: 'telegram',
    },
  ];

  /** Page Foundation Packages */
  pageFoundationPackages: PackageItem[] = [
    {
      nameKey: 'PACKAGES.FOUND_BASIC_NAME',
      price: '1,800',
      duration: '72',
      durationKey: 'PACKAGES.HOURS',
      descKey: 'PACKAGES.FOUND_BASIC_DESC',
      featured: false,
      features: [
        'PACKAGES.FOUND_FEAT_META_SEO',
        'PACKAGES.FOUND_FEAT_KEYWORDS',
        'PACKAGES.FOUND_FEAT_RECOMMEND',
        'PACKAGES.FOUND_FEAT_ENGAGEMENT',
        'PACKAGES.FOUND_FEAT_1K_FOLLOWERS',
        'PACKAGES.FOUND_FEAT_ADS_SETUP',
      ],
      category: 'pageFoundation',
    },
    {
      nameKey: 'PACKAGES.FOUND_FULL_NAME',
      price: '2,500',
      duration: '5',
      durationKey: 'PACKAGES.WORKDAYS',
      descKey: 'PACKAGES.FOUND_FULL_DESC',
      featured: true,
      badge: 'PACKAGES.MOST_REQUESTED',
      features: [
        'PACKAGES.FOUND_FEAT_META_SEO',
        'PACKAGES.FOUND_FEAT_KEYWORDS',
        'PACKAGES.FOUND_FEAT_RECOMMEND',
        'PACKAGES.FOUND_FEAT_ENGAGEMENT',
        'PACKAGES.FOUND_FEAT_1K_FOLLOWERS',
        'PACKAGES.FOUND_FEAT_ADS_SETUP',
        'PACKAGES.FOUND_FEAT_BIZ_MGR',
        'PACKAGES.FOUND_FEAT_COMPETITORS',
      ],
      category: 'pageFoundation',
    },
  ];

  /** Page Creation Packages */
  pageCreationPackages: PackageItem[] = [
    {
      nameKey: 'PACKAGES.PAGE_BEGINNER_NAME',
      price: '1,000',
      duration: '3',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.PAGE_BEGINNER_DESC',
      featured: false,
      features: [
        'PACKAGES.PAGE_FEAT_2K_REAL',
        'PACKAGES.PAGE_FEAT_LOGO_COVER',
        'PACKAGES.PAGE_FEAT_CUSTOM_URL',
        'PACKAGES.PAGE_FEAT_WHATSAPP',
        'PACKAGES.PAGE_FEAT_PIXEL',
      ],
      category: 'pageCreation',
    },
    {
      nameKey: 'PACKAGES.PAGE_PRO_NAME',
      price: '2,500',
      duration: '3',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.PAGE_PRO_DESC',
      featured: true,
      badge: 'PACKAGES.MOST_REQUESTED',
      features: [
        'PACKAGES.PAGE_FEAT_2K_REAL',
        'PACKAGES.PAGE_FEAT_LOGO_COVER',
        'PACKAGES.PAGE_FEAT_CUSTOM_URL',
        'PACKAGES.PAGE_FEAT_WHATSAPP',
        'PACKAGES.PAGE_FEAT_PIXEL',
        'PACKAGES.FOUND_FEAT_META_SEO',
        'PACKAGES.FOUND_FEAT_KEYWORDS',
        'PACKAGES.FOUND_FEAT_RECOMMEND',
        'PACKAGES.PAGE_FEAT_BIZ_MGR',
      ],
      category: 'pageCreation',
    },
    {
      nameKey: 'PACKAGES.PAGE_5K_NAME',
      price: '3,500',
      duration: '',
      durationKey: '',
      descKey: 'PACKAGES.PAGE_5K_DESC',
      featured: false,
      features: [
        'PACKAGES.PAGE_FEAT_LOGO_COVER',
        'PACKAGES.PAGE_FEAT_CUSTOM_URL',
        'PACKAGES.PAGE_FEAT_WHATSAPP',
        'PACKAGES.PAGE_FEAT_RECOMMENDATIONS',
        'PACKAGES.PAGE_FEAT_SEARCH_VISIBILITY',
      ],
      category: 'pageCreation',
    },
    {
      nameKey: 'PACKAGES.PAGE_10K_NAME',
      price: '5,000',
      duration: '',
      durationKey: '',
      descKey: 'PACKAGES.PAGE_10K_DESC',
      featured: false,
      features: [
        'PACKAGES.PAGE_FEAT_LOGO_COVER',
        'PACKAGES.PAGE_FEAT_CUSTOM_URL',
        'PACKAGES.PAGE_FEAT_WHATSAPP',
        'PACKAGES.PAGE_FEAT_RECOMMENDATIONS',
        'PACKAGES.PAGE_FEAT_SEARCH_VISIBILITY',
      ],
      category: 'pageCreation',
    },
    {
      nameKey: 'PACKAGES.PAGE_25K_NAME',
      price: '7,000',
      duration: '',
      durationKey: '',
      descKey: 'PACKAGES.PAGE_25K_DESC',
      featured: false,
      features: [
        'PACKAGES.PAGE_FEAT_LOGO_COVER',
        'PACKAGES.PAGE_FEAT_CUSTOM_URL',
        'PACKAGES.PAGE_FEAT_WHATSAPP',
        'PACKAGES.PAGE_FEAT_RECOMMENDATIONS',
        'PACKAGES.PAGE_FEAT_SEARCH_VISIBILITY',
      ],
      category: 'pageCreation',
    },
    {
      nameKey: 'PACKAGES.PAGE_50K_NAME',
      price: '11,000',
      duration: '',
      durationKey: '',
      descKey: 'PACKAGES.PAGE_50K_DESC',
      featured: false,
      features: [
        'PACKAGES.PAGE_FEAT_LOGO_COVER',
        'PACKAGES.PAGE_FEAT_CUSTOM_URL',
        'PACKAGES.PAGE_FEAT_WHATSAPP',
        'PACKAGES.PAGE_FEAT_RECOMMENDATIONS',
        'PACKAGES.PAGE_FEAT_SEARCH_VISIBILITY',
      ],
      category: 'pageCreation',
    },
    {
      nameKey: 'PACKAGES.PAGE_100K_NAME',
      price: '20,000',
      duration: '',
      durationKey: '',
      descKey: 'PACKAGES.PAGE_100K_DESC',
      featured: true,
      badge: 'PACKAGES.STRONGEST',
      features: [
        'PACKAGES.PAGE_FEAT_LOGO_COVER',
        'PACKAGES.PAGE_FEAT_CUSTOM_URL',
        'PACKAGES.PAGE_FEAT_WHATSAPP',
        'PACKAGES.PAGE_FEAT_RECOMMENDATIONS',
        'PACKAGES.PAGE_FEAT_SEARCH_VISIBILITY',
        'PACKAGES.PAGE_FEAT_100_REVIEWS',
      ],
      category: 'pageCreation',
    },
  ];

  /** StartUp Packages */
  startupPackages: PackageItem[] = [
    {
      nameKey: 'PACKAGES.STARTUP_C_NAME',
      price: '4,500',
      duration: '',
      durationKey: '',
      descKey: 'PACKAGES.STARTUP_C_DESC',
      featured: false,
      features: [
        'PACKAGES.STARTUP_FEAT_PAGE',
        'PACKAGES.STARTUP_FEAT_2K_FOLLOWERS',
        'PACKAGES.STARTUP_FEAT_IDENTITY',
        'PACKAGES.STARTUP_FEAT_7_POSTS',
        'PACKAGES.STARTUP_FEAT_MARKETING_PLAN',
        'PACKAGES.STARTUP_FEAT_ADS_7D',
      ],
      category: 'startup',
    },
    {
      nameKey: 'PACKAGES.STARTUP_CPLUS_NAME',
      price: '8,000',
      duration: '',
      durationKey: '',
      descKey: 'PACKAGES.STARTUP_CPLUS_DESC',
      featured: false,
      features: [
        'PACKAGES.STARTUP_FEAT_PAGE',
        'PACKAGES.STARTUP_FEAT_META_SEO',
        'PACKAGES.STARTUP_FEAT_ADS_VERIFY',
        'PACKAGES.STARTUP_FEAT_IDENTITY',
        'PACKAGES.STARTUP_FEAT_100_RECOMMEND',
        'PACKAGES.STARTUP_FEAT_8_POSTS_REEL',
        'PACKAGES.STARTUP_FEAT_ADS_10D',
      ],
      category: 'startup',
    },
    {
      nameKey: 'PACKAGES.STARTUP_B_NAME',
      price: '12,900',
      duration: '',
      durationKey: '',
      descKey: 'PACKAGES.STARTUP_B_DESC',
      featured: false,
      features: [
        'PACKAGES.STARTUP_FEAT_PAGE_5K',
        'PACKAGES.STARTUP_FEAT_13_POSTS_REEL',
        'PACKAGES.STARTUP_FEAT_META_SEO',
        'PACKAGES.STARTUP_FEAT_VERIFY',
        'PACKAGES.STARTUP_FEAT_MARKETING_PLAN',
        'PACKAGES.STARTUP_FEAT_ADS_15D',
        'PACKAGES.STARTUP_GIFT_TIKTOK',
      ],
      category: 'startup',
    },
    {
      nameKey: 'PACKAGES.STARTUP_BPLUS_NAME',
      price: '23,000',
      duration: '',
      durationKey: '',
      descKey: 'PACKAGES.STARTUP_BPLUS_DESC',
      featured: true,
      badge: 'PACKAGES.MOST_REQUESTED',
      features: [
        'PACKAGES.STARTUP_FEAT_PAGE_50K',
        'PACKAGES.STARTUP_FEAT_30_POSTS_REELS',
        'PACKAGES.STARTUP_FEAT_IDENTITY',
        'PACKAGES.STARTUP_FEAT_META_SEO',
        'PACKAGES.STARTUP_FEAT_MARKETING_PLAN',
        'PACKAGES.STARTUP_FEAT_ADS_15D',
        'PACKAGES.STARTUP_GIFT_TIKTOK_IG',
      ],
      category: 'startup',
    },
    {
      nameKey: 'PACKAGES.STARTUP_A_NAME',
      price: '62,000',
      duration: '',
      durationKey: '',
      descKey: 'PACKAGES.STARTUP_A_DESC',
      featured: false,
      features: [
        'PACKAGES.STARTUP_FEAT_PAGE_25K',
        'PACKAGES.STARTUP_FEAT_30_POSTS_REELS',
        'PACKAGES.STARTUP_FEAT_IDENTITY',
        'PACKAGES.STARTUP_FEAT_MARKETING_PLAN',
        'PACKAGES.STARTUP_FEAT_ADS_30D',
        'PACKAGES.STARTUP_FEAT_META_SEO',
        'PACKAGES.STARTUP_GIFT_FULL_TEAM',
      ],
      category: 'startup',
    },
    {
      nameKey: 'PACKAGES.STARTUP_APLUS_NAME',
      price: '70,000',
      duration: '',
      durationKey: '',
      descKey: 'PACKAGES.STARTUP_APLUS_DESC',
      featured: false,
      features: [
        'PACKAGES.STARTUP_FEAT_PAGE_50K',
        'PACKAGES.STARTUP_FEAT_30_POSTS_REELS',
        'PACKAGES.STARTUP_FEAT_IDENTITY',
        'PACKAGES.STARTUP_FEAT_META_SEO',
        'PACKAGES.STARTUP_FEAT_VERIFY',
        'PACKAGES.STARTUP_FEAT_ADS_30D',
        'PACKAGES.STARTUP_FEAT_MARKETING_PLAN',
        'PACKAGES.STARTUP_GIFT_TIKTOK_IG',
      ],
      category: 'startup',
    },
  ];

  // ══════════════════════════════════════════
  // SOCIAL BOOST SERVICES — Instagram
  // ══════════════════════════════════════════

  /** Instagram Likes & Shares */
  igLikesPackages: PackageItem[] = [
    {
      nameKey: 'PACKAGES.IG_LIKES_250_NAME',
      price: '150',
      duration: '',
      durationKey: '',
      descKey: 'PACKAGES.IG_LIKES_250_DESC',
      featured: true,
      badge: 'PACKAGES.SPECIAL_OFFER',
      features: ['PACKAGES.IG_LIKES_FEAT1', 'PACKAGES.IG_LIKES_FEAT2'],
      category: 'igLikes',
    },
  ];

  /** Instagram Followers */
  igFollowersPackages: PackageItem[] = [
    {
      nameKey: 'PACKAGES.IG_FOLLOW_1K_NAME',
      price: '415',
      duration: '',
      durationKey: '',
      descKey: 'PACKAGES.IG_FOLLOW_1K_DESC',
      featured: true,
      badge: 'PACKAGES.SPECIAL_OFFER',
      features: ['PACKAGES.IG_FOLLOW_FEAT1', 'PACKAGES.IG_FOLLOW_FEAT2'],
      category: 'igFollowers',
    },
  ];

  /** Instagram Comments */
  igCommentsPackages: PackageItem[] = [
    {
      nameKey: 'PACKAGES.IG_COMMENTS_100_NAME',
      price: '249',
      duration: '',
      durationKey: '',
      descKey: 'PACKAGES.IG_COMMENTS_100_DESC',
      featured: true,
      badge: 'PACKAGES.SPECIAL_OFFER',
      features: ['PACKAGES.IG_COMMENTS_FEAT1', 'PACKAGES.IG_COMMENTS_FEAT2'],
      category: 'igComments',
    },
  ];

  /** Instagram Reels / Video Views */
  igViewsPackages: PackageItem[] = [
    {
      nameKey: 'PACKAGES.IG_VIEWS_1K_NAME',
      price: '79',
      duration: '',
      durationKey: '',
      descKey: 'PACKAGES.IG_VIEWS_1K_DESC',
      featured: true,
      badge: 'PACKAGES.SPECIAL_OFFER',
      features: ['PACKAGES.IG_VIEWS_FEAT1', 'PACKAGES.IG_VIEWS_FEAT2'],
      category: 'igViews',
    },
  ];

  // ══════════════════════════════════════════
  // SOCIAL BOOST SERVICES — Telegram
  // ══════════════════════════════════════════

  /** Telegram Group / Channel Members */
  tgMembersPackages: PackageItem[] = [
    {
      nameKey: 'PACKAGES.TG_MEMBERS_1K_NAME',
      price: '295',
      duration: '',
      durationKey: '',
      descKey: 'PACKAGES.TG_MEMBERS_1K_DESC',
      featured: true,
      badge: 'PACKAGES.SPECIAL_OFFER',
      features: ['PACKAGES.TG_MEMBERS_FEAT1', 'PACKAGES.TG_MEMBERS_FEAT2'],
      category: 'tgMembers',
    },
  ];

  /** Telegram Verification */
  tgVerifyPackages: PackageItem[] = [
    {
      nameKey: 'PACKAGES.TG_VERIFY_NAME',
      price: '2,100',
      duration: '365',
      durationKey: 'PACKAGES.DAYS',
      descKey: 'PACKAGES.TG_VERIFY_DESC',
      featured: true,
      badge: 'PACKAGES.SPECIAL_OFFER',
      features: ['PACKAGES.TG_VERIFY_FEAT1', 'PACKAGES.TG_VERIFY_FEAT2'],
      category: 'tgVerify',
    },
  ];

  /** Telegram Post Views */
  tgPostViewsPackages: PackageItem[] = [
    {
      nameKey: 'PACKAGES.TG_POST_VIEWS_1K_NAME',
      price: '35',
      duration: '',
      durationKey: '',
      descKey: 'PACKAGES.TG_POST_VIEWS_1K_DESC',
      featured: true,
      badge: 'PACKAGES.SPECIAL_OFFER',
      features: ['PACKAGES.TG_POST_VIEWS_FEAT1'],
      category: 'tgPostViews',
    },
  ];

  /** Telegram Story Views */
  tgStoryViewsPackages: PackageItem[] = [
    {
      nameKey: 'PACKAGES.TG_STORY_VIEWS_1K_NAME',
      price: '70',
      duration: '',
      durationKey: '',
      descKey: 'PACKAGES.TG_STORY_VIEWS_1K_DESC',
      featured: true,
      badge: 'PACKAGES.SPECIAL_OFFER',
      features: ['PACKAGES.TG_STORY_VIEWS_FEAT1'],
      category: 'tgStoryViews',
    },
  ];

  /** Telegram Reactions / Likes */
  tgReactionsPackages: PackageItem[] = [
    {
      nameKey: 'PACKAGES.TG_REACT_250_NAME',
      price: '35',
      duration: '',
      durationKey: '',
      descKey: 'PACKAGES.TG_REACT_250_DESC',
      featured: true,
      badge: 'PACKAGES.SPECIAL_OFFER',
      features: ['PACKAGES.TG_REACT_FEAT1', 'PACKAGES.TG_GEO_FEAT'],
      category: 'tgReactions',
    },
  ];

  /** Telegram Votes / Polls */
  tgVotesPackages: PackageItem[] = [
    {
      nameKey: 'PACKAGES.TG_VOTES_250_NAME',
      price: '99',
      duration: '',
      durationKey: '',
      descKey: 'PACKAGES.TG_VOTES_250_DESC',
      featured: true,
      badge: 'PACKAGES.SPECIAL_OFFER',
      features: ['PACKAGES.TG_VOTES_FEAT1', 'PACKAGES.TG_GEO_FEAT'],
      category: 'tgVotes',
    },
  ];
}