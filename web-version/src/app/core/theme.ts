import { Injectable, signal, effect } from '@angular/core';
import { TranslateService } from '@ngx-translate/core';

@Injectable({
  providedIn: 'root',
})
export class Theme {
  currentLang = signal<string>('ar');
  isDarkMode = signal<boolean>(true);

  constructor(private translate: TranslateService) {
    this.initThemeAndLang();

    effect(() => {
      const lang = this.currentLang();
      const theme = this.isDarkMode() ? 'dark' : 'light';

      document.documentElement.dir = lang === 'ar' ? 'rtl' : 'ltr';
      document.documentElement.lang = lang;
      document.documentElement.setAttribute('data-bs-theme', theme);

      // Update meta theme-color for mobile browsers
      const metaThemeColor = document.querySelector('meta[name="theme-color"]');
      if (metaThemeColor) {
        metaThemeColor.setAttribute('content', theme === 'dark' ? '#070706' : '#f9f8f5');
      }
    });
  }

  private initThemeAndLang() {
    const savedLang = localStorage.getItem('lang');
    const savedTheme = localStorage.getItem('theme');
    if (savedLang) {
      this.currentLang.set(savedLang);
    } else {
      const defaultLang = 'ar';
      this.currentLang.set(defaultLang);
      localStorage.setItem('lang', defaultLang);
    }
    this.translate.setDefaultLang('ar');
    this.translate.use(this.currentLang());
    if (savedTheme) {
      this.isDarkMode.set(savedTheme === 'dark');
    } else {
      
      const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
      const defaultTheme = prefersDark ? 'dark' : 'light';
      this.isDarkMode.set(defaultTheme === 'dark');
      localStorage.setItem('theme', defaultTheme);
    }
  }

  toggleTheme() {
    const newTheme = !this.isDarkMode();
    this.isDarkMode.set(newTheme);
    localStorage.setItem('theme', newTheme ? 'dark' : 'light');
    window.location.reload();
  }

  toggleLanguage() {
    const newLang = this.currentLang() === 'ar' ? 'en' : 'ar';
    this.currentLang.set(newLang);
    this.translate.use(newLang);
    localStorage.setItem('lang', newLang);
    window.location.reload();
  }
}
