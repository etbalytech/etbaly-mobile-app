import { Component, inject, AfterViewInit, HostListener, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, RouterModule } from '@angular/router';
import { TranslateModule, TranslateService } from '@ngx-translate/core';
import { Theme } from '../../../core/theme';

// ── Interfaces ──────────────────────────────────────────────────────────────
interface SocialPackage {
  id: string;
  nameAr: string;
  nameEn: string;
  descAr: string;
  descEn: string;
  price: number;
  image: string;
  features: { ar: string; en: string }[];
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
  selector: 'app-social',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterModule, TranslateModule],
  templateUrl: './social.html',
  styleUrl: './social.scss',
})
export class Social implements AfterViewInit, OnInit {
  private themeService = inject(Theme);
  private translate = inject(TranslateService);
  private router = inject(Router);

  get isArabic(): boolean {
    return this.themeService.currentLang() === 'ar';
  }

  // ── Invoice meta ────────────────────────────────────────────────────────
  invoiceNumber = Math.floor(100000 + Math.random() * 900000);
  invoiceDate = new Date().toLocaleDateString('ar-EG');

  // ── Social Media Packages (8 items) ─────────────────────────────────────
  socialPackages: SocialPackage[] = [
    {
      id: 'start-pkg',
      nameAr: 'باقة Start',
      nameEn: 'Start Package',
      descAr: 'مثالية للبداية والتواجد الرقمي على فيسبوك وانستجرام',
      descEn: 'Perfect for starting your digital presence on Facebook & Instagram',
      price: 1200,
      image: 'assets/images/social/start-pkg.jpg',
      features: [
        { ar: '7 بوستات بمحتوى وتصميم', en: '7 posts with content & design' },
        { ar: '7 ستوريز', en: '7 stories' },
        { ar: 'فيسبوك وانستجرام', en: 'Facebook & Instagram' },
        { ar: 'إدارة Messenger', en: 'Messenger management' },
      ],
    },
    {
      id: 'boost-pkg',
      nameAr: 'باقة Boost',
      nameEn: 'Boost Package',
      descAr: 'محتوى متنوع مع ريلز لتعزيز التفاعل والانتشار',
      descEn: 'Diverse content with Reels to boost engagement and reach',
      price: 1800,
      image: 'assets/images/social/boost-pkg.jpg',
      features: [
        { ar: '8 بوستات بمحتوى وتصميم', en: '8 posts with content & design' },
        { ar: '8 ستوريز', en: '8 stories' },
        { ar: 'ريل واحد', en: '1 Reel' },
        { ar: 'فيسبوك وانستجرام', en: 'Facebook & Instagram' },
      ],
    },
    {
      id: 'pro-pkg',
      nameAr: 'باقة Pro',
      nameEn: 'Pro Package',
      descAr: 'إدارة احترافية مع خطة تسويقية كاملة ومتابعة مستمرة',
      descEn: 'Professional management with a complete marketing plan',
      price: 2500,
      image: 'assets/images/social/pro-pkg.jpg',
      features: [
        { ar: '13 بوست بمحتوى وتصميم', en: '13 posts with content & design' },
        { ar: '13 ستوري', en: '13 stories' },
        { ar: 'ريل واحد', en: '1 Reel' },
        { ar: 'تحليل المنافسين', en: 'Competitor analysis' },
      ],
    },
    {
      id: 'pro-max-pkg',
      nameAr: 'باقة Pro Max',
      nameEn: 'Pro Max Package',
      descAr: 'الباقة الأقوى لإدارة شاملة على جميع المنصات',
      descEn: 'The most powerful package for full management across all platforms',
      price: 3500,
      image: 'assets/images/social/pro-max-pkg.jpg',
      features: [
        { ar: '30 بوست بمحتوى وتصميم', en: '30 posts with content & design' },
        { ar: '30 ستوري', en: '30 stories' },
        { ar: 'ريلين', en: '2 Reels' },
        { ar: 'فيسبوك وانستجرام وتيك توك', en: 'Facebook, Instagram & TikTok' },
      ],
    },
    {
      id: 'content-pkg',
      nameAr: 'باقة المحتوى',
      nameEn: 'Content Package',
      descAr: 'محتوى إبداعي متخصص يعكس هوية علامتك التجارية بأسلوب مميز',
      descEn: 'Creative specialized content reflecting your brand identity',
      price: 1500,
      image: 'assets/images/social/content-pkg.jpg',
      features: [
        { ar: 'كتابة محتوى احترافي', en: 'Professional content writing' },
        { ar: 'بوستات دعائية', en: 'Promotional posts' },
        { ar: 'هاشتاقات مدروسة', en: 'Researched hashtags' },
        { ar: 'جدول نشر منظم', en: 'Organized publishing schedule' },
      ],
    },
    {
      id: 'community-pkg',
      nameAr: 'باقة المجتمع',
      nameEn: 'Community Package',
      descAr: 'إدارة تفاعل الجمهور والرد على التعليقات والرسائل باحترافية',
      descEn: 'Manage audience engagement, comments, and messages professionally',
      price: 900,
      image: 'assets/images/social/community-pkg.jpg',
      features: [
        { ar: 'رد على التعليقات والرسائل', en: 'Reply to comments & messages' },
        { ar: 'فلترة التعليقات السلبية', en: 'Filter negative comments' },
        { ar: 'تقارير التفاعل الأسبوعية', en: 'Weekly engagement reports' },
        { ar: 'متابعة 7 أيام أسبوعياً', en: '7 days a week follow-up' },
      ],
    },
    {
      id: 'growth-pkg',
      nameAr: 'باقة النمو',
      nameEn: 'Growth Package',
      descAr: 'خطة متكاملة لتنمية حضورك الرقمي وزيادة المتابعين بشكل عضوي',
      descEn: 'Integrated plan to grow your digital presence organically',
      price: 2000,
      image: 'assets/images/social/growth-pkg.jpg',
      features: [
        { ar: 'استراتيجية نمو مخصصة', en: 'Custom growth strategy' },
        { ar: 'تحسين SEO للصفحات', en: 'Page SEO optimization' },
        { ar: 'تقارير أداء شهرية', en: 'Monthly performance reports' },
        { ar: 'تحليل منافسين', en: 'Competitor analysis' },
      ],
    },
    {
      id: 'enterprise-pkg',
      nameAr: 'باقة Enterprise',
      nameEn: 'Enterprise Package',
      descAr: 'حلول متكاملة للشركات الكبرى تشمل كل منصات التواصل الاجتماعي',
      descEn: 'Integrated solutions for large enterprises across all social platforms',
      price: 5000,
      image: 'assets/images/social/enterprise-pkg.jpg',
      features: [
        { ar: 'إدارة كاملة لكل المنصات', en: 'Full management across all platforms' },
        { ar: 'مدير حساب مخصص', en: 'Dedicated account manager' },
        { ar: 'حملات إعلانية مدفوعة', en: 'Paid advertising campaigns' },
        { ar: 'تقارير تفصيلية أسبوعية وشهرية', en: 'Detailed weekly & monthly reports' },
      ],
    },
  ];

  // ── Platforms ────────────────────────────────────────────────────────────
  platforms: Platform[] = [
    { id: 'facebook', nameAr: 'فيسبوك', nameEn: 'Facebook', icon: 'fa-facebook-f' },
    { id: 'instagram', nameAr: 'انستجرام', nameEn: 'Instagram', icon: 'fa-instagram' },
    { id: 'tiktok', nameAr: 'تيك توك', nameEn: 'TikTok', icon: 'fa-tiktok' },
    { id: 'snapchat', nameAr: 'سناب شات', nameEn: 'Snapchat', icon: 'fa-snapchat' },
    { id: 'youtube', nameAr: 'يوتيوب', nameEn: 'YouTube', icon: 'fa-youtube' },
    { id: 'google', nameAr: 'جوجل', nameEn: 'Google', icon: 'fa-google' },
    { id: 'telegram', nameAr: 'تيليجرام', nameEn: 'Telegram', icon: 'fa-telegram' },
  ];

  // ── State ────────────────────────────────────────────────────────────────
  selectedPackages: SocialPackage[] = [];
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

  // ── Package Selection ────────────────────────────────────────────────────
  isSelected(id: string): boolean {
    return this.selectedPackages.some((p) => p.id === id);
  }

  togglePackage(pkg: SocialPackage) {
    if (this.isSelected(pkg.id)) {
      this.selectedPackages = this.selectedPackages.filter((p) => p.id !== pkg.id);
    } else {
      this.selectedPackages.push(pkg);
      setTimeout(() => {
        const el = document.getElementById('order-form');
        el?.scrollIntoView({ behavior: 'smooth', block: 'start' });
      }, 100);
    }
  }

  clearSelection() {
    this.selectedPackages = [];
  }

  // ── Platforms ────────────────────────────────────────────────────────────
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

  // ── Same as mobile ───────────────────────────────────────────────────────
  onSameAsMobileChange() {
    if (this.sameAsMobile) {
      this.orderForm.whatsapp = this.orderForm.mobile;
    }
  }

  // ── Grand Total ──────────────────────────────────────────────────────────
  grandTotal(): number {
    return this.selectedPackages.reduce((sum, pkg) => sum + pkg.price, 0);
  }

  // ── Form Validation ──────────────────────────────────────────────────────
  isFormValid(): boolean {
    return !!(
      this.orderForm.fullName.trim() &&
      this.orderForm.mobile.trim() &&
      this.orderForm.whatsapp.trim() &&
      this.orderForm.email.trim() &&
      this.selectedPackages.length > 0
    );
  }

  // ── Submit ───────────────────────────────────────────────────────────────
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

  // ── Modal Controls ───────────────────────────────────────────────────────
  bodyUnlock() {
    document.body.classList.remove('modal-open');
  }

  closeInvoiceModal(event: MouseEvent) {
    if ((event.target as HTMLElement).classList.contains('invoice-modal-overlay')) {
      this.showInvoiceModal = false;
      document.body.classList.remove('modal-open');
    }
  }

  navigateToPayments() {
    this.showInvoiceModal = false;
    document.body.classList.remove('modal-open');
    try {
      sessionStorage.setItem(
        'social_order',
        JSON.stringify({
          packages: this.selectedPackages.map((p) => ({
            name: this.isArabic ? p.nameAr : p.nameEn,
            price: p.price,
          })),
          platforms: this.selectedPlatforms,
          form: this.orderForm,
          total: this.grandTotal(),
        }),
      );
    } catch {}
    this.router.navigate(['/payments']);
  }

  closePaymentModal(event: MouseEvent) {
    if ((event.target as HTMLElement).classList.contains('pay-modal-overlay')) {
      this.showPaymentModal = false;
      document.body.classList.remove('modal-open');
    }
  }

  fixArabic(text: string) {
    return text.split('').reverse().join('');
  }

  selectPayMethod(method: string) {
    this.selectedPayMethod = method;
  }

  printInvoiceFromModal() {
    const invoiceEl = document.querySelector('.invoice-modal') as HTMLElement;
    if (!invoiceEl) return;

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
          body { font-family: 'Segoe UI', Tahoma, Arial, sans-serif; background: #f4f4f8; padding: 2rem; }
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

  async downloadInvoiceAsPdf() {
    // ── تحميل المكتبات ──────────────────────────────────────────────────────
    const loadScript = (src: string, globalKey: string): Promise<void> =>
      new Promise((resolve, reject) => {
        if ((window as any)[globalKey]) {
          resolve();
          return;
        }
        const s = document.createElement('script');
        s.src = src;
        s.onload = () => resolve();
        s.onerror = reject;
        document.head.appendChild(s);
      });

    try {
      await loadScript(
        'https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js',
        'jspdf',
      );
      await loadScript(
        'https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.8.2/jspdf.plugin.autotable.min.js',
        'jspdfAutoTable',
      );

      const { jsPDF } = (window as any).jspdf;
      const isAr = this.isArabic;
      const cairoFont = 'PUT_BASE64_FONT_HERE';

      // ── إنشاء مستند PDF ─────────────────────────────────────────────────
      const doc = new jsPDF({ orientation: 'portrait', unit: 'mm', format: 'a4' });
      doc.addFileToVFS('Cairo.ttf', cairoFont);
      doc.addFont('Cairo.ttf', 'Cairo', 'normal');
      doc.setFont('Cairo');
      const W = doc.internal.pageSize.getWidth(); // 210mm
      const mar = 14; // هامش جانبي
      let y = mar;

      // ── ألوان وخطوط ─────────────────────────────────────────────────────
      const GOLD = [212, 175, 55] as [number, number, number];
      const DARK = [26, 26, 46] as [number, number, number];
      const MUTED = [108, 117, 133] as [number, number, number];
      const WHITE = [255, 255, 255] as [number, number, number];
      const LIGHT = [248, 248, 252] as [number, number, number];

      // ── دالة مساعدة: نص محاذى يمين/يسار حسب اللغة ──────────────────────
      const txt = (
        text: string,
        xL: number,
        yPos: number,
        opts: {
          size?: number;
          bold?: boolean;
          color?: [number, number, number];
          align?: 'left' | 'right' | 'center';
        } = {},
      ) => {
        doc.setFontSize(opts.size ?? 10);
        doc.setFont('Cairo');
        doc.setTextColor(...(opts.color ?? DARK));
        const align = opts.align ?? (isAr ? 'right' : 'left');
        const xPos = align === 'right' ? W - xL : align === 'center' ? W / 2 : xL;
        doc.text(text, xPos, yPos, { align });
      };

      // ══════════════════════════════════════════════════════════════════════
      // ١. شريط العنوان الذهبي (Header bar)
      // ══════════════════════════════════════════════════════════════════════
      doc.setFillColor(...GOLD);
      doc.rect(0, 0, W, 22, 'F');

      doc.setFontSize(13);
        doc.setFont('Cairo');
      doc.setTextColor(...WHITE);
      const brand = isAr ? 'تصميمات احترافية' : 'Professional Designs';
      const sub = isAr ? 'خدمات التواصل الاجتماعي' : 'Social Services';
      doc.text(brand, isAr ? W - mar : mar, 10, { align: isAr ? 'right' : 'left' });

      doc.setFontSize(8);
      doc.setFont('helvetica', 'normal');
      doc.text(sub, isAr ? W - mar : mar, 16, { align: isAr ? 'right' : 'left' });

      // رقم الفاتورة والتاريخ (يمين/يسار)
      const invLabel = isAr ? `# ${this.invoiceNumber}` : `Invoice # ${this.invoiceNumber}`;
      doc.setFontSize(9);
      doc.setFont('helvetica', 'bold');
      doc.text(invLabel, isAr ? mar : W - mar, 10, { align: isAr ? 'left' : 'right' });
      doc.setFont('helvetica', 'normal');
      doc.setFontSize(8);
      doc.text(this.invoiceDate, isAr ? mar : W - mar, 16, { align: isAr ? 'left' : 'right' });

      y = 30;

      // ══════════════════════════════════════════════════════════════════════
      // ٢. بطاقة حالة الفاتورة
      // ══════════════════════════════════════════════════════════════════════
      doc.setFillColor(...LIGHT);
      doc.roundedRect(mar, y, W - mar * 2, 10, 3, 3, 'F');
      doc.setFillColor(...GOLD);
      doc.circle(isAr ? W - mar - 4 : mar + 4, y + 5, 2, 'F');
      txt(isAr ? 'في انتظار الدفع' : 'Pending Payment', mar + 9, y + 6.5, {
        size: 9,
        bold: true,
        color: DARK,
        align: isAr ? 'right' : 'left',
      });
      y += 16;

      // ══════════════════════════════════════════════════════════════════════
      // ٣. بيانات العميل
      // ══════════════════════════════════════════════════════════════════════
      // عنوان القسم
      doc.setDrawColor(...GOLD);
      doc.setLineWidth(0.5);
      doc.line(mar, y, W - mar, y);
      y += 5;
      txt(isAr ? 'بيانات العميل' : 'Client Details', mar, y, { size: 10, bold: true, color: GOLD });
      y += 7;

      // شبكة البيانات (صفين)
      const fields = [
        { key: isAr ? 'الاسم' : 'Name', val: this.orderForm.fullName || '—' },
        { key: isAr ? 'موبايل' : 'Mobile', val: this.orderForm.mobile || '—' },
        { key: isAr ? 'واتساب' : 'WhatsApp', val: this.orderForm.whatsapp || '—' },
        { key: isAr ? 'إيميل' : 'Email', val: this.orderForm.email || '—' },
      ];
      if (this.orderForm.company) {
        fields.push({ key: isAr ? 'شركة' : 'Company', val: this.orderForm.company });
      }

      const colW = (W - mar * 2 - 5) / 2;
      const rowH = 13;
      for (let i = 0; i < fields.length; i += 2) {
        const xA = isAr ? W - mar - colW : mar;
        const xB = isAr ? mar : mar + colW + 5;

        // خلفية فاتحة للصف
        doc.setFillColor(...LIGHT);
        doc.roundedRect(mar, y, W - mar * 2, rowH - 1, 2, 2, 'F');

        // عمود A
        doc.setFontSize(7.5);
        doc.setFont('Cairo');
        doc.setTextColor(...MUTED);
        doc.text(fields[i].key, isAr ? xA + colW : xA, y + 4.5, { align: isAr ? 'right' : 'left' });
        doc.setFontSize(9);
        doc.setFont('helvetica', 'bold');
        doc.setTextColor(...DARK);
        doc.text(fields[i].val, isAr ? xA + colW : xA, y + 10, { align: isAr ? 'right' : 'left' });

        // عمود B (إن وُجد)
        if (fields[i + 1]) {
          doc.setFontSize(7.5);
          doc.setFont('helvetica', 'normal');
          doc.setTextColor(...MUTED);
          doc.text(fields[i + 1].key, isAr ? xB + colW : xB, y + 4.5, {
            align: isAr ? 'right' : 'left',
          });
          doc.setFontSize(9);
          doc.setFont('helvetica', 'bold');
          doc.setTextColor(...DARK);
          doc.text(fields[i + 1].val, isAr ? xB + colW : xB, y + 10, {
            align: isAr ? 'right' : 'left',
          });
        }
        y += rowH;
      }
      y += 6;

      // ══════════════════════════════════════════════════════════════════════
      // ٤. جدول الطلب (autoTable)
      // ══════════════════════════════════════════════════════════════════════
      doc.setDrawColor(...GOLD);
      doc.line(mar, y, W - mar, y);
      y += 5;
      txt(isAr ? 'تفاصيل الطلب' : 'Order Details', mar, y, { size: 10, bold: true, color: GOLD });
      y += 5;

      // بناء صفوف الجدول
      const tableRows = this.selectedPackages.map((pkg, idx) => {
        const name = isAr ? pkg.nameAr : pkg.nameEn;
        const qty = '1';
        const price = `${pkg.price.toLocaleString()} ${isAr ? 'ج.م' : 'EGP'}`;
        const total = `${pkg.price.toLocaleString()} ${isAr ? 'ج.م' : 'EGP'}`;
        return isAr ? [total, price, qty, name] : [idx + 1, name, qty, price, total];
      });

      const headAr = [['الإجمالي', 'سعر / قطعة', 'الكمية', 'الخدمة']];
      const headEn = [['#', 'Service', 'Qty', 'Unit Price', 'Total']];

      (doc as any).autoTable({
        head: isAr ? headAr : headEn,
        body: tableRows,
        startY: y,
        margin: { left: mar, right: mar },
        tableWidth: W - mar * 2,
        styles: {
          font: 'helvetica',
          fontSize: 9,
          cellPadding: 4,
          textColor: DARK,
          halign: isAr ? 'right' : 'left',
        },
        headStyles: {
          fillColor: GOLD,
          textColor: WHITE,
          fontStyle: 'bold',
          halign: isAr ? 'right' : 'left',
        },
        alternateRowStyles: { fillColor: LIGHT },
        columnStyles: isAr
          ? { 0: { halign: 'right', fontStyle: 'bold', textColor: DARK } }
          : { 4: { halign: 'right', fontStyle: 'bold', textColor: DARK } },
        didParseCell: (data: any) => {
          // تلوين صف الإجمالي الكلي
          if (data.row.index === tableRows.length - 1 && data.section === 'body') {
            data.cell.styles.fillColor = [245, 240, 220];
          }
        },
      });

      y = (doc as any).lastAutoTable.finalY + 4;

      // ── صف الإجمالي الكلي ──────────────────────────────────────────────
      doc.setFillColor(...GOLD);
      doc.roundedRect(mar, y, W - mar * 2, 11, 3, 3, 'F');
      doc.setFontSize(10);
        doc.setFont('Cairo');
      doc.setTextColor(...WHITE);
      const totalLabel = isAr ? 'الإجمالي الكلي' : 'Grand Total';
      const totalVal = `${this.grandTotal().toLocaleString()} ${isAr ? 'ج.م' : 'EGP'}`;
      doc.text(totalLabel, isAr ? W - mar - 4 : mar + 4, y + 7.5, {
        align: isAr ? 'right' : 'left',
      });
      doc.text(totalVal, isAr ? mar + 4 : W - mar - 4, y + 7.5, { align: isAr ? 'left' : 'right' });
      y += 17;

      // ══════════════════════════════════════════════════════════════════════
      // ٥. تنبيه الدفع
      // ══════════════════════════════════════════════════════════════════════
      doc.setFillColor(255, 249, 230);
      doc.setDrawColor(...GOLD);
      doc.setLineWidth(0.4);
      doc.roundedRect(mar, y, W - mar * 2, 16, 3, 3, 'FD');

      doc.setFontSize(9);
        doc.setFont('Cairo');
      doc.setTextColor(...DARK);
      txt(isAr ? 'برجاء إتمام عملية الدفع' : 'Please Complete Payment', mar + 4, y + 6.5, {
        size: 9,
        bold: true,
      });
      doc.setFont('helvetica', 'normal');
      doc.setFontSize(7.5);
      doc.setTextColor(...MUTED);
      txt(
        isAr
          ? 'لن يبدأ تنفيذ الطلب قبل تأكيد الدفع'
          : 'Order will not start before payment confirmation',
        mar + 4,
        y + 12.5,
        { size: 7.5 },
      );
      y += 22;

      // ══════════════════════════════════════════════════════════════════════
      // ٦. تذييل الصفحة
      // ══════════════════════════════════════════════════════════════════════
      const footerY = doc.internal.pageSize.getHeight() - 10;
      doc.setDrawColor(...GOLD);
      doc.setLineWidth(0.3);
      doc.line(mar, footerY - 4, W - mar, footerY - 4);
      doc.setFontSize(8);
        doc.setFont('Cairo');
      doc.setTextColor(...MUTED);
      const footerTxt = isAr
        ? 'شكراً لثقتك — تصميمات احترافية'
        : 'Thank you for your trust — Professional Designs';
      doc.text(footerTxt, W / 2, footerY, { align: 'center' });

      // ── حفظ الملف ───────────────────────────────────────────────────────
      doc.save(`invoice-${this.invoiceNumber}.pdf`);
    } catch (err) {
      console.error('PDF generation failed:', err);
    }
  }

  confirmAndSubmit() {
    if (!this.selectedPayMethod || !this.isFormValid()) return;
    try {
      sessionStorage.setItem(
        'social_order',
        JSON.stringify({
          packages: this.selectedPackages.map((p) => ({
            name: this.isArabic ? p.nameAr : p.nameEn,
            price: p.price,
          })),
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
      queryParams: { service: 'social', pay: this.selectedPayMethod },
    });
  }

  // ── Scroll reveal ────────────────────────────────────────────────────────
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
