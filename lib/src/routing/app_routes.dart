/// Centralized route path constants for GoRouter.
///
/// Use these variables instead of raw strings throughout the app.
/// Example: `context.go(AppRoutes.onboarding)` instead of `context.go('/')`.
abstract final class AppRoutes {
  AppRoutes._();

  // Auth & Onboarding
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';

  // Main Navigation (Bottom Tabs)
  static const String home = '/';
  static const String services = '/services';
  static const String expertises = '/expertises';
  static const String about = '/about';
  static const String payments = '/pricing';
  static const String contact = '/contact';
  static const String startNow = '/start-now';
  static const String careers = '/careers';

  // "Our Expertise" sample pages (opened from the expertise hub)
  static const String expertiseDesigns = '/expertises/designs';
  static const String expertiseReels = '/expertises/reels';
  static const String expertiseWebsites = '/expertises/websites';
  static const String expertiseMobileApps = '/expertises/mobile-apps';
  static const String expertiseCampaigns =
      '/expertises/advertising-campaigns';
  static const String expertiseFacebook = '/expertises/facebook-pages';
  static const String expertiseInstagram = '/expertises/instagram-accounts';

  // Sub-routes (push navigation)
  static const String serviceDetail = '/services/:slug';
  static const String whyChooseUsDetail = '/why-choose-us/:slug';
  static const String privacy = '/privacy';
}
