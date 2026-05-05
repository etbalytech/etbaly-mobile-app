import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink, RouterModule } from '@angular/router';
import { TranslateModule } from '@ngx-translate/core';
import { Theme } from '../../core/theme';
import { environment } from '../../../environments/environment';

@Component({
  selector: 'app-footer',
  standalone: true,
  imports: [CommonModule, RouterModule, TranslateModule, RouterLink],
  templateUrl: './footer.html',
  styleUrl: './footer.scss',
})
export class Footer {
  private themeService = inject(Theme);
  environment = environment;
  currentYear = new Date().getFullYear();

  get isArabic(): boolean {
    return this.themeService.currentLang() === 'ar';
  }

  scrollTop() {
    window.scrollTo({
      top: 0,
      behavior: 'smooth',
    });
  }
}
