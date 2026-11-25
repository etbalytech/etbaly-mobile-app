import 'dart:ui' show ImageFilter;
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:url_launcher/url_launcher.dart';

import 'app_routes.dart';
import 'global_navigator.dart';
import '../extensions/context_extension.dart';
import '../services/theme_service.dart';
import '../shared/app_assets.dart';
import '../shared/etbaly_web_tokens.dart';

// Import screens (will create these in Phase 4)
import '../features/home/presentation/screens/home_page.dart';
import '../features/services/presentation/screens/services_screen.dart';
import '../features/expertises/data/expertise_catalogue.dart'
    show SocialPlatform;
import '../features/expertises/presentation/screens/campaign_samples_screen.dart';
import '../features/expertises/presentation/screens/expertises_screen.dart';
import '../features/expertises/presentation/screens/mobile_samples_screen.dart';
import '../features/expertises/presentation/screens/social_samples_screen.dart';
import '../features/expertises/presentation/screens/web_samples_screen.dart';
import '../features/about/presentation/screens/about_screen.dart';
import '../features/contact/presentation/screens/contact_screen.dart';
import '../features/start_now/presentation/screens/start_now_page.dart';
import '../features/careers/presentation/screens/careers_screen.dart';
import '../features/services/data/services_catalog_data.dart';
import '../features/services/presentation/screens/catalog_service_screen.dart';
import '../features/services/presentation/screens/service_detail_screen.dart';
import '../features/services/presentation/screens/why_choose_us_detail_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Bottom Navigation Bar for Etbaly App
class EtbalyNavBar extends StatefulWidget {
  const EtbalyNavBar({super.key, required this.child});

  final Widget child;

  @override
  State<EtbalyNavBar> createState() => _EtbalyNavBarState();
}

class _EtbalyNavBarState extends State<EtbalyNavBar> {
  static const _waNumber = '201010285020';
  static const _mainRoutes = [
    AppRoutes.home,
    AppRoutes.services,
    AppRoutes.expertises,
    AppRoutes.about,
    AppRoutes.careers,
  ];

  void _onNavigationSwipe(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity.abs() < 200) return;
    final location = GoRouterState.of(context).uri.path;
    // Only switch between the main pages; never abandon a nested form or gallery.
    final index = _mainRoutes.indexOf(location);
    if (index < 0) return;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final forward = isRtl ? velocity > 0 : velocity < 0;
    final next = index + (forward ? 1 : -1);
    if (next >= 0 && next < _mainRoutes.length) context.go(_mainRoutes[next]);
  }

  Future<void> _openWhatsApp() async {
    final uri = Uri.parse('https://wa.me/$_waNumber');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication) &&
        mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('auto.t_bd30dcd40b'.tr())),
      );
    }
  }

  void _showContactSheet() {
    final isArabic = context.locale.languageCode == 'ar';
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _WhatsAppSheet(
        isArabic: isArabic,
        onWhatsApp: () {
          Navigator.pop(context);
          _openWhatsApp();
        },
        onContact: () {
          Navigator.pop(context);
          context.go(AppRoutes.contact);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: const _EtbalyBrandAppBar(),
      body: LayoutBuilder(
        builder: (ctx, constraints) => Stack(
          children: [
            widget.child,
            _WhatsAppFab(
              bodyW: constraints.maxWidth,
              bodyH: constraints.maxHeight,
              bottomInset: MediaQuery.paddingOf(ctx).bottom,
              onTap: _showContactSheet,
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    final etbalyColors = context.etbalyColors;
    final location = GoRouterState.of(context).uri.toString();

    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: etbalyColors.bgCard.withValues(alpha: 0.88),
            border: Border(
              top: BorderSide(
                color: etbalyColors.borderColor.withValues(alpha: 0.3),
                width: 1.w,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: etbalyColors.cardShadow,
                blurRadius: 20.r,
                offset: Offset(0.w, -4.h),
                spreadRadius: 0.r,
              ),
            ],
          ),
          child: GestureDetector(
            onHorizontalDragEnd: _onNavigationSwipe,
            behavior: HitTestBehavior.translucent,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
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
                      icon: Icons.workspace_premium_rounded,
                      label: 'navigation.expertises'.tr(),
                      route: AppRoutes.expertises,
                      // Also active on the expertise sample pages.
                      isActive: location.startsWith(AppRoutes.expertises),
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
                      icon: Icons.work_outline_rounded,
                      label: 'navigation.careers'.tr(),
                      route: AppRoutes.careers,
                      isActive: location == AppRoutes.careers,
                    ),
                  ],
                ),
              ),
            ),
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

    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    return Expanded(
      child: Semantics(
        button: true,
        selected: isActive,
        label: label,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isActive ? null : () => context.go(route),
            borderRadius: BorderRadius.circular(12.r),
            child: AnimatedContainer(
              duration: reducedMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 3.w),
              decoration: BoxDecoration(
                color: isActive
                    ? etbalyColors.primary.withValues(alpha: 0.10)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedScale(
                    scale: isActive ? 1.08 : 1,
                    duration: reducedMotion
                        ? Duration.zero
                        : const Duration(milliseconds: 220),
                    child: Icon(icon,
                        size: 20.sp,
                        color: isActive
                            ? etbalyColors.primary
                            : etbalyColors.textLight),
                  ),
                  SizedBox(height: 4.h),
                  // Longer labels ("مجالات خبرتنا") shrink a little instead of
                  // being cut off.
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: isActive
                            ? etbalyColors.primary
                            : etbalyColors.textLight,
                        fontSize: 10.sp,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Draggable WhatsApp FAB ───────────────────────────────────────────────────

class _WhatsAppFab extends StatefulWidget {
  const _WhatsAppFab({
    required this.bodyW,
    required this.bodyH,
    required this.bottomInset,
    required this.onTap,
  });
  final double bodyW, bodyH;
  final double bottomInset;
  final VoidCallback onTap;

  @override
  State<_WhatsAppFab> createState() => _WhatsAppFabState();
}

class _WhatsAppFabState extends State<_WhatsAppFab>
    with SingleTickerProviderStateMixin {
  static const _fabW = 66.0;
  static const _fabH = 66.0;

  late final AnimationController _pulse;
  late final Animation<double> _scale;

  double _x = 16;
  double _y = double.infinity;
  bool _dragging = false;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 1, end: 1.09).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_WhatsAppFab old) {
    super.didUpdateWidget(old);
    if (_y.isFinite) {
      _x = _x.clamp(0.0, math.max(0, widget.bodyW - _fabW));
      _y =
          _y.clamp(0.0, math.max(0, widget.bodyH - _fabH - widget.bottomInset));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_y.isInfinite) {
      _y = math.max(0, widget.bodyH - widget.bottomInset - _fabH - 12);
    }
    final reducedMotion = MediaQuery.disableAnimationsOf(context);

    return Positioned(
      left: _x,
      top: _y,
      child: GestureDetector(
        onPanStart: (_) => setState(() => _dragging = true),
        onPanUpdate: (d) => setState(() {
          _x = (_x + d.delta.dx).clamp(0.0, math.max(0, widget.bodyW - _fabW));
          _y = (_y + d.delta.dy).clamp(
              0.0, math.max(0, widget.bodyH - _fabH - widget.bottomInset));
        }),
        onPanEnd: (_) => setState(() => _dragging = false),
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _scale,
          builder: (_, child) => Transform.scale(
            scale: _dragging || reducedMotion ? 1.0 : _scale.value,
            child: child,
          ),
          child: SizedBox(
            width: _fabW,
            height: _fabH,
            child: Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                // Animated glow ring
                AnimatedBuilder(
                  animation: _pulse,
                  builder: (_, __) => Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF25D366).withValues(
                              alpha: 0.2 +
                                  0.25 * (reducedMotion ? 0.0 : _pulse.value)),
                          blurRadius:
                              14.r + 14 * (reducedMotion ? 0.0 : _pulse.value),
                          spreadRadius:
                              2.r + 3 * (reducedMotion ? 0.0 : _pulse.value),
                        ),
                      ],
                    ),
                  ),
                ),
                // Green circle with WhatsApp icon
                Container(
                  width: 58,
                  height: 58,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Color(0xFF40E87C),
                        Color(0xFF25D366),
                        Color(0xFF18A04B),
                      ],
                      radius: 0.85,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const FaIcon(FontAwesomeIcons.whatsapp,
                          color: Colors.white, size: 25),
                      const SizedBox(height: 1),
                      SizedBox(
                        width: 49,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'auto.t_3e0489cbf4'.tr(),
                            maxLines: 1,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                height: 1.1,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ],
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

// ─── WhatsApp Contact Bottom Sheet ───────────────────────────────────────────

class _WhatsAppSheet extends StatelessWidget {
  const _WhatsAppSheet({
    required this.isArabic,
    required this.onWhatsApp,
    required this.onContact,
  });

  final bool isArabic;
  final VoidCallback onWhatsApp, onContact;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.fromLTRB(12.w, 0.h, 12.w, 12.h),
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
          decoration: BoxDecoration(
            color: const Color(0xFF110926),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: const Color(0x5528155E)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.6),
                blurRadius: 40.r,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 36.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 18.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.13),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              // Header: icon + team name + online indicator
              Row(
                children: [
                  Container(
                    width: 52.w,
                    height: 52.h,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Color(0xFF40E87C),
                          Color(0xFF25D366),
                          Color(0xFF18A04B),
                        ],
                        radius: 0.85,
                      ),
                    ),
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.whatsapp,
                        color: Colors.white,
                        size: 26.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'auto.t_3d44ed0cee'.tr(),
                          style: context.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          children: [
                            Icon(Icons.circle,
                                size: 8.sp, color: const Color(0xFF25D366)),
                            SizedBox(width: 5.w),
                            Text(
                              'auto.t_fc4453ad89'.tr(),
                              style: context.textTheme.labelSmall?.copyWith(
                                color: const Color(0xFF25D366),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              // Message bubble
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
                child: Text(
                  'auto.t_828cd81fed'.tr(),
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.78),
                    height: 1.65,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              // WhatsApp button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onWhatsApp,
                  icon: FaIcon(FontAwesomeIcons.whatsapp, size: 18.sp),
                  label: Text(
                    'auto.t_fe483dc795'.tr(),
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              // Contact form button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onContact,
                  icon: Icon(Icons.edit_note_rounded, size: 20.sp),
                  label: Text(
                    'auto.t_10331a1002'.tr(),
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFD4AF37),
                    side: const BorderSide(color: Color(0x88D4AF37)),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _EtbalyBrandAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _EtbalyBrandAppBar();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.etbalyColors.bgMain,
        border: Border(
          bottom: BorderSide(color: context.etbalyColors.borderSubtle),
        ),
        boxShadow: [
          BoxShadow(
            color: context.etbalyColors.cardShadow,
            blurRadius: 18.r,
            offset: Offset(0.w, 8.h),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 10.h),
          child: Row(
            children: [
              Semantics(
                button: true,
                label: context.locale.languageCode == 'ar'
                    ? 'العودة إلى الرئيسية'
                    : 'Go to home',
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16.r),
                    onTap: () => context.go(AppRoutes.home),
                    child: const _AppBarBrand(),
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _ThemeToggleButton(),
                  SizedBox(width: 10.w),
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
          width: 46.w,
          height: 46.h,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: const Color(0x44D4AF37), blurRadius: 14.r),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(AppAssets.logo, fit: BoxFit.contain),
        ),
        SizedBox(width: 10.w),
        Text(
          'auto.t_135dd3f6f1'.tr(),
          style: context.textTheme.headlineSmall?.copyWith(
            color: context.etbalyColors.textMain,
            fontSize: 24.sp,
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
        borderRadius: BorderRadius.circular(999.r),
        child: Container(
          height: 44.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            color: context.etbalyColors.badgeBg,
            borderRadius: BorderRadius.circular(999.r),
            border: Border.all(color: context.etbalyColors.borderColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: context.textTheme.labelLarge?.copyWith(
                  color: context.etbalyColors.textMuted,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(width: 10.w),
              Icon(
                Icons.language,
                color: context.etbalyColors.textMuted,
                size: 22.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeToggleButton extends StatelessWidget {
  const _ThemeToggleButton();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService.instance.themeMode,
      builder: (context, themeMode, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final isAr = context.locale.languageCode == 'ar';
        return Tooltip(
          message: isDark
              ? (isAr ? 'تفعيل الوضع النهاري' : 'Switch to light mode')
              : (isAr ? 'تفعيل الوضع الليلي' : 'Switch to dark mode'),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: ThemeService.instance.toggle,
              borderRadius: BorderRadius.circular(999.r),
              child: Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  color: context.etbalyColors.badgeBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: context.etbalyColors.borderColor),
                ),
                child: AnimatedSwitcher(
                  duration: MediaQuery.disableAnimationsOf(context)
                      ? Duration.zero
                      : const Duration(milliseconds: 200),
                  child: Icon(
                    isDark ? Icons.wb_sunny_outlined : Icons.nightlight_round,
                    key: ValueKey(isDark),
                    color: isDark
                        ? EtbalyWebColors.gold
                        : context.etbalyColors.primary,
                    size: 22.sp,
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
          path: AppRoutes.expertises,
          name: 'expertises',
          builder: (context, state) => const ExpertisesScreen(),
          // Sample pages open on top of the hub, so back returns to it.
          routes: [
            GoRoute(
              path: 'designs',
              name: 'expertiseDesigns',
              builder: (context, state) =>
                  const ExpertisesScreen(kind: ExpertiseGalleryKind.photos),
            ),
            GoRoute(
              path: 'reels',
              name: 'expertiseReels',
              builder: (context, state) =>
                  const ExpertisesScreen(kind: ExpertiseGalleryKind.reels),
            ),
            GoRoute(
              path: 'websites',
              name: 'expertiseWebsites',
              builder: (context, state) => const WebSamplesScreen(),
            ),
            GoRoute(
              path: 'mobile-apps',
              name: 'expertiseMobileApps',
              builder: (context, state) => const MobileSamplesScreen(),
            ),
            GoRoute(
              path: 'advertising-campaigns',
              name: 'expertiseCampaigns',
              builder: (context, state) => const CampaignSamplesScreen(),
            ),
            GoRoute(
              path: 'facebook-pages',
              name: 'expertiseFacebook',
              builder: (context, state) =>
                  const SocialSamplesScreen(platform: SocialPlatform.facebook),
            ),
            GoRoute(
              path: 'instagram-accounts',
              name: 'expertiseInstagram',
              builder: (context, state) => const SocialSamplesScreen(
                platform: SocialPlatform.instagram,
              ),
            ),
          ],
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
        GoRoute(
          path: AppRoutes.startNow,
          name: 'startNow',
          builder: (context, state) => StartNowPage(
            initialService: state.uri.queryParameters['service'] ??
                state.uri.queryParameters['type'],
          ),
        ),
        GoRoute(
          path: AppRoutes.careers,
          name: 'careers',
          builder: (context, state) => const CareersScreen(),
        ),
      ],
    ),

    // Sub-routes (push navigation)
    GoRoute(
      path: AppRoutes.serviceDetail,
      name: 'serviceDetail',
      redirect: (context, state) {
        final slug = state.pathParameters['slug']!;
        if (slug == 'moderator' || slug == 'brand-plan') return null;
        return catalogServiceBySlug(slug) == null ? AppRoutes.services : null;
      },
      builder: (context, state) {
        final slug = state.pathParameters['slug']!;
        // Services that have no dedicated screen use the catalogue-driven page.
        if (catalogServiceBySlug(slug)?.catalogPage ?? false) {
          return CatalogServiceScreen(slug: slug);
        }
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
