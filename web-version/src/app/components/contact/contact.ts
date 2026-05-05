import {
  Component,
  inject,
  AfterViewInit,
  HostListener,
  ChangeDetectorRef,
  OnInit,
} from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, RouterModule } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { TranslateModule } from '@ngx-translate/core';
import { Theme } from '../../core/theme';
import { RateLimit } from '../../core/rate-limit';
import { environment } from '../../../environments/environment';

const CONTACT_KEY = 'contact_last_submit';
const COOLDOWN_MS = 300_000;
const FORM_DRAFT_KEY = 'contact_form_draft';

export interface Country {
  value: string;
  labelAr: string;
  labelEn: string;
  flag: string;
}

@Component({
  selector: 'app-contact',
  standalone: true,
  imports: [CommonModule, RouterModule, FormsModule, TranslateModule],
  templateUrl: './contact.html',
  styleUrl: './contact.scss',
})
export class Contact implements AfterViewInit, OnInit {
  private themeService = inject(Theme);
  private cdr = inject(ChangeDetectorRef);
  private route = inject(ActivatedRoute);
  private rateLimit = inject(RateLimit);
  selectedPackage: string | null = null;
  selectedPrice: string | null = null;
  /** لو المستخدم جه من صفحة الخدمات واختار باقة، بنخفي select الخدمة */
  selectedPackageService: string | null = null;
  /** المنصات المحددة تلقائياً من الباقة */
  selectedPackagePlatforms: string[] = [];

  get isArabic(): boolean {
    return this.themeService.currentLang() === 'ar';
  }

  get isDayMode(): boolean {
    return !this.themeService.isDarkMode();
  }

  formData = {
    name: '',
    email: '',
    phone: '',
    whatsapp: '',
    service: '',
    targetCountries: [] as string[],
    platforms: [] as string[],
    hasVisualIdentity: '',
    hasDigitalMarketing: '',
    hasPaidAds: '',
    companyName: '',
    hasProductPhoto: '',
    hasWebsite: '',
    message: '',
  };

  arabCountries: Country[] = [
    { value: 'sa', labelAr: 'السعودية', labelEn: 'Saudi Arabia', flag: '🇸🇦' },
    { value: 'ae', labelAr: 'الإمارات', labelEn: 'UAE', flag: '🇦🇪' },
    { value: 'kw', labelAr: 'الكويت', labelEn: 'Kuwait', flag: '🇰🇼' },
    { value: 'qa', labelAr: 'قطر', labelEn: 'Qatar', flag: '🇶🇦' },
    { value: 'bh', labelAr: 'البحرين', labelEn: 'Bahrain', flag: '🇧🇭' },
    { value: 'om', labelAr: 'عُمان', labelEn: 'Oman', flag: '🇴🇲' },
    { value: 'eg', labelAr: 'مصر', labelEn: 'Egypt', flag: '🇪🇬' },
    { value: 'jo', labelAr: 'الأردن', labelEn: 'Jordan', flag: '🇯🇴' },
    { value: 'lb', labelAr: 'لبنان', labelEn: 'Lebanon', flag: '🇱🇧' },
    { value: 'sy', labelAr: 'سوريا', labelEn: 'Syria', flag: '🇸🇾' },
    { value: 'iq', labelAr: 'العراق', labelEn: 'Iraq', flag: '🇮🇶' },
    { value: 'ps', labelAr: 'فلسطين', labelEn: 'Palestine', flag: '🇵🇸' },
    { value: 'ly', labelAr: 'ليبيا', labelEn: 'Libya', flag: '🇱🇾' },
    { value: 'tn', labelAr: 'تونس', labelEn: 'Tunisia', flag: '🇹🇳' },
    { value: 'dz', labelAr: 'الجزائر', labelEn: 'Algeria', flag: '🇩🇿' },
    { value: 'ma', labelAr: 'المغرب', labelEn: 'Morocco', flag: '🇲🇦' },
    { value: 'sd', labelAr: 'السودان', labelEn: 'Sudan', flag: '🇸🇩' },
    { value: 'ye', labelAr: 'اليمن', labelEn: 'Yemen', flag: '🇾🇪' },
    { value: 'so', labelAr: 'الصومال', labelEn: 'Somalia', flag: '🇸🇴' },
    { value: 'mr', labelAr: 'موريتانيا', labelEn: 'Mauritania', flag: '🇲🇷' },
    { value: 'km', labelAr: 'جزر القمر', labelEn: 'Comoros', flag: '🇰🇲' },
    { value: 'dj', labelAr: 'جيبوتي', labelEn: 'Djibouti', flag: '🇩🇯' },
  ];

  // ─── Service Options ──────────────────────────────────────────────────────
  serviceOptions: { value: string; labelAr: string; labelEn: string; icon: string }[] = [
    {
      value: 'design',
      labelAr: 'تصميمات احترافية',
      labelEn: 'Professional Design',
      icon: 'fa-paint-brush',
    },
    {
      value: 'social',
      labelAr: 'إدارة السوشيال ميديا',
      labelEn: 'Social Media Management',
      icon: 'fa-share-alt',
    },
    { value: 'ads', labelAr: 'الإعلانات الممولة', labelEn: 'Paid Ads', icon: 'fa-bullhorn' },
    {
      value: 'web',
      labelAr: 'تصميم وتطوير المواقع',
      labelEn: 'Web Design & Development',
      icon: 'fa-laptop-code',
    },
    {
      value: 'boost',
      labelAr: 'تزويد منصات السوشيال ميديا',
      labelEn: 'Social Media Boost',
      icon: 'fa-rocket',
    },
    {
      value: 'video',
      labelAr: 'إنشاء وتعديل الفيديوهات',
      labelEn: 'Video Creation & Editing',
      icon: 'fa-video',
    },
    {
      value: 'seo',
      labelAr: 'تحسين محركات البحث SEO',
      labelEn: 'SEO Optimization',
      icon: 'fa-search',
    },
    {
      value: 'moderator',
      labelAr: 'خدمة Moderator',
      labelEn: 'Moderator Service',
      icon: 'fa-headset',
    },
    {
      value: 'brand_plan',
      labelAr: 'خطة براند مخصصة',
      labelEn: 'Custom Brand Plan',
      icon: 'fa-star',
    },
  ];

  serviceDropdownOpen = false;

  toggleServiceDropdown() {
    this.serviceDropdownOpen = !this.serviceDropdownOpen;
  }

  selectService(value: string) {
    this.formData.service = value;
    this.serviceDropdownOpen = false;
    this.serviceError = '';
    this.saveDraft();
  }

  getSelectedServiceLabelAr(): string {
    return this.serviceOptions.find((s) => s.value === this.formData.service)?.labelAr || '';
  }

  getSelectedServiceLabelEn(): string {
    return this.serviceOptions.find((s) => s.value === this.formData.service)?.labelEn || '';
  }

  getSelectedServiceIcon(): string {
    return (
      this.serviceOptions.find((s) => s.value === this.formData.service)?.icon || 'fa-briefcase'
    );
  }

  countryDropdownOpen = false;
  countrySearchQuery = '';

  get filteredCountries(): Country[] {
    const q = this.countrySearchQuery.trim().toLowerCase();
    if (!q) return this.arabCountries;
    return this.arabCountries.filter(
      (c) =>
        c.labelAr.includes(this.countrySearchQuery.trim()) || c.labelEn.toLowerCase().includes(q),
    );
  }

  get selectedCountryObjects(): Country[] {
    return this.arabCountries.filter((c) => this.formData.targetCountries.includes(c.value));
  }

  toggleCountryDropdown() {
    this.countryDropdownOpen = !this.countryDropdownOpen;
    if (this.countryDropdownOpen) this.countrySearchQuery = '';
  }

  isCountrySelected(value: string): boolean {
    return this.formData.targetCountries.includes(value);
  }

  toggleCountry(value: string) {
    const idx = this.formData.targetCountries.indexOf(value);
    if (idx > -1) {
      this.formData.targetCountries.splice(idx, 1);
    } else {
      this.formData.targetCountries.push(value);
      this.countriesError = '';
    }
    this.saveDraft();
  }

  removeCountry(value: string) {
    this.formData.targetCountries = this.formData.targetCountries.filter((c) => c !== value);
    this.saveDraft();
  }

  platformOptions: {
    value: string;
    labelAr: string;
    labelEn: string;
    icon: string;
    color: string;
    darkText?: boolean;
  }[] = [
    {
      value: 'facebook',
      labelAr: 'فيسبوك',
      labelEn: 'Facebook',
      icon: 'fa-facebook-f',
      color: '#1877f2',
    },
    {
      value: 'instagram',
      labelAr: 'إنستجرام',
      labelEn: 'Instagram',
      icon: 'fa-instagram',
      color: '#e1306c',
    },
    { value: 'google', labelAr: 'جوجل', labelEn: 'Google', icon: 'fa-google', color: '#ea4335' },
    { value: 'tiktok', labelAr: 'تيك توك', labelEn: 'TikTok', icon: 'fa-tiktok', color: '#000000' },
    {
      value: 'youtube',
      labelAr: 'يوتيوب',
      labelEn: 'YouTube',
      icon: 'fa-youtube',
      color: '#ff0000',
    },
    {
      value: 'telegram',
      labelAr: 'تيليجرام',
      labelEn: 'Telegram',
      icon: 'fa-telegram',
      color: '#2ca5e0',
    },
    {
      value: 'snapchat',
      labelAr: 'سناب شات',
      labelEn: 'Snapchat',
      icon: 'fa-snapchat-ghost',
      color: '#FFFC00',
      darkText: true,
    },
  ];

  /** Called from template on any field change to persist draft */
  onFieldChange() {
    this.saveDraft();
  }

  /** إزالة الباقة المختارة — الاختيار اختياري */
  clearPackage() {
    this.selectedPackage = null;
    this.selectedPrice = null;
    this.selectedPackageService = null;
    this.selectedPackagePlatforms = [];
    // امسح الخدمة والمنصات اللي اتحددت تلقائياً من الباقة بس لو كانوا فاضيين قبلها
    if (!this.formData.service) {
      this.formData.service = '';
    }
    this.saveDraft();
  }

  /** Toggle qual answer — click same value again to deselect */
  toggleQual(
    field:
      | 'hasVisualIdentity'
      | 'hasDigitalMarketing'
      | 'hasPaidAds'
      | 'hasProductPhoto'
      | 'hasWebsite',
    value: string,
  ) {
    if (this.formData[field] === value) {
      this.formData[field] = '';
    } else {
      this.formData[field] = value;
      delete this.qualErrors[field];
    }
    this.saveDraft();
  }

  togglePlatform(platform: string) {
    const idx = this.formData.platforms.indexOf(platform);
    if (idx > -1) {
      this.formData.platforms.splice(idx, 1);
    } else {
      this.formData.platforms.push(platform);
      this.platformsError = '';
    }
    this.saveDraft();
  }

  isPlatformSelected(platform: string): boolean {
    return this.formData.platforms.includes(platform);
  }

  formFocused = false;
  isSubmitting = false;
  successMessage = false;
  validationError = false;
  submitError = false;
  cooldown = false;
  cooldownTime = 0;

  nameError = '';
  emailError = '';
  emailDomainBlocked = false;
  phoneError = '';
  whatsappError = '';
  serviceError = '';
  messageError = '';
  countriesError = '';
  platformsError = '';
  qualErrors: { [key: string]: string } = {};

  private cooldownInterval: any;
  environment = environment;

  private isValidPhone(value: string): boolean {
    const cleaned = value.replace(/[\s\-().]/g, '');
    const egyptLocal = /^0(10|11|12|15)\d{8}$/.test(cleaned);
    const egyptIntl = /^(\+2|002)(010|011|012|015)\d{8}$/.test(cleaned);
    const intl = /^\+\d{7,15}$/.test(cleaned);
    const localGeneric = /^0\d{6,14}$/.test(cleaned);
    return egyptLocal || egyptIntl || intl || localGeneric;
  }

  private isValidEmail(value: string): boolean {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value.trim());
  }

  // ── Email Domain Whitelist ────────────────────────────────────────────────
  private readonly ALLOWED_EMAIL_DOMAINS = [
    'gmail.com',
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
    'proton.me',
    'protonmail.com',
    'pm.me',
    'zoho.com',
    'zohomail.com',
    'icloud.com',
    'me.com',
    'mac.com',
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
    // ── Guerrilla Mail family ──
    'guerrillamail.com',
    'guerrillamail.info',
    'guerrillamail.biz',
    'guerrillamail.de',
    'guerrillamail.net',
    'guerrillamail.org',
    'guerrillamailblock.com',
    'grr.la',
    'sharklasers.com',
    'spam4.me',
    'throwam.com',

    // ── Mailinator family ──
    'mailinator.com',
    'mailinator2.com',
    'mailinator.net',
    'suremail.info',
    'chammy.info',
    'tradermail.info',
    'spamherelots.com',
    'spamhereplease.com',

    // ── YOPmail family ──
    'yopmail.com',
    'yopmail.fr',
    'cool.fr.nf',
    'jetable.fr.nf',
    'nospam.ze.tc',
    'nomail.xl.cx',
    'mega.zik.dj',
    'speed.1s.fr',
    'courriel.fr.nf',
    'moncourrier.fr.nf',
    'monemail.fr.nf',
    'monmail.fr.nf',

    // ── Temp-mail / 10 Minute Mail family ──
    'tempmail.com',
    'tempmail.net',
    'tempmail.org',
    'tempmail.de',
    'temp-mail.org',
    'temp-mail.ru',
    'temp-mail.io',
    'tempr.email',
    'discard.email',
    'discardmail.com',
    'discardmail.de',
    '10minutemail.com',
    '10minutemail.net',
    '10minutemail.org',
    '10minutemail.de',
    '10minutemail.co.uk',
    '10minutemail.ru',
    '10minutemail.cf',
    '10minutemail.ga',
    '10minutemail.gq',
    '10minutemail.ml',
    '10minutemail.tk',
    '10minemail.com',
    'minuteemails.com',
    'email10minutemail.com',

    // ── Trash Mail family ──
    'trashmail.com',
    'trashmail.me',
    'trashmail.net',
    'trashmail.org',
    'trashmail.at',
    'trashmail.io',
    'trashmail.xyz',
    'trashemail.de',
    'trashdevil.com',
    'trashdevil.de',

    // ── Fake / Disposable misc ──
    'fakeinbox.com',
    'fakeinbox.net',
    'fakemail.fr',
    'mailnull.com',
    'maildrop.cc',
    'dispostable.com',
    'spamgourmet.com',
    'spamgourmet.net',
    'spamgourmet.org',
    'spamfree24.org',
    'spamfree24.de',
    'spamfree24.eu',
    'spamfree24.info',
    'spamfree24.net',
    'spamoff.de',
    'spamspot.com',
    'spamthis.co.uk',
    'spamtroll.net',
    'speed.1s.fr',

    // ── Jetable / Yep ──
    'jetable.com',
    'jetable.fr',
    'jetable.net',
    'jetable.org',
    'nospamfor.us',
    'nospamthanks.info',
    'spamevader.net',

    // ── Throwaway / One-time ──
    'throwam.com',
    'throwaway.email',
    'throwam.com',
    'getonemail.com',
    'getonemail.net',
    'owlpic.com',
    'trbvm.com',
    'emlpro.com',
    'emltmp.com',
    'emlhub.com',

    // ── Mailnesia / Nada ──
    'mailnesia.com',
    'mailna.me',
    'mailna.co',
    'nada.email',
    'nada.ltd',

    // ── GuerrillaMail alternative domains ──
    'einrot.com',
    'jourrapide.com',
    'armyspy.com',
    'cuvox.de',
    'dayrep.com',
    'fleckens.hu',
    'gustr.com',
    'rhyta.com',
    'superrito.com',
    'teleworm.us',
    'tmail.io',

    // ── Mailizor / Mailtothis ──
    'mailizor.com',
    'mailtothis.com',
    'mailismagic.com',
    'mailfreeonline.com',
    'mailforspam.com',
    'mailfree.ga',

    // ── Disposable domains with known fake TLDs ──
    'spamgob.com',
    'spaml.de',
    'spaml.com',
    'spamoff.de',
    'incognitomail.com',
    'incognitomail.net',
    'incognitomail.org',
    'mailblocks.com',
    'mailbolt.com',
    'mailc.net',
    'mailchop.com',
    'mailde.org',
    'maileimer.de',
    'mailexpire.com',
    'mailfall.com',
    'mailfs.com',
    'mailguard.me',
    'mailhazard.com',
    'mailhz.me',
    'mailin8r.com',
    'mailinblack.com',
    'mailismagic.com',
    'mailme.lv',
    'mailme.gq',
    'mailmetrash.com',
    'mailmoat.com',
    'mailnew.com',
    'mailninja.co.uk',
    'mailnull.com',
    'mailorg.org',
    'mailpick.biz',
    'mailrock.biz',
    'mailsac.com',
    'mailscrap.com',
    'mailshell.com',
    'mailsiphon.com',
    'mailslapping.com',
    'mailslite.com',
    'mailsnd.com',
    'mailspam.me',
    'mailspam.xyz',
    'mailspeed.de',
    'mailspread.com',
    'mailstart.com',
    'mailsucker.net',
    'mailtemp.info',
    'mailtome.de',
    'mailtothis.com',
    'mailtrash.net',
    'mailtv.net',
    'mailtv.tv',
    'mailwire.com',
    'mailworks.org',

    // ── Burner / Spamgourmet-style ──
    'burnthespam.info',
    'bumpymail.com',
    'byom.de',
    'cool.fr.nf',
    'cyberscooty.com',
    'deagot.com',

    // ── GreenSloth and similar ──
    'greensloth.com',
    'gowikicampus.com',
    'gowikicars.com',
    'gowikifilms.com',
    'gowikigames.com',
    'gowikimusic.com',
    'gowikinetwork.com',
    'gowikitravel.com',
    'gowikitv.com',

    // ── Misc known disposable ──
    'kasmail.com',
    'kaspop.com',
    'keepmymail.com',
    'killmail.com',
    'killmail.net',
    'klzlk.com',
    'kook.ml',
    'kurzepost.de',
    'letthemeatspam.com',
    'lhsdv.com',
    'lifebyfood.com',
    'lol.ovpn.to',
    'lookugly.com',
    'lortemail.dk',
    'lroid.com',
    'lukop.dk',
    'luukku.com',

    // ── More temp mail ──
    'tempinbox.com',
    'tempinbox.co.uk',
    'tempe.email',
    'tempemailaddress.com',
    'tempsky.com',
    'tempsky.com',
    'dispomail.eu',
    'dispomail.com',

    // ── Spoofed TLDs that are commonly fake ──
    'mailinator.us',
    'fakeemail.de',
    'fakeemails.com',

    // ── Anonymousemail / cloaked ──
    'anonymousemail.me',
    'anonymbox.com',

    // ── Spamgourmet ──
    'spamgourmet.com',
    'spamgourmet.net',
    'spamgourmet.org',

    // ── Nope ──
    'nope.com',
    'nomail.nodns.xyz',

    // ── Hide my email style ──
    'dispostable.com',
    'e4ward.com',
    'e-mailanywhere.com',
    'myspamless.com',
    'nobulk.com',
    'nus.edu.sg',

    // ── German / EU disposable ──
    'müllmail.de',
    'muelmail.de',
    'muellemail.de',

    // ── Random known disposable ──
    'objectmail.com',
    'odaymail.com',
    'odnorazovaya.ru',
    'ohaaa.de',
    'olypmail.com',
    'onewaymail.com',
    'onlatedotcom.info',
    'online.ms',
    'oopi.org',
    'opayq.com',
    'ordinaryamerican.net',
    'otherinbox.coiaccount.com',
    'ourklips.com',
    'ourpreviewdomain.com',
    'ovpn.to',
    'owlpic.com',
    'emailax.pro'
  ];

  // TLDs heavily abused by disposable / throwaway services
  private readonly SUSPICIOUS_TLDS = new Set([
    'cf',
    'ga',
    'gq',
    'ml',
    'tk', // Freenom free TLDs — almost exclusively spam
  ]);

  // Known keywords in SLDs that signal a temp/disposable mail service
  private readonly DISPOSABLE_SLD_KEYWORDS = [
    'spam',
    'trash',
    'temp',
    'fake',
    'junk',
    'disposable',
    'throwaway',
    'mailinator',
    'guerrilla',
    'yopmail',
    'tempmail',
    'discard',
    'nospam',
    'antispam',
    'spamfree',
    'spamoff',
    'burner',
  ];

  private isAllowedEmailDomain(email: string): boolean {
    const lower = email.toLowerCase().trim();
    const atIdx = lower.lastIndexOf('@');
    if (atIdx < 1) return false;
    const domain = lower.slice(atIdx + 1);

    // 1. Explicit blocklist — fastest check
    if (this.BLOCKED_EMAIL_DOMAINS.includes(domain)) return false;

    // 2. Explicit allowlist (well-known providers)
    if (this.ALLOWED_EMAIL_DOMAINS.includes(domain)) return true;

    // 3. Validate domain structure
    const domainParts = domain.split('.');
    if (domainParts.length < 2) return false;
    const sld = domainParts[domainParts.length - 2];
    const tld = domainParts[domainParts.length - 1];
    if (!sld || sld.length < 2 || !tld || tld.length < 2) return false;

    // 4. Block Freenom / spam-magnet free TLDs
    if (this.SUSPICIOUS_TLDS.has(tld)) return false;

    // 5. Block if SLD contains disposable-service keywords
    const sldLower = sld.toLowerCase();
    if (this.DISPOSABLE_SLD_KEYWORDS.some((kw) => sldLower.includes(kw))) return false;

    // 6. Accept as corporate / business email
    return true;
  }

  validateName() {
    if (!this.formData.name.trim()) {
      this.nameError = this.isArabic ? 'الاسم مطلوب' : 'Name is required';
    } else if (this.formData.name.trim().length < 2) {
      this.nameError = this.isArabic ? 'الاسم قصير جداً' : 'Name is too short';
    } else {
      this.nameError = '';
    }
  }

  validateEmail() {
    this.emailDomainBlocked = false;
    if (!this.formData.email.trim()) {
      this.emailError = this.isArabic ? 'البريد الإلكتروني مطلوب' : 'Email is required';
    } else if (!this.isValidEmail(this.formData.email)) {
      this.emailError = this.isArabic ? 'صيغة البريد غير صحيحة' : 'Invalid email format';
    } else if (!this.isAllowedEmailDomain(this.formData.email)) {
      this.emailDomainBlocked = true;
      this.emailError = this.isArabic
        ? 'يُسمح فقط بـ Gmail أو Outlook أو Yahoo أو Proton أو Zoho أو بريد الشركات'
        : 'Only Gmail, Outlook, Yahoo, Proton, Zoho, or business emails are allowed';
    } else {
      this.emailError = '';
    }
  }

  validatePhone() {
    if (!this.formData.phone) {
      this.phoneError = this.isArabic ? 'رقم الهاتف مطلوب' : 'Phone number is required';
      return;
    }
    if (!this.isValidPhone(this.formData.phone)) {
      this.phoneError = this.isArabic
        ? 'رقم الهاتف غير صحيح — مثال: 01012345678'
        : 'Invalid phone — e.g. 01012345678 or +20101234567';
    } else {
      this.phoneError = '';
    }
  }

  validateWhatsapp() {
    if (!this.formData.whatsapp) {
      this.whatsappError = this.isArabic ? 'رقم واتساب مطلوب' : 'WhatsApp number is required';
      return;
    }
    if (!this.isValidPhone(this.formData.whatsapp)) {
      this.whatsappError = this.isArabic
        ? 'رقم واتساب غير صحيح — مثال: 01012345678'
        : 'Invalid WhatsApp — e.g. 01012345678 or +20101234567';
    } else {
      this.whatsappError = '';
    }
  }

  validateService() {
    if (!this.formData.service) {
      this.serviceError = this.isArabic ? 'يرجى اختيار الخدمة المطلوبة' : 'Please select a service';
    } else {
      this.serviceError = '';
    }
  }

  validateMessage() {
    if (!this.formData.message.trim()) {
      this.messageError = this.isArabic ? 'الرسالة مطلوبة' : 'Message is required';
    } else if (this.formData.message.trim().length < 10) {
      this.messageError = this.isArabic
        ? 'الرسالة قصيرة جداً — أخبرنا أكثر'
        : 'Message is too short — tell us more';
    } else {
      this.messageError = '';
    }
  }

  validateQuals() {
    const quals = [
      { key: 'hasVisualIdentity', val: this.formData.hasVisualIdentity },
      { key: 'hasDigitalMarketing', val: this.formData.hasDigitalMarketing },
      { key: 'hasPaidAds', val: this.formData.hasPaidAds },
      { key: 'hasProductPhoto', val: this.formData.hasProductPhoto },
      { key: 'hasWebsite', val: this.formData.hasWebsite },
    ];
    quals.forEach(({ key, val }) => {
      if (!val) {
        this.qualErrors[key] = this.isArabic ? 'يرجى الإجابة' : 'Please answer';
      } else {
        delete this.qualErrors[key];
      }
    });
  }

  validateCountries() {
    if (this.formData.targetCountries.length === 0) {
      this.countriesError = this.isArabic
        ? 'يرجى اختيار دولة واحدة على الأقل'
        : 'Please select at least one country';
    } else {
      this.countriesError = '';
    }
  }

  validatePlatforms() {
    if (this.formData.platforms.length === 0) {
      this.platformsError = this.isArabic
        ? 'يرجى اختيار منصة واحدة على الأقل'
        : 'Please select at least one platform';
    } else {
      this.platformsError = '';
    }
  }

  isFormValid(): boolean {
    return (
      !this.nameError &&
      !this.emailError &&
      !this.phoneError &&
      !this.whatsappError &&
      !this.serviceError &&
      !this.messageError &&
      Object.keys(this.qualErrors).length === 0 &&
      !!this.formData.name.trim() &&
      !!this.formData.email.trim() &&
      !!this.formData.phone &&
      !!this.formData.whatsapp &&
      !!this.formData.service &&
      !!this.formData.message.trim() &&
      !!this.formData.hasVisualIdentity &&
      !!this.formData.hasDigitalMarketing &&
      !!this.formData.hasPaidAds &&
      !!this.formData.hasWebsite &&
      !!this.formData.hasProductPhoto &&
      this.formData.targetCountries.length > 0 &&
      this.formData.platforms.length > 0
    );
  }

  startCooldown(ms: number) {
    this.cooldown = true;
    this.cooldownTime = Math.ceil(ms / 1000);
    clearInterval(this.cooldownInterval);
    this.cooldownInterval = setInterval(() => {
      this.cooldownTime--;
      if (this.cooldownTime <= 0) {
        this.cooldown = false;
        clearInterval(this.cooldownInterval);
      }
      this.cdr.detectChanges();
    }, 1000);
  }

  async ngOnInit() {
    this.route.queryParams.subscribe((params) => {
      // ✅ Step 1: Load saved draft first (restores form fields)
      this.loadDraft();

      // ✅ Step 2: Check if coming from packages page via sessionStorage
      try {
        const savedPkg = sessionStorage.getItem('selected_package');
        if (savedPkg) {
          const parsed = JSON.parse(savedPkg);
          // Override package info from incoming selection (takes priority over draft)
          this.selectedPackage = parsed.package || null;
          this.selectedPrice = parsed.price || null;

          // ✅ لو في خدمة مرتبطة بالباقة — اختارها تلقائياً واخفي الـ select
          if (parsed.service) {
            this.selectedPackageService = parsed.service;
            this.formData.service = parsed.service;
          }
          // ✅ لو في منصات مرتبطة بالباقة — حددها تلقائياً واخفي الـ checkboxes
          if (parsed.platforms?.length > 0) {
            this.selectedPackagePlatforms = parsed.platforms;
            this.formData.platforms = [...parsed.platforms];
          }
          // ✅ امسح selected_package ثم احفظ الـ draft المحدث
          sessionStorage.removeItem('selected_package');
          this.saveDraft();
        } else if (!this.selectedPackage) {
          // فقط لو مفيش باقة محفوظة في الـ draft، نقرأ من query params
          this.selectedPackage = params['package'] || null;
          this.selectedPrice = params['price'] || null;
        }
      } catch {
        if (!this.selectedPackage) {
          this.selectedPackage = params['package'] || null;
          this.selectedPrice = params['price'] || null;
        }
      }

      // ✅ لو جاي من صفحة الخدمات بـ query param — اختار الخدمة تلقائياً
      if (params['service'] && !this.formData.service) {
        this.selectService(params['service']);
      }

      this.cdr.detectChanges();
    });

    const remaining = await this.rateLimit.getRemainingCooldown(CONTACT_KEY, COOLDOWN_MS);
    if (remaining > 0) {
      this.startCooldown(remaining);
      this.cdr.detectChanges();
    }
  }

  /** Save current form state to sessionStorage */
  saveDraft() {
    try {
      sessionStorage.setItem(
        FORM_DRAFT_KEY,
        JSON.stringify({
          formData: this.formData,
          selectedPackage: this.selectedPackage,
          selectedPrice: this.selectedPrice,
          selectedPackageService: this.selectedPackageService,
          selectedPackagePlatforms: this.selectedPackagePlatforms,
        }),
      );
    } catch {}
  }

  /** Load saved draft from sessionStorage */
  loadDraft() {
    try {
      const raw = sessionStorage.getItem(FORM_DRAFT_KEY);
      if (raw) {
        const saved = JSON.parse(raw);

        // ── بيانات الفورم ──
        const formData = saved.formData ?? saved; // fallback للصيغة القديمة
        this.formData = { ...this.formData, ...formData };

        // ── بيانات الباقة ──
        if (saved.selectedPackage) {
          this.selectedPackage = saved.selectedPackage;
          this.selectedPrice = saved.selectedPrice || null;
        }
        if (saved.selectedPackageService) {
          this.selectedPackageService = saved.selectedPackageService;
          // تأكد إن الخدمة محددة في formData بدون استدعاء saveDraft
          if (!this.formData.service) {
            this.formData.service = saved.selectedPackageService;
          }
        }
        if (saved.selectedPackagePlatforms?.length > 0) {
          this.selectedPackagePlatforms = saved.selectedPackagePlatforms;
          if (this.formData.platforms.length === 0) {
            this.formData.platforms = [...saved.selectedPackagePlatforms];
          }
        }

        this.cdr.detectChanges();
      }
    } catch {}
  }

  /** Clear draft after successful submit */
  clearDraft() {
    try {
      sessionStorage.removeItem(FORM_DRAFT_KEY);
      sessionStorage.removeItem('selected_package');
    } catch {}
  }

  async submitForm(event: Event) {
    event.preventDefault();

    this.validateName();
    this.validateEmail();
    this.validatePhone();
    this.validateWhatsapp();
    this.validateService();
    this.validateMessage();
    this.validateQuals();
    this.validateCountries();
    this.validatePlatforms();

    if (!this.isFormValid()) {
      this.validationError = true;
      setTimeout(() => {
        this.validationError = false;
        this.cdr.detectChanges();
      }, 3000);
      return;
    }

    this.isSubmitting = true;
    this.successMessage = false;

    const finalData = {
      ...this.formData,
      platforms: this.formData.platforms.join(', '),
      targetCountries: this.formData.targetCountries
        .map((v) => {
          const c = this.arabCountries.find((x) => x.value === v);
          return c ? (this.isArabic ? c.labelAr : c.labelEn) : v;
        })
        .join(', '),
      access_key: 'ebfc072d-a69e-4ff5-bd13-03418fda2c53',
      package: this.selectedPackage || '',
      price: this.selectedPrice || '',
    };

    // ✅ احفظ الإيميل قبل ما formData يتمسح
    const submittedEmail = this.formData.email.trim();

    try {
      const response = await fetch(`${environment.formsubmitUrl}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
        body: JSON.stringify(finalData),
      });

      if (!response.ok) throw new Error('API Error');

      // ✅ اشترك في النشرة بصمت بعد نجاح الفورم
      this.subscribeEmailSilently(submittedEmail);

      this.successMessage = true;
      this.formData = {
        name: '',
        email: '',
        phone: '',
        whatsapp: '',
        service: '',
        targetCountries: [],
        platforms: [],
        hasVisualIdentity: '',
        hasDigitalMarketing: '',
        hasPaidAds: '',
        hasWebsite: '',
        companyName: '',
        hasProductPhoto: '',
        message: '',
      };
      this.nameError = '';
      this.emailError = '';
      this.phoneError = '';
      this.whatsappError = '';
      this.serviceError = '';
      this.messageError = '';
      this.countriesError = '';
      this.platformsError = '';
      this.qualErrors = {};
      // ✅ امسح بيانات الباقة من الـ state بعد الـ submit
      this.selectedPackage = null;
      this.selectedPrice = null;
      this.selectedPackageService = null;
      this.selectedPackagePlatforms = [];
      this.clearDraft(); // ✅ Clear saved draft after successful submit

      this.cdr.detectChanges();
      setTimeout(() => {
        this.successMessage = false;
        this.cdr.detectChanges();
      }, 5000);
      await this.rateLimit.recordSubmit(CONTACT_KEY);
      this.startCooldown(COOLDOWN_MS);
    } catch (error) {
      console.error(error);
      this.submitError = true;
      setTimeout(() => {
        this.submitError = false;
        this.cdr.detectChanges();
      }, 10000);
      this.cdr.detectChanges();
    }

    this.isSubmitting = false;
    this.cdr.detectChanges();
  }

  private subscribeEmailSilently(email: string): void {
    if (!email) return;

    fetch(`https://corsproxy.io/?url=https://etba3ly-api.xo.je/subscribe.php`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: `email=${encodeURIComponent(email)}&lang=${this.isArabic ? 'ar' : 'en'}`,
    }).catch(() => {});
  }

  ngAfterViewInit() {
    setTimeout(() => this.checkReveal(), 100);
  }

  @HostListener('window:scroll')
  onScroll() {
    this.checkReveal();
  }

  @HostListener('document:click', ['$event'])
  onDocumentClick(event: MouseEvent) {
    const target = event.target as HTMLElement;
    if (!target.closest('.cpage-country-select') && !target.closest('.cpage-service-select')) {
      this.countryDropdownOpen = false;
      this.serviceDropdownOpen = false;
    }
  }

  private checkReveal() {
    document.querySelectorAll('.reveal').forEach((el) => {
      const rect = el.getBoundingClientRect();
      if (rect.top < window.innerHeight * 0.88) el.classList.add('visible');
    });
  }
}
