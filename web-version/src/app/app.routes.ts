import { Routes } from '@angular/router';

export const routes: Routes = [
  {
    path: '',
    data: { title: 'ROUTES.HOME' },
    loadComponent: () => import('./components/home/home').then((m) => m.Home),
  },
  {
    path: 'Home',
    redirectTo: '',
    pathMatch: 'full',
  },
  {
    path: 'contact',
    data: { title: 'ROUTES.CONTACT' },
    loadComponent: () => import('./components/contact/contact').then((m) => m.Contact),
  },
  {
    path: 'services',
    data: { title: 'ROUTES.SERVICES' },
    loadComponent: () => import('./components/services/services').then((m) => m.Services),
  },

  // ══════════════════════════════════════════════════════════════════════════
  // Service Detail Pages
  // ══════════════════════════════════════════════════════════════════════════
  {
    path: 'services/design',
    data: { title: 'ROUTES.SERVICE_DESIGN' },
    loadComponent: () =>
      import('./components/service-details/design/design').then((m) => m.Design),
  },
  {
    path: 'services/social',
    data: { title: 'ROUTES.SERVICE_SOCIAL' },
    loadComponent: () =>
      import('./components/service-details/social/social').then((m) => m.Social),
  },
  {
    path: 'services/ads',
    data: { title: 'ROUTES.SERVICE_ADS' },
    loadComponent: () =>
      import('./components/service-details/ads/ads').then((m) => m.Ads),
  },
  {
    path: 'services/web',
    data: { title: 'ROUTES.SERVICE_WEB' },
    loadComponent: () =>
      import('./components/service-details/web/web').then((m) => m.Web),
  },
  {
    path: 'services/boost',
    data: { title: 'ROUTES.SERVICE_BOOST' },
    loadComponent: () =>
      import('./components/service-details/boost/boost').then((m) => m.Boost),
  },
  {
    path: 'services/video',
    data: { title: 'ROUTES.SERVICE_VIDEO' },
    loadComponent: () =>
      import('./components/service-details/video/video').then((m) => m.Video),
  },
  {
    path: 'services/seo',
    data: { title: 'ROUTES.SERVICE_SEO' },
    loadComponent: () =>
      import('./components/service-details/seo/seo').then((m) => m.Seo),
  },
  {
    path: 'services/moderator',
    data: { title: 'ROUTES.SERVICE_MODERATOR' },
    loadComponent: () =>
      import('./components/service-details/moderator/moderator').then(
        (m) => m.Moderator,
      ),
  },
  {
    path: 'services/brand-plan',
    data: { title: 'ROUTES.SERVICE_BRAND_PLAN' },
    loadComponent: () =>
      import('./components/service-details/brand-plan/brand-plan').then(
        (m) => m.BrandPlan,
      ),
  },
  // ══════════════════════════════════════════════════════════════════════════

  {
    path: 'about',
    data: { title: 'ROUTES.ABOUT' },
    loadComponent: () => import('./components/about/about').then((m) => m.About),
  },
  {
    path: 'privacy',
    data: { title: 'ROUTES.PRIVACY' },
    loadComponent: () => import('./components/privacy/privacy').then((m) => m.Privacy),
  },
  {
    path: 'payments',
    data: { title: 'ROUTES.PAYMENTS' },
    loadComponent: () => import('./components/payments/payments').then((m) => m.Payments),
  },
  {
    path: 'portfolio',
    data: { title: 'ROUTES.PORTFOLIO' },
    loadComponent: () => import('./components/portfolio/portfolio').then((m) => m.Portfolio),
  },
  {
    path: '**',
    data: { title: 'ROUTES.NOTFOUND' },
    loadComponent: () => import('./components/notfound/notfound').then((m) => m.Notfound),
  },
];
