import {
  Component,
  inject,
  OnInit,
  AfterViewInit,
  OnDestroy,
  HostListener,
  ElementRef,
  ChangeDetectionStrategy,
  ChangeDetectorRef,
} from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterLink, RouterModule } from '@angular/router';
import { TranslateModule } from '@ngx-translate/core';
import { Theme } from '../../core/theme';
import { SpecialtyMedia } from '../../models/portfolio';
import { PortfolioData } from '../../core/portfolio-data';
import { HttpClient } from '@angular/common/http';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [CommonModule, RouterModule, TranslateModule, RouterLink, FormsModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './home.html',
  styleUrl: './home.scss',
})
export class Home implements OnInit, AfterViewInit, OnDestroy {
  private themeService = inject(Theme);
  private router = inject(Router);
  private data = inject(PortfolioData);
  private el = inject(ElementRef);
  private cdr = inject(ChangeDetectorRef);
  private http = inject(HttpClient);
  currentImageItem: SpecialtyMedia | null = null;

  private tiltCard: HTMLElement | null = null;
  private tiltRAF: number | null = null;
  private isMobile = false;
  stripImagesLoop: string[] = [];
  currentProjectIndex: number = 0;

  // Trail canvas
  private trailCanvas: HTMLCanvasElement | null = null;
  private trailCtx: CanvasRenderingContext2D | null = null;
  private trailPoints: { x: number; y: number; alpha: number; size: number }[] = [];
  private trailRAF: number | null = null;
  private heroSection: HTMLElement | null = null;

  // Wave canvas
  private waveCanvas: HTMLCanvasElement | null = null;
  private waveCtx: CanvasRenderingContext2D | null = null;
  private waveRAF: number | null = null;
  private waveTime = 0;

  // Particle mesh canvas
  private particleCanvas: HTMLCanvasElement | null = null;
  private particleCtx: CanvasRenderingContext2D | null = null;
  private particleRAF: number | null = null;
  private particles: {
    x: number;
    y: number;
    vx: number;
    vy: number;
    size: number;
    alpha: number;
    baseAlpha: number;
    pulseOffset: number;
    pulseSpeed: number;
  }[] = [];
  private mouseHeroX = -9999;
  private mouseHeroY = -9999;
  private isMouseInHero = false;
  private isDark = true;

  // Cursor glow (magnetic field)
  private cursorGlow: HTMLElement | null = null;
  private cursorGlowRAF: number | null = null;
  private mouseX = 0;
  private mouseY = 0;
  private glowX = 0;
  private glowY = 0;

  // Intersection Observer for reveal
  private revealObserver: IntersectionObserver | null = null;

  get isArabic(): boolean {
    return this.themeService.currentLang() === 'ar';
  }

  get isDayMode(): boolean {
    return !this.themeService.isDarkMode();
  }

  nlEmail = '';
  nlLoading = false;
  nlSuccess = false;
  nlDuplicate = false;
  nlRateLimited = false;
  nlRateLimitMsg = '';
  nlError = false;
  nlErrorMsg = '';
  nlEmailDomainBlocked = false;

  // ── Client-side 30-minute cooldown ─────────────────────────
  private readonly NL_COOLDOWN_MS = 30 * 60 * 1000; // 30 min
  private readonly NL_COOLDOWN_KEY = 'nl_last_submit';

  nlCooldownActive = false;
  nlCooldownRemaining = '';
  private nlCooldownInterval: any = null;

  private startCooldownTimer(): void {
    localStorage.setItem(this.NL_COOLDOWN_KEY, Date.now().toString());
    this.updateCooldownState();
    this.nlCooldownInterval = setInterval(() => this.updateCooldownState(), 1000);
  }

  private updateCooldownState(): void {
    const stored = localStorage.getItem(this.NL_COOLDOWN_KEY);
    if (!stored) {
      this.nlCooldownActive = false;
      return;
    }

    const elapsed = Date.now() - parseInt(stored, 10);
    const remaining = this.NL_COOLDOWN_MS - elapsed;

    if (remaining <= 0) {
      this.nlCooldownActive = false;
      localStorage.removeItem(this.NL_COOLDOWN_KEY);
      if (this.nlCooldownInterval) {
        clearInterval(this.nlCooldownInterval);
        this.nlCooldownInterval = null;
      }
    } else {
      this.nlCooldownActive = true;
      const mins = Math.floor(remaining / 60000);
      const secs = Math.floor((remaining % 60000) / 1000);
      this.nlCooldownRemaining = `${mins}:${secs.toString().padStart(2, '0')}`;
    }
    this.cdr.markForCheck();
  }

  private checkCooldownOnInit(): void {
    this.updateCooldownState();
    if (this.nlCooldownActive && !this.nlCooldownInterval) {
      this.nlCooldownInterval = setInterval(() => this.updateCooldownState(), 1000);
    }
  }

  // ── Strip images (shown below hero) ──────────────────────
  images_tab_ar = [
    'images/tab-ar/tab_1.jpeg',
    'images/tab-ar/tab_2.jpeg',
    'images/tab-ar/tab_3.jpeg',
    'images/tab-ar/tab_4.jpeg',
    'images/tab-ar/tab_5.jpeg',
    'images/tab-ar/tab_6.jpeg',
    'images/tab-ar/tab_7.jpeg',
    'images/tab-ar/tab_8.jpeg',
    'images/tab-ar/tab_9.jpeg',
    'images/tab-ar/tab_10.jpeg',
  ];

  images_tab_en = [
    'images/tab-en/tab_1.png',
    'images/tab-en/tab_2.png',
    'images/tab-en/tab_3.png',
    'images/tab-en/tab_4.png',
    'images/tab-en/tab_5.png',
    'images/tab-en/tab_6.png',
    'images/tab-en/tab_7.png',
    'images/tab-en/tab_8.png',
    'images/tab-en/tab_9.png',
    'images/tab-en/tab_10.jpeg',
  ];

  get stripImages(): string[] {
    return this.isArabic ? this.images_tab_ar : this.images_tab_en;
  }

  // ── Strip drag state ──────────────────────────────────────
  private stripTrack: HTMLElement | null = null;
  private stripWrap: HTMLElement | null = null;
  private stripAutoX = 0;
  private stripDragDelta = 0;
  private stripDragVelocity = 0;
  private stripIsDragging = false;
  private stripDragStartX = 0;
  private stripDragStartScroll = 0;
  private stripRAF: number | null = null;

  // ── Scroll Parallax 3D ────────────────────────────────────
  private scrollParallaxRAF: number | null = null;
  private lastScrollY = 0;

  // ── Logo 3D state ─────────────────────────────────────────
  private logoCard: HTMLElement | null = null;
  private logoRAF: number | null = null;

  // ── PNG Logo 3D Interactive (mouse tilt on png) ────────────
  private initLogoPng3D() {
    const pngImg = document.getElementById('heroLogoPng') as HTMLImageElement | null;
    const shine = document.getElementById('heroPngShine');
    const card = document.getElementById('heroLogoCard');
    if (!pngImg || this.isMobile) return;

    const onMove = (e: MouseEvent) => {
      if (!card) return;
      const rect = card.getBoundingClientRect();
      const x = e.clientX - rect.left;
      const y = e.clientY - rect.top;
      const cx = rect.width / 2;
      const cy = rect.height / 2;
      const rx = ((y - cy) / cy) * -18;
      const ry = ((x - cx) / cx) * 22;

      pngImg.style.transform = `rotateX(${rx}deg) rotateY(${ry}deg) scale(1.06)`;
      pngImg.style.transition = 'none';
      pngImg.style.filter = `drop-shadow(0 0 ${20 + Math.abs(ry)}px rgba(201,162,39,0.75)) drop-shadow(${ry * 0.3}px ${rx * 0.2}px 24px rgba(0,0,0,0.4))`;

      if (shine) {
        const gx = (x / rect.width) * 100;
        const gy = (y / rect.height) * 100;
        shine.style.background = `radial-gradient(ellipse at ${gx}% ${gy}%, rgba(255,255,235,0.42) 0%, transparent 60%)`;
        shine.style.opacity = '1';
      }
    };

    const onLeave = () => {
      pngImg.style.transform = '';
      pngImg.style.transition = 'transform 0.7s cubic-bezier(0.23,1,0.32,1), filter 0.5s ease';
      pngImg.style.filter = '';
      if (shine) shine.style.opacity = '0.4';
    };

    card?.addEventListener('mousemove', onMove);
    card?.addEventListener('mouseleave', onLeave);

    // Mobile gyro tilt
    if (window.DeviceOrientationEvent) {
      window.addEventListener(
        'deviceorientation',
        (ev: DeviceOrientationEvent) => {
          const rx = Math.max(-12, Math.min(12, (ev.beta ?? 0) - 45)) * 0.5;
          const ry = Math.max(-12, Math.min(12, ev.gamma ?? 0)) * 0.5;
          pngImg.style.transform = `rotateX(${rx}deg) rotateY(${ry}deg)`;
        },
        { passive: true },
      );
    }
  }

  // Legacy (kept for compatibility, not used for hero display)
  currentIndex = 0;
  isFading = false;
  interval: any;
  currentImage = '';

  services = [
    {
      icon: 'fa-paint-brush',
      slug: 'design',
      titleKey: 'SERVICES.S1_TITLE',
      descKey: 'SERVICES.S1_DESC',
    },
    {
      icon: 'fa-share-alt',
      slug: 'social',
      titleKey: 'SERVICES.S2_TITLE',
      descKey: 'SERVICES.S2_DESC',
    },
    {
      icon: 'fa-laptop-code',
      slug: 'web',
      titleKey: 'SERVICES.S3_TITLE',
      descKey: 'SERVICES.S3_DESC',
    },
    {
      icon: 'fa-bullhorn',
      slug: 'ads',
      titleKey: 'SERVICES.S4_TITLE',
      descKey: 'SERVICES.S4_DESC',
    },
    {
      icon: 'fa-camera',
      slug: 'boost',
      titleKey: 'SERVICES.S10_TITLE',
      descKey: 'SERVICES.S10_DESC',
    },
    {
      icon: 'fa-video',
      slug: 'video',
      titleKey: 'SERVICES.S11_TITLE',
      descKey: 'SERVICES.S11_DESC',
    },
    {
      icon: 'fa-microphone',
      slug: 'seo',
      titleKey: 'SERVICES.S12_TITLE',
      descKey: 'SERVICES.S12_DESC',
    },
    {
      icon: 'fa-film',
      slug: 'moderator',
      titleKey: 'SERVICES.S13_TITLE',
      descKey: 'SERVICES.S13_DESC',
    },
    {
      icon: 'fa-user',
      slug: 'brand_plan',
      titleKey: 'SERVICES.S14_TITLE',
      descKey: 'SERVICES.S14_DESC',
    },
  ];

  processSteps = [
    { numKey: 'PROCESS.P1_NUM', titleKey: 'PROCESS.P1_TITLE', descKey: 'PROCESS.P1_DESC' },
    { numKey: 'PROCESS.P2_NUM', titleKey: 'PROCESS.P2_TITLE', descKey: 'PROCESS.P2_DESC' },
    { numKey: 'PROCESS.P3_NUM', titleKey: 'PROCESS.P3_TITLE', descKey: 'PROCESS.P3_DESC' },
    { numKey: 'PROCESS.P4_NUM', titleKey: 'PROCESS.P4_TITLE', descKey: 'PROCESS.P4_DESC' },
  ];

  // ── Portfolio ──────────────────────────────────────────────
  private readonly HOME_LIMIT_STEP = 3;
  private readonly HOME_MAX = 6;
  photosShown = this.HOME_LIMIT_STEP;
  reelsShown = this.HOME_LIMIT_STEP;
  activeTab: 'photos' | 'reels' = 'photos';

  // ── Reel Logo Background ────────────────────────────────────────────────────
  logoStars: { x: number; y: number; size: number; delay: number }[] = Array.from(
    { length: 40 },
    () => ({
      x: Math.random() * 100,
      y: Math.random() * 65,
      size: Math.random() * 2 + 1,
      delay: Math.random() * 4,
    }),
  );
  logoParticles: { x: number; dur: number; delay: number; size: number }[] = Array.from(
    { length: 12 },
    () => ({
      x: Math.random() * 100,
      dur: 3 + Math.random() * 4,
      delay: Math.random() * 5,
      size: Math.random() * 4 + 2,
    }),
  );

  popupOpen = false;
  popupImages: string[] = [];
  popupCurrentIndex = 0;
  popupTitle = '';

  reelPopupOpen = false;
  reelPopupUrl = '';
  reelPopupTitle = '';

  // Flatten all photos and reels from new industry structure
  photos: SpecialtyMedia[] = this.shuffleArray(
    this.data.industries.flatMap((i) => i.specialties).flatMap((s) => s.photos),
  );

  reels: SpecialtyMedia[] = this.shuffleArray(
    this.data.industries.flatMap((i) => i.specialties).flatMap((s) => s.reels),
  );

  get visiblePhotos() {
    return this.photos.slice(0, this.photosShown);
  }
  get hasMorePhotos() {
    return this.photosShown < Math.min(this.HOME_MAX, this.photos.length);
  }
  get hasLessPhotos() {
    return this.photosShown > this.HOME_LIMIT_STEP;
  }
  get visibleReels() {
    return this.reels.slice(0, this.reelsShown);
  }
  get hasMoreReels() {
    return this.reelsShown < Math.min(this.HOME_MAX, this.reels.length);
  }
  get hasLessReels() {
    return this.reelsShown > this.HOME_LIMIT_STEP;
  }
  switchTab(tab: 'photos' | 'reels') {
    if (this.activeTab === tab) return;
    this.activeTab = tab;
    this.photosShown = this.HOME_LIMIT_STEP;
    this.reelsShown = this.HOME_LIMIT_STEP;
    setTimeout(() => this.checkReveal(), 50);
  }

  showMorePhotos() {
    const next = Math.min(
      this.photosShown + this.HOME_LIMIT_STEP,
      this.HOME_MAX,
      this.photos.length,
    );
    if (next >= this.HOME_MAX) {
      this.router.navigate(['/portfolio']);
      return;
    }
    this.photosShown = next;
    setTimeout(() => this.checkReveal(), 50);
  }

  showLessPhotos() {
    this.photosShown = this.HOME_LIMIT_STEP;
  }

  showMoreReels() {
    const next = Math.min(this.reelsShown + this.HOME_LIMIT_STEP, this.HOME_MAX, this.reels.length);
    if (next >= this.HOME_MAX) {
      this.router.navigate(['/portfolio']);
      return;
    }
    this.reelsShown = next;
    setTimeout(() => this.checkReveal(), 50);
  }

  showLessReels() {
    this.reelsShown = this.HOME_LIMIT_STEP;
  }

  openImagePopup(photo: SpecialtyMedia, index: number) {
    this.popupImages = photo.galleryImages ?? [photo.thumbnail];
    this.popupCurrentIndex = 0;
    this.currentProjectIndex = index;
    this.currentImageItem = photo;
    this.popupOpen = true;
    document.body.style.overflow = 'hidden';
  }

  closeImagePopup() {
    this.popupOpen = false;
    document.body.style.overflow = '';
  }

  nextImage() {
    const step = this.isArabic ? -1 : 1;
    this.popupCurrentIndex =
      (this.popupCurrentIndex + step + this.popupImages.length) % this.popupImages.length;
  }

  prevImage() {
    const step = this.isArabic ? 1 : -1;
    this.popupCurrentIndex =
      (this.popupCurrentIndex + step + this.popupImages.length) % this.popupImages.length;
  }

  shuffleArray(array: any[]) {
    return array
      .map((value) => ({ value, sort: Math.random() }))
      .sort((a, b) => a.sort - b.sort)
      .map(({ value }) => value);
  }

  openReelPopup(reel: SpecialtyMedia, index: number) {
    this.reelPopupUrl = reel.videoUrl ?? '';
    this.currentImageItem = reel;
    this.currentProjectIndex = index;
    this.reelPopupOpen = true;
    document.body.style.overflow = 'hidden';
  }

  closeReelPopup() {
    this.reelPopupOpen = false;
    this.reelPopupUrl = '';
    document.body.style.overflow = '';
  }

  onPopupBgClick(event: MouseEvent, type: 'image' | 'reel') {
    if ((event.target as HTMLElement).classList.contains('popup-backdrop'))
      type === 'image' ? this.closeImagePopup() : this.closeReelPopup();
  }

  // ── 3D Tilt Effect with Glare ──────────────────────────────
  private initTilt() {
    this.isMobile = window.innerWidth < 768;
    if (this.isMobile) return;

    this.tiltCard = document.getElementById('heroTiltCard');
    if (!this.tiltCard) return;

    const card = this.tiltCard;
    const glare = document.getElementById('heroCardGlare');

    card.addEventListener('mousemove', (e: MouseEvent) => {
      if (this.tiltRAF) cancelAnimationFrame(this.tiltRAF);
      this.tiltRAF = requestAnimationFrame(() => {
        const rect = card.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const y = e.clientY - rect.top;
        const centerX = rect.width / 2;
        const centerY = rect.height / 2;
        const rotateY = ((x - centerX) / centerX) * 10;
        const rotateX = ((centerY - y) / centerY) * 7;
        card.style.transform = `perspective(1200px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) scale(1.02)`;
        card.style.transition = 'none';

        if (glare) {
          const glareX = (x / rect.width) * 100;
          const glareY = (y / rect.height) * 100;
          glare.style.background = `radial-gradient(circle at ${glareX}% ${glareY}%, rgba(255,255,255,0.1) 0%, transparent 60%)`;
          glare.style.opacity = '1';
        }
      });
    });

    card.addEventListener('mouseleave', () => {
      if (this.tiltRAF) cancelAnimationFrame(this.tiltRAF);
      card.style.transform = 'perspective(1200px) rotateX(0deg) rotateY(0deg) scale(1)';
      card.style.transition = 'transform 0.6s cubic-bezier(0.23, 1, 0.32, 1)';
      if (glare) glare.style.opacity = '0';
    });

    if (window.DeviceOrientationEvent) {
      window.addEventListener('deviceorientation', this.handleOrientation.bind(this), {
        passive: true,
      });
    }
  }

  private handleOrientation(e: DeviceOrientationEvent) {
    if (!this.tiltCard || !this.isMobile) return;
    const beta = Math.max(-15, Math.min(15, e.beta ?? 0));
    const gamma = Math.max(-15, Math.min(15, e.gamma ?? 0));
    this.tiltCard.style.transform = `perspective(800px) rotateX(${beta * 0.3}deg) rotateY(${gamma * 0.3}deg)`;
  }

  // ── Cursor Glow Follower ────────────────────────────────────
  private initCursorGlow() {
    this.heroSection = document.getElementById('heroSection');
    this.cursorGlow = document.getElementById('heroCursorGlow');
    if (!this.heroSection || !this.cursorGlow || this.isMobile) return;

    const section = this.heroSection;
    const glow = this.cursorGlow;

    // Start completely off-screen and hidden
    glow.style.left = '-9999px';
    glow.style.top = '-9999px';
    glow.style.opacity = '0';

    let hasEntered = false;

    section.addEventListener('mousemove', (e: MouseEvent) => {
      const rect = section.getBoundingClientRect();
      this.mouseX = e.clientX - rect.left;
      this.mouseY = e.clientY - rect.top;
      if (!hasEntered) {
        // Snap to position on first move before fading in
        this.glowX = this.mouseX;
        this.glowY = this.mouseY;
        hasEntered = true;
        glow.style.opacity = '1';
      }
    });

    section.addEventListener('mouseleave', () => {
      glow.style.opacity = '0';
      hasEntered = false;
    });

    section.addEventListener('mouseenter', () => {
      // Don't show until first mousemove fires
    });

    const animateGlow = () => {
      if (hasEntered) {
        this.glowX += (this.mouseX - this.glowX) * 0.1;
        this.glowY += (this.mouseY - this.glowY) * 0.1;
        glow.style.left = this.glowX + 'px';
        glow.style.top = this.glowY + 'px';
      }
      this.cursorGlowRAF = requestAnimationFrame(animateGlow);
    };
    animateGlow();
  }

  // ── Mouse Trail Canvas ──────────────────────────────────────
  private initTrailCanvas() {
    this.heroSection = document.getElementById('heroSection');
    this.trailCanvas = document.getElementById('heroTrailCanvas') as HTMLCanvasElement;
    if (!this.trailCanvas || !this.heroSection) return;

    const section = this.heroSection;
    const canvas = this.trailCanvas;

    const resize = () => {
      canvas.width = section.offsetWidth;
      canvas.height = section.offsetHeight;
    };
    resize();
    window.addEventListener('resize', resize);

    this.trailCtx = canvas.getContext('2d');

    section.addEventListener('mousemove', (e: MouseEvent) => {
      const rect = section.getBoundingClientRect();
      this.trailPoints.push({
        x: e.clientX - rect.left,
        y: e.clientY - rect.top,
        alpha: 0.65,
        size: 3 + Math.random() * 4,
      });
      if (this.trailPoints.length > 35) this.trailPoints.shift();
    });

    const renderTrail = () => {
      const ctx = this.trailCtx;
      if (!ctx || !canvas) {
        this.trailRAF = requestAnimationFrame(renderTrail);
        return;
      }
      ctx.clearRect(0, 0, canvas.width, canvas.height);

      for (let i = this.trailPoints.length - 1; i >= 0; i--) {
        const p = this.trailPoints[i];
        p.alpha *= 0.88;
        if (p.alpha < 0.01) {
          this.trailPoints.splice(i, 1);
          continue;
        }
        ctx.beginPath();
        ctx.arc(p.x, p.y, p.size * p.alpha, 0, Math.PI * 2);
        ctx.fillStyle = `rgba(201, 162, 39, ${p.alpha * 0.45})`;
        ctx.fill();
      }

      this.trailRAF = requestAnimationFrame(renderTrail);
    };
    renderTrail();
  }

  // ── Wave Canvas — Animated Background ──────────────────────
  private initWaveCanvas() {
    const canvas = document.getElementById('heroWaveCanvas') as HTMLCanvasElement | null;
    const section = document.getElementById('heroSection') as HTMLElement | null;
    if (!canvas || !section) return;

    this.waveCanvas = canvas;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;
    this.waveCtx = ctx;

    const resize = () => {
      canvas.width = section.offsetWidth;
      canvas.height = section.offsetHeight;
    };
    resize();
    window.addEventListener('resize', resize);

    // ── Helper: hex + alpha ───────────────────────────────────
    function hexAlpha(hex: string, a: number): string {
      if (hex === '#ffffff') return `rgba(255,255,255,${a.toFixed(3)})`;
      if (hex === '#000000') return `rgba(0,0,0,${a.toFixed(3)})`;
      const r = parseInt(hex.slice(1, 3), 16);
      const g = parseInt(hex.slice(3, 5), 16);
      const b = parseInt(hex.slice(5, 7), 16);
      return `rgba(${r},${g},${b},${a.toFixed(3)})`;
    }

    interface WaveLayer {
      amplitude: number;
      frequency: number;
      speed: number;
      yOffset: number;
      lineCount: number;
      lineSpacing: number;
      colors: string[];
      phase: number;
      alphaBase: number;
      lineWidth: number;
    }

    // ── DARK MODE layers (deep purple-blue) ───────────────────
    const darkLayers: WaveLayer[] = [
      {
        amplitude: 110,
        frequency: 0.0022,
        speed: 0.008,
        yOffset: 0.72,
        lineCount: 22,
        lineSpacing: 3.5,
        colors: ['#3B0080', '#5B21B6', '#7C3AED', '#8B5CF6', '#A78BFA'],
        phase: 0,
        alphaBase: 0.55,
        lineWidth: 1.6,
      },
      {
        amplitude: 90,
        frequency: 0.0028,
        speed: 0.011,
        yOffset: 0.63,
        lineCount: 18,
        lineSpacing: 3,
        colors: ['#1E3A8A', '#2563EB', '#3B82F6', '#60A5FA', '#93C5FD'],
        phase: 1.1,
        alphaBase: 0.5,
        lineWidth: 1.4,
      },
      {
        amplitude: 75,
        frequency: 0.0034,
        speed: 0.013,
        yOffset: 0.54,
        lineCount: 12,
        lineSpacing: 2.5,
        colors: ['#6D28D9', '#C084FC', '#E879F9', '#F0ABFC', '#ffffff'],
        phase: 2.3,
        alphaBase: 0.6,
        lineWidth: 1.2,
      },
      {
        amplitude: 55,
        frequency: 0.004,
        speed: 0.016,
        yOffset: 0.48,
        lineCount: 7,
        lineSpacing: 2,
        colors: ['#BE185D', '#EC4899', '#F9A8D4', '#ffffff'],
        phase: 3.7,
        alphaBase: 0.45,
        lineWidth: 0.9,
      },
    ];

    // ── LIGHT MODE layers (purple-indigo-violet on white) ──────────
    // Clean, professional — matches the primary purple brand
    const lightLayers: WaveLayer[] = [
      // Deep indigo base wave — wide & slow
      {
        amplitude: 105,
        frequency: 0.0021,
        speed: 0.007,
        yOffset: 0.74,
        lineCount: 20,
        lineSpacing: 3.5,
        colors: ['#3730A3', '#4338CA', '#6366F1', '#818CF8', '#C7D2FE'],
        phase: 0,
        alphaBase: 0.38,
        lineWidth: 1.5,
      },
      // Mid purple-violet wave
      {
        amplitude: 85,
        frequency: 0.0027,
        speed: 0.01,
        yOffset: 0.64,
        lineCount: 16,
        lineSpacing: 3,
        colors: ['#5B21B6', '#7C3AED', '#8B5CF6', '#A78BFA', '#DDD6FE'],
        phase: 1.3,
        alphaBase: 0.32,
        lineWidth: 1.3,
      },
      // Bright violet highlight wave
      {
        amplitude: 70,
        frequency: 0.0033,
        speed: 0.012,
        yOffset: 0.54,
        lineCount: 11,
        lineSpacing: 2.5,
        colors: ['#6D28D9', '#7C3AED', '#A78BFA', '#EDE9FE', '#ffffff'],
        phase: 2.5,
        alphaBase: 0.42,
        lineWidth: 1.1,
      },
      // Thin lavender shimmer
      {
        amplitude: 50,
        frequency: 0.0038,
        speed: 0.015,
        yOffset: 0.48,
        lineCount: 6,
        lineSpacing: 2,
        colors: ['#818CF8', '#C4B5FD', '#ffffff'],
        phase: 3.9,
        alphaBase: 0.32,
        lineWidth: 0.85,
      },
    ];

    const renderWave = () => {
      const w = canvas.width;
      const h = canvas.height;
      const isLight = this.isDayMode;
      const layers = isLight ? lightLayers : darkLayers;

      ctx.clearRect(0, 0, w, h);

      // ── Background fill ───────────────────────────────────
      if (isLight) {
        // Clean white with subtle purple hint
        const bg = ctx.createLinearGradient(0, 0, 0, h);
        bg.addColorStop(0, '#ffffff'); // pure white top
        bg.addColorStop(0.4, '#fafafe'); // almost white, hint of lavender
        bg.addColorStop(0.75, '#f5f3ff'); // very soft violet tint
        bg.addColorStop(1, '#ffffff');
        ctx.fillStyle = bg;
        ctx.fillRect(0, 0, w, h);

        // Soft purple radial glow center-right
        const glowR = ctx.createRadialGradient(w * 0.6, h * 0.58, 0, w * 0.6, h * 0.58, w * 0.5);
        glowR.addColorStop(0, 'rgba(139,92,246,0.09)');
        glowR.addColorStop(0.5, 'rgba(111,63,245,0.04)');
        glowR.addColorStop(1, 'rgba(255,255,255,0)');
        ctx.fillStyle = glowR;
        ctx.fillRect(0, 0, w, h);

        // Soft indigo glow left
        const glowL = ctx.createRadialGradient(w * 0.2, h * 0.45, 0, w * 0.2, h * 0.45, w * 0.35);
        glowL.addColorStop(0, 'rgba(99,102,241,0.07)');
        glowL.addColorStop(1, 'rgba(255,255,255,0)');
        ctx.fillStyle = glowL;
        ctx.fillRect(0, 0, w, h);
      } else {
        // Deep dark gradient
        const bg = ctx.createLinearGradient(0, 0, 0, h);
        bg.addColorStop(0, '#04010d');
        bg.addColorStop(0.45, '#07022a');
        bg.addColorStop(1, '#02010a');
        ctx.fillStyle = bg;
        ctx.fillRect(0, 0, w, h);

        const glow = ctx.createRadialGradient(w * 0.5, h * 0.6, 0, w * 0.5, h * 0.6, w * 0.55);
        glow.addColorStop(0, 'rgba(100,40,200,0.18)');
        glow.addColorStop(1, 'rgba(0,0,0,0)');
        ctx.fillStyle = glow;
        ctx.fillRect(0, 0, w, h);
      }

      this.waveTime += 1;

      layers.forEach((layer) => {
        layer.phase += layer.speed;
        const amp = this.isMobile ? layer.amplitude * 0.65 : layer.amplitude;
        const baseY = h * layer.yOffset;

        for (let li = 0; li < layer.lineCount; li++) {
          const t = li / (layer.lineCount - 1);
          const yShift = (li - layer.lineCount / 2) * layer.lineSpacing;
          const phaseShift = li * 0.12;

          const colorIdx = Math.min(
            Math.floor(t * (layer.colors.length - 1)),
            layer.colors.length - 2,
          );
          const c1 = layer.colors[colorIdx];
          const c2 = layer.colors[colorIdx + 1];

          const midness = 1 - Math.abs(t - 0.5) * 1.6;
          // Light mode: slightly lower alpha to stay elegant, not overpowering
          const alphaMult = isLight ? 0.75 : 1;
          const alpha = Math.max(0.04, layer.alphaBase * (0.3 + midness * 0.7) * alphaMult);

          const grad = ctx.createLinearGradient(0, 0, w, 0);
          grad.addColorStop(0, hexAlpha(c1, alpha * 0.2));
          grad.addColorStop(0.3, hexAlpha(c1, alpha));
          grad.addColorStop(0.6, hexAlpha(c2, alpha));
          grad.addColorStop(1, hexAlpha(c2, alpha * 0.2));

          ctx.beginPath();
          ctx.strokeStyle = grad;
          ctx.lineWidth = layer.lineWidth * (0.6 + midness * 0.7);
          ctx.shadowBlur = 0;

          const step = this.isMobile ? 6 : 4;
          for (let x = 0; x <= w; x += step) {
            const y =
              baseY +
              yShift +
              Math.sin(x * layer.frequency + layer.phase + phaseShift) * amp +
              Math.sin(x * layer.frequency * 1.7 + layer.phase * 0.6 + phaseShift) * (amp * 0.22) +
              Math.cos(x * layer.frequency * 0.5 + layer.phase * 1.4 + phaseShift) * (amp * 0.12);

            if (x === 0) ctx.moveTo(x, y);
            else ctx.lineTo(x, y);
          }
          ctx.stroke();
        }
      });

      this.waveRAF = requestAnimationFrame(renderWave);
    };

    renderWave();
  }

  // ── Magnetic Buttons ────────────────────────────────────────
  private initMagneticButtons() {
    if (this.isMobile) return;
    const buttons = document.querySelectorAll<HTMLElement>('.hero-btn-magnetic');

    buttons.forEach((btn) => {
      btn.addEventListener('mousemove', (e: MouseEvent) => {
        const rect = btn.getBoundingClientRect();
        const x = e.clientX - rect.left - rect.width / 2;
        const y = e.clientY - rect.top - rect.height / 2;
        btn.style.transform = `translate(${x * 0.22}px, ${y * 0.22}px) scale(1.05)`;
      });

      btn.addEventListener('mouseleave', () => {
        btn.style.transform = 'translate(0,0) scale(1)';
        btn.style.transition = 'transform 0.55s cubic-bezier(0.23, 1, 0.32, 1)';
      });

      btn.addEventListener('mouseenter', () => {
        btn.style.transition = 'none';
      });

      btn.addEventListener('click', (e: MouseEvent) => {
        const rect = btn.getBoundingClientRect();
        const ripple = btn.querySelector('.btn-ripple') as HTMLElement;
        if (!ripple) return;
        const size = Math.max(rect.width, rect.height) * 2.2;
        ripple.style.width = ripple.style.height = size + 'px';
        ripple.style.left = e.clientX - rect.left - size / 2 + 'px';
        ripple.style.top = e.clientY - rect.top - size / 2 + 'px';
        ripple.style.animation = 'none';
        void ripple.offsetWidth;
        ripple.style.animation = 'rippleOut 0.65s linear';
      });
    });
  }

  // ── Float card hover pause ──────────────────────────────────
  private initFloatCards() {
    const cards = document.querySelectorAll<HTMLElement>('.float-card');
    cards.forEach((card) => {
      card.addEventListener('mouseenter', () => {
        card.style.animationPlayState = 'paused';
      });
      card.addEventListener('mouseleave', () => {
        card.style.animationPlayState = 'running';
      });
    });
  }

  // ── Float card number counters (ascending animation) ────────
  private initFloatCardCounters() {
    const easeOut = (t: number) => 1 - Math.pow(1 - t, 4);

    interface CardConfig {
      selector: string;
      target: number;
      suffix: string;
      decimals?: number;
      prefix?: string;
    }

    const configs: CardConfig[] = [
      { selector: '.float-card--analytics .float-card-num', target: 187, suffix: '%', prefix: '+' },
      { selector: '.float-card--social .float-card-num', target: 150.4, suffix: 'K', decimals: 1 },
      { selector: '.float-card--award .float-card-num', target: 5, suffix: '★' },
    ];

    const animateNum = (el: HTMLElement, cfg: CardConfig) => {
      const duration = cfg.target >= 100 ? 1800 : 1400;
      const start = performance.now();
      const prefix = cfg.prefix ?? '';

      const tick = (now: number) => {
        const progress = Math.min((now - start) / duration, 1);
        const eased = easeOut(progress);
        const current = eased * cfg.target;
        const formatted = cfg.decimals
          ? current.toFixed(cfg.decimals)
          : Math.floor(current).toString();
        el.textContent = prefix + formatted + cfg.suffix;
        if (progress < 1) requestAnimationFrame(tick);
        else
          el.textContent =
            prefix +
            (cfg.decimals ? cfg.target.toFixed(cfg.decimals) : cfg.target.toString()) +
            cfg.suffix;
      };

      requestAnimationFrame(tick);
    };

    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            const el = entry.target as HTMLElement;
            const cfg = configs.find((c) => el.matches(c.selector));
            if (cfg) animateNum(el, cfg);
            observer.unobserve(el);
          }
        });
      },
      { threshold: 0.4 },
    );

    configs.forEach(({ selector }) => {
      const el = document.querySelector<HTMLElement>(selector);
      if (el) observer.observe(el);
    });
  }

  // ── Intersection Observer Reveal (smooth on all devices) ────
  private initRevealObserver() {
    if (!('IntersectionObserver' in window)) {
      // Fallback: show everything immediately
      document.querySelectorAll('.reveal').forEach((el) => el.classList.add('visible'));
      return;
    }

    this.revealObserver = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add('visible');
            // Unobserve after reveal (once is enough)
            this.revealObserver?.unobserve(entry.target);
          }
        });
      },
      {
        threshold: 0.12,
        rootMargin: '0px 0px -40px 0px',
      },
    );

    document.querySelectorAll('.reveal').forEach((el) => {
      this.revealObserver!.observe(el);
    });
  }

  // ── Re-observe new .reveal elements (after tab switch / show more) ──
  private reObserveReveal() {
    document.querySelectorAll('.reveal:not(.visible)').forEach((el) => {
      if (this.revealObserver) {
        this.revealObserver.observe(el);
      } else {
        const rect = el.getBoundingClientRect();
        if (rect.top < window.innerHeight * 0.92) el.classList.add('visible');
      }
    });
  }

  private buildLoopImages() {
    const base = this.stripImages;
    // نسختين بالظبط → segmentW = scrollWidth / 2 دايمًا صح
    this.stripImagesLoop = [...base, ...base];
  }

  // ── Hero entrance stagger ──────────────────────────────────
  private initHeroEntrance() {
    const animEls = document.querySelectorAll<HTMLElement>(
      '.hero-section .animate-fade-up, .hero-section .animate-scale-in',
    );
    animEls.forEach((el) => {
      // Ensure animation plays — re-trigger if needed
      el.style.animationPlayState = 'running';
    });
  }

  // ── Scroll Reveal (fallback for older browsers) ────────────
  private checkReveal() {
    document.querySelectorAll('.reveal').forEach((el) => {
      const rect = el.getBoundingClientRect();
      if (rect.top < window.innerHeight * 0.9) el.classList.add('visible');
    });
  }

  private listenLangChange() {
    setInterval(() => {
      const current = this.stripImages;

      if (
        JSON.stringify(current) !== JSON.stringify(this.stripImagesLoop.slice(0, current.length))
      ) {
        this.refreshStrip();
      }
    }, 500);
  }

  private refreshStrip() {
    if (this.stripRAF) cancelAnimationFrame(this.stripRAF);
    this.stripRAF = null;

    this.buildLoopImages();
    this.cdr.detectChanges(); // flush Angular change detection so DOM updates first

    // Wait two frames: first for DOM update, second for layout recalc
    setTimeout(() => {
      this.initClientsStrip();
    }, 80);
  }

  // ── Scroll Parallax 3D — subtle depth shift on scroll ────
  private initScrollParallax3D() {
    const heroSection = document.getElementById('heroSection');
    const logoScene = document.getElementById('logo3dScene');
    const heroContent = document.querySelector<HTMLElement>('.hero-content');
    if (!heroSection || !logoScene) return;

    const onScroll = () => {
      if (this.scrollParallaxRAF) cancelAnimationFrame(this.scrollParallaxRAF);
      this.scrollParallaxRAF = requestAnimationFrame(() => {
        const scrollY = window.scrollY;
        const heroH = heroSection.offsetHeight;
        if (scrollY > heroH) return;

        const progress = scrollY / heroH; // 0 → 1

        // Logo tilts slightly back on scroll — like receding into depth
        const rotateX = progress * 8; // max 8deg tilt
        const translateZ = progress * -60; // recede 60px
        const scale = 1 - progress * 0.06;
        logoScene.style.transform = `perspective(1400px) rotateX(${rotateX}deg) translateZ(${translateZ}px) scale(${scale})`;
        logoScene.style.transition = 'transform 0.1s linear';

        // Content slides up slightly faster — creates parallax separation
        if (heroContent) {
          const contentShift = scrollY * 0.18;
          heroContent.style.transform = `translateY(-${contentShift}px)`;
          heroContent.style.transition = 'transform 0.1s linear';
          heroContent.style.opacity = `${1 - progress * 1.4}`;
        }

        this.lastScrollY = scrollY;
      });
    };

    window.addEventListener('scroll', onScroll, { passive: true });
  }

  // ── Animated Counters ──────────────────────────────────────
  private initCounters() {
    const counters = document.querySelectorAll<HTMLElement>('.counter-val');
    if (!counters.length) return;

    const easeOut = (t: number) => 1 - Math.pow(1 - t, 3);

    const animateCounter = (el: HTMLElement) => {
      const target = parseInt(el.dataset['target'] ?? '0', 10);
      const suffix = el.dataset['suffix'] ?? '';
      const duration = target >= 100000 ? 2200 : target >= 1000 ? 1800 : 1400;
      const start = performance.now();

      const format = (n: number): string => {
        if (n >= 1000) return n.toLocaleString('en-US');
        return n.toString();
      };

      const tick = (now: number) => {
        const elapsed = now - start;
        const progress = Math.min(elapsed / duration, 1);
        const eased = easeOut(progress);
        const current = Math.floor(eased * target);
        el.textContent = format(current) + suffix;
        if (progress < 1) requestAnimationFrame(tick);
        else el.textContent = format(target) + suffix;
      };

      requestAnimationFrame(tick);
    };

    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            animateCounter(entry.target as HTMLElement);
            observer.unobserve(entry.target);
          }
        });
      },
      { threshold: 0.5 },
    );

    counters.forEach((el) => observer.observe(el));
  }

  // ── Lifecycle ──────────────────────────────────────────────
  ngAfterViewInit() {
    setTimeout(() => {
      this.isMobile = window.innerWidth < 768;
      this.buildLoopImages();
      this.initHeroEntrance();
      this.initRevealObserver();
      this.checkReveal();
      this.initTilt();
      this.initLogoCard3D();
      this.initLogoPng3D();
      this.initCursorGlow();
      this.initTrailCanvas();
      this.initWaveCanvas();
      this.initParticleMesh();
      this.initMagneticButtons();
      this.initFloatCards();
      this.initFloatCardCounters();
      this.initTouchRipple();
      this.initClientsStrip();
      this.initLogo3dTilt();
      this.initScrollParallax3D();
      this.initCounters();
      this.startTestimonialsRotation();
      this.cdr.detectChanges();
    }, 100);
  }

  // ══════════════════════════════════════════════════════════════
  //  MAGNETIC 3D TILT — logo_3d.png hover interaction
  // ══════════════════════════════════════════════════════════════
  private logo3dTiltRAF: number | null = null;

  private initLogo3dTilt() {
    const wrap = document.getElementById('logo3dWrap') as HTMLElement | null;
    const img = document.getElementById('logo3dImg') as HTMLImageElement | null;
    const shimmer = document.getElementById('logo3dShimmer') as HTMLElement | null;
    const aura = document.querySelector('.logo3d-aura') as HTMLElement | null;
    if (!wrap || !img) return;

    wrap.style.transformStyle = 'preserve-3d';

    wrap.addEventListener('mousemove', (e: MouseEvent) => {
      if (this.logo3dTiltRAF) cancelAnimationFrame(this.logo3dTiltRAF);
      this.logo3dTiltRAF = requestAnimationFrame(() => {
        const rect = wrap.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const y = e.clientY - rect.top;
        const cx = rect.width / 2;
        const cy = rect.height / 2;
        const rx = ((y - cy) / cy) * -10; // reduced from -14 → calmer
        const ry = ((x - cx) / cx) * 13; // reduced from 18 → calmer

        wrap.style.transform = `
  perspective(1200px)
  rotateX(${rx}deg)
  rotateY(${ry}deg)
  scale(1.04)
  translateZ(10px)
`;
        wrap.style.transition = 'none';

        const gx = (x / rect.width) * 100;
        const gy = (y / rect.height) * 100;

        img.style.filter = 'none';

        img.style.transition = 'none';
        img.style.animation = 'none';

        if (shimmer) {
          shimmer.style.background = `radial-gradient(ellipse at ${gx}% ${gy}%,
            rgba(255,248,200,0.1) 0%, rgba(245,200,66,0.04) 40%, transparent 65%)`;
          shimmer.style.opacity = '1';
        }
        if (aura) {
          aura.style.background = `radial-gradient(ellipse at ${gx}% 70%,
            rgba(201,162,39,0.22) 0%, rgba(201,149,42,0.08) 50%, transparent 75%)`;
          aura.style.transform = `translate(${ry * 0.5}px, ${rx * -0.3}px)`;
        }
      });
    });

    wrap.addEventListener('mouseleave', () => {
      if (this.logo3dTiltRAF) cancelAnimationFrame(this.logo3dTiltRAF);
      wrap.style.transform = '';
      wrap.style.transition = 'transform 1s cubic-bezier(0.19,1,0.22,1)';
      img.style.filter = 'none';
      img.style.transition = 'filter 0.6s ease';
      img.style.animation = '';
      if (shimmer) shimmer.style.opacity = '0';
      if (aura) {
        aura.style.background = '';
        aura.style.transform = '';
        aura.style.transition = 'transform 0.8s ease';
      }
    });

    // Touch tilt for mobile
    wrap.addEventListener(
      'touchmove',
      (e: TouchEvent) => {
        const t = e.touches[0];
        const rect = wrap.getBoundingClientRect();
        const rx = (-(t.clientY - rect.top - rect.height / 2) / (rect.height / 2)) * 10;
        const ry = ((t.clientX - rect.left - rect.width / 2) / (rect.width / 2)) * 12;
        wrap.style.transform = `perspective(700px) rotateX(${rx}deg) rotateY(${ry}deg)`;
      },
      { passive: true },
    );

    wrap.addEventListener('touchend', () => {
      wrap.style.transform = '';
      wrap.style.transition = 'transform 0.6s cubic-bezier(0.23,1,0.32,1)';
    });

    // Gyro for mobile
    if (window.DeviceOrientationEvent && this.isMobile) {
      window.addEventListener(
        'deviceorientation',
        (ev: DeviceOrientationEvent) => {
          const rx = Math.max(-10, Math.min(10, (ev.beta ?? 0) - 45)) * 0.4;
          const ry = Math.max(-10, Math.min(10, ev.gamma ?? 0)) * 0.4;
          wrap.style.transform = `perspective(700px) rotateX(${rx}deg) rotateY(${ry}deg)`;
        },
        { passive: true },
      );
    }
  }

  ngOnDestroy() {
    if (this.tiltRAF) cancelAnimationFrame(this.tiltRAF);
    if (this.trailRAF) cancelAnimationFrame(this.trailRAF);
    if (this.cursorGlowRAF) cancelAnimationFrame(this.cursorGlowRAF);
    if (this.particleRAF) cancelAnimationFrame(this.particleRAF);
    if (this.waveRAF) cancelAnimationFrame(this.waveRAF);
    if (this.logoRAF) cancelAnimationFrame(this.logoRAF);
    if (this.stripRAF) cancelAnimationFrame(this.stripRAF);
    if (this.logo3dTiltRAF) cancelAnimationFrame(this.logo3dTiltRAF);
    if (this.scrollParallaxRAF) cancelAnimationFrame(this.scrollParallaxRAF);
    if (this.interval) clearInterval(this.interval);
    if (this.testimonialsInterval) clearInterval(this.testimonialsInterval);
    if (this.nlCooldownInterval) clearInterval(this.nlCooldownInterval);
    if (this.revealObserver) this.revealObserver.disconnect();
  }

  ngOnInit() {
    this.preloadImages();
    this.buildLoopImages();
    this.checkCooldownOnInit();

    setTimeout(() => this.listenLangChange(), 0);
  }

  preloadImages() {
    const allImages = [...this.images_tab_ar, ...this.images_tab_en];
    allImages.forEach((src) => {
      const img = new Image();
      img.src = src;
    });
  }

  // ── 3D Interactive Logo Card ─────────────────────────────
  private initLogoCard3D() {
    this.logoCard = document.getElementById('heroLogoCard');
    if (!this.logoCard || this.isMobile) return;

    const card = this.logoCard;
    const glare = document.getElementById('heroCardGlare');

    card.addEventListener('mousemove', (e: MouseEvent) => {
      if (this.logoRAF) cancelAnimationFrame(this.logoRAF);
      this.logoRAF = requestAnimationFrame(() => {
        const rect = card.getBoundingClientRect();
        const cx = rect.left + rect.width / 2;
        const cy = rect.top + rect.height / 2;
        const dx = e.clientX - cx;
        const dy = e.clientY - cy;
        const rotX = (-dy / (rect.height / 2)) * 18;
        const rotY = (dx / (rect.width / 2)) * 18;
        card.style.transform = `perspective(900px) rotateX(${rotX}deg) rotateY(${rotY}deg) scale3d(1.04,1.04,1.04)`;
        if (glare) {
          const gx = ((e.clientX - rect.left) / rect.width) * 100;
          const gy = ((e.clientY - rect.top) / rect.height) * 100;
          glare.style.background = `radial-gradient(circle at ${gx}% ${gy}%, rgba(245,200,66,0.25) 0%, transparent 60%)`;
          glare.style.opacity = '1';
        }
      });
    });

    card.addEventListener('mouseleave', () => {
      card.style.transform = 'perspective(900px) rotateX(0deg) rotateY(0deg) scale3d(1,1,1)';
      if (glare) glare.style.opacity = '0';
    });

    // Touch tilt for mobile
    card.addEventListener(
      'touchmove',
      (e: TouchEvent) => {
        const t = e.touches[0];
        const rect = card.getBoundingClientRect();
        const cx = rect.left + rect.width / 2;
        const cy = rect.top + rect.height / 2;
        const rotX = (-(t.clientY - cy) / (rect.height / 2)) * 12;
        const rotY = ((t.clientX - cx) / (rect.width / 2)) * 12;
        card.style.transform = `perspective(900px) rotateX(${rotX}deg) rotateY(${rotY}deg) scale3d(1.02,1.02,1.02)`;
      },
      { passive: true },
    );

    card.addEventListener('touchend', () => {
      card.style.transform = '';
    });
  }

  // ── Infinite Auto-Scroll Image Strip v5 (RTL-safe) ────────
  private initClientsStrip() {
    const wrap = document.getElementById('clientsStripWrap') as HTMLElement;
    const track = document.getElementById('clientsStripTrack') as HTMLElement;
    if (!wrap || !track) return;

    // ── constants ──────────────────────────────────────────
    const SPEED = 0.55; // px per frame
    const FRICTION = 0.91; // drag inertia decay
    const MAX_VEL = 35; // max throw velocity

    // ── RTL detection ──────────────────────────────────────
    // The track itself is always direction:ltr (set in CSS),
    // so translateX always moves left→right regardless of page dir.
    // But we flip the AUTO-SCROLL direction for RTL pages so the
    // strip scrolls right-to-left (feels natural in Arabic).
    const isRtlPage = (): boolean =>
      document.documentElement.dir === 'rtl' ||
      document.body.dir === 'rtl' ||
      getComputedStyle(document.documentElement).direction === 'rtl';

    // ── state ──────────────────────────────────────────────
    let segmentW = 0;
    let offset = 0; // always in [0, segmentW)
    let velocity = 0;
    let paused = false;
    let isDragging = false;
    let dragStartX = 0;
    let dragStartOff = 0;
    let lastX = 0;
    let lastT = 0;
    let rafId: number | null = null;

    const hint = document.getElementById('stripDragHint');
    const progressEl = document.getElementById('stripProgressBar');
    let hintDismissed = false;

    const mod = (v: number, m: number) => ((v % m) + m) % m;

    // ── measure ────────────────────────────────────────────
    // Always read scrollWidth on an LTR element; works in both modes.
    const measure = () => {
      const sw = track.scrollWidth;
      if (sw < 10) return;
      segmentW = sw / 2;
    };

    const waitAndMeasure = () => {
      const imgs = Array.from(track.querySelectorAll('img')) as HTMLImageElement[];
      if (imgs.length === 0) {
        setTimeout(measure, 300);
        return;
      }
      let done = 0;
      const onOne = () => {
        if (++done >= imgs.length) measure();
      };
      imgs.forEach((img) => (img.complete ? onOne() : (img.onload = img.onerror = onOne)));
      setTimeout(measure, 600);
    };

    waitAndMeasure();
    window.addEventListener('resize', measure);

    // ── apply: translateX is always in LTR space ───────────
    const applyOffset = (raw: number) => {
      if (segmentW <= 0) return;
      offset = mod(raw, segmentW);
      // translateX(-offset) → shifts track to the LEFT in both LTR and RTL
      // because the track itself is direction:ltr
      track.style.transform = `translateX(${-offset}px)`;

      if (progressEl) {
        progressEl.style.width = `${(offset / segmentW) * 100}%`;
      }
    };

    // ── animation loop ─────────────────────────────────────
    const tick = () => {
      if (!isDragging && segmentW > 0) {
        let next = offset;
        if (!paused) {
          // In RTL pages we still move offset forward (left-scroll)
          // because translateX(-offset) always moves left.
          // The visual result is the same — images slide left.
          next += SPEED;
        }
        if (Math.abs(velocity) > 0.01) {
          next += velocity;
          velocity *= FRICTION;
        } else {
          velocity = 0;
        }
        applyOffset(next);
      }
      rafId = requestAnimationFrame(tick);
    };

    rafId = requestAnimationFrame(tick);
    this.stripRAF = rafId as any;

    // ── drag ───────────────────────────────────────────────
    const startDrag = (clientX: number) => {
      if (segmentW <= 0) return;
      isDragging = true;
      dragStartX = clientX;
      dragStartOff = offset;
      velocity = 0;
      lastX = clientX;
      lastT = performance.now();

      if (!hintDismissed && hint) {
        hintDismissed = true;
        hint.classList.add('hidden');
      }
    };

    const moveDrag = (clientX: number) => {
      if (!isDragging) return;

      // In RTL the user drags right-to-increase (natural for Arabic reading)
      // but since the track is LTR, dragging left = positive offset = correct scroll.
      // We DON'T flip here — dragStartX - clientX is always correct:
      //   drag right → clientX increases → delta decreases → scrolls back (correct)
      //   drag left  → clientX decreases → delta increases → scrolls forward (correct)
      const delta = dragStartX - clientX;
      applyOffset(dragStartOff + delta);

      const now = performance.now();
      const dt = now - lastT;
      if (dt > 0) {
        const rawVel = ((lastX - clientX) / dt) * 16.67;
        velocity = Math.max(-MAX_VEL, Math.min(MAX_VEL, rawVel));
      }
      lastX = clientX;
      lastT = performance.now();
    };

    const endDrag = () => {
      isDragging = false;
    };

    // ── events ─────────────────────────────────────────────
    wrap.addEventListener('mousedown', (e: MouseEvent) => {
      startDrag(e.clientX);
      wrap.style.cursor = 'grabbing';
      e.preventDefault();
    });
    window.addEventListener('mousemove', (e: MouseEvent) => {
      if (isDragging) moveDrag(e.clientX);
    });
    window.addEventListener('mouseup', () => {
      if (!isDragging) return;
      endDrag();
      wrap.style.cursor = 'grab';
    });

    wrap.addEventListener('touchstart', (e: TouchEvent) => startDrag(e.touches[0].clientX), {
      passive: true,
    });
    wrap.addEventListener('touchmove', (e: TouchEvent) => moveDrag(e.touches[0].clientX), {
      passive: true,
    });
    wrap.addEventListener('touchend', endDrag);

    wrap.addEventListener('mouseenter', () => {
      paused = true;
    });
    wrap.addEventListener('mouseleave', () => {
      paused = false;
    });

    wrap.style.cursor = 'grab';
  }

  @HostListener('window:scroll')
  onScroll() {
    this.checkReveal();
  }

  @HostListener('window:resize')
  onResize() {
    this.isMobile = window.innerWidth < 768;
    if (this.isMobile && this.tiltCard) {
      this.tiltCard.style.transform = '';
    }
  }

  @HostListener('document:keydown', ['$event'])
  onKeyDown(e: KeyboardEvent) {
    if (this.popupOpen) {
      if (e.key === 'ArrowRight') this.nextImage();
      if (e.key === 'ArrowLeft') this.prevImage();
      if (e.key === 'Escape') this.closeImagePopup();
    }
    if (this.reelPopupOpen && e.key === 'Escape') this.closeReelPopup();
  }

  // ── All 12 testimonials ───────────────────────────────────
  allTestimonials = [
    {
      nameAr: 'أحمد الشمري',
      nameEn: 'Ahmed Al-Shamri',
      roleAr: 'مدير شركة ليكس للقهوة',
      roleEn: 'CEO, Lux Coffee',
      stars: 5,
      textAr: 'غيّرت هوية علامتنا التجارية بالكامل. النتيجة فاقت توقعاتنا بكثير.',
      textEn:
        'Etbaly completely transformed our brand identity. The result far exceeded our expectations.',
    },
    {
      nameAr: 'سارة المنصور',
      nameEn: 'Sara Al-Mansour',
      roleAr: 'مؤسسة بلوم بوتيك',
      roleEn: 'Founder, Bloom Boutique',
      stars: 5,
      textAr: 'زاد عدد متابعينا من ألف إلى خمسة وعشرين ألفاً في ستة أشهر فقط.',
      textEn: 'Our followers grew from 1K to 25K in just six months. A very professional team.',
    },
    {
      nameAr: 'محمد القحطاني',
      nameEn: 'Mohammed Al-Qahtani',
      roleAr: 'مدير هورايزون العقارية',
      roleEn: 'Director, Horizon Real Estate',
      stars: 5,
      textAr: 'الموقع الذي صمموا لنا يعكس احترافية شركتنا تماماً.',
      textEn: "The website they designed perfectly reflects our company's professionalism.",
    },
    {
      nameAr: 'نورة العتيبي',
      nameEn: 'Noura Al-Otaibi',
      roleAr: 'صاحبة متجر لمسة',
      roleEn: 'Owner, Lamsa Store',
      stars: 5,
      textAr: 'محتوى السوشيال ميديا الذي أنتجوه رفع مبيعاتنا بنسبة 70% في شهرين.',
      textEn: 'The social media content they produced boosted our sales by 70% in just two months.',
    },
    {
      nameAr: 'خالد البقمي',
      nameEn: 'Khalid Al-Baqmi',
      roleAr: 'مدير مطعم الأصيل',
      roleEn: 'Manager, Al-Aseel Restaurant',
      stars: 5,
      textAr: 'فريق محترف جداً، سرعة في التنفيذ وجودة لا تضاهى.',
      textEn: 'A very professional team — fast execution and unmatched quality.',
    },
    {
      nameAr: 'ريم الدوسري',
      nameEn: 'Reem Al-Dosari',
      roleAr: 'مديرة مركز رؤية للتدريب',
      roleEn: 'Director, Vision Training Center',
      stars: 5,
      textAr: 'تعاملت مع كثير من الوكالات، لكن اطبعلي الأكثر احترافاً وإبداعاً.',
      textEn: "I've worked with many agencies, but Etbaly is the most professional and creative.",
    },
    {
      nameAr: 'عمر الزهراني',
      nameEn: 'Omar Al-Zahrani',
      roleAr: 'مؤسس تك نوفا',
      roleEn: 'Founder, Tech Nova',
      stars: 5,
      textAr: 'حملاتهم الإعلانية حققت عائد استثمار تجاوز توقعاتنا بأضعاف.',
      textEn: 'Their advertising campaigns delivered an ROI that far exceeded our projections.',
    },
    {
      nameAr: 'منى الحربي',
      nameEn: 'Mona Al-Harbi',
      roleAr: 'مصممة أزياء',
      roleEn: 'Fashion Designer',
      stars: 5,
      textAr: 'أسلوبهم الإبداعي في التصميم أضاف قيمة كبيرة لعلامتي التجارية.',
      textEn: 'Their creative design approach added tremendous value to my brand.',
    },
    {
      nameAr: 'فيصل السبيعي',
      nameEn: 'Faisal Al-Subai',
      roleAr: 'رئيس مجموعة ألفا',
      roleEn: 'Chairman, Alpha Group',
      stars: 5,
      textAr: 'نتائج قابلة للقياس وتقارير شفافة — هذا ما يميزهم عن غيرهم.',
      textEn: 'Measurable results and transparent reporting — that is what sets them apart.',
    },
    {
      nameAr: 'هند الشهراني',
      nameEn: 'Hind Al-Shahrani',
      roleAr: 'مديرة علاقات عامة',
      roleEn: 'PR Manager',
      stars: 5,
      textAr: 'استجابة سريعة وتسليم في الوقت المحدد دائماً. شركاء موثوقون.',
      textEn: 'Always responsive and deliver on time. Truly reliable partners.',
    },
    {
      nameAr: 'سلطان المطيري',
      nameEn: 'Sultan Al-Mutairi',
      roleAr: 'مدير شركة النخبة',
      roleEn: 'CEO, Elite Company',
      stars: 5,
      textAr: 'من أفضل القرارات التي اتخذتها هي التعاون مع فريق اطبعلي.',
      textEn: 'Partnering with Etbaly was one of the best decisions I ever made.',
    },
    {
      nameAr: 'لمياء القرني',
      nameEn: 'Lamia Al-Qarni',
      roleAr: 'صاحبة مشروع جمال',
      roleEn: 'Beauty Brand Owner',
      stars: 5,
      textAr: 'تحولت صفحتنا من صفحة عادية إلى علامة تجارية قوية بفضلهم.',
      textEn: 'Our page transformed from ordinary to a powerful brand, all thanks to them.',
    },
  ];

  // ── الـ 3 cards الظاهرة حالياً ─────────────────────────────
  testimonials = this.allTestimonials.slice(0, 3);

  // State للـ rotation
  private testimonialsPage = 0;
  private testimonialsInterval: any = null;
  testimonialsAnimating = false;
  testimonialsExiting = false;
  testimonialsEntering = false;

  // ── بدء الـ auto-rotate ───────────────────────────────────
  private startTestimonialsRotation() {
    this.testimonialsInterval = setInterval(() => {
      this.rotateTestimonials();
    }, 6000);
  }

  rotateTestimonials() {
    if (this.testimonialsAnimating) return;
    this.testimonialsAnimating = true;
    this.testimonialsExiting = true;
    this.testimonialsEntering = false;
    this.cdr.markForCheck();

    // Phase 1: exit animation (480ms)
    setTimeout(() => {
      const total = this.allTestimonials.length;
      this.testimonialsPage = (this.testimonialsPage + 1) % Math.ceil(total / 3);
      const start = this.testimonialsPage * 3;
      // Update data with exiting=false, entering=false first
      this.testimonials = [...this.allTestimonials.slice(start, start + 3)];
      this.testimonialsExiting = false;
      this.testimonialsEntering = false;
      this.cdr.markForCheck();

      // Double rAF: wait for browser to paint the new cards WITHOUT enter class,
      // then add the enter class so the animation triggers fresh on every rotation
      requestAnimationFrame(() => {
        requestAnimationFrame(() => {
          this.testimonialsEntering = true;
          this.cdr.markForCheck();

          // Phase 2: enter animation (650ms), then unlock
          setTimeout(() => {
            this.testimonialsEntering = false;
            this.testimonialsAnimating = false;
            this.cdr.markForCheck();
          }, 650);
        });
      });
    }, 480);
  }

  goToTestimonialsPage(page: number) {
    if (this.testimonialsAnimating || page === this.testimonialsPage) return;
    clearInterval(this.testimonialsInterval);
    const pageCount = Math.ceil(this.allTestimonials.length / 3);
    // rotateTestimonials will do +1, so we set to target-1
    this.testimonialsPage = (page - 1 - 1 + pageCount) % pageCount;
    this.rotateTestimonials();
    this.startTestimonialsRotation();
  }

  get testimonialsPageCount(): number {
    return Math.ceil(this.allTestimonials.length / 3);
  }

  get testimonialsCurrentPage(): number {
    return this.testimonialsPage;
  }

  // ── Professional Particle Mesh System ──────────────────────
  private initParticleMesh() {
    this.heroSection = document.getElementById('heroSection');
    this.particleCanvas = document.getElementById('heroParticleCanvas') as HTMLCanvasElement;
    if (!this.particleCanvas || !this.heroSection) return;

    const section = this.heroSection;
    const canvas = this.particleCanvas;
    this.particleCtx = canvas.getContext('2d');
    if (!this.particleCtx) return;

    // Detect dark mode
    this.isDark = document.documentElement.getAttribute('data-bs-theme') !== 'light';

    const resize = () => {
      canvas.width = section.offsetWidth;
      canvas.height = section.offsetHeight;
      this.buildParticles(canvas.width, canvas.height);
    };
    resize();
    window.addEventListener('resize', resize);

    // Track mouse within hero
    section.addEventListener('mousemove', (e: MouseEvent) => {
      const rect = section.getBoundingClientRect();
      this.mouseHeroX = e.clientX - rect.left;
      this.mouseHeroY = e.clientY - rect.top;
      this.isMouseInHero = true;
    });
    section.addEventListener('mouseleave', () => {
      this.isMouseInHero = false;
      this.mouseHeroX = -9999;
      this.mouseHeroY = -9999;
    });
    section.addEventListener(
      'touchmove',
      (e: TouchEvent) => {
        const rect = section.getBoundingClientRect();
        this.mouseHeroX = e.touches[0].clientX - rect.left;
        this.mouseHeroY = e.touches[0].clientY - rect.top;
        this.isMouseInHero = true;
      },
      { passive: true },
    );
    section.addEventListener(
      'touchend',
      () => {
        this.isMouseInHero = false;
        this.mouseHeroX = -9999;
        this.mouseHeroY = -9999;
      },
      { passive: true },
    );

    this.renderParticleMesh();
  }

  private buildParticles(w: number, h: number) {
    const count = this.isMobile ? 55 : 110;
    this.particles = [];
    for (let i = 0; i < count; i++) {
      const baseAlpha = 0.15 + Math.random() * 0.35;
      this.particles.push({
        x: Math.random() * w,
        y: Math.random() * h,
        vx: (Math.random() - 0.5) * 0.35,
        vy: (Math.random() - 0.5) * 0.35,
        size: 1.5 + Math.random() * 2,
        alpha: baseAlpha,
        baseAlpha,
        pulseOffset: Math.random() * Math.PI * 2,
        pulseSpeed: 0.012 + Math.random() * 0.018,
      });
    }
  }

  private renderParticleMesh() {
    const ctx = this.particleCtx;
    const canvas = this.particleCanvas;
    if (!ctx || !canvas) return;

    const w = canvas.width;
    const h = canvas.height;
    const CONNECT_DIST = this.isMobile ? 100 : 145;
    const MOUSE_REPEL = 130;
    const MOUSE_ATTRACT = 200;
    const isDark = this.isDark;

    // Gold color values
    const goldR = 201,
      goldG = 162,
      goldB = 39;

    let tick = 0;

    const loop = () => {
      ctx.clearRect(0, 0, w, h);
      tick++;

      const mx = this.mouseHeroX;
      const my = this.mouseHeroY;
      const inHero = this.isMouseInHero;

      // Update & draw particles
      for (let i = 0; i < this.particles.length; i++) {
        const p = this.particles[i];

        // Gentle float
        p.x += p.vx;
        p.y += p.vy;

        // Wrap around
        if (p.x < 0) p.x = w;
        if (p.x > w) p.x = 0;
        if (p.y < 0) p.y = h;
        if (p.y > h) p.y = 0;

        // Mouse interaction — attract then repel
        if (inHero) {
          const dx = p.x - mx;
          const dy = p.y - my;
          const dist = Math.sqrt(dx * dx + dy * dy);

          if (dist < MOUSE_REPEL) {
            // Repel — push away
            const force = (1 - dist / MOUSE_REPEL) * 2.2;
            p.x += (dx / dist) * force;
            p.y += (dy / dist) * force;
            p.alpha = Math.min(1, p.baseAlpha + force * 0.5);
          } else if (dist < MOUSE_ATTRACT) {
            // Attract — gentle pull
            const force = (1 - dist / MOUSE_ATTRACT) * 0.6;
            p.x -= (dx / dist) * force;
            p.y -= (dy / dist) * force;
            p.alpha = p.baseAlpha + (1 - dist / MOUSE_ATTRACT) * 0.4;
          } else {
            p.alpha += (p.baseAlpha - p.alpha) * 0.05;
          }
        } else {
          // Pulse breathing
          p.alpha = p.baseAlpha + Math.sin(tick * p.pulseSpeed + p.pulseOffset) * 0.1;
        }

        // Draw particle
        ctx.beginPath();
        ctx.arc(p.x, p.y, p.size, 0, Math.PI * 2);
        ctx.fillStyle = `rgba(${goldR}, ${goldG}, ${goldB}, ${p.alpha})`;
        ctx.fill();

        // Connect nearby particles
        for (let j = i + 1; j < this.particles.length; j++) {
          const q = this.particles[j];
          const dx = p.x - q.x;
          const dy = p.y - q.y;
          const dist = Math.sqrt(dx * dx + dy * dy);

          if (dist < CONNECT_DIST) {
            let lineAlpha = (1 - dist / CONNECT_DIST) * 0.25;

            // Boost lines near mouse
            if (inHero) {
              const mdx = (p.x + q.x) / 2 - mx;
              const mdy = (p.y + q.y) / 2 - my;
              const mDist = Math.sqrt(mdx * mdx + mdy * mdy);
              if (mDist < MOUSE_ATTRACT) {
                lineAlpha += (1 - mDist / MOUSE_ATTRACT) * 0.45;
              }
            }

            ctx.beginPath();
            ctx.moveTo(p.x, p.y);
            ctx.lineTo(q.x, q.y);
            ctx.strokeStyle = `rgba(${goldR}, ${goldG}, ${goldB}, ${Math.min(lineAlpha, 0.55)})`;
            ctx.lineWidth = isDark ? 0.7 : 0.5;
            ctx.stroke();
          }
        }
      }

      // Mouse glow ring on canvas
      if (inHero && mx > 0) {
        const time = tick * 0.04;
        const rings = isDark ? 3 : 2;
        for (let r = 0; r < rings; r++) {
          const radius = 18 + r * 22 + Math.sin(time + r * 1.2) * 6;
          const alpha = (0.22 - r * 0.06) * (isDark ? 1 : 0.6);
          const grad = ctx.createRadialGradient(mx, my, 0, mx, my, radius);
          grad.addColorStop(0, `rgba(${goldR}, ${goldG}, ${goldB}, ${alpha})`);
          grad.addColorStop(1, `rgba(${goldR}, ${goldG}, ${goldB}, 0)`);
          ctx.beginPath();
          ctx.arc(mx, my, radius, 0, Math.PI * 2);
          ctx.fillStyle = grad;
          ctx.fill();
        }
      }

      this.particleRAF = requestAnimationFrame(loop);
    };

    loop();
  }

  trackByTestimonial(index: number, t: any): string {
    return t.nameEn;
  }

  getProjectTitle(media: any, index: number): string {
    const num = index + 1;
    return this.isArabic ? `تصميم مميز ${num}` : `Design Preview ${num}`;
  }

  getProjectDescription(media: SpecialtyMedia, context: any, index: number): string {
    // 🟢 نجيب اسم التخصص
    const tag = this.getTagFromMedia(media);
    const name = this.isArabic ? tag.ar : tag.en;

    // 🟢 أوصاف متنوعة
    const descriptionsAr = [
      `تصميم احترافي في مجال ${name}`,
      `حملة تسويقية قوية لقطاع ${name}`,
      `محتوى بصري مميز يعكس هوية ${name}`,
      `استراتيجية سوشيال ميديا فعالة في ${name}`,
      `تصميم إبداعي يعزز ظهور ${name}`,
      `محتوى احترافي لزيادة التفاعل في ${name}`,
      `حملة إعلانية موجهة لجمهور ${name}`,
      `تصميم جذاب يخدم نشاط ${name}`,
      `إدارة محتوى متكاملة في مجال ${name}`,
      `تطوير هوية بصرية قوية لـ ${name}`,
    ];

    const descriptionsEn = [
      `Professional design in ${name}`,
      `High-performing campaign for ${name}`,
      `Creative visual content for ${name}`,
      `Effective social media strategy in ${name}`,
      `Brand-focused design for ${name}`,
      `Engaging content for ${name}`,
      `Targeted campaign for ${name} audience`,
      `Eye-catching visuals in ${name}`,
      `Content management for ${name}`,
      `Strong branding for ${name}`,
    ];

    const list = this.isArabic ? descriptionsAr : descriptionsEn;

    // ✅ stable per media item — combine thumbnail + videoUrl + specialty + index for unique seed
    const seedStr = (media.thumbnail ?? '') + (media.videoUrl ?? '') + tag.en + String(index);
    const seed = this.hashString(seedStr);
    return list[seed % list.length];
  }

  private hashString(str: string): number {
    let hash = 0;
    for (let i = 0; i < str.length; i++) {
      hash = (hash * 31 + str.charCodeAt(i)) & 0xffffffff;
    }
    return Math.abs(hash);
  }

  getTagFromMedia(media: SpecialtyMedia): { ar: string; en: string } {
    for (const industry of this.data.industries) {
      for (const specialty of industry.specialties) {
        if (specialty.photos?.includes(media)) {
          return {
            ar: specialty.nameAr,
            en: specialty.nameEn,
          };
        }

        if (specialty.reels?.includes(media)) {
          return {
            ar: specialty.nameAr,
            en: specialty.nameEn,
          };
        }
      }
    }

    return { ar: '', en: '' };
  }

  get featureImage(): string {
    if (this.isArabic && this.isDayMode) return 'responsive/light-ar.png';
    if (this.isArabic && !this.isDayMode) return 'responsive/dark-ar.png';
    if (!this.isArabic && this.isDayMode) return 'responsive/light-en.png';
    return 'responsive/dark-en.png';
  }

  // ── Email Domain Whitelist ────────────────────────────────────────────────
  private readonly ALLOWED_EMAIL_DOMAINS = [
    // Gmail
    'gmail.com',
    // Microsoft / Outlook family
    'outlook.com',
    'hotmail.com',
    'live.com',
    'msn.com',
    'outlook.sa',
    'outlook.eg',
    'hotmail.co.uk',
    'hotmail.fr',
    'hotmail.de',
    'hotmail.es',
    'hotmail.it',
    'hotmail.nl',
    'hotmail.se',
    'hotmail.no',
    'hotmail.dk',
    'live.co.uk',
    'live.fr',
    'live.de',
    'live.nl',
    'live.se',
    // Yahoo family
    'yahoo.com',
    'yahoo.co.uk',
    'yahoo.fr',
    'yahoo.de',
    'yahoo.es',
    'yahoo.it',
    'yahoo.com.ar',
    'yahoo.com.au',
    'yahoo.co.jp',
    'yahoo.co.in',
    'yahoo.gr',
    'yahoo.com.br',
    'yahoo.com.mx',
    'ymail.com',
    'rocketmail.com',
    // ProtonMail
    'proton.me',
    'protonmail.com',
    'pm.me',
    // Zoho
    'zoho.com',
    'zohomail.com',
    // iCloud / Apple
    'icloud.com',
    'me.com',
    'mac.com',
    // Other reputable providers
    'aol.com',
    'mail.com',
    'email.com',
    'gmx.com',
    'gmx.net',
    'gmx.de',
    'web.de',
    'tutanota.com',
    'tutamail.com',
    'tuta.io',
    'fastmail.com',
    'hey.com',
  ];

  private readonly BLOCKED_EMAIL_DOMAINS = [
    'mailinator.com',
    'guerrillamail.com',
    'trashmail.com',
    'tempmail.com',
    'throwam.com',
    'sharklasers.com',
    'guerrillamail.info',
    'guerrillamail.biz',
    'guerrillamail.de',
    'guerrillamail.net',
    'guerrillamail.org',
    'spam4.me',
    'yopmail.com',
    'yopmail.fr',
    'dispostable.com',
    'mailnull.com',
    'spamgourmet.com',
    'trashmail.me',
    'fakeinbox.com',
    'maildrop.cc',
    'discard.email',
    'grr.la',
    'guerrillamailblock.com',
    'emailax.pro',
  ];

  isAllowedEmailDomain(email: string): boolean {
    const lower = email.toLowerCase().trim();
    const atIdx = lower.lastIndexOf('@');
    if (atIdx < 1) return false;
    const domain = lower.slice(atIdx + 1);

    // Always reject known disposable domains
    if (this.BLOCKED_EMAIL_DOMAINS.includes(domain)) return false;

    // Accept known reputable personal/provider domains
    if (this.ALLOWED_EMAIL_DOMAINS.includes(domain)) return true;

    // Accept business/corporate emails — domain must have a valid SLD + TLD
    const domainParts = domain.split('.');
    if (domainParts.length < 2) return false;
    const sld = domainParts[domainParts.length - 2];
    const tld = domainParts[domainParts.length - 1];
    if (!sld || sld.length < 2 || !tld || tld.length < 2) return false;

    // Accept as legitimate business email
    return true;
  }

  subscribeNewsletter(): void {
    const email = this.nlEmail.trim();

    // ── Client-side cooldown check ──
    if (this.nlCooldownActive) {
      this.nlRateLimited = true;
      this.nlRateLimitMsg = this.isArabic
        ? `يرجى الانتظار ${this.nlCooldownRemaining} قبل المحاولة مجدداً.`
        : `Please wait ${this.nlCooldownRemaining} before trying again.`;
      this.cdr.markForCheck();
      return;
    }

    // Reset state
    this.nlError = false;
    this.nlErrorMsg = '';
    this.nlDuplicate = false;
    this.nlRateLimited = false;
    this.nlRateLimitMsg = '';
    this.nlEmailDomainBlocked = false;

    // Client-side validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!email) {
      this.nlError = true;
      this.nlErrorMsg = this.isArabic
        ? 'يرجى إدخال بريدك الإلكتروني'
        : 'Please enter your email address';
      this.cdr.markForCheck();
      return;
    }
    if (!emailRegex.test(email)) {
      this.nlError = true;
      this.nlErrorMsg = this.isArabic
        ? 'البريد الإلكتروني غير صحيح'
        : 'Please enter a valid email address';
      this.cdr.markForCheck();
      return;
    }
    if (!this.isAllowedEmailDomain(email)) {
      this.nlError = true;
      this.nlEmailDomainBlocked = true;
      this.nlErrorMsg = this.isArabic
        ? 'يُسمح فقط بـ Gmail أو Outlook أو Yahoo أو Proton أو Zoho أو بريد الشركات'
        : 'Only Gmail, Outlook, Yahoo, Proton, Zoho, or business emails are allowed';
      this.cdr.markForCheck();
      return;
    }

    this.nlLoading = true;
    this.cdr.markForCheck();

    this.http
      .post<any>(
        'https://corsproxy.io/?url=https://etba3ly-api.xo.je/subscribe.php',
        `email=${encodeURIComponent(email)}&lang=${this.isArabic ? 'ar' : 'en'}`,
        {
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        },
      )
      .subscribe({
        next: (res) => {
          this.nlLoading = false;
          if (res?.status === 'rate_limited') {
            this.nlRateLimited = true;
            const mins = res?.retry_after_minutes ?? 30;
            this.nlRateLimitMsg = this.isArabic
              ? `لقد أرسلت طلبات كثيرة. انتظر ${mins} دقيقة ثم حاول مجدداً.`
              : `Too many attempts. Please wait ${mins} minute(s) before trying again.`;
          } else if (res?.new === false) {
            this.nlDuplicate = true;
            this.startCooldownTimer(); // cooldown even for duplicate
          } else {
            this.nlSuccess = true;
            this.startCooldownTimer(); // ✅ start 30-min client cooldown
          }

          this.nlEmail = '';
          this.cdr.markForCheck();
        },
        error: (err) => {
          this.nlLoading = false;
          // HTTP 429 يعني rate limited — corsproxy قد يمرّره كـ error
          if (err?.status === 429) {
            this.nlRateLimited = true;
            const mins = err?.error?.retry_after_minutes ?? 30;
            this.nlRateLimitMsg = this.isArabic
              ? `لقد أرسلت طلبات كثيرة. انتظر ${mins} دقيقة ثم حاول مجدداً.`
              : `Too many attempts. Please wait ${mins} minute(s) before trying again.`;
          } else {
            this.nlError = true;
            this.nlErrorMsg = this.isArabic
              ? 'حدث خطأ، حاول مرة أخرى'
              : 'Something went wrong. Please try again.';
          }

          this.cdr.markForCheck();
        },
      });
  }

  resetNewsletter(): void {
    this.nlSuccess = false;
    this.nlDuplicate = false;
    this.nlRateLimited = false;
    this.nlRateLimitMsg = '';
    this.nlError = false;
    this.nlErrorMsg = '';
    this.nlEmailDomainBlocked = false;
    this.nlEmail = '';
    this.cdr.markForCheck();
  }

  // ── Mobile Touch Ripple ────────────────────────────────────
  private initTouchRipple(): void {
    const section = document.getElementById('heroSection');
    if (!section) return;

    section.addEventListener(
      'touchstart',
      (e: TouchEvent) => {
        const rect = section.getBoundingClientRect();
        Array.from(e.changedTouches).forEach((touch) => {
          const ripple = document.createElement('div');
          ripple.className = 'hero-touch-ripple';
          ripple.style.left = touch.clientX - rect.left + 'px';
          ripple.style.top = touch.clientY - rect.top + 'px';
          section.appendChild(ripple);
          ripple.addEventListener('animationend', () => ripple.remove());
        });
      },
      { passive: true },
    );

    section.addEventListener(
      'touchmove',
      (e: TouchEvent) => {
        const rect = section.getBoundingClientRect();
        const t = e.touches[0];
        this.trailPoints.push({
          x: t.clientX - rect.left,
          y: t.clientY - rect.top,
          alpha: 0.75,
          size: 5 + Math.random() * 5,
        });
        if (this.trailPoints.length > 45) this.trailPoints.shift();
      },
      { passive: true },
    );
  }
}
