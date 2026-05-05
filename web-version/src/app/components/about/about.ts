import {
  Component,
  inject,
  AfterViewInit,
  OnDestroy,
  HostListener,
  ViewChild,
  ElementRef,
} from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { TranslateModule } from '@ngx-translate/core';
import { Theme } from '../../core/theme';

@Component({
  selector: 'app-about',
  standalone: true,
  imports: [CommonModule, RouterModule, TranslateModule],
  templateUrl: './about.html',
  styleUrl: './about.scss',
})
export class About implements AfterViewInit, OnDestroy {
  private themeService = inject(Theme);

  @ViewChild('ceoVideo') ceoVideoRef!: ElementRef<HTMLVideoElement>;
  @ViewChild('videoPreloader') videoPreloaderRef!: ElementRef<HTMLDivElement>;

  /** Whether the user has pressed play (controls visibility of preloader overlay) */
  videoStarted = false;

  /** Formatted duration string (e.g. "2:34") — populated once metadata loads */
  videoDuration: string | null = null;
  contractIndex = 0;
  contractZoomOpen = false;
  contractZoomIndex = 0;

  get isArabic(): boolean {
    return this.themeService.currentLang() === 'ar';
  }

  // ── Data ────────────────────────────────────────────────────
  stats = [
    { num: '+400,000', labelKey: 'PORTFOLIO.STATS_PROJECTS', icon: 'fa-briefcase' },
    { num: '+5000', labelKey: 'PORTFOLIO.STATS_CLIENTS', icon: 'fa-handshake' },
    { num: '12+', labelKey: 'PORTFOLIO.STATS_YEARS', icon: 'fa-calendar-alt' },
    { num: '93%', labelKey: 'PORTFOLIO.STATS_RATE', icon: 'fa-star' },
  ];

  values = [
    {
      icon: 'fa-lightbulb',
      color: '#D4AF37',
      titleKey: 'ABOUT.V1_TITLE',
      descKey: 'ABOUT.V1_DESC',
    },
    { icon: 'fa-eye', color: '#63B3ED', titleKey: 'ABOUT.V2_TITLE', descKey: 'ABOUT.V2_DESC' },
    {
      icon: 'fa-chart-line',
      color: '#68D391',
      titleKey: 'ABOUT.V3_TITLE',
      descKey: 'ABOUT.V3_DESC',
    },
    {
      icon: 'fa-handshake',
      color: '#F6AD55',
      titleKey: 'ABOUT.V4_TITLE',
      descKey: 'ABOUT.V4_DESC',
    },
  ];

  whyUs = [
    {
      icon: 'fa-rocket',
      color: '#D4AF37',
      num: '+400,000',
      titleAr: 'مشروع منجز',
      titleEn: 'Projects Delivered',
      descAr: 'أنجزنا أكثر من 400,000 مشروع في مجالات متعددة بجودة لا تُنافَس.',
      descEn: 'Over 400,000 projects delivered across industries with unmatched quality.',
      bar: '92%',
    },
    {
      icon: 'fa-chart-line',
      color: '#68D391',
      num: '3.8x',
      titleAr: 'متوسط عائد الاستثمار',
      titleEn: 'Avg. ROI Multiplier',
      descAr: 'عملاؤنا يحققون في المتوسط 3.8 ضعف ما ينفقونه على التسويق.',
      descEn: 'Our clients earn on average 3.8x their marketing spend in measurable returns.',
      bar: '85%',
    },
    {
      icon: 'fa-clock',
      color: '#63B3ED',
      num: '24h',
      titleAr: 'وقت الاستجابة',
      titleEn: 'Response Time',
      descAr: 'نرد على جميع استفسارات العملاء خلال 24 ساعة كحد أقصى.',
      descEn: 'We respond to all client inquiries within 24 hours — no exceptions.',
      bar: '100%',
    },
    {
      icon: 'fa-shield-alt',
      color: '#F6AD55',
      num: '93%',
      titleAr: 'معدل رضا العملاء',
      titleEn: 'Client Satisfaction',
      descAr: '93% من عملائنا يوصون بنا لشركاء أعمالهم بعد أول تجربة.',
      descEn: '93% of our clients refer us to their business partners after the first project.',
      bar: '93%',
    },
  ];

  bannerStats = [
    { num: '12+', labelAr: 'سنوات خبرة', labelEn: 'Years Experience' },
    { num: '+5000', labelAr: 'عميل نشط', labelEn: 'Active Clients' },
    { num: '15+', labelAr: 'متخصص', labelEn: 'Specialists' },
    { num: '4', labelAr: 'دول خليجية', labelEn: 'GCC Countries' },
  ];

  storyMeta = [
    { icon: 'fa-calendar-alt', labelKey: 'ABOUT.STORY_FOUNDED', valKey: 'ABOUT.STORY_FOUNDED_VAL' },
    { icon: 'fa-map-marker-alt', labelKey: 'ABOUT.STORY_HQ', valKey: 'ABOUT.STORY_HQ_VAL' },
    { icon: 'fa-users', labelKey: 'ABOUT.STORY_TEAM', valKey: 'ABOUT.STORY_TEAM_VAL' },
  ];

  ceoHighlights = [
    {
      color: '#D4AF37',
      ar: 'رؤية إبداعية تجمع بين الفن والبيانات',
      en: 'Creative vision combining art and data',
    },
    {
      color: '#68D391',
      ar: 'استراتيجيات مُخصَّصة لكل عميل على حدة',
      en: 'Tailored strategies for each client individually',
    },
    {
      color: '#63B3ED',
      ar: 'شفافية كاملة في التقارير والنتائج',
      en: 'Full transparency in reporting and results',
    },
  ];

  // ── Team Members ─────────────────────────────────────────────
  team = [
    {
      nameAr: 'ياسمين',
      nameEn: 'Yasmine',
      roleAr: 'Account Manager',
      roleEn: 'Account Manager',
      avatar: 'about/team/yasmine.png',
    },
    {
      nameAr: 'محمود السيد',
      nameEn: 'Mahmoud Elsayed',
      roleAr: 'Team Leader & Video Editor',
      roleEn: 'Team Leader & Video Editor',
      avatar: 'about/team/mahmoud.png',
    },
    {
      nameAr: 'هاجر',
      nameEn: 'Hagar',
      roleAr: 'Operations Coordinator',
      roleEn: 'Operations Coordinator',
      avatar: 'about/team/hagar.png',
    },
    {
      nameAr: 'أحمد السيد',
      nameEn: 'Ahmed Elsayed',
      roleAr: 'Web Developer',
      roleEn: 'Web Developer',
      avatar: 'about/team/ahmed.png',
    },
    {
      nameAr: 'مريم محمد',
      nameEn: 'Mariam Mohamed',
      roleAr: 'مصممة جرافيك',
      roleEn: 'Graphic Designer',
    },
  ];

  // ── Lifecycle ────────────────────────────────────────────────
  private _revealObserver: IntersectionObserver | null = null;
  private _counterObserver: IntersectionObserver | null = null;

  ngAfterViewInit() {
    this._revealObserver = this.initScrollReveal();
    this._counterObserver = this.initCounters();
    this.initVideoPreload();
  }

  ngOnDestroy() {
    this._revealObserver?.disconnect();
    this._counterObserver?.disconnect();
  }

  @HostListener('document:keydown.escape')
  onEscape() {
    if (this.contractZoomOpen) this.closeContractZoom();
  }

  // ── Video Methods ────────────────────────────────────────────

  /**
   * Preload the video metadata (poster + duration) without buffering
   * the full file. The <video> already has preload="metadata", so
   * this just ensures the element is ready and grabs the duration.
   */
  private initVideoPreload(): void {
    const video = this.ceoVideoRef?.nativeElement;
    if (!video) return;

    // If metadata is already available (cached), populate duration now
    if (video.readyState >= 1) {
      this.formatAndSetDuration(video.duration);
    }
  }

  contractNext(): void {
    this.contractIndex = (this.contractIndex + 1) % 2;
  }

  contractPrev(): void {
    this.contractIndex = (this.contractIndex - 1 + 2) % 2;
  }

  openContractZoom(index: number): void {
    this.contractZoomIndex = index;
    this.contractZoomOpen = true;
    document.body.style.overflow = 'hidden';
  }

  closeContractZoom(): void {
    this.contractZoomOpen = false;
    document.body.style.overflow = '';
  }

  zoomNext(): void {
    this.contractZoomIndex = (this.contractZoomIndex + 1) % 2;
  }

  zoomPrev(): void {
    this.contractZoomIndex = (this.contractZoomIndex - 1 + 2) % 2;
  }

  /** Called by (loadedmetadata) binding in the template */
  onVideoMetadata(): void {
    const video = this.ceoVideoRef?.nativeElement;
    if (video) this.formatAndSetDuration(video.duration);
  }

  /** Called by (play) binding — hides the preloader overlay */
  onVideoPlay(): void {
    this.videoStarted = true;
    const preloader = this.videoPreloaderRef?.nativeElement;
    if (preloader) preloader.classList.add('hidden');
  }

  /** Custom play-button click: show native controls and start playback */
  playVideo(): void {
    const video = this.ceoVideoRef?.nativeElement;
    if (!video) return;
    this.videoStarted = true;
    const preloader = this.videoPreloaderRef?.nativeElement;
    if (preloader) preloader.classList.add('hidden');
    video.play().catch(() => {
      // Autoplay blocked; controls still visible so user can press play
    });
  }

  /** Called when user clicks the PDF cover frame — opens portfolio in Google Drive viewer */
  openPortfolioPdf(): void {
    window.open(
      'https://drive.google.com/file/d/1WjNShO_Fb3ZCVe5tPnvpuViNkjJ5VLCA/view?usp=drive_link',
      '_blank',
      'noopener,noreferrer',
    );
  }

  /** Triggers browser download of the portfolio PDF */
  downloadPortfolioPdf(): void {
    const a = document.createElement('a');
    a.href = 'works/Portfolio_Etba3ly.pdf';
    a.download = 'Portfolio_Etbaly.pdf';
    a.click();
  }

  private formatAndSetDuration(seconds: number): void {
    if (!seconds || !isFinite(seconds)) return;
    const m = Math.floor(seconds / 60);
    const s = Math.floor(seconds % 60);
    this.videoDuration = `${m}:${s.toString().padStart(2, '0')}`;
  }

  // ── Scroll Reveal ────────────────────────────────────────────
  private initScrollReveal(): IntersectionObserver {
    const selectors = [
      '.reveal',
      '.reveal-left',
      '.reveal-right',
      '.reveal-down',
      '.reveal-scale',
      '.about-stat',
      '.team-card',
      '.about-why-card',
      '.about-value-card',
    ];

    const allEls: Element[] = [];
    selectors.forEach((sel) => document.querySelectorAll(sel).forEach((el) => allEls.push(el)));

    // أي عنصر ظاهر مباشرةً — أضفله visible فوراً
    allEls.forEach((el) => {
      const rect = el.getBoundingClientRect();
      if (rect.top < window.innerHeight * 0.98) el.classList.add('visible');
    });

    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add('visible');
            observer.unobserve(entry.target);
          }
        });
      },
      { threshold: 0.1, rootMargin: '0px 0px -40px 0px' },
    );

    allEls.forEach((el) => {
      if (!el.classList.contains('visible')) observer.observe(el);
    });

    return observer;
  }

  // ── Counter Animation ─────────────────────────────────────────
  private initCounters(): IntersectionObserver {
    const selectors = [
      '.about-stat-num',
      '.about-portfolio-stat-num',
      '.about-why-bstat-num',
      '.about-why-num',
    ];

    const elements: Element[] = [];
    selectors.forEach((sel) => document.querySelectorAll(sel).forEach((el) => elements.push(el)));

    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            this.animateCounter(entry.target as HTMLElement, 1800);
            observer.unobserve(entry.target);
          }
        });
      },
      { threshold: 0.3 },
    );

    elements.forEach((el) => observer.observe(el));
    return observer;
  }

  private animateCounter(el: HTMLElement, duration: number): void {
    const raw = el.textContent?.trim() ?? '';

    // استخرج prefix (+ في البداية)
    let prefix = '';
    let rest = raw;
    if (rest.startsWith('+')) {
      prefix = '+';
      rest = rest.slice(1);
    }

    // ازل فواصل الآلاف
    rest = rest.replace(/,/g, '');

    // استخرج الرقم والـ suffix
    const match = rest.match(/^([\d.]+)(.*)$/);
    if (!match) return;

    const numStr = match[1];
    const suffix = match[2] ?? '';
    const target = parseFloat(numStr);
    const decimals = (numStr.split('.')[1] ?? '').length;

    if (isNaN(target) || target === 0) return;

    const startTime = performance.now();

    const formatNum = (n: number): string => {
      const rounded = decimals > 0 ? n.toFixed(decimals) : String(Math.round(n));
      // أضف فاصلة آلاف
      return rounded.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    };

    const tick = (now: number) => {
      const elapsed = now - startTime;
      const progress = Math.min(elapsed / duration, 1);
      // easeOutExpo
      const eased = progress === 1 ? 1 : 1 - Math.pow(2, -10 * progress);
      el.textContent = prefix + formatNum(eased * target) + suffix;
      if (progress < 1) requestAnimationFrame(tick);
      else el.textContent = prefix + formatNum(target) + suffix;
    };

    requestAnimationFrame(tick);
  }
}
