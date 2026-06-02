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
  static const String portfolio = '/portfolio';
  static const String about = '/about';
  static const String payments = '/pricing';
  static const String contact = '/contact';
  static const String startNow = '/start-now';

  // Sub-routes (push navigation)
  static const String serviceDetail = '/services/:slug';
  static const String whyChooseUsDetail = '/why-choose-us/:slug';
  static const String privacy = '/privacy';
}
