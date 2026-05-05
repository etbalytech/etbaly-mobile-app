import { Component, inject, OnInit, OnDestroy, signal } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { Navbar } from './components/navbar/navbar';
import { Footer } from './components/footer/footer';
import { CookieBanner } from './components/cookie-banner/cookie-banner';
import { TranslateService } from '@ngx-translate/core';
import { PageTitleService } from './core/page-title-service';
import { Meta, Title } from '@angular/platform-browser';
import { Theme } from './core/theme';
import { environment } from '../environments/environment';

const SEO: Record<
  'ar' | 'en',
  {
    title: string;
    desc: string;
    keywords: string;
    site: string;
    locale: string;
    lang: string;
  }
> = {
  ar: {
    title: 'اطبعلي | وكالة تصميم وتسويق رقمي متكاملة',
    desc: 'اطبعلي وكالة متخصصة في الهوية البصرية، إدارة السوشيال ميديا، الإعلانات المدفوعة وتصميم المواقع. نحوّل علامتك التجارية إلى تجربة بصرية لا تُنسى.',
    keywords: 'اطبعلي, تصميم, تسويق رقمي, سوشيال ميديا, هوية بصرية, إعلانات, فيسبوك, انستجرام',
    site: 'اطبعلي',
    locale: 'ar_EG',
    lang: 'ar',
  },
  en: {
    title: 'Etbaly | Full-Service Marketing & Design Agency',
    desc: 'Etbaly is a full-service marketing agency specializing in branding, social media management, paid ads, and web design. We turn your brand into an unforgettable visual experience.',
    keywords:
      'Etbaly, marketing agency, branding, social media management, paid ads, Facebook ads, Instagram',
    site: 'Etbaly',
    locale: 'en_US',
    lang: 'en',
  },
};

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, Navbar, Footer, CookieBanner],
  templateUrl: './app.html',
  styleUrl: './app.scss',
})
export class App implements OnInit, OnDestroy {
  protected readonly title = signal('Etbaly');
  currentLang = this._getLangFromUrlOrStorage();

  /** رابط واتساب الثابت المربوط ببيانات الـ environment */
  readonly whatsappLink: string = environment.WhatsappContact || 'https://wa.me/201010285020';

  // ── WhatsApp Bubble ────────────────────────────────────────────────────────
  private readonly waMessages: Record<'ar' | 'en', string[]> = {
    ar: [
      '👋 تواصل معنا الآن!',
      '💬 هل تحتاج مساعدة؟ نحن هنا!',
      '🎯 احصل على عرض مجاني اليوم',
      '✨ نصمم هويتك البصرية باحتراف',
      '🚀 سوشيال ميديا تحويلية لعلامتك',
      '📞 ردنا سريع — تكلم معنا الآن',
    ],
    en: [
      '👋 Contact us now!',
      '💬 Need help? We\'re here!',
      '🎯 Get a free quote today',
      '✨ Professional branding & design',
      '🚀 Elevate your social media',
      '📞 Fast reply — chat with us now',
    ],
  };

  waBubbleVisible = false;
  waCurrentMessage = '';
  private _waMsgIndex = 0;
  private _waBubbleTimer: ReturnType<typeof setInterval> | null = null;
  private _waInitTimer: ReturnType<typeof setTimeout> | null = null;

  private translate = inject(TranslateService);
  private meta = inject(Meta);
  private pageTitle = inject(Title);

  constructor() {
    inject(PageTitleService).init();
    inject(Theme); // ← بيشغّل الـ effect اللي بيحط data-bs-theme على <html> فوراً
  }

  ngOnInit() {
    const lang = this.currentLang;
    this._applyLang(lang);
    this._injectStructuredData(); // Schema.org مرة واحدة عند التحميل
    this._injectHreflang(); // hreflang مرة واحدة عند التحميل
    this.updateSEO(lang);
    this._startWaBubbleCycle();
  }

  ngOnDestroy() {
    if (this._waBubbleTimer) clearInterval(this._waBubbleTimer);
    if (this._waInitTimer) clearTimeout(this._waInitTimer);
  }

  toggleLang() {
    this.currentLang = this.currentLang === 'en' ? 'ar' : 'en';
    localStorage.setItem('lang', this.currentLang);
    this._applyLang(this.currentLang);
    this.updateSEO(this.currentLang);
    // تحديث رسالة الفقاعة فوراً مع اللغة الجديدة
    this._waMsgIndex = 0;
    this._showNextWaMessage();
  }

  // ── WhatsApp Bubble Logic ───────────────────────────────────────────────────

  dismissWaBubble() {
    this.waBubbleVisible = false;
  }

  private _showNextWaMessage() {
    const msgs = this.waMessages[this.currentLang];
    this.waCurrentMessage = msgs[this._waMsgIndex % msgs.length];
    this._waMsgIndex++;
    this.waBubbleVisible = false;
    // إخفاء ثم إظهار لتشغيل الـ animation من جديد
    setTimeout(() => { this.waBubbleVisible = true; }, 80);
  }

  private _startWaBubbleCycle() {
    // أول ظهور بعد 3 ثواني من تحميل الصفحة
    this._waInitTimer = setTimeout(() => {
      this._showNextWaMessage();
      // تكرار كل 30 ثانية
      this._waBubbleTimer = setInterval(() => {
        this._showNextWaMessage();
      }, 100_000);
    }, 5_000);
  }

  // ── Core SEO update (يتكرر مع تغيير اللغة) ────────────────────────────────
  updateSEO(lang: 'ar' | 'en') {
    const s = SEO[lang];
    const url = window.location.href;
    const img = `${window.location.origin}/logo.png`;

    // Title
    this.pageTitle.setTitle(s.title);

    // Basic meta
    this._tag('name', 'description', s.desc);
    this._tag('name', 'keywords', s.keywords);
    this._tag('name', 'author', s.site);
    this._tag('name', 'robots', 'index, follow');
    this._tag('name', 'theme-color', '#0a0a0a');
    this._tag('name', 'apple-mobile-web-app-title', s.site);

    // OpenGraph
    this._tag('property', 'og:type', 'website');
    this._tag('property', 'og:site_name', s.site);
    this._tag('property', 'og:title', s.title);
    this._tag('property', 'og:description', s.desc);
    this._tag('property', 'og:url', url);
    this._tag('property', 'og:locale', s.locale);
    this._tag('property', 'og:locale:alternate', lang === 'ar' ? 'en_US' : 'ar_EG');
    this._tag('property', 'og:image', img);
    this._tag('property', 'og:image:width', '1200');
    this._tag('property', 'og:image:height', '630');
    this._tag('property', 'og:image:alt', s.site);

    // Twitter Card
    this._tag('name', 'twitter:card', 'summary_large_image');
    this._tag('name', 'twitter:title', s.title);
    this._tag('name', 'twitter:description', s.desc);
    this._tag('name', 'twitter:image', img);
    this._tag('name', 'twitter:image:alt', s.site);

    // Canonical
    this._setCanonical(url);

    // Schema.org بيتحدث مع اللغة
    this._updateStructuredData(lang);
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  private _getLangFromUrlOrStorage(): 'ar' | 'en' {
    const urlLang = new URLSearchParams(window.location.search).get('lang');
    if (urlLang === 'ar' || urlLang === 'en') {
      localStorage.setItem('lang', urlLang);
      return urlLang;
    }
    return (localStorage.getItem('lang') || 'ar') as 'ar' | 'en';
  }

  private _applyLang(lang: string) {
    document.documentElement.lang = lang;
    document.documentElement.dir = lang === 'ar' ? 'rtl' : 'ltr';
    this.translate.use(lang);
  }

  /** updateTag موحّد للـ name و property */
  private _tag(attr: 'name' | 'property', key: string, content: string) {
    this.meta.updateTag({ [attr]: key, content });
  }

  /** Canonical — بيضيف أو يحدّث بدون تكرار */
  private _setCanonical(url: string) {
    let link = document.querySelector<HTMLLinkElement>("link[rel='canonical']");
    if (!link) {
      link = document.createElement('link');
      link.setAttribute('rel', 'canonical');
      document.head.appendChild(link);
    }
    link.setAttribute('href', url);
  }

  /**
   * hreflang — بيتكتب مرة واحدة فقط عند التحميل.
   * Google بيستخدمه عشان يعرض النسخة الصح للمستخدم حسب بلده ولغته.
   *
   * المنطق:
   *  x-default  → النسخة الافتراضية (العربية لأن معظم جمهورك عرب)
   *  ar         → نسخة عربية
   *  en         → نسخة إنجليزية
   */
  private _injectHreflang() {
    // امسح القديم لو موجود عشان نتجنب التكرار
    document.querySelectorAll("link[rel='alternate']").forEach((el) => el.remove());

    const origin = window.location.origin;

    const tags: { hreflang: string; href: string }[] = [
      { hreflang: 'x-default', href: `${origin}/` },
      { hreflang: 'ar', href: `${origin}/?lang=ar` },
      { hreflang: 'en', href: `${origin}/?lang=en` },
    ];

    const frag = document.createDocumentFragment();
    tags.forEach(({ hreflang, href }) => {
      const link = document.createElement('link');
      link.setAttribute('rel', 'alternate');
      link.setAttribute('hreflang', hreflang);
      link.setAttribute('href', href);
      frag.appendChild(link);
    });
    document.head.appendChild(frag);
  }

  /**
   * Schema.org JSON-LD — LocalBusiness + WebSite مع SearchAction.
   * ده بيظهر في Google كـ Rich Result (اسم الشركة، وصف، sitelinks searchbox).
   * بيتكتب مرة واحدة في <script id="structured-data">.
   */
  private _injectStructuredData() {
    if (!document.getElementById('structured-data')) {
      const script = document.createElement('script');
      script.id = 'structured-data';
      script.type = 'application/ld+json';
      document.head.appendChild(script);
    }
    // المحتوى بيتحدث مع اللغة عبر _updateStructuredData
  }

  private _updateStructuredData(lang: 'ar' | 'en') {
    const s = SEO[lang];
    const origin = window.location.origin;

    const schemas = [
      {
        '@context': 'https://schema.org',
        '@type': 'Organization',
        name: s.site,
        url: origin,
        logo: `${origin}/logo.png`,
        description: s.desc,
        inLanguage: s.lang,
        sameAs: [
          'https://www.facebook.com/etba3lydigitalmarkerting',
          'https://www.instagram.com/etba3ly2022',
          'https://www.youtube.com/@etba3ly4adv',
          'https://www.tiktok.com/@etba3ly2',
        ],
        contactPoint: {
          '@type': 'ContactPoint',
          contactType: 'customer support',
          availableLanguage: ['Arabic', 'English'],
        },
      },
      {
        '@context': 'https://schema.org',
        '@type': 'WebSite',
        name: s.site,
        url: origin,
        inLanguage: s.lang,
        potentialAction: {
          '@type': 'SearchAction',
          target: `${origin}/?q={search_term_string}`,
          'query-input': 'required name=search_term_string',
        },
      },
    ];

    const script = document.getElementById('structured-data')!;
    script.textContent = JSON.stringify(schemas);
  }
}
