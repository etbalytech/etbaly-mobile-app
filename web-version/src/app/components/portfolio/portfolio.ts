import {
  Component,
  inject,
  AfterViewInit,
  HostListener,
  ChangeDetectorRef,
  ChangeDetectionStrategy,
} from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { TranslateModule } from '@ngx-translate/core';
import { Theme } from '../../core/theme';
import { RateLimit } from '../../core/rate-limit';
import { PortfolioData } from '../../core/portfolio-data';
import { Industry, Specialty, SpecialtyMedia } from '../../models/portfolio';

const REVIEW_KEY = 'portfolio_review_last_submit';
const REVIEW_COOLDOWN_MS = 300_000; // 5 دقايق

@Component({
  selector: 'app-portfolio',
  standalone: true,
  imports: [CommonModule, RouterModule, FormsModule, TranslateModule],
  templateUrl: './portfolio.html',
  styleUrl: './portfolio.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class Portfolio implements AfterViewInit {
  private themeService = inject(Theme);
  private cdr = inject(ChangeDetectorRef);
  private data = inject(PortfolioData);
  private rateLimit = inject(RateLimit);
  currentImageItem: SpecialtyMedia | null = null;
  currentProjectIndex: number = 0;

  get isArabic(): boolean {
    return this.themeService.currentLang() === 'ar';
  }

  get isDayMode(): boolean {
    return !this.themeService.isDarkMode();
  }

  // ── Navigation State ────────────────────────────────────────────────────────
  industries = this.data.industries;
  selectedIndustry: Industry | null = null;
  selectedSpecialty: Specialty | null = null;

  // ── Media Tab ───────────────────────────────────────────────────────────────
  activeTab: 'photos' | 'reels' = 'photos';

  // ── Pagination ──────────────────────────────────────────────────────────────
  readonly INITIAL_COUNT = 6;
  readonly LOAD_STEP = 6;
  photosVisible = this.INITIAL_COUNT;
  reelsVisible = this.INITIAL_COUNT;

  // ── Image Popup ─────────────────────────────────────────────────────────────
  popupOpen = false;
  popupImages: string[] = [];
  popupCurrentIndex = 0;
  popupTitle = '';

  // ── Reel Popup ──────────────────────────────────────────────────────────────
  reelPopupOpen = false;
  reelPopupUrl = '';
  reelPopupTitle = '';

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

  // ── Review ──────────────────────────────────────────────────────────────────
  reviewRating = 0;
  reviewHover = 0;
  reviewComment = '';
  reviewSubmitted = false;
  reviewSkipped = false;
  reviewSubmitting = false;
  reviewCooldown = false;
  reviewCooldownTime = 0;
  reviewError = false;
  private reviewCooldownInterval: any;
  reviewLabelsEn = ['Poor', 'Fair', 'Good', 'Very Good', 'Excellent'];
  reviewLabelsAr = ['سيء', 'مقبول', 'جيد', 'جيد جداً', 'ممتاز'];

  // ── Stats ───────────────────────────────────────────────────────────────────
  stats = [
    { numKey: 'HERO.STAT_1_NUM', labelKey: 'PORTFOLIO.STATS_PROJECTS', icon: 'fa-briefcase' },
    { numKey: 'HERO.STAT_2_NUM', labelKey: 'PORTFOLIO.STATS_CLIENTS', icon: 'fa-heart' },
    { numKey: 'HERO.STAT_3_NUM', labelKey: 'PORTFOLIO.STATS_YEARS', icon: 'fa-calendar-alt' },
    { num: '93%', labelKey: 'PORTFOLIO.STATS_RATE', icon: 'fa-star' },
  ];

  // ── Direct Industry Mode (no specialties) ────────────────────────────────────
  /** صح لو المجال ليس له تخصصات — يعرض photos/reels مباشرة */
  get isDirectMode(): boolean {
    return !!this.selectedIndustry && this.selectedIndustry.specialties.length === 0;
  }

  // ── Computed — يدعم كلاً من الـ specialty وال direct industry ────────────────
  get currentPhotos(): SpecialtyMedia[] {
    if (this.selectedSpecialty) return this.selectedSpecialty.photos ?? [];
    if (this.isDirectMode) return this.selectedIndustry?.photos ?? [];
    return [];
  }

  get currentReels(): SpecialtyMedia[] {
    if (this.selectedSpecialty) return this.selectedSpecialty.reels ?? [];
    if (this.isDirectMode) return this.selectedIndustry?.reels ?? [];
    return [];
  }

  get visiblePhotos(): SpecialtyMedia[] {
    return this.currentPhotos.slice(0, this.photosVisible);
  }

  get visibleReels(): SpecialtyMedia[] {
    return this.currentReels.slice(0, this.reelsVisible);
  }

  get hasMorePhotos(): boolean {
    return this.photosVisible < this.currentPhotos.length;
  }

  get hasLessPhotos(): boolean {
    return this.photosVisible > this.INITIAL_COUNT;
  }

  get hasMoreReels(): boolean {
    return this.reelsVisible < this.currentReels.length;
  }

  get hasLessReels(): boolean {
    return this.reelsVisible > this.INITIAL_COUNT;
  }

  // ── Navigation ────────────────────────────────────────────────────────────────
  selectIndustry(industry: Industry) {
    this.selectedIndustry = industry;
    this.selectedSpecialty = null;
    this.photosVisible = this.INITIAL_COUNT;
    this.reelsVisible = this.INITIAL_COUNT;
    this.activeTab = 'photos';
    this.cdr.markForCheck();
    setTimeout(() => this.checkReveal(), 50);
    setTimeout(() => this.checkReveal(), 300);

    // لو مفيش تخصصات — scroll للـ media مباشرة
    const scrollTarget =
      industry.specialties.length === 0 ? '.port-media-section' : '.port-specialty-section';

    setTimeout(() => {
      document.querySelector(scrollTarget)?.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }, 100);
  }

  selectSpecialty(specialty: Specialty) {
    this.selectedSpecialty = specialty;
    this.photosVisible = this.INITIAL_COUNT;
    this.reelsVisible = this.INITIAL_COUNT;
    this.activeTab = 'photos';
    this.cdr.markForCheck();
    setTimeout(() => this.checkReveal(), 50);
    setTimeout(() => this.checkReveal(), 300);
    setTimeout(() => {
      document
        .querySelector('.port-media-section')
        ?.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }, 100);
  }

  goBack() {
    if (this.selectedSpecialty) {
      this.selectedSpecialty = null;
    } else if (this.selectedIndustry) {
      this.selectedIndustry = null;
    }
    this.cdr.markForCheck();
    setTimeout(() => this.checkReveal(), 50);
  }

  goBackToIndustries() {
    this.selectedIndustry = null;
    this.selectedSpecialty = null;
    this.cdr.markForCheck();
    setTimeout(() => this.checkReveal(), 50);
  }

  goBackToSpecialties() {
    this.selectedSpecialty = null;
    this.cdr.markForCheck();
    setTimeout(() => this.checkReveal(), 50);
  }

  setActiveTab(tab: 'photos' | 'reels') {
    this.activeTab = tab;
    this.cdr.markForCheck();
  }

  // ── Pagination ────────────────────────────────────────────────────────────────
  showMorePhotos() {
    this.photosVisible = Math.min(this.photosVisible + this.LOAD_STEP, this.currentPhotos.length);
    this.cdr.markForCheck();
    setTimeout(() => this.checkReveal(), 50);
  }

  showLessPhotos() {
    this.photosVisible = this.INITIAL_COUNT;
    this.cdr.markForCheck();
    window.scrollTo({
      top:
        document.querySelector('.port-media-section')?.getBoundingClientRect().top! +
        window.scrollY -
        80,
      behavior: 'smooth',
    });
  }

  showMoreReels() {
    this.reelsVisible = Math.min(this.reelsVisible + this.LOAD_STEP, this.currentReels.length);
    this.cdr.markForCheck();
    setTimeout(() => this.checkReveal(), 50);
  }

  showLessReels() {
    this.reelsVisible = this.INITIAL_COUNT;
    this.cdr.markForCheck();
    window.scrollTo({
      top:
        document.querySelector('.port-media-section')?.getBoundingClientRect().top! +
        window.scrollY -
        80,
      behavior: 'smooth',
    });
  }

  // ── Image Popup ───────────────────────────────────────────────────────────────
  // ── Class PDF ─────────────────────────────────────────────────────────────────

  /** Google Drive file IDs */
  private readonly DRIVE_IDS = {
    classA: '1xX3oVh8X4gXhm4EHGobkgymPm_cvYBak',
    classB: '1OMlt-uM8cu2LuuDmE-E5_kxv1H4Bsr7q',
  };

  /** Open a PDF by key in Google Drive viewer */
  openClassPdf(classKey: 'classA' | 'classB'): void {
    const id = this.DRIVE_IDS[classKey];
    window.open(
      `https://drive.google.com/file/d/${id}/view?usp=drive_link`,
      '_blank',
      'noopener,noreferrer',
    );
  }

  /** Download — still served from local works/ folder */
  downloadClassPdf(path: string, filename: string): void {
    const a = document.createElement('a');
    a.href = path;
    a.download = filename;
    a.click();
  }

  openImagePopup(photo: SpecialtyMedia, index: number) {
    this.popupImages = photo.galleryImages ?? [photo.thumbnail];
    this.popupCurrentIndex = 0;
    this.currentProjectIndex = index;
    this.currentImageItem = photo;
    this.popupOpen = true;
    document.body.style.overflow = 'hidden';
    this.cdr.markForCheck();
  }

  closeImagePopup() {
    this.popupOpen = false;
    document.body.style.overflow = '';
    this.cdr.markForCheck();
  }

  nextImage() {
    if (this.isArabic) {
      this.popupCurrentIndex =
        (this.popupCurrentIndex - 1 + this.popupImages.length) % this.popupImages.length;
    } else {
      this.popupCurrentIndex = (this.popupCurrentIndex + 1) % this.popupImages.length;
    }
    this.cdr.markForCheck();
  }

  prevImage() {
    if (this.isArabic) {
      this.popupCurrentIndex = (this.popupCurrentIndex + 1) % this.popupImages.length;
    } else {
      this.popupCurrentIndex =
        (this.popupCurrentIndex - 1 + this.popupImages.length) % this.popupImages.length;
    }
    this.cdr.markForCheck();
  }

  // ── Reel Popup ────────────────────────────────────────────────────────────────
  openReelPopup(reel: SpecialtyMedia, index: number) {
    this.reelPopupUrl = reel.videoUrl ?? '';
    this.currentImageItem = reel;
    this.currentProjectIndex = index;
    this.reelPopupOpen = true;
    document.body.style.overflow = 'hidden';
    this.cdr.markForCheck();
  }

  closeReelPopup() {
    this.reelPopupOpen = false;
    this.reelPopupUrl = '';
    document.body.style.overflow = '';
    this.cdr.markForCheck();
  }

  onPopupBgClick(event: MouseEvent, type: 'image' | 'reel') {
    if ((event.target as HTMLElement).classList.contains('popup-backdrop'))
      type === 'image' ? this.closeImagePopup() : this.closeReelPopup();
  }

  // ── Review ─────────────────────────────────────────────────────────────────────
  private async initReviewCooldown() {
    const remaining = await this.rateLimit.getRemainingCooldown(REVIEW_KEY, REVIEW_COOLDOWN_MS);
    if (remaining > 0) {
      this.reviewSubmitted = true;
      this._startReviewCooldown(remaining);
    }
    // لو remaining = 0 مش بنعمل حاجة — الـ form يفضل زي ما هو (false by default)
    this.cdr.markForCheck();
  }

  selectRating(rating: number) {
    this.reviewRating = rating;
    this.cdr.markForCheck();
    setTimeout(() => this.checkReveal(), 50);
  }

  skipReview() {
    this.reviewSkipped = true;
    this.cdr.markForCheck();
    setTimeout(() => this.checkReveal(), 50);
  }

  async submitReview() {
    if (this.reviewSubmitting || this.reviewCooldown) return;

    this.reviewSubmitting = true;
    this.reviewError = false;
    this.cdr.detectChanges();

    const payload = {
      access_key: 'ebfc072d-a69e-4ff5-bd13-03418fda2c53',
      name: 'Portfolio Review',
      email: 'review@portfolio',
      message: `Rating: ${this.reviewRating}/5 (${this.reviewLabelsEn[this.reviewRating - 1]})\n\n${this.reviewComment || 'No comment provided.'}`,
      service: 'Portfolio Rating',
    };

    try {
      const response = await fetch('https://api.web3forms.com/submit', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
        body: JSON.stringify(payload),
      });

      if (!response.ok) throw new Error('API Error');

      this.reviewSubmitted = true;
      await this.rateLimit.recordSubmit(REVIEW_KEY);
      this._startReviewCooldown(REVIEW_COOLDOWN_MS);
      setTimeout(() => this.checkReveal(), 50);
    } catch (err) {
      this.reviewError = true;
      setTimeout(() => {
        this.reviewError = false;
        this.cdr.detectChanges();
      }, 8000);
    }

    this.reviewSubmitting = false;
    this.cdr.detectChanges();
  }

  private _startReviewCooldown(ms: number) {
    this.reviewCooldown = true;
    this.reviewCooldownTime = Math.ceil(ms / 1000);
    clearInterval(this.reviewCooldownInterval);
    this.reviewCooldownInterval = setInterval(async () => {
      this.reviewCooldownTime--;
      if (this.reviewCooldownTime <= 0) {
        clearInterval(this.reviewCooldownInterval);
        // ✅ نرجع نتحقق من كل الـ storages (مش بس الـ timer)
        // عشان لو اتمسح localStorage بس، الـ IDB/Cookie/Session لسه فيهم البيانات
        const remaining = await this.rateLimit.getRemainingCooldown(REVIEW_KEY, REVIEW_COOLDOWN_MS);
        if (remaining > 0) {
          // لسه في cooldown في storage تاني — نكمل
          this._startReviewCooldown(remaining);
        } else {
          // الكل انتهى فعلاً
          this.reviewCooldown = false;
          this.reviewSubmitted = false;
        }
      }
      this.cdr.detectChanges();
    }, 1000);
  }

  getProjectTitle(media: any, index: number): string {
    const num = index + 1;
    return this.isArabic ? `تصميم مميز ${num}` : `Design Preview ${num}`;
  }

  getProjectDescription(media: any, context: any, index: number): string {
    const name = this.isArabic ? context?.nameAr : context?.nameEn;

    const descriptionsAr = [
      `تصميم احترافي في مجال ${name}`,
      `إدارة محتوى مميز لعلامة في مجال ${name}`,
      `حملة تسويقية قوية لزيادة التفاعل في ${name}`,
      `تصميم إبداعي يعكس هوية ${name}`,
      `تطوير محتوى بصري احترافي لقطاع ${name}`,
      `استراتيجية سوشيال ميديا فعالة في مجال ${name}`,
      `تصميم يعزز حضور العلامة التجارية في ${name}`,
      `حملة إعلانية موجهة لجمهور ${name}`,
      `محتوى مبتكر يبرز قوة مجال ${name}`,
      `تصميم جذاب يرفع معدل التفاعل في ${name}`,
    ];

    const descriptionsEn = [
      `Professional design in ${name}`,
      `Creative content strategy for ${name}`,
      `High-performing campaign for ${name}`,
      `Brand-focused design for ${name}`,
      `Visual content development for ${name}`,
      `Effective social media strategy in ${name}`,
      `Engaging design for ${name} audience`,
      `Targeted campaign for ${name}`,
      `Creative visuals for ${name} field`,
      `High engagement design for ${name}`,
    ];

    const list = this.isArabic ? descriptionsAr : descriptionsEn;

    return list[index % list.length];
  }

  getTagFromSpecialty(specialty?: any): { ar: string; en: string } {
    if (!specialty) return { ar: '', en: '' };

    return {
      ar: specialty.nameAr,
      en: specialty.nameEn,
    };
  }

  // ── Keyboard & Scroll ──────────────────────────────────────────────────────────
  @HostListener('document:keydown', ['$event'])
  onKeyDown(e: KeyboardEvent) {
    if (this.popupOpen) {
      if (e.key === 'ArrowRight') this.nextImage();
      if (e.key === 'ArrowLeft') this.prevImage();
      if (e.key === 'Escape') this.closeImagePopup();
    }
    if (this.reelPopupOpen && e.key === 'Escape') this.closeReelPopup();
  }

  ngAfterViewInit() {
    this.initReviewCooldown();
    setTimeout(() => {
      this.checkReveal();
      this.cdr.markForCheck();
    }, 100);
  }

  @HostListener('window:scroll')
  onScroll() {
    this.checkReveal();
    this.cdr.markForCheck();
  }

  private checkReveal() {
    document.querySelectorAll('.reveal').forEach((el) => {
      const rect = el.getBoundingClientRect();
      if (rect.top < window.innerHeight * 0.88) el.classList.add('visible');
    });
  }
}
