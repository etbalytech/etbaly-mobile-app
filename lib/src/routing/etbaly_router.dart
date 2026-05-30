import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

import 'app_routes.dart';
import 'global_navigator.dart';
import '../extensions/context_extension.dart';
import '../shared/app_assets.dart';
import '../shared/etbaly_web_tokens.dart';

// Import screens (will create these in Phase 4)
import '../features/home/presentation/screens/home_page.dart';
import '../features/services/presentation/screens/services_screen.dart';
import '../features/portfolio/presentation/screens/portfolio_screen.dart';
import '../features/about/presentation/screens/about_screen.dart';
import '../features/payments/presentation/screens/payments_screen.dart';
import '../features/contact/presentation/screens/contact_screen.dart';
import '../features/services/presentation/screens/service_detail_screen.dart';
import '../features/services/presentation/screens/why_choose_us_detail_screen.dart';

/// Bottom Navigation Bar for Etbaly App
class EtbalyNavBar extends StatelessWidget {
  const EtbalyNavBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _EtbalyBrandAppBar(),
      body: child,
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    final etbalyColors = context.etbalyColors;
    final location = GoRouterState.of(context).uri.toString();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: etbalyColors.bgCard,
        border: Border(
          top: BorderSide(
            color: etbalyColors.borderColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: etbalyColors.cardShadow,
            blurRadius: 20,
            offset: const Offset(0, -4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                icon: Icons.home,
                label: 'navigation.home'.tr(),
                route: AppRoutes.home,
                isActive: location == AppRoutes.home,
              ),
              _buildNavItem(
                context,
                icon: Icons.grid_view,
                label: 'navigation.services'.tr(),
                route: AppRoutes.services,
                isActive: location == AppRoutes.services,
              ),
              _buildNavItem(
                context,
                icon: Icons.photo_library,
                label: 'navigation.portfolio'.tr(),
                route: AppRoutes.portfolio,
                isActive: location == AppRoutes.portfolio,
              ),
              _buildNavItem(
                context,
                icon: Icons.people,
                label: 'navigation.about'.tr(),
                route: AppRoutes.about,
                isActive: location == AppRoutes.about,
              ),
              _buildNavItem(
                context,
                icon: Icons.account_balance_wallet,
                label: 'navigation.payments'.tr(),
                route: AppRoutes.payments,
                isActive: location == AppRoutes.payments,
              ),
              _buildNavItem(
                context,
                icon: Icons.send,
                label: 'navigation.contact'.tr(),
                route: AppRoutes.contact,
                isActive: location == AppRoutes.contact,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
    required bool isActive,
  }) {
    final etbalyColors = context.etbalyColors;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.go(route),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color:
                      isActive ? etbalyColors.primary : etbalyColors.textLight,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: isActive
                        ? etbalyColors.primary
                        : etbalyColors.textLight,
                    fontSize: 10,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EtbalyBrandAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _EtbalyBrandAppBar();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: EtbalyWebColors.appBarBg,
        border: Border(
          bottom: BorderSide(color: Color(0x663D236C)),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x5528155E),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
          child: Row(
            children: [
              const _AppBarBrand(),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _AppBarIconButton(icon: Icons.lightbulb_outline),
                  const SizedBox(width: 10),
                  _AppBarLanguageButton(
                    onTap: () {
                      final nextLocale = context.locale.languageCode == 'ar'
                          ? const Locale('en')
                          : const Locale('ar');
                      context.setLocale(nextLocale);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(74);
}

class _AppBarBrand extends StatelessWidget {
  const _AppBarBrand();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Color(0x44D4AF37), blurRadius: 14),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(AppAssets.logo, fit: BoxFit.contain),
        ),
        const SizedBox(width: 10),
        Text(
          'اطبعلي',
          style: context.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            height: 0.95,
          ),
        ),
      ],
    );
  }
}

class _AppBarLanguageButton extends StatelessWidget {
  const _AppBarLanguageButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = context.locale.languageCode == 'ar' ? 'EN' : 'AR';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: EtbalyWebColors.darkPill,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: const Color(0x443D365C)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: context.textTheme.labelLarge?.copyWith(
                  color: EtbalyWebColors.body,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.language,
                color: EtbalyWebColors.body,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppBarIconButton extends StatelessWidget {
  const _AppBarIconButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: EtbalyWebColors.darkPill,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0x443D365C)),
      ),
      child: Icon(icon, color: EtbalyWebColors.body, size: 22),
    );
  }
}

/// Etbaly App Router Configuration
final GoRouter etbalyRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.home,
  routes: [
    // Shell route with bottom navigation
    ShellRoute(
      builder: (context, state, child) => EtbalyNavBar(child: child),
      routes: [
        // Main navigation routes
        GoRoute(
          path: AppRoutes.home,
          name: 'home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: AppRoutes.services,
          name: 'services',
          builder: (context, state) => const ServicesScreen(),
        ),
        GoRoute(
          path: AppRoutes.portfolio,
          name: 'portfolio',
          builder: (context, state) => const PortfolioScreen(),
        ),
        GoRoute(
          path: AppRoutes.about,
          name: 'about',
          builder: (context, state) => const AboutScreen(),
        ),
        GoRoute(
          path: AppRoutes.payments,
          name: 'payments',
          builder: (context, state) => const PaymentsScreen(),
        ),
        GoRoute(
          path: AppRoutes.contact,
          name: 'contact',
          builder: (context, state) => const ContactScreen(),
        ),
      ],
    ),

    // Sub-routes (push navigation)
    GoRoute(
      path: AppRoutes.serviceDetail,
      name: 'serviceDetail',
      builder: (context, state) {
        final slug = state.pathParameters['slug']!;
        return ServiceDetailScreen(slug: slug);
      },
    ),
    GoRoute(
      path: AppRoutes.whyChooseUsDetail,
      name: 'whyChooseUsDetail',
      builder: (context, state) {
        final slug = state.pathParameters['slug']!;
        return WhyChooseUsDetailScreen(slug: slug);
      },
    ),
  ],
);
