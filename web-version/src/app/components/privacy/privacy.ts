import { Component, inject, AfterViewInit, HostListener } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { TranslateModule } from '@ngx-translate/core';
import { Theme } from '../../core/theme';
import { environment } from '../../../environments/environment';

@Component({
  selector: 'app-privacy',
  standalone: true,
  imports: [CommonModule, RouterModule, TranslateModule],
  templateUrl: './privacy.html',
  styleUrl: './privacy.scss',
})
export class Privacy implements AfterViewInit {
  private themeService = inject(Theme);
  environment = environment;

  get isArabic(): boolean {
    return this.themeService.currentLang() === 'ar';
  }

  sections = [
    {
      icon: 'fa-database',
      color: '#D4AF37',
      titleKey: 'PRIVACY.S1_TITLE',
      descKey: 'PRIVACY.S1_DESC',
      type: 'items',
      items: [
        { titleKey: 'PRIVACY.S1_I1_TITLE', descKey: 'PRIVACY.S1_I1_DESC', icon: 'fa-id-card' },
        { titleKey: 'PRIVACY.S1_I2_TITLE', descKey: 'PRIVACY.S1_I2_DESC', icon: 'fa-chart-bar' },
        { titleKey: 'PRIVACY.S1_I3_TITLE', descKey: 'PRIVACY.S1_I3_DESC', icon: 'fa-folder' },
      ],
    },
    {
      icon: 'fa-cogs',
      color: '#63B3ED',
      titleKey: 'PRIVACY.S2_TITLE',
      descKey: 'PRIVACY.S2_DESC',
      type: 'list',
      list: ['PRIVACY.S2_I1', 'PRIVACY.S2_I2', 'PRIVACY.S2_I3', 'PRIVACY.S2_I4', 'PRIVACY.S2_I5'],
    },
    {
      icon: 'fa-share-alt',
      color: '#F6AD55',
      titleKey: 'PRIVACY.S3_TITLE',
      descKey: 'PRIVACY.S3_DESC',
      type: 'list',
      list: ['PRIVACY.S3_I1', 'PRIVACY.S3_I2', 'PRIVACY.S3_I3'],
    },
    {
      icon: 'fa-shield-alt',
      color: '#68D391',
      titleKey: 'PRIVACY.S4_TITLE',
      descKey: 'PRIVACY.S4_DESC',
      type: 'items',
      items: [
        { titleKey: 'PRIVACY.S4_I1_TITLE', descKey: 'PRIVACY.S4_I1_DESC', icon: 'fa-lock' },
        { titleKey: 'PRIVACY.S4_I2_TITLE', descKey: 'PRIVACY.S4_I2_DESC', icon: 'fa-user-shield' },
        { titleKey: 'PRIVACY.S4_I3_TITLE', descKey: 'PRIVACY.S4_I3_DESC', icon: 'fa-save' },
      ],
    },
    {
      icon: 'fa-cookie-bite',
      color: '#E1306C',
      titleKey: 'PRIVACY.S5_TITLE',
      descKey: 'PRIVACY.S5_DESC',
      type: 'list',
      list: ['PRIVACY.S5_I1', 'PRIVACY.S5_I2', 'PRIVACY.S5_I3'],
    },
    {
      icon: 'fa-balance-scale',
      color: '#9F7AEA',
      titleKey: 'PRIVACY.S6_TITLE',
      descKey: 'PRIVACY.S6_DESC',
      type: 'items',
      items: [
        { titleKey: 'PRIVACY.S6_I1_TITLE', descKey: 'PRIVACY.S6_I1_DESC', icon: 'fa-eye' },
        { titleKey: 'PRIVACY.S6_I2_TITLE', descKey: 'PRIVACY.S6_I2_DESC', icon: 'fa-edit' },
        { titleKey: 'PRIVACY.S6_I3_TITLE', descKey: 'PRIVACY.S6_I3_DESC', icon: 'fa-trash-alt' },
        { titleKey: 'PRIVACY.S6_I4_TITLE', descKey: 'PRIVACY.S6_I4_DESC', icon: 'fa-download' },
      ],
    },
  ];

  ngAfterViewInit() {
    setTimeout(() => this.checkReveal(), 100);
  }

  @HostListener('window:scroll')
  onScroll() {
    this.checkReveal();
  }

  scrollToSection(id: string) {
    const el = document.getElementById(id);
    if (el) el.scrollIntoView({ behavior: 'smooth', block: 'start' });
  }

  private checkReveal() {
    document.querySelectorAll('.reveal').forEach((el) => {
      const rect = el.getBoundingClientRect();
      if (rect.top < window.innerHeight * 0.88) el.classList.add('visible');
    });
  }
}
