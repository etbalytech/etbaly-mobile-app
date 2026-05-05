import {
  Component,
  OnInit,
  OnDestroy,
  signal,
  computed,
  Input,
  inject,
  ChangeDetectionStrategy,
} from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { Theme } from '../../core/theme';

const COOKIE_KEY = 'etbaly_cookie_consent';

/** النهار: 6 صباحاً → 6 مساءً  |  غير ده: ليل */
const DAY_START = 6;
const DAY_END = 18;

function getTimeTheme(): 'light' | 'dark' {
  const h = new Date().getHours();
  return h >= DAY_START && h < DAY_END ? 'light' : 'dark';
}

@Component({
  selector: 'app-cookie-banner',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './cookie-banner.html',
  styleUrl: './cookie-banner.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class CookieBanner implements OnInit, OnDestroy {
  @Input() lang: 'ar' | 'en' = 'ar';

  visible = signal(false);
  leaving = signal(false);

  readonly theme = inject(Theme);

  /**
   * theme البانر:
   *  1. لو المستخدم اختار theme يدوياً (localStorage['theme'] موجود) → يتبع الـ App
   *  2. لو مفيش اختيار → يتبع وقت الجهاز
   */
  readonly bannerTheme = computed<'light' | 'dark'>(() => {
    const saved = localStorage.getItem('theme') as 'light' | 'dark' | null;
    if (saved === 'light' || saved === 'dark') {
      // يتبع theme الـ App (isDarkMode signal)
      return this.theme.isDarkMode() ? 'dark' : 'light';
    }
    // fallback: وقت الجهاز
    return getTimeTheme();
  });

  private _themeInterval?: ReturnType<typeof setInterval>;

  get isArabic() {
    return this.lang === 'ar';
  }

  ngOnInit() {
    // نحدّث الـ computed كل ساعة عشان الـ fallback (الوقت) يتغير تلقائياً
    this._themeInterval = setInterval(
      () => {
        // إعادة قراءة localStorage تلقائياً عند تغيير الساعة
        // الـ computed بيتحدث لأنه بيقرأ isDarkMode signal
      },
      60 * 60 * 1000,
    );

    if (!localStorage.getItem(COOKIE_KEY)) {
      setTimeout(() => this.visible.set(true), 2000);
    }
  }

  ngOnDestroy() {
    clearInterval(this._themeInterval);
  }

  accept() {
    this._dismiss('accepted');
  }

  private _dismiss(value: 'accepted') {
    this.leaving.set(true);
    setTimeout(() => {
      localStorage.setItem(COOKIE_KEY, value);
      this.visible.set(false);
      this.leaving.set(false);
    }, 500);
  }
}
