import {
  ChangeDetectorRef,
  Component,
  inject,
  AfterViewInit,
  HostListener,
  OnInit,
} from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { TranslateModule } from '@ngx-translate/core';
import { environment } from '../../../environments/environment';
import { Theme } from '../../core/theme';

@Component({
  selector: 'app-payments',
  standalone: true,
  imports: [CommonModule, RouterModule, TranslateModule],
  templateUrl: './payments.html',
  styleUrl: './payments.scss',
})
export class Payments implements OnInit, AfterViewInit {
  environment = environment;
  private cdr = inject(ChangeDetectorRef);
  private theme = inject(Theme);

  copySuccess: string | null = null;
  whatsappLink = '';

  // Proof / Transfer section — image 1: transfer screenshot
  proofFile: File | null = null;
  proofPreview: string | null = null;
  isDragOver = false;

  // Invoice photo — image 2
  invoiceFile: File | null = null;
  invoicePreview: string | null = null;
  isDragOver2 = false;

  emailSending = false;
  emailSent = false;
  emailError = false;
  whatsappProofLink = '';

  get isArabic(): boolean {
    return this.theme.currentLang() === 'ar';
  }

  ngOnInit() {
    const msg = this.isArabic
      ? `تم تحويل المبلغ \nبرجاء مراجعة العملية`
      : `Payment sent \nPlease review the transaction`;

    this.whatsappLink = `https://wa.me/${this.environment.WhatsappNumber.replace(
      '+',
      '',
    )}?text=${encodeURIComponent(msg)}`;

    const proofMsg = this.isArabic
      ? `مرحباً، أرسل إيصال الدفع المرفق — برجاء تفعيل الخدمة`
      : `Hello, please find my payment receipt attached — kindly activate my service`;

    this.whatsappProofLink = `https://wa.me/${this.environment.WhatsappNumber.replace(
      '+',
      '',
    )}?text=${encodeURIComponent(proofMsg)}`;
  }

  ngAfterViewInit() {
    // Give the DOM a moment to render then trigger reveal check
    setTimeout(() => this.checkReveal(), 100);
  }

  @HostListener('window:scroll')
  onScroll() {
    this.checkReveal();
  }

  private checkReveal() {
    document.querySelectorAll('.reveal').forEach((el) => {
      const rect = el.getBoundingClientRect();
      if (rect.top < window.innerHeight * 0.92) {
        el.classList.add('visible');
      }
    });
  }

  // ── Transfer Proof Upload (image 1) ──────────────────────────

  onProofSelected(event: Event) {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files[0]) {
      this.loadProofFile(input.files[0]);
    }
  }

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
    if (file && file.type.startsWith('image/')) {
      this.loadProofFile(file);
    }
  }

  private loadProofFile(file: File) {
    if (file.size > 10 * 1024 * 1024) return;
    this.proofFile = file;
    this.emailSent = false;
    this.emailError = false;
    const reader = new FileReader();
    reader.onload = (e) => {
      this.proofPreview = e.target?.result as string;
      this.cdr.detectChanges();
    };
    reader.readAsDataURL(file);
  }

  removeProof(event: Event) {
    event.stopPropagation();
    this.proofFile = null;
    this.proofPreview = null;
    this.emailSent = false;
    this.emailError = false;
    this.cdr.detectChanges();
  }

  // ── Invoice Upload (image 2) ──────────────────────────────────

  onInvoiceSelected(event: Event) {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files[0]) {
      this.loadInvoiceFile(input.files[0]);
    }
  }

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
    if (file && file.type.startsWith('image/')) {
      this.loadInvoiceFile(file);
    }
  }

  private loadInvoiceFile(file: File) {
    if (file.size > 10 * 1024 * 1024) return;
    this.invoiceFile = file;
    this.emailSent = false;
    this.emailError = false;
    const reader = new FileReader();
    reader.onload = (e) => {
      this.invoicePreview = e.target?.result as string;
      this.cdr.detectChanges();
    };
    reader.readAsDataURL(file);
  }

  removeInvoice(event: Event) {
    event.stopPropagation();
    this.invoiceFile = null;
    this.invoicePreview = null;
    this.emailSent = false;
    this.emailError = false;
    this.cdr.detectChanges();
  }

  async sendProofByEmail() {
    if (!this.proofFile || !this.invoiceFile || this.emailSending) return;

    this.emailSending = true;
    this.emailError = false;
    this.cdr.detectChanges();

    try {
      const base64Transfer = await this.fileToBase64(this.proofFile);
      const base64Invoice  = await this.fileToBase64(this.invoiceFile);

      const subject = this.isArabic ? 'إثبات تحويل + فاتورة جديدة' : 'New Transfer Proof & Invoice';
      const body = this.isArabic
        ? 'مرحباً، أرفق صورة التحويل وصورة الفاتورة — برجاء تفعيل الخدمة'
        : 'Hello, please find the transfer screenshot and invoice attached. Kindly activate the service.';

      const apiUrl = (this.environment as any).receiptApiUrl as string;

      if (!apiUrl) {
        throw new Error('receiptApiUrl not configured');
      }

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

  onWhatsappProofClick() {
    if (navigator.vibrate) navigator.vibrate(40);
  }

  private fileToBase64(file: File): Promise<string> {
    return new Promise((resolve, reject) => {
      const reader = new FileReader();
      reader.onload = () => resolve(reader.result as string);
      reader.onerror = reject;
      reader.readAsDataURL(file);
    });
  }

  async copy(text: string, key: string) {
    try {
      await navigator.clipboard.writeText(text);
    } catch {
      const textarea = document.createElement('textarea');
      textarea.value = text;
      document.body.appendChild(textarea);
      textarea.select();
      document.execCommand('copy');
      document.body.removeChild(textarea);
    }

    this.copySuccess = key;
    if (navigator.vibrate) navigator.vibrate(40);
    this.cdr.detectChanges();

    setTimeout(() => {
      this.copySuccess = null;
      this.cdr.detectChanges();
    }, 1500);
  }
}
