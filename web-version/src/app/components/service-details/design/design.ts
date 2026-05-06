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
    const name = this.orderForm.fullName || this.orderForm.fullName;
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
  formTouched = false;

  /** Live field-level error messages (Arabic / English based on isArabic) */
  get fieldErrors(): Record<string, string> {
    const ar = this.isArabic;
    const f = this.orderForm;
    const errors: Record<string, string> = {};

    // Full name — at least 2 words
    if (!f.fullName.trim()) {
      errors['fullName'] = ar ? 'الاسم الكامل مطلوب' : 'Full name is required';
    } else if (f.fullName.trim().split(/\s+/).length < 2) {
      errors['fullName'] = ar
        ? 'أدخل الاسم الكامل (اسمان على الأقل)'
        : 'Enter at least first and last name';
    }

    // Mobile — Egyptian 11-digit starting with 01
    const mobileRegex = /^01[0-9]{9}$/;
    if (!f.mobile.trim()) {
      errors['mobile'] = ar ? 'رقم الموبايل مطلوب' : 'Mobile number is required';
    } else if (!mobileRegex.test(f.mobile.trim())) {
      errors['mobile'] = ar
        ? 'رقم موبايل غير صحيح (11 رقم يبدأ بـ 01)'
        : 'Invalid mobile (11 digits starting with 01)';
    }

    // WhatsApp — same rule
    if (!f.whatsapp.trim()) {
      errors['whatsapp'] = ar ? 'رقم الواتساب مطلوب' : 'WhatsApp number is required';
    } else if (!mobileRegex.test(f.whatsapp.trim())) {
      errors['whatsapp'] = ar
        ? 'رقم واتساب غير صحيح (11 رقم يبدأ بـ 01)'
        : 'Invalid WhatsApp (11 digits starting with 01)';
    }

    // Email — valid format
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!f.email.trim()) {
      errors['email'] = ar ? 'البريد الإلكتروني مطلوب' : 'Email address is required';
    } else if (!emailRegex.test(f.email.trim())) {
      errors['email'] = ar ? 'صيغة البريد الإلكتروني غير صحيحة' : 'Invalid email address format';
    }

    // At least one platform selected
    if (this.selectedPlatforms.length === 0) {
      errors['platforms'] = ar ? 'اختر منصة واحدة على الأقل' : 'Select at least one platform';
    }

    // Description required
    if (!f.description.trim()) {
      errors['description'] = ar ? 'برجاء وصف طلبك بالتفصيل' : 'Please describe your request';
    } else if (f.description.trim().length < 10) {
      errors['description'] = ar
        ? 'الوصف قصير جداً — أدخل تفاصيل أكثر'
        : 'Description is too short — please add more details';
    }

    return errors;
  }

  get isFormValid(): boolean {
    return Object.keys(this.fieldErrors).length === 0 && this.selectedServices.length > 0;
  }

  /** Returns error for a specific field only after form is touched */
  getError(field: string): string {
    if (!this.formTouched) return '';
    return this.fieldErrors[field] ?? '';
  }

  /** Mark field as touched on blur to show inline errors progressively */
  touchField(field: string) {
    // We use a simple flag — once any field is blurred we enable all error display
    this.formTouched = true;
    this.cdr.markForCheck();
  }

  // ── Submit ─────────────────────────────────────────────────────────────────
  submitOrder() {
    this.formTouched = true;
    this.cdr.markForCheck();

    if (!this.isFormValid) {
      // Scroll to first error field
      setTimeout(() => {
        const firstErr = document.querySelector('.field-error-msg');
        firstErr?.scrollIntoView({ behavior: 'smooth', block: 'center' });
      }, 50);
      return;
    }
    this.invoiceDate = new Date().toLocaleDateString(this.isArabic ? 'ar-EG' : 'en-US');
    this.openPaymentPopup();
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
      setTimeout(() => {
        this.copySuccess = null;
        this.cdr.markForCheck();
      }, 2000);
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
      const base64Invoice = await this.fileToBase64(this.invoiceFile);

      const isAr = this.isArabic;

      const subject = isAr
        ? `إثبات دفع + فاتورة — ${this.orderForm.fullName || 'عميل جديد'}`
        : `Payment Proof & Invoice — ${this.orderForm.fullName || 'New Client'}`;

      const body = isAr
        ? `مرحباً،\n\nبيانات العميل:\n` +
          `الاسم: ${this.orderForm.fullName}\n` +
          `الموبايل: ${this.orderForm.mobile}\n` +
          `واتساب: ${this.orderForm.whatsapp || '—'}\n` +
          `الإيميل: ${this.orderForm.email || '—'}\n` +
          `ملاحظات: ${this.orderForm.description || '—'}\n\n` +
          `أرفق صورة التحويل وصورة الفاتورة — برجاء تفعيل الخدمة.`
        : `Hello,\n\nClient Details:\n` +
          `Name: ${this.orderForm.fullName}\n` +
          `Mobile: ${this.orderForm.mobile}\n` +
          `WhatsApp: ${this.orderForm.whatsapp || '—'}\n` +
          `Email: ${this.orderForm.email || '—'}\n` +
          `Notes: ${this.orderForm.description || '—'}\n\n` +
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
            fullName: this.orderForm.fullName,
            mobile: this.orderForm.mobile,
            whatsapp: this.orderForm.whatsapp,
            email: this.orderForm.email,
            notes: this.orderForm.description,
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
    if (!this.selectedPayMethod || !this.isFormValid) return;
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

  // ── Print Invoice from Popup ───────────────────────────────────────────────
  async printInvoiceFromModal() {
    const invoiceEl = document.querySelector('.ppi-card') as HTMLElement;
    if (!invoiceEl) return;

    // Convert logo to base64 to ensure it renders in print window
    let logoBase64 = '';
    try {
      const resp = await fetch('/logo.png');
      const blob = await resp.blob();
      logoBase64 = await new Promise<string>((res) => {
        const reader = new FileReader();
        reader.onload = () => res(reader.result as string);
        reader.readAsDataURL(blob);
      });
    } catch {
      /* logo optional */
    }

    const styles = Array.from(document.styleSheets)
      .map((sheet) => {
        try {
          return Array.from(sheet.cssRules)
            .map((r) => r.cssText)
            .join('\n');
        } catch {
          return '';
        }
      })
      .join('\n');

    // Clone the invoice HTML and replace font-awesome icons + logo icon with actual logo
    const clonedEl = invoiceEl.cloneNode(true) as HTMLElement;

    // Replace the paint-brush icon wrapper with logo image in header
    const logoIconEl = clonedEl.querySelector('.ppi-logo-icon') as HTMLElement | null;
    if (logoIconEl && logoBase64) {
      logoIconEl.innerHTML = `<img src="${logoBase64}" alt="Logo" style="width:52px;height:52px;object-fit:contain;border-radius:10px;display:block;" />`;
      logoIconEl.style.cssText =
        'background:transparent;border:none;padding:0;display:flex;align-items:center;justify-content:center;';
    }

    // Hide action buttons in clone
    clonedEl
      .querySelectorAll('.ppi-actions')
      .forEach((el) => ((el as HTMLElement).style.display = 'none'));

    const printWin = window.open('', '_blank', 'width=900,height=700');
    if (!printWin) return;

    const isAr = this.isArabic;
    printWin.document.write(`
      <!DOCTYPE html>
      <html dir="${isAr ? 'rtl' : 'ltr'}" lang="${isAr ? 'ar' : 'en'}">
      <head>
        <meta charset="UTF-8"/>
        <title>${isAr ? 'طباعة الفاتورة' : 'Print Invoice'}</title>
        <link rel="preconnect" href="https://fonts.googleapis.com"/>
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Cairo:wght@400;600;700;800;900&display=swap"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
        <style>
          :root {
            --gold: #d4af37;
            --gold-light: #f0d060;
            --bg-card: #fff;
            --text-main: #1a1a2e;
            --text-muted: #6c757d;
            --border-color: #e0e0e0;
            --border-subtle: #eeeeee;
            --bg-subtle: #fafaf8;
            --radius-lg: 16px;
          }
          * { box-sizing: border-box; margin: 0; padding: 0; }
          ${
            isAr
              ? `body, * { font-family: 'Cairo', 'Segoe UI', Tahoma, Arial, sans-serif !important; }`
              : `body { font-family: 'Segoe UI', Tahoma, Arial, sans-serif; }`
          }
          body {
            background: #f4f4f8;
            padding: 2rem;
            color: #1a1a2e;
            direction: ${isAr ? 'rtl' : 'ltr'};
          }
          ${styles}
          /* ── Layout overrides ── */
          .ppi-card {
            position: static !important;
            max-width: 760px !important;
            margin: 0 auto !important;
            background: #fff !important;
            border-radius: 16px !important;
            padding: 2.5rem 2.5rem 2rem !important;
            box-shadow: 0 4px 32px rgba(0,0,0,0.12) !important;
            transform: none !important;
            opacity: 1 !important;
          }
          .ppi-actions { display: none !important; }
          /* ── Header ── */
          .ppi-header {
            display: flex !important;
            align-items: center !important;
            justify-content: space-between !important;
            margin-bottom: 1rem !important;
          }
          .ppi-logo-wrap {
            display: flex !important;
            align-items: center !important;
            gap: 0.75rem !important;
          }
          .ppi-logo-icon img {
            width: 52px !important;
            height: 52px !important;
            object-fit: contain !important;
            border-radius: 10px !important;
          }
          .ppi-brand {
            font-size: 1.2rem !important;
            font-weight: 800 !important;
            color: #1a1a2e !important;
          }
          .ppi-brand-sub {
            font-size: 0.8rem !important;
            color: #888 !important;
          }
          .ppi-meta { text-align: ${isAr ? 'left' : 'right'} !important; }
          .ppi-num { font-size: 1.1rem !important; font-weight: 800 !important; color: #b8860b !important; }
          .ppi-date { font-size: 0.85rem !important; color: #555 !important; margin-top: 2px !important; }
          .ppi-status {
            display: inline-flex !important;
            align-items: center !important;
            gap: 5px !important;
            background: #fff8e1 !important;
            color: #7a5c00 !important;
            border: 1px solid #d4af37 !important;
            border-radius: 20px !important;
            padding: 2px 10px !important;
            font-size: 0.75rem !important;
            font-weight: 700 !important;
            margin-top: 4px !important;
          }
          /* ── Gold bar ── */
          .ppi-gold-bar {
            height: 3px !important;
            background: linear-gradient(90deg, #d4af37, #f0c040, #d4af37) !important;
            border-radius: 2px !important;
            margin: 1rem 0 !important;
          }
          /* ── Section label ── */
          .ppi-section-label {
            font-weight: 700 !important;
            color: #b8860b !important;
            font-size: 0.9rem !important;
            display: flex !important;
            align-items: center !important;
            gap: 6px !important;
            margin-bottom: 0.5rem !important;
          }
          /* ── Client grid ── */
          .ppi-client-grid {
            display: grid !important;
            grid-template-columns: repeat(3, 1fr) !important;
            gap: 0.5rem 1rem !important;
            background: #faf8f0 !important;
            border: 1px solid #e0d5a0 !important;
            border-radius: 10px !important;
            padding: 0.75rem 1rem !important;
            margin-bottom: 0.75rem !important;
          }
          .ppi-key { font-size: 0.72rem !important; color: #888 !important; display: block !important; }
          .ppi-val { font-size: 0.9rem !important; font-weight: 600 !important; color: #1a1a2e !important; }
          /* ── Table ── */
          .ppi-table-wrap { overflow: visible !important; border-radius: 10px !important; border: 1px solid rgba(212,175,55,0.3) !important; margin-bottom: 1rem !important; }
          .ppi-table { width: 100% !important; border-collapse: collapse !important; table-layout: auto !important; }
          .ppi-table thead th {
            background: linear-gradient(135deg, rgba(212,175,55,0.9), rgba(184,138,11,0.95)) !important;
            padding: 0.65rem 0.8rem !important;
            text-align: start !important;
            font-size: 0.8rem !important;
            font-weight: 700 !important;
            color: #0a0800 !important;
            white-space: nowrap !important;
          }
          .ppi-table tbody td {
            padding: 0.6rem 0.8rem !important;
            font-size: 0.85rem !important;
            border-bottom: 1px solid rgba(212,175,55,0.1) !important;
            color: #1a1a2e !important;
          }
          .ppi-table tbody td:first-child { white-space: normal !important; }
          .ppi-table tbody td:not(:first-child) { white-space: nowrap !important; }
          .ppi-table tbody tr:nth-child(even) td { background: #faf8f0 !important; }
          .ppi-table tfoot td {
            padding: 0.65rem 0.8rem !important;
            background: rgba(212,175,55,0.08) !important;
            border-top: 2px solid rgba(212,175,55,0.4) !important;
            border-bottom: none !important;
            font-weight: 700 !important;
            color: #b8860b !important;
          }
          .ppi-qty-badge {
            background: #f0e8c8 !important;
            color: #7a5c00 !important;
            border: 1px solid #d4af37 !important;
            border-radius: 6px !important;
            padding: 1px 8px !important;
            font-size: 0.8rem !important;
            font-weight: 700 !important;
          }
          /* ── Pay note ── */
          .ppi-pay-note {
            display: flex !important;
            align-items: center !important;
            gap: 0.75rem !important;
            background: #fff8e1 !important;
            border: 1px solid #d4af37 !important;
            border-radius: 10px !important;
            padding: 0.75rem 1rem !important;
            margin-bottom: 1rem !important;
          }
          .ppi-pay-note-title { font-weight: 700 !important; color: #7a5c00 !important; font-size: 0.9rem !important; }
          .ppi-pay-note-sub { font-size: 0.78rem !important; color: #a08030 !important; }
          /* ── Footer ── */
          .ppi-footer {
            text-align: center !important;
            border-top: 1px solid #e0d8b0 !important;
            padding-top: 0.75rem !important;
            font-size: 0.78rem !important;
            color: #888 !important;
            margin-top: 1rem !important;
          }
          /* ── Platforms ── */
          .ppi-platforms-wrap { display: flex !important; flex-wrap: wrap !important; gap: 0.4rem !important; margin-bottom: 0.75rem !important; }
          .ppi-platform-tag {
            background: #f5f0e0 !important;
            border: 1px solid #d4af37 !important;
            color: #7a5c00 !important;
            border-radius: 20px !important;
            padding: 2px 10px !important;
            font-size: 0.78rem !important;
            font-weight: 600 !important;
            display: inline-flex !important;
            align-items: center !important;
            gap: 4px !important;
          }
          /* ── Client message ── */
          .ppi-client-msg {
            background: #faf8f0 !important;
            border-right: 3px solid #d4af37 !important;
            padding: 0.6rem 0.85rem !important;
            font-size: 0.85rem !important;
            border-radius: 6px !important;
            margin-bottom: 0.75rem !important;
            color: #333 !important;
          }
          @media print {
            body { background: white !important; padding: 0 !important; }
            .ppi-card { box-shadow: none !important; border-radius: 0 !important; padding: 1.5rem !important; }
          }
        </style>
      </head>
      <body>
        ${clonedEl.outerHTML}
        <script>
          document.querySelectorAll('.ppi-actions').forEach(el => el.style.display = 'none');
          setTimeout(() => { window.print(); window.close(); }, 800);
        <\/script>
      </body>
      </html>
    `);
    printWin.document.close();
  }

  // ── Download Invoice as Image ──────────────────────────────────────────────
  /**
   * Waits for the browser to complete a full layout/paint cycle.
   * Two nested requestAnimationFrame calls guarantee we are past
   * the reflow that follows any DOM/style mutation.
   */
  private waitForLayout(): Promise<void> {
    return new Promise((resolve) => {
      requestAnimationFrame(() => requestAnimationFrame(() => resolve()));
    });
  }

  async downloadInvoiceAsImage(): Promise<void> {
    if (this.isDownloadingImage) return;

    this.isDownloadingImage = true;
    this.cdr.detectChanges();

    // Let Angular finish its change-detection pass before touching the DOM
    await this.waitForLayout();

    const modal = document.querySelector('.ppi-card') as HTMLElement | null;
    if (!modal) {
      this.isDownloadingImage = false;
      return;
    }

    const isRtl = this.isArabic;
    const dir = isRtl ? 'rtl' : 'ltr';
    const filename = `invoice-${this.invoiceNumber}.png`;

    const ensureScript = (url: string, ready: () => boolean): Promise<void> =>
      new Promise((res, rej) => {
        if (ready()) {
          res();
          return;
        }
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
          } catch {
            /* skip */
          }
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

    // Load logo as base64 so dom-to-image can embed it correctly
    let logoBase64 = '';
    try {
      const resp = await fetch('/logo.png');
      const blob = await resp.blob();
      logoBase64 = await new Promise<string>((res) => {
        const reader = new FileReader();
        reader.onload = () => res(reader.result as string);
        reader.readAsDataURL(blob);
      });
    } catch {
      /* logo optional */
    }

    // Replace the icon in .ppi-logo-icon with the real logo image
    const logoIconEl = modal.querySelector('.ppi-logo-icon') as HTMLElement | null;
    let originalLogoContent = '';
    if (logoIconEl && logoBase64) {
      originalLogoContent = logoIconEl.innerHTML;
      logoIconEl.innerHTML = `<img src="${logoBase64}" alt="Logo" style="width:52px;height:52px;object-fit:contain;border-radius:10px;display:block;" />`;
      logoIconEl.style.cssText =
        'background:transparent;border:none;padding:0;display:flex;align-items:center;justify-content:center;width:52px;height:52px;';
    }

    // Keep old variable for cleanup (no separate logoImg needed now)
    let logoImg: HTMLImageElement | null = null;

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
        'transform',
        'opacity',
        'maxHeight',
        'overflow',
        'direction',
        'position',
        'width',
        'height',
        'boxShadow',
        'borderRadius',
        'transition',
      ];
      props.forEach((p) => {
        originals[p] = (modalStyle as any)[p];
      });

      // Detect current theme to preserve dark/light mode in exported image
      const isDark = document.documentElement.getAttribute('data-bs-theme') === 'dark';
      const captureBackground = isDark ? '#1e1b30' : '#ffffff';
      const captureColor = isDark ? '#ede8ff' : '#111111';

      Object.assign(modalStyle, {
        transform: 'none',
        opacity: '1',
        maxHeight: 'none',
        overflow: 'visible',
        direction: dir,
        position: 'relative',
        width: '800px',
        boxShadow: 'none',
        transition: 'none',
        borderRadius: '0',
        padding: '40px 56px 56px',
        background: captureBackground,
        color: captureColor,
      });

      const hideTargets = [
        modal.querySelector('.ppi-actions') as HTMLElement | null,
        modal.querySelector('.pay-popup-close') as HTMLElement | null,
      ].filter((el): el is HTMLElement => !!el);
      const hiddenOriginals = hideTargets.map((el) => el.style.display);
      hideTargets.forEach((el) => {
        el.style.display = 'none';
      });

      // ── CRITICAL FIX ──────────────────────────────────────────────────────
      // After mutating styles we MUST wait for the browser to reflow before
      // reading scrollWidth/scrollHeight.  A double-rAF guarantees we are in
      // a fresh paint frame and all dimensions are settled.
      // (The old setTimeout(300) was unreliable: on fast machines the layout
      // was measured before reflow; on slow machines it caused visible flicker.)
      await this.waitForLayout();
      // Force a synchronous reflow so the values below are always fresh:
      void modal.offsetHeight; // triggers layout flush

      const W = modal.scrollWidth;
      const H = modal.scrollHeight;
      const SCALE = 4;

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
        .ppi-actions, .pay-popup-close { display: none !important; }
        /* ── Theme-aware card reset ── */
        .ppi-card {
          transform: none !important;
          opacity: 1 !important;
          max-height: none !important;
          overflow: visible !important;
          box-shadow: none !important;
          transition: none !important;
          background: ${isDark ? '#1e1b30' : '#ffffff'} !important;
          color: ${isDark ? '#ede8ff' : '#111111'} !important;
          --text-main: ${isDark ? '#ede8ff' : '#111111'} !important;
          --text-muted: ${isDark ? '#b9a3ff' : '#4a4a4a'} !important;
          --text-light: ${isDark ? '#8b7dc8' : '#777777'} !important;
          --bg-card: ${isDark ? '#1e1b30' : '#ffffff'} !important;
          --bg-subtle: ${isDark ? '#252040' : '#fafaf8'} !important;
          --border-color: ${isDark ? '#332d55' : '#dddddd'} !important;
          --border-subtle: ${isDark ? '#2a2448' : '#eeeeee'} !important;
          --gold: ${isDark ? '#d4af37' : '#b8860b'} !important;
        }
        .ppi-client-grid {
          background: ${isDark ? '#252040' : '#faf8f0'} !important;
          border-color: ${isDark ? '#3d3560' : '#e0d5a0'} !important;
        }
        .ppi-gold-bar {
          background: linear-gradient(90deg, #d4af37, #f0c040, #d4af37) !important;
          opacity: 1 !important;
        }
        .ppi-table thead th {
          background: linear-gradient(135deg, rgba(212,175,55,0.9), rgba(184,138,11,0.95)) !important;
          color: #0a0800 !important;
          border-bottom: none !important;
        }
        .ppi-table tfoot td {
          background: ${isDark ? 'rgba(212,175,55,0.12)' : '#fff8e1'} !important;
          border-top-color: #d4af37 !important;
          color: ${isDark ? '#d4af37' : '#b8860b'} !important;
        }
        .ppi-table tbody td { color: ${isDark ? '#ede8ff' : '#1a1a2e'} !important; }
        .ppi-table tbody tr:nth-child(even) td { background: ${isDark ? '#252040' : '#faf8f0'} !important; }
        .ppi-table-wrap {
          border-color: rgba(212,175,55,0.2) !important;
          overflow: hidden !important;
        }
        .ppi-grand-total { color: ${isDark ? '#d4af37' : '#b8860b'} !important; }
        .ppi-status { background: ${isDark ? 'rgba(212,175,55,0.12)' : '#fff8e1'} !important; border-color: #d4af37 !important; color: ${isDark ? '#d4af37' : '#7a5c00'} !important; }
        .ppi-num { color: ${isDark ? '#d4af37' : '#b8860b'} !important; }
        .ppi-section-label { color: ${isDark ? '#d4af37' : '#b8860b'} !important; }
        .ppi-pay-note { background: ${isDark ? 'rgba(212,175,55,0.08)' : '#fff8e1'} !important; border-color: #d4af37 !important; }
        .ppi-pay-note-title { color: ${isDark ? '#d4af37' : '#7a5c00'} !important; }
        .ppi-pay-note-sub { color: ${isDark ? '#b8922a' : '#a08030'} !important; }
        .ppi-qty-badge { background: ${isDark ? 'rgba(212,175,55,0.15)' : '#f0e8c8'} !important; color: ${isDark ? '#d4af37' : '#7a5c00'} !important; border-color: #d4af37 !important; }
        .ppi-footer { border-top-color: ${isDark ? '#332d55' : '#e0d8b0'} !important; color: ${isDark ? '#8b7dc8' : '#888'} !important; }
        .ppi-row-total { color: ${isDark ? '#ede8ff' : '#111'} !important; font-weight: 600 !important; }
        .ppi-key { color: ${isDark ? '#8b7dc8' : '#888'} !important; }
        .ppi-val { color: ${isDark ? '#ede8ff' : '#1a1a2e'} !important; }
        .ppi-client-msg { background: ${isDark ? '#252040' : '#faf8f0'} !important; color: ${isDark ? '#ede8ff' : '#333'} !important; border-right-color: #d4af37 !important; }
        .ppi-platform-tag { background: ${isDark ? 'rgba(212,175,55,0.1)' : '#f5f0e0'} !important; border-color: #d4af37 !important; color: ${isDark ? '#d4af37' : '#7a5c00'} !important; }
      `;
      document.head.appendChild(tempStyle);

      // Wait for the new style sheet to be parsed and applied before capturing.
      await this.waitForLayout();
      void modal.offsetHeight; // second layout flush

      const dataUrl: string = await dti.toPng(modal, {
        width: W * SCALE,
        height: H * SCALE,
        bgcolor: isDark ? '#1e1b30' : '#ffffff',
        style: {
          transform: `scale(${SCALE})`,
          transformOrigin: 'top left',
          width: `${W}px`,
          height: `${H}px`,
        },
        filter: (node: Node): boolean => {
          if (!(node instanceof HTMLElement)) return true;
          return (
            !node.classList.contains('ppi-actions') && !node.classList.contains('pay-popup-close')
          );
        },
      });

      tempStyle.remove();
      tempStyle = null;
      props.forEach((p) => {
        (modalStyle as any)[p] = originals[p];
      });
      hideTargets.forEach((el, i) => {
        el.style.display = hiddenOriginals[i];
      });

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
      if (logoIconEl && originalLogoContent !== undefined) {
        logoIconEl.innerHTML = originalLogoContent;
        logoIconEl.style.cssText = '';
      }
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

  get fieldErrorCount(): number {
    return Object.keys(this.fieldErrors).length;
  }

  // ── Platform helpers ───────────────────────────────────────────────────────
  getPlatformIcon(id: string): string {
    return this.platforms.find((p) => p.id === id)?.icon ?? 'fa-globe';
  }

  getPlatformNameAr(id: string): string {
    return this.platforms.find((p) => p.id === id)?.nameAr ?? id;
  }

  getPlatformNameEn(id: string): string {
    return this.platforms.find((p) => p.id === id)?.nameEn ?? id;
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
