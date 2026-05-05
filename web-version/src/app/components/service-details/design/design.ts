import {
  Component,
  inject,
  AfterViewInit,
  HostListener,
  OnInit,
  ChangeDetectorRef,
} from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, RouterModule } from '@angular/router';
import { TranslateModule, TranslateService } from '@ngx-translate/core';
import { Theme } from '../../../core/theme';
import { environment } from '../../../../environments/environment';

// ── Interfaces ──────────────────────────────────────────────────────────────
interface DesignService {
  id: string;
  nameAr: string;
  nameEn: string;
  descAr: string;
  descEn: string;
  price: number;
  image: string;
  minQty: number;
}

interface DesignPackage {
  id: string;
  nameAr: string;
  nameEn: string;
  price: number;
}

interface Platform {
  id: string;
  nameAr: string;
  nameEn: string;
  icon: string;
}

interface OrderForm {
  fullName: string;
  mobile: string;
  whatsapp: string;
  email: string;
  company: string;
  description: string;
}

@Component({
  selector: 'app-design',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterModule, TranslateModule],
  templateUrl: './design.html',
  styleUrl: './design.scss',
})
export class Design implements AfterViewInit, OnInit {
  private themeService = inject(Theme);
  private translate = inject(TranslateService);
  private router = inject(Router);
  private cdr = inject(ChangeDetectorRef);

  // Expose environment to template
  readonly environment = environment;

  get isArabic(): boolean {
    return this.themeService.currentLang() === 'ar';
  }

  // ── Invoice meta ──────────────────────────────────────────────────────────
  invoiceNumber = Math.floor(100000 + Math.random() * 900000);
  invoiceDate = new Date().toLocaleDateString('ar-EG');
  isDownloadingImage = false;

  // ── Design Services ───────────────────────────────────────────────────────
  designServices: DesignService[] = [
    {
      id: 'social-design',
      nameAr: 'تصميم سوشيال ميديا',
      nameEn: 'Social Media Design',
      descAr: 'تصميمات احترافية لمنصات التواصل الاجتماعي تعكس هوية علامتك التجارية',
      descEn: 'Professional social media designs that reflect your brand identity',
      price: 250,
      image: 'assets/images/design/social-design.jpg',
      minQty: 1,
    },
    {
      id: 'identity',
      nameAr: 'هوية بصرية كاملة',
      nameEn: 'Full Visual Identity',
      descAr: 'هوية بصرية متكاملة تشمل لوجو + غلاف + سلوجات + كافة المواد التسويقية',
      descEn: 'Full visual identity: logo + cover + slogans + all marketing materials',
      price: 3000,
      image: 'assets/images/design/identity.jpg',
      minQty: 1,
    },
    {
      id: 'logo',
      nameAr: 'تصميم لوجو احترافي',
      nameEn: 'Professional Logo Design',
      descAr: 'لوجو + غلاف + سلوجات بتصميم عالي الجودة يمثل علامتك التجارية',
      descEn: 'Logo + cover + slogans with high-quality design representing your brand',
      price: 500,
      image: 'assets/images/design/logo.jpg',
      minQty: 1,
    },
    {
      id: 'about-us',
      nameAr: 'تصميم About Us',
      nameEn: 'About Us Design',
      descAr: 'تصميم صفحة التعريف بشركتك بأسلوب احترافي وجذاب يعكس قيمك',
      descEn: 'Professional About Us page design that reflects your company values',
      price: 1000,
      image: 'assets/images/design/about-us.jpg',
      minQty: 1,
    },
  ];

  // ── Packages ───────────────────────────────────────────────────────────────
  designPackagesList: DesignPackage[] = [
    { id: 'pkg-starter', nameAr: 'تصميم سوشيال ميديا', nameEn: 'Social Media Design', price: 250 },
    { id: 'pkg-growth', nameAr: 'هوية بصرية كاملة', nameEn: 'Full Visual Identity', price: 3000 },
    { id: 'pkg-pro', nameAr: 'تصميم لوجو احترافي', nameEn: 'Professional Logo Design', price: 500 },
    { id: 'pkg-brand', nameAr: 'تصميم About Us', nameEn: 'About Us Design', price: 1000 },
  ];

  // ── Platforms ──────────────────────────────────────────────────────────────
  platforms: Platform[] = [
    { id: 'facebook', nameAr: 'فيسبوك', nameEn: 'Facebook', icon: 'fa-facebook-f' },
    { id: 'instagram', nameAr: 'انستجرام', nameEn: 'Instagram', icon: 'fa-instagram' },
    { id: 'tiktok', nameAr: 'تيك توك', nameEn: 'TikTok', icon: 'fa-tiktok' },
    { id: 'snapchat', nameAr: 'سناب شات', nameEn: 'Snapchat', icon: 'fa-snapchat' },
    { id: 'youtube', nameAr: 'يوتيوب', nameEn: 'YouTube', icon: 'fa-youtube' },
    { id: 'linkedin', nameAr: 'جوجل', nameEn: 'Google', icon: 'fa-google' },
    { id: 'telegram', nameAr: 'تيليجرام', nameEn: 'Telegram', icon: 'fa-telegram' },
  ];

  // ── State ──────────────────────────────────────────────────────────────────
  selectedServices: DesignService[] = [];
  qtyMap: Record<string, number> = {};
  selectedPackages: string[] = [];
  selectedPlatforms: string[] = [];
  sameAsMobile = false;
  showInvoiceModal = false;
  showPaymentModal = false;
  selectedPayMethod: string | null = null;

  orderForm: OrderForm = {
    fullName: '',
    mobile: '',
    whatsapp: '',
    email: '',
    company: '',
    description: '',
  };

  // ── NEW: Payment Popup State ───────────────────────────────────────────────
  showPaymentPopup = false;
  activePopupTab: 'invoice' | 'methods' | 'proof' = 'invoice';

  // ── NEW: Proof Form (Send Proof tab) ──────────────────────────────────────
  proofForm = {
    fullName: '',
    mobile: '',
    whatsapp: '',
    email: '',
    notes: '',
  };

  // ── NEW: File upload state ─────────────────────────────────────────────────
  proofFile: File | null = null;
  proofPreview: string | null = null;
  invoiceFile: File | null = null;
  invoicePreview: string | null = null;
  isDragOver = false;
  isDragOver2 = false;

  // ── NEW: Email send state ──────────────────────────────────────────────────
  emailSending = false;
  emailSent = false;
  emailError = false;

  // ── NEW: Copy state ────────────────────────────────────────────────────────
  copySuccess: string | null = null;

  // ── NEW: WhatsApp proof link ───────────────────────────────────────────────
  get whatsappProofLink(): string {
    const phone = (this.environment as any).WhatsappNumber?.replace(/\D/g, '') ?? '';
    const name = this.proofForm.fullName || this.orderForm.fullName;
    const msg = this.isArabic
      ? `مرحباً، إثبات الدفع — ${name} — فاتورة رقم ${this.invoiceNumber}`
      : `Hello, Payment Proof — ${name} — Invoice #${this.invoiceNumber}`;
    return `https://wa.me/${phone}?text=${encodeURIComponent(msg)}`;
  }

  // ── Service Selection ──────────────────────────────────────────────────────
  isSelected(id: string): boolean {
    return this.selectedServices.some((s) => s.id === id);
  }

  toggleService(svc: DesignService) {
    if (this.isSelected(svc.id)) {
      this.selectedServices = this.selectedServices.filter((s) => s.id !== svc.id);
    } else {
      this.selectedServices.push(svc);
      if (!this.qtyMap[svc.id]) this.qtyMap[svc.id] = 1;
      setTimeout(() => {
        const el = document.getElementById('order-form');
        el?.scrollIntoView({ behavior: 'smooth', block: 'start' });
      }, 100);
    }
  }

  clearSelection() {
    this.selectedServices = [];
    this.qtyMap = {};
  }

  // ── Qty ────────────────────────────────────────────────────────────────────
  getQty(id: string): number {
    return this.qtyMap[id] || 1;
  }

  increaseQty(svc: DesignService) {
    this.qtyMap[svc.id] = (this.qtyMap[svc.id] || svc.minQty) + 1;
  }

  decreaseQty(svc: DesignService) {
    const current = this.qtyMap[svc.id] || svc.minQty;
    if (current > svc.minQty) this.qtyMap[svc.id] = current - 1;
  }

  setQty(svc: DesignService, event: Event) {
    const val = parseInt((event.target as HTMLInputElement).value, 10);
    if (!isNaN(val) && val >= svc.minQty) {
      this.qtyMap[svc.id] = val;
    } else {
      this.qtyMap[svc.id] = svc.minQty;
      (event.target as HTMLInputElement).value = String(svc.minQty);
    }
  }

  getSubtotal(svc: DesignService): number {
    return svc.price * this.getQty(svc.id);
  }

  // ── Packages ───────────────────────────────────────────────────────────────
  isPackageSelected(id: string): boolean {
    return this.selectedPackages.includes(id);
  }

  togglePackage(id: string) {
    if (this.isPackageSelected(id)) {
      this.selectedPackages = this.selectedPackages.filter((p) => p !== id);
    } else {
      this.selectedPackages.push(id);
    }
  }

  getPackageById(id: string): DesignPackage | undefined {
    return this.designPackagesList.find((p) => p.id === id);
  }

  // ── Platforms ──────────────────────────────────────────────────────────────
  isPlatformSelected(id: string): boolean {
    return this.selectedPlatforms.includes(id);
  }

  togglePlatform(id: string) {
    if (this.isPlatformSelected(id)) {
      this.selectedPlatforms = this.selectedPlatforms.filter((p) => p !== id);
    } else {
      this.selectedPlatforms.push(id);
    }
  }

  // ── Same as mobile ─────────────────────────────────────────────────────────
  onSameAsMobileChange() {
    if (this.sameAsMobile) {
      this.orderForm.whatsapp = this.orderForm.mobile;
    }
  }

  // ── Grand Total ────────────────────────────────────────────────────────────
  grandTotal(): number {
    const svcTotal = this.selectedServices.reduce((sum, svc) => sum + this.getSubtotal(svc), 0);
    const pkgTotal = this.selectedPackages.reduce((sum, pid) => {
      const pkg = this.getPackageById(pid);
      return sum + (pkg ? pkg.price : 0);
    }, 0);
    return svcTotal + pkgTotal;
  }

  // ── Form Validation ────────────────────────────────────────────────────────
  isFormValid(): boolean {
    return !!(
      this.orderForm.fullName.trim() &&
      this.orderForm.mobile.trim() &&
      this.orderForm.whatsapp.trim() &&
      this.orderForm.email.trim() &&
      this.selectedServices.length > 0
    );
  }

  // ── Submit ─────────────────────────────────────────────────────────────────
  submitOrder() {
    if (!this.isFormValid()) {
      alert(
        this.isArabic ? 'برجاء إدخال جميع البيانات المطلوبة' : 'Please fill in all required fields',
      );
      return;
    }
    this.invoiceDate = new Date().toLocaleDateString(this.isArabic ? 'ar-EG' : 'en-US');
    this.showInvoiceModal = true;
    document.body.classList.add('modal-open');
  }

  // ── Print Invoice ──────────────────────────────────────────────────────────
  printInvoice() {
    this.invoiceDate = new Date().toLocaleDateString(this.isArabic ? 'ar-EG' : 'en-US');
    this.showInvoiceModal = true;
    document.body.classList.add('modal-open');
  }

  // ── Modal Controls ─────────────────────────────────────────────────────────
  bodyUnlock() {
    document.body.classList.remove('modal-open');
  }

  closeInvoiceModal(event: MouseEvent) {
    if ((event.target as HTMLElement).classList.contains('invoice-modal-overlay')) {
      this.showInvoiceModal = false;
      document.body.classList.remove('modal-open');
    }
  }

  openPaymentModal() {
    this.showInvoiceModal = false;
    this.showPaymentModal = true;
  }

  // ── REPLACED: navigateToPayments → opens Payment Popup ────────────────────
  navigateToPayments() {
    this.showInvoiceModal = false;
    document.body.classList.remove('modal-open');
    this.openPaymentPopup();
  }

  closePaymentModal(event: MouseEvent) {
    if ((event.target as HTMLElement).classList.contains('pay-modal-overlay')) {
      this.showPaymentModal = false;
      document.body.classList.remove('modal-open');
    }
  }

  selectPayMethod(method: string) {
    this.selectedPayMethod = method;
  }

  // ── NEW: Payment Popup ─────────────────────────────────────────────────────
  openPaymentPopup() {
    // Pre-fill proofForm from orderForm
    this.proofForm.fullName = this.orderForm.fullName || '';
    this.proofForm.mobile   = this.orderForm.mobile   || '';
    this.proofForm.whatsapp = this.orderForm.whatsapp || '';
    this.proofForm.email    = this.orderForm.email    || '';
    this.activePopupTab = 'invoice';
    this.showPaymentPopup = true;
    document.body.classList.add('modal-open');
  }

  closePaymentPopup(event: MouseEvent) {
    if ((event.target as HTMLElement).classList.contains('pay-popup-overlay')) {
      this.showPaymentPopup = false;
      document.body.classList.remove('modal-open');
    }
  }

  // ── NEW: Copy to clipboard ─────────────────────────────────────────────────
  copy(value: string, key: string) {
    navigator.clipboard.writeText(value).then(() => {
      this.copySuccess = key;
      setTimeout(() => { this.copySuccess = null; this.cdr.markForCheck(); }, 2000);
      this.cdr.markForCheck();
    });
  }

  // ── NEW: Drag & Drop — Zone 1 (Transfer Screenshot) ───────────────────────
  onDragOver(event: DragEvent) {
    event.preventDefault();
    this.isDragOver = true;
  }

  onDragLeave(event: DragEvent) {
    event.preventDefault();
    this.isDragOver = false;
  }

  onDrop(event: DragEvent) {
    event.preventDefault();
    this.isDragOver = false;
    const file = event.dataTransfer?.files[0];
    if (file && file.type.startsWith('image/')) this.setProofFile(file);
  }

  onProofSelected(event: Event) {
    const file = (event.target as HTMLInputElement).files?.[0];
    if (file) this.setProofFile(file);
  }

  private setProofFile(file: File) {
    this.proofFile = file;
    const reader = new FileReader();
    reader.onload = () => {
      this.proofPreview = reader.result as string;
      this.cdr.markForCheck();
    };
    reader.readAsDataURL(file);
  }

  removeProof(event: MouseEvent) {
    event.stopPropagation();
    this.proofFile = null;
    this.proofPreview = null;
    this.emailSent = false;
  }

  // ── NEW: Drag & Drop — Zone 2 (Invoice Photo) ─────────────────────────────
  onDragOver2(event: DragEvent) {
    event.preventDefault();
    this.isDragOver2 = true;
  }

  onDragLeave2(event: DragEvent) {
    event.preventDefault();
    this.isDragOver2 = false;
  }

  onDrop2(event: DragEvent) {
    event.preventDefault();
    this.isDragOver2 = false;
    const file = event.dataTransfer?.files[0];
    if (file && file.type.startsWith('image/')) this.setInvoiceFile(file);
  }

  onInvoiceSelected(event: Event) {
    const file = (event.target as HTMLInputElement).files?.[0];
    if (file) this.setInvoiceFile(file);
  }

  private setInvoiceFile(file: File) {
    this.invoiceFile = file;
    const reader = new FileReader();
    reader.onload = () => {
      this.invoicePreview = reader.result as string;
      this.cdr.markForCheck();
    };
    reader.readAsDataURL(file);
  }

  removeInvoice(event: MouseEvent) {
    event.stopPropagation();
    this.invoiceFile = null;
    this.invoicePreview = null;
    this.emailSent = false;
  }

  // ── NEW: WhatsApp proof click handler ─────────────────────────────────────
  onWhatsappProofClick() {
    // Optionally track or log
  }

  // ── NEW: Send Proof by Email (with form data + 2 attachments) ─────────────
  async sendProofByEmail() {
    if (!this.proofFile || !this.invoiceFile || this.emailSending) return;

    this.emailSending = true;
    this.emailError = false;
    this.cdr.detectChanges();

    try {
      const base64Transfer = await this.fileToBase64(this.proofFile);
      const base64Invoice  = await this.fileToBase64(this.invoiceFile);

      const isAr = this.isArabic;

      const subject = isAr
        ? `إثبات دفع + فاتورة — ${this.proofForm.fullName || 'عميل جديد'}`
        : `Payment Proof & Invoice — ${this.proofForm.fullName || 'New Client'}`;

      const body = isAr
        ? `مرحباً،\n\nبيانات العميل:\n` +
          `الاسم: ${this.proofForm.fullName}\n` +
          `الموبايل: ${this.proofForm.mobile}\n` +
          `واتساب: ${this.proofForm.whatsapp || '—'}\n` +
          `الإيميل: ${this.proofForm.email || '—'}\n` +
          `ملاحظات: ${this.proofForm.notes || '—'}\n\n` +
          `أرفق صورة التحويل وصورة الفاتورة — برجاء تفعيل الخدمة.`
        : `Hello,\n\nClient Details:\n` +
          `Name: ${this.proofForm.fullName}\n` +
          `Mobile: ${this.proofForm.mobile}\n` +
          `WhatsApp: ${this.proofForm.whatsapp || '—'}\n` +
          `Email: ${this.proofForm.email || '—'}\n` +
          `Notes: ${this.proofForm.notes || '—'}\n\n` +
          `Please find the transfer screenshot and invoice attached. Kindly activate the service.`;

      const apiUrl = (this.environment as any).receiptApiUrl as string;
      if (!apiUrl) throw new Error('receiptApiUrl not configured');

      const res = await fetch(apiUrl, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          subject,
          body,
          attachment1: base64Transfer,
          filename1: this.proofFile.name,
          attachment2: base64Invoice,
          filename2: this.invoiceFile.name,
          clientData: {
            fullName: this.proofForm.fullName,
            mobile:   this.proofForm.mobile,
            whatsapp: this.proofForm.whatsapp,
            email:    this.proofForm.email,
            notes:    this.proofForm.notes,
          },
        }),
      });

      if (!res.ok) {
        const err = await res.json().catch(() => ({}));
        throw new Error((err as any).error ?? `HTTP ${res.status}`);
      }

      this.emailSent = true;
    } catch (e) {
      console.error('[sendProofByEmail]', e);
      this.emailError = true;
    } finally {
      this.emailSending = false;
      this.cdr.detectChanges();
    }
  }

  // ── Confirm & Submit (old payment modal) ──────────────────────────────────
  confirmAndSubmit() {
    if (!this.selectedPayMethod || !this.isFormValid()) return;
    try {
      sessionStorage.setItem(
        'design_order',
        JSON.stringify({
          services: this.selectedServices.map((s) => ({
            name: this.isArabic ? s.nameAr : s.nameEn,
            qty: this.getQty(s.id),
            subtotal: this.getSubtotal(s),
          })),
          packages: this.selectedPackages.map((pid) => this.getPackageById(pid)),
          platforms: this.selectedPlatforms,
          form: this.orderForm,
          total: this.grandTotal(),
          payMethod: this.selectedPayMethod,
        }),
      );
    } catch {}
    this.showPaymentModal = false;
    document.body.classList.remove('modal-open');
    this.router.navigate(['/contact'], {
      queryParams: { service: 'design', pay: this.selectedPayMethod },
    });
  }

  // ── Print Invoice ──────────────────────────────────────────────────────────
  printInvoiceFromModal() {
    const invoiceEl = document.querySelector('.invoice-modal') as HTMLElement;
    if (!invoiceEl) return;

    const styles = Array.from(document.styleSheets)
      .map((sheet) => {
        try {
          return Array.from(sheet.cssRules).map((r) => r.cssText).join('\n');
        } catch {
          return '';
        }
      })
      .join('\n');

    const printWin = window.open('', '_blank', 'width=900,height=700');
    if (!printWin) return;

    printWin.document.write(`
      <!DOCTYPE html>
      <html dir="${this.isArabic ? 'rtl' : 'ltr'}" lang="${this.isArabic ? 'ar' : 'en'}">
      <head>
        <meta charset="UTF-8"/>
        <title>${this.isArabic ? 'طباعة الفاتورة' : 'Print Invoice'}</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
        <style>
          :root {
            --gold: #d4af37;
            --gold-light: #f0d060;
            --bg-card: #fff;
            --text-main: #1a1a2e;
            --text-muted: #6c757d;
            --radius-lg: 16px;
          }
          * { box-sizing: border-box; margin: 0; padding: 0; }
          ${
            this.isArabic
              ? `@import url('https://fonts.googleapis.com/css2?family=Cairo:wght@400;600;700;800;900&display=swap');
                 body, * { font-family: 'Cairo', 'Segoe UI', Tahoma, Arial, sans-serif !important; background: #f4f4f8; padding: 2rem; }`
              : `body { font-family: 'Segoe UI', Tahoma, Arial, sans-serif; background: #f4f4f8; padding: 2rem; }`
          }
          ${styles}
          .invoice-modal {
            position: static !important;
            max-width: 760px;
            margin: 0 auto;
            background: #fff;
            border-radius: 16px;
            padding: 2rem;
            box-shadow: 0 4px 32px rgba(0,0,0,0.12);
          }
          .inv-close-btn, .inv-actions { display: none !important; }
          @media print {
            body { background: white; padding: 0; }
            .invoice-modal { box-shadow: none; }
          }
        </style>
      </head>
      <body>
        ${invoiceEl.outerHTML}
        <script>
          document.querySelectorAll('.inv-close-btn, .inv-actions').forEach(el => el.style.display = 'none');
          setTimeout(() => { window.print(); window.close(); }, 600);
        <\/script>
      </body>
      </html>
    `);
    printWin.document.close();
  }

  // ── Download Invoice as Image ──────────────────────────────────────────────
  async downloadInvoiceAsImage(): Promise<void> {
    if (this.isDownloadingImage) return;

    this.isDownloadingImage = true;
    this.cdr.detectChanges();

    await new Promise((r) => setTimeout(r, 400));

    const modal = document.querySelector('.invoice-modal') as HTMLElement | null;
    if (!modal) {
      this.isDownloadingImage = false;
      return;
    }

    const isRtl = this.isArabic;
    const dir = isRtl ? 'rtl' : 'ltr';
    const filename = `invoice-${this.invoiceNumber}.png`;

    const ensureScript = (url: string, ready: () => boolean): Promise<void> =>
      new Promise((res, rej) => {
        if (ready()) { res(); return; }
        const s = document.createElement('script');
        s.src = url;
        s.crossOrigin = 'anonymous';
        s.onload = () => res();
        s.onerror = () => rej(new Error(`Cannot load: ${url}`));
        document.head.appendChild(s);
      });

    const buildFontCss = async (): Promise<string> => {
      if (!isRtl) return '';
      const entries = [
        { w: '400', subset: 'arabic' },
        { w: '700', subset: 'arabic' },
        { w: '900', subset: 'arabic' },
        { w: '400', subset: 'latin' },
        { w: '700', subset: 'latin' },
      ];
      const faces: string[] = [];
      await Promise.allSettled(
        entries.map(async ({ w, subset }) => {
          const url = `https://cdn.jsdelivr.net/fontsource/fonts/cairo@latest/${subset}-${w}-normal.woff2`;
          try {
            const buf = await fetch(url).then((r) => r.arrayBuffer());
            const bytes = new Uint8Array(buf);
            let b64 = '';
            const CHUNK = 8192;
            for (let i = 0; i < bytes.length; i += CHUNK) {
              b64 += String.fromCharCode(...bytes.subarray(i, i + CHUNK));
            }
            faces.push(
              `@font-face{font-family:'Cairo';font-style:normal;font-weight:${w};` +
                `src:url('data:font/woff2;base64,${btoa(b64)}') format('woff2');}`,
            );
          } catch { /* skip */ }
        }),
      );
      return faces.join('\n');
    };

    const getCssVars = (): string => {
      const cs = getComputedStyle(document.documentElement);
      const pairs: string[] = [];
      for (let i = 0; i < cs.length; i++) {
        const p = cs[i];
        if (p.startsWith('--')) pairs.push(`${p}:${cs.getPropertyValue(p).trim()}`);
      }
      return `:root{${pairs.join(';')}}`;
    };

    let tempStyle: HTMLStyleElement | null = null;

    const logoWrap = modal.querySelector('.inv-logo-wrap') as HTMLElement | null;
    let logoImg: HTMLImageElement | null = null;
    if (logoWrap) {
      logoImg = document.createElement('img');
      logoImg.src = '/logo.png';
      logoImg.style.cssText =
        'width:48px;height:48px;object-fit:contain;margin-inline-end:8px;border-radius:8px;';
      logoImg.alt = 'Logo';
      logoWrap.insertAdjacentElement('afterbegin', logoImg);
    }

    let watermark: HTMLElement | null = null;
    watermark = document.createElement('div');
    watermark.style.cssText = `
      text-align:center;
      font-size:1.1rem;
      font-weight:700;
      color:#d4af37;
      letter-spacing:2px;
      padding:0.5rem 0 0.25rem;
      opacity:0.85;
    `;
    watermark.textContent = 'تصميمات احترافية';
    const invFooter = modal.querySelector('.inv-footer') as HTMLElement | null;
    if (invFooter) invFooter.insertAdjacentElement('beforebegin', watermark);

    try {
      await ensureScript(
        'https://unpkg.com/dom-to-image-more@3.4.0/dist/dom-to-image-more.min.js',
        () => typeof (window as any).domtoimage?.toPng === 'function',
      );
      const dti = (window as any).domtoimage;

      const [fontCss, cssVars] = await Promise.all([buildFontCss(), Promise.resolve(getCssVars())]);

      const originals: Record<string, string> = {};
      const modalStyle = modal.style;
      const props = [
        'transform', 'opacity', 'maxHeight', 'overflow', 'direction',
        'position', 'width', 'height', 'boxShadow', 'borderRadius', 'transition',
      ];
      props.forEach((p) => { originals[p] = (modalStyle as any)[p]; });

      Object.assign(modalStyle, {
        transform: 'none',
        opacity: '1',
        maxHeight: 'none',
        overflow: 'visible',
        direction: dir,
        position: 'relative',
        width: '680px',
        boxShadow: 'none',
        transition: 'none',
      });

      const hideTargets = [
        modal.querySelector('.inv-actions') as HTMLElement | null,
        modal.querySelector('.inv-close-btn') as HTMLElement | null,
      ].filter((el): el is HTMLElement => !!el);
      const hiddenOriginals = hideTargets.map((el) => el.style.display);
      hideTargets.forEach((el) => { el.style.display = 'none'; });

      await new Promise((r) => setTimeout(r, 300));

      const W = modal.scrollWidth;
      const H = modal.scrollHeight;
      const SCALE = 3;

      tempStyle = document.createElement('style');
      tempStyle.id = '__inv-capture-style__';
      tempStyle.textContent = `
        ${fontCss}
        ${cssVars}
        *, *::before, *::after {
          font-family: ${
            isRtl
              ? "'Cairo','Amiri','Noto Sans Arabic',Tahoma"
              : "'Segoe UI','Helvetica Neue','Arial'"
          }, sans-serif !important;
          -webkit-font-smoothing: antialiased;
        }
        ${isRtl ? `html,body,[dir]{direction:rtl!important;unicode-bidi:embed}` : ''}
        .inv-actions, .inv-close-btn { display: none !important; }
        .invoice-modal {
          transform: none !important;
          opacity: 1 !important;
          max-height: none !important;
          overflow: visible !important;
          box-shadow: none !important;
          transition: none !important;
        }
      `;
      document.head.appendChild(tempStyle);

      const dataUrl: string = await dti.toPng(modal, {
        width: W * SCALE,
        height: H * SCALE,
        bgcolor: '#ffffff',
        style: {
          transform: `scale(${SCALE})`,
          transformOrigin: 'top left',
          width: `${W}px`,
          height: `${H}px`,
        },
        filter: (node: Node): boolean => {
          if (!(node instanceof HTMLElement)) return true;
          return (
            !node.classList.contains('inv-actions') && !node.classList.contains('inv-close-btn')
          );
        },
      });

      tempStyle.remove();
      tempStyle = null;
      props.forEach((p) => { (modalStyle as any)[p] = originals[p]; });
      hideTargets.forEach((el, i) => { el.style.display = hiddenOriginals[i]; });

      const a = document.createElement('a');
      a.download = filename;
      a.href = dataUrl;
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
    } catch (err) {
      console.error('[Invoice] download failed →', err);
      tempStyle?.remove();
    } finally {
      logoImg?.remove();
      watermark?.remove();
      this.isDownloadingImage = false;
      this.cdr.markForCheck();
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  private fileToBase64(file: File): Promise<string> {
    return new Promise((resolve, reject) => {
      const reader = new FileReader();
      reader.onload = () => resolve(reader.result as string);
      reader.onerror = reject;
      reader.readAsDataURL(file);
    });
  }

  // ── Scroll reveal ──────────────────────────────────────────────────────────
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
}
