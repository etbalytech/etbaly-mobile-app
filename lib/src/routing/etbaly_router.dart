import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

import 'app_routes.dart';
import 'global_navigator.dart';
import '../extensions/context_extension.dart';

// Import screens (will create these in Phase 4)
import '../features/home/presentation/screens/home_page.dart';
import '../features/services/presentation/screens/services_screen.dart';
import '../features/portfolio/presentation/screens/portfolio_screen.dart';
import '../features/about/presentation/screens/about_screen.dart';
import '../features/contact/presentation/screens/contact_screen.dart';
import '../features/services/presentation/screens/service_detail_screen.dart';
import '../features/privacy/presentation/screens/privacy_screen.dart';

/// Bottom Navigation Bar for Etbaly App
class EtbalyNavBar extends StatelessWidget {
  const EtbalyNavBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    final etbalyColors = context.etbalyColors;
    final location = GoRouterState.of(context).uri.toString();

    return Container(
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
                icon: FontAwesomeIcons.home,
                label: 'navigation.home'.tr(),
                route: AppRoutes.home,
                isActive: location == AppRoutes.home,
              ),
              _buildNavItem(
                context,
                icon: FontAwesomeIcons.thLarge,
                label: 'navigation.services'.tr(),
                route: AppRoutes.services,
                isActive: location == AppRoutes.services,
              ),
              _buildNavItem(
                context,
                icon: FontAwesomeIcons.images,
                label: 'navigation.portfolio'.tr(),
                route: AppRoutes.portfolio,
                isActive: location == AppRoutes.portfolio,
              ),
              _buildNavItem(
                context,
                icon: FontAwesomeIcons.users,
                label: 'navigation.about'.tr(),
                route: AppRoutes.about,
                isActive: location == AppRoutes.about,
              ),
              _buildNavItem(
                context,
                icon: FontAwesomeIcons.paperPlane,
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
                  color: isActive ? etbalyColors.primary : etbalyColors.textLight,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: isActive ? etbalyColors.primary : etbalyColors.textLight,
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
      path: AppRoutes.privacy,
      name: 'privacy',
      builder: (context, state) => const PrivacyScreen(),
    ),
  ],
);
