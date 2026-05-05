import { Component, inject, AfterViewInit, HostListener, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterModule } from '@angular/router';
import { TranslateModule, TranslateService } from '@ngx-translate/core';
import { Theme } from '../../core/theme';
import Swal from 'sweetalert2';
import { environment } from '../../../environments/environment';
import { PackageItem } from '../../models/packageitem';
import { Packages } from '../../core/packages';

@Component({
  selector: 'app-services',
  standalone: true,
  imports: [CommonModule, RouterModule, TranslateModule],
  templateUrl: './services.html',
  styleUrl: './services.scss',
})
export class Services implements AfterViewInit, OnInit {
  private themeService = inject(Theme);
  private translate = inject(TranslateService);
  private router = inject(Router);
  private packagesService = inject(Packages);

  get isArabic(): boolean {
    return this.themeService.currentLang() === 'ar';
  }

  // Active tab for social boost section (separate from packages)
  activeBoostTab:
    | 'igLikes'
    | 'igFollowers'
    | 'igComments'
    | 'igViews'
    | 'tgMembers'
    | 'tgVerify'
    | 'tgPostViews'
    | 'tgStoryViews'
    | 'tgReactions'
    | 'tgVotes' = 'igFollowers';

  get activeBoostPackages(): PackageItem[] {
    switch (this.activeBoostTab) {
      case 'igLikes':
        return this.packagesService.igLikesPackages;
      case 'igFollowers':
        return this.packagesService.igFollowersPackages;
      case 'igComments':
        return this.packagesService.igCommentsPackages;
      case 'igViews':
        return this.packagesService.igViewsPackages;
      case 'tgMembers':
        return this.packagesService.tgMembersPackages;
      case 'tgVerify':
        return this.packagesService.tgVerifyPackages;
      case 'tgPostViews':
        return this.packagesService.tgPostViewsPackages;
      case 'tgStoryViews':
        return this.packagesService.tgStoryViewsPackages;
      case 'tgReactions':
        return this.packagesService.tgReactionsPackages;
      case 'tgVotes':
        return this.packagesService.tgVotesPackages;
    }
  }

  // Active tab for packages section
  activePackageTab:
    | 'local'
    | 'international'
    | 'management'
    | 'design'
    | 'classA'
    | 'classB'
    | 'website'
    | 'tiktok'
    | 'tiktokViews'
    | 'google'
    | 'snapchat'
    | 'youtube'
    | 'telegram'
    | 'pageFoundation'
    | 'pageCreation'
    | 'startup' = 'management';

  get activePackages(): PackageItem[] {
    switch (this.activePackageTab) {
      case 'local':
        return this.packagesService.localAdsPackages;
      case 'international':
        return this.packagesService.internationalAdsPackages;
      case 'management':
        return this.packagesService.pageManagementPackages;
      case 'design':
        return this.packagesService.designPackages;
      case 'classA':
        return this.packagesService.classAPackages;
      case 'classB':
        return this.packagesService.classBPackages;
      case 'website':
        return this.packagesService.websitePackages;
      case 'tiktok':
        return this.packagesService.tiktokPackages;
      case 'tiktokViews':
        return this.packagesService.tiktokViewsPackages;
      case 'google':
        return this.packagesService.googleAdsPackages;
      case 'snapchat':
        return this.packagesService.snapchatPackages;
      case 'youtube':
        return this.packagesService.youtubePackages;
      case 'telegram':
        return this.packagesService.telegramPackages;
      case 'pageFoundation':
        return this.packagesService.pageFoundationPackages;
      case 'pageCreation':
        return this.packagesService.pageCreationPackages;
      case 'startup':
        return this.packagesService.startupPackages;
      default:
        return this.packagesService.pageManagementPackages;
    }
  }

  // Tab groups for organized display
  packageTabGroups = [
    {
      groupKey: 'PACKAGES.GROUP_SOCIAL',
      icon: 'fa-share-alt',
      tabs: [
        { key: 'management', labelKey: 'PACKAGES.TAB_MANAGEMENT', icon: 'fa-share-alt' },
        { key: 'local', labelKey: 'PACKAGES.TAB_LOCAL_ADS', icon: 'fa-bullhorn' },
        { key: 'international', labelKey: 'PACKAGES.TAB_INTL_ADS', icon: 'fa-globe' },
        { key: 'classA', labelKey: 'PACKAGES.TAB_CLASS_A', icon: 'fa-star' },
        { key: 'classB', labelKey: 'PACKAGES.TAB_CLASS_B', icon: 'fa-layer-group' },
      ],
    },
    {
      groupKey: 'PACKAGES.GROUP_PLATFORMS',
      icon: 'fa-mobile-alt',
      tabs: [
        { key: 'tiktok', labelKey: 'PACKAGES.TAB_TIKTOK', icon: 'fa-music' },
        { key: 'tiktokViews', labelKey: 'PACKAGES.TAB_TIKTOK_VIEWS', icon: 'fa-eye' },
        { key: 'google', labelKey: 'PACKAGES.TAB_GOOGLE', icon: 'fa-search' },
        { key: 'snapchat', labelKey: 'PACKAGES.TAB_SNAPCHAT', icon: 'fa-ghost' },
        { key: 'youtube', labelKey: 'PACKAGES.TAB_YOUTUBE', icon: 'fa-play-circle' },
        { key: 'telegram', labelKey: 'PACKAGES.TAB_TELEGRAM', icon: 'fa-paper-plane' },
      ],
    },
    {
      groupKey: 'PACKAGES.GROUP_BUILD',
      icon: 'fa-rocket',
      tabs: [
        { key: 'design', labelKey: 'PACKAGES.TAB_DESIGN', icon: 'fa-paint-brush' },
        { key: 'website', labelKey: 'PACKAGES.TAB_WEBSITE', icon: 'fa-laptop-code' },
        { key: 'pageFoundation', labelKey: 'PACKAGES.TAB_PAGE_FOUNDATION', icon: 'fa-tools' },
        { key: 'pageCreation', labelKey: 'PACKAGES.TAB_PAGE_CREATION', icon: 'fa-plus-circle' },
        { key: 'startup', labelKey: 'PACKAGES.TAB_STARTUP', icon: 'fa-rocket' },
      ],
    },
  ] as const;

  // Social Boost Tab Groups (separate section)
  socialBoostTabGroups = [
    {
      groupKey: 'PACKAGES.GROUP_IG_BOOST',
      icon: 'fa-instagram',
      tabs: [
        { key: 'igLikes', labelKey: 'PACKAGES.TAB_IG_LIKES', icon: 'fa-thumbs-up' },
        { key: 'igFollowers', labelKey: 'PACKAGES.TAB_IG_FOLLOWERS', icon: 'fa-user-plus' },
        { key: 'igComments', labelKey: 'PACKAGES.TAB_IG_COMMENTS', icon: 'fa-comment' },
        { key: 'igViews', labelKey: 'PACKAGES.TAB_IG_VIEWS', icon: 'fa-eye' },
      ],
    },
    {
      groupKey: 'PACKAGES.GROUP_TG_BOOST',
      icon: 'fa-paper-plane',
      tabs: [
        { key: 'tgMembers', labelKey: 'PACKAGES.TAB_TG_MEMBERS', icon: 'fa-users' },
        { key: 'tgVerify', labelKey: 'PACKAGES.TAB_TG_VERIFY', icon: 'fa-check-circle' },
        { key: 'tgPostViews', labelKey: 'PACKAGES.TAB_TG_POST_VIEWS', icon: 'fa-eye' },
        { key: 'tgStoryViews', labelKey: 'PACKAGES.TAB_TG_STORY_VIEWS', icon: 'fa-film' },
        { key: 'tgReactions', labelKey: 'PACKAGES.TAB_TG_REACTIONS', icon: 'fa-heart' },
        { key: 'tgVotes', labelKey: 'PACKAGES.TAB_TG_VOTES', icon: 'fa-poll' },
      ],
    },
  ] as const;

  // Flat list kept for backward-compat if needed
  packageTabs = [
    { key: 'management', labelKey: 'PACKAGES.TAB_MANAGEMENT', icon: 'fa-share-alt' },
    { key: 'local', labelKey: 'PACKAGES.TAB_LOCAL_ADS', icon: 'fa-bullhorn' },
    { key: 'international', labelKey: 'PACKAGES.TAB_INTL_ADS', icon: 'fa-globe' },
    { key: 'classA', labelKey: 'PACKAGES.TAB_CLASS_A', icon: 'fa-star' },
    { key: 'classB', labelKey: 'PACKAGES.TAB_CLASS_B', icon: 'fa-layer-group' },
    { key: 'tiktok', labelKey: 'PACKAGES.TAB_TIKTOK', icon: 'fa-music' },
    { key: 'tiktokViews', labelKey: 'PACKAGES.TAB_TIKTOK_VIEWS', icon: 'fa-eye' },
    { key: 'google', labelKey: 'PACKAGES.TAB_GOOGLE', icon: 'fa-search' },
    { key: 'snapchat', labelKey: 'PACKAGES.TAB_SNAPCHAT', icon: 'fa-ghost' },
    { key: 'youtube', labelKey: 'PACKAGES.TAB_YOUTUBE', icon: 'fa-play-circle' },
    { key: 'telegram', labelKey: 'PACKAGES.TAB_TELEGRAM', icon: 'fa-paper-plane' },
    { key: 'design', labelKey: 'PACKAGES.TAB_DESIGN', icon: 'fa-paint-brush' },
    { key: 'website', labelKey: 'PACKAGES.TAB_WEBSITE', icon: 'fa-laptop-code' },
    { key: 'pageFoundation', labelKey: 'PACKAGES.TAB_PAGE_FOUNDATION', icon: 'fa-tools' },
    { key: 'pageCreation', labelKey: 'PACKAGES.TAB_PAGE_CREATION', icon: 'fa-plus-circle' },
    { key: 'startup', labelKey: 'PACKAGES.TAB_STARTUP', icon: 'fa-rocket' },
  ] as const;

  services = [
    {
      num: '01',
      icon: 'fa-paint-brush',
      slug: 'design',
      serviceValue: 'design',
      gradientBg: 'linear-gradient(135deg, rgba(212,175,55,0.15), rgba(212,175,55,0.05))',
      titleKey: 'SERVICES.S1_TITLE',
      descKey: 'SERVICES.S1_DESC',
      features: ['SERVICES_PAGE.F1_1', 'SERVICES_PAGE.F1_2', 'SERVICES_PAGE.F1_3'],
    },
    {
      num: '02',
      icon: 'fa-share-alt',
      slug: 'social',
      serviceValue: 'social',
      gradientBg: 'linear-gradient(135deg, rgba(37,211,102,0.12), rgba(37,211,102,0.03))',
      titleKey: 'SERVICES.S2_TITLE',
      descKey: 'SERVICES.S2_DESC',
      features: ['SERVICES_PAGE.F2_1', 'SERVICES_PAGE.F2_2', 'SERVICES_PAGE.F2_3'],
    },
    {
      num: '03',
      icon: 'fa-bullhorn',
      slug: 'ads',
      serviceValue: 'ads',
      gradientBg: 'linear-gradient(135deg, rgba(252,129,74,0.12), rgba(252,129,74,0.03))',
      titleKey: 'SERVICES.S4_TITLE',
      descKey: 'SERVICES.S4_DESC',
      features: ['SERVICES_PAGE.F4_1', 'SERVICES_PAGE.F4_2', 'SERVICES_PAGE.F4_3'],
    },
    {
      num: '04',
      icon: 'fa-laptop-code',
      slug: 'web',
      serviceValue: 'web',
      gradientBg: 'linear-gradient(135deg, rgba(99,179,237,0.12), rgba(99,179,237,0.03))',
      titleKey: 'SERVICES.S3_TITLE',
      descKey: 'SERVICES.S3_DESC',
      features: ['SERVICES_PAGE.F3_1', 'SERVICES_PAGE.F3_2', 'SERVICES_PAGE.F3_3'],
    },
    {
      num: '05',
      icon: 'fa-rocket',
      slug: 'boost',
      serviceValue: 'boost',
      gradientBg: 'linear-gradient(135deg, rgba(159,122,234,0.12), rgba(159,122,234,0.03))',
      titleKey: 'SERVICES.S10_TITLE',
      descKey: 'SERVICES.S10_DESC',
      features: ['SERVICES_PAGE.F10_1', 'SERVICES_PAGE.F10_2', 'SERVICES_PAGE.F10_3'],
    },
    {
      num: '06',
      icon: 'fa-film',
      slug: 'video',
      serviceValue: 'video',
      gradientBg: 'linear-gradient(135deg, rgba(72,187,120,0.12), rgba(72,187,120,0.03))',
      titleKey: 'SERVICES.S11_TITLE',
      descKey: 'SERVICES.S11_DESC',
      features: ['SERVICES_PAGE.F11_1', 'SERVICES_PAGE.F11_2', 'SERVICES_PAGE.F11_3'],
    },
    {
      num: '07',
      icon: 'fa-chart-line',
      slug: 'seo',
      serviceValue: 'seo',
      gradientBg: 'linear-gradient(135deg, rgba(99,179,237,0.12), rgba(99,179,237,0.03))',
      titleKey: 'SERVICES.S12_TITLE',
      descKey: 'SERVICES.S12_DESC',
      features: ['SERVICES_PAGE.F12_1', 'SERVICES_PAGE.F12_2', 'SERVICES_PAGE.F12_3'],
    },
    {
      num: '08',
      icon: 'fa-user-shield',
      slug: 'moderator',
      serviceValue: 'moderator',
      gradientBg: 'linear-gradient(135deg, rgba(245,200,66,0.12), rgba(245,200,66,0.03))',
      titleKey: 'SERVICES.S13_TITLE',
      descKey: 'SERVICES.S13_DESC',
      features: ['SERVICES_PAGE.F13_1', 'SERVICES_PAGE.F13_2', 'SERVICES_PAGE.F13_3'],
    },
    {
      num: '09',
      icon: 'fa-star',
      slug: 'brand_plan',
      serviceValue: 'brand_plan',
      gradientBg: 'linear-gradient(135deg, rgba(212,175,55,0.15), rgba(212,175,55,0.05))',
      titleKey: 'SERVICES.S14_TITLE',
      descKey: 'SERVICES.S14_DESC',
      features: ['SERVICES_PAGE.F14_1', 'SERVICES_PAGE.F14_2', 'SERVICES_PAGE.F14_3'],
    },
  ];

  whyUs = [
    {
      icon: 'fa-medal',
      titleKey: 'SERVICES_PAGE.WHY_1_TITLE',
      descKey: 'SERVICES_PAGE.WHY_1_DESC',
    },
    {
      icon: 'fa-rocket',
      titleKey: 'SERVICES_PAGE.WHY_2_TITLE',
      descKey: 'SERVICES_PAGE.WHY_2_DESC',
    },
    {
      icon: 'fa-chart-line',
      titleKey: 'SERVICES_PAGE.WHY_3_TITLE',
      descKey: 'SERVICES_PAGE.WHY_3_DESC',
    },
    {
      icon: 'fa-headset',
      titleKey: 'SERVICES_PAGE.WHY_4_TITLE',
      descKey: 'SERVICES_PAGE.WHY_4_DESC',
    },
  ];

  ngOnInit() {}

  ngAfterViewInit() {
    setTimeout(() => this.checkReveal(), 100);
  }

  @HostListener('window:scroll')
  onScroll() {
    this.checkReveal();
  }

  private checkReveal() {
    document.querySelectorAll('.reveal').forEach((el) => {
      const rect = el.getBoundingClientRect();
      if (rect.top < window.innerHeight * 0.88) el.classList.add('visible');
    });
  }

  goToContact(serviceValue: string) {
    this.router.navigate(['/contact'], {
      queryParams: { service: serviceValue },
    });
  }

  // ── NEW: navigate to the service detail page ──────────────────────────────
  goToDetails(slug: string) {
    this.router.navigate(['/services', slug]);
  }
  // ─────────────────────────────────────────────────────────────────────────

  setActiveTab(tab: typeof this.activePackageTab) {
    this.activePackageTab = tab;
    setTimeout(() => this.checkReveal(), 50);
  }

  setActiveBoostTab(tab: typeof this.activeBoostTab) {
    this.activeBoostTab = tab;
    setTimeout(() => this.checkReveal(), 50);
  }

  openPackagePopup(pkg: PackageItem) {
    const packageName = this.translate.instant(pkg.nameKey);
    const days = pkg.duration ? `${pkg.duration} ${this.translate.instant(pkg.durationKey)}` : '';
    const adBudgetLabel = this.isArabic ? 'ميزانية الإعلان' : 'Ad Budget';
    const feeLabel = this.isArabic ? 'رسوم الإدارة' : 'Management Fee';

    const budgetHtml = pkg.adBudget
      ? `<p><strong>📊 ${adBudgetLabel}:</strong> <span style="color:var(--gold)">${pkg.adBudget} EGP</span></p>
         <p><strong>⚙️ ${feeLabel}:</strong> <span style="opacity:.7">${pkg.managementFee} EGP</span></p>`
      : '';

    Swal.fire({
      background: getComputedStyle(document.documentElement).getPropertyValue('--bg-card'),
      color: getComputedStyle(document.documentElement).getPropertyValue('--text-main'),
      width: '440px',
      title: this.isArabic ? '✨ اطلب باقتك الآن' : '✨ Order Your Package',
      html: `
<div style="text-align:${this.isArabic ? 'right' : 'left'}; line-height:1.8">
  <p style="opacity:.7; font-size:14px">
    ${this.isArabic ? 'ابدأ دلوقتي وخلي شغلك يوصل لمستوى أعلى 🚀' : 'Start now and take your business to the next level 🚀'}
  </p>
  <div class="swal-package-box">
    <p><strong>📦 ${this.isArabic ? 'الباقة' : 'Package'}:</strong> ${packageName}</p>
    <p><strong>💰 ${this.isArabic ? 'السعر الإجمالي' : 'Total Price'}:</strong> <span class="gold-text">${pkg.price} EGP</span></p>
    ${days ? `<p><strong>📅 ${this.isArabic ? 'المدة' : 'Duration'}:</strong> ${days}</p>` : ''}
    ${budgetHtml}
  </div>
</div>`,
      showCancelButton: true,
      showDenyButton: true,
      didOpen: () => {
        document.body.classList.add('swal-opened');
      },
      confirmButtonText: this.isArabic
        ? '<i class="fas fa-headset"></i> تواصل معنا'
        : '<i class="fas fa-headset"></i> Contact Us',
      denyButtonText: this.isArabic
        ? '<i class="fab fa-whatsapp"></i> واتساب'
        : '<i class="fab fa-whatsapp"></i> WhatsApp',
      cancelButtonText: this.isArabic ? 'إلغاء' : 'Cancel',
      customClass: {
        popup: 'lux-popup',
        confirmButton: 'btn-contact',
        denyButton: 'btn-whatsapp',
        cancelButton: 'btn-cancel',
      },
      buttonsStyling: false,
    }).then((result) => {
      if (result.isConfirmed) {
        const tabToService: Record<string, string> = {
          management: 'social',
          local: 'ads',
          international: 'ads',
          classA: 'ads',
          classB: 'ads',
          tiktok: 'ads',
          tiktokViews: 'boost',
          google: 'ads',
          snapchat: 'ads',
          youtube: 'ads',
          telegram: 'ads',
          design: 'design',
          website: 'web',
          pageFoundation: 'social',
          pageCreation: 'social',
          startup: 'social',
        };
        const tabToPlatforms: Record<string, string[]> = {
          management: ['facebook', 'instagram'],
          local: ['facebook', 'instagram'],
          international: ['facebook', 'instagram'],
          classA: ['facebook', 'instagram'],
          classB: ['facebook', 'instagram'],
          tiktok: ['tiktok'],
          tiktokViews: ['tiktok'],
          google: ['google'],
          snapchat: ['snapchat'],
          youtube: ['youtube'],
          telegram: ['telegram'],
          design: ['facebook', 'instagram'],
          website: ['facebook', 'instagram'],
          pageFoundation: ['facebook', 'instagram'],
          pageCreation: ['facebook', 'instagram'],
          startup: ['facebook', 'instagram'],
        };
        const serviceValue = tabToService[this.activePackageTab] || '';
        const platformsValue = tabToPlatforms[this.activePackageTab] || [];
        try {
          sessionStorage.setItem(
            'selected_package',
            JSON.stringify({
              package: packageName,
              price: pkg.price,
              service: serviceValue,
              platforms: platformsValue,
            }),
          );
        } catch {}
        this.router.navigate(['/contact']);
      }
      if (result.isDenied) {
        const msg = `${this.isArabic ? 'الباقة' : 'Package'}: ${packageName}\n${this.isArabic ? 'السعر' : 'Price'}: ${pkg.price} EGP${days ? `\n${this.isArabic ? 'المدة' : 'Duration'}: ${days}` : ''}`;
        window.open(
          `https://wa.me/${environment.WhatsappNumber}?text=${encodeURIComponent(msg)}`,
          '_blank',
        );
      }
    });
  }
}
