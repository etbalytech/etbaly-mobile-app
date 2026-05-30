import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:url_launcher/url_launcher.dart';

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
      appBar: const _EtbalyBrandAppBar(),
      body: LayoutBuilder(
        builder: (ctx, constraints) => Stack(
          children: [
            widget.child,
            _WhatsAppFab(
              bodyW: constraints.maxWidth,
              bodyH: constraints.maxHeight,
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

    return DecoratedBox(
      decoration: BoxDecoration(
        color: etbalyColors.bgCard,
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
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 20.sp,
                  color:
                      isActive ? etbalyColors.primary : etbalyColors.textLight,
                ),
                SizedBox(height: 4.h),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: isActive
                        ? etbalyColors.primary
                        : etbalyColors.textLight,
                    fontSize: 10.sp,
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

// ─── Draggable WhatsApp FAB ───────────────────────────────────────────────────

class _WhatsAppFab extends StatefulWidget {
  const _WhatsAppFab({
    required this.bodyW,
    required this.bodyH,
    required this.onTap,
  });
  final double bodyW, bodyH;
  final VoidCallback onTap;

  @override
  State<_WhatsAppFab> createState() => _WhatsAppFabState();
}

class _WhatsAppFabState extends State<_WhatsAppFab>
    with SingleTickerProviderStateMixin {
  static const _fabW = 66.0;
  static const _fabH = 86.0;

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
      _x = _x.clamp(0, widget.bodyW - _fabW);
      _y = _y.clamp(0, widget.bodyH - _fabH);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_y.isInfinite) _y = widget.bodyH - _fabH - 16;

    return Positioned(
      left: _x,
      top: _y,
      child: GestureDetector(
        onPanStart: (_) => setState(() => _dragging = true),
        onPanUpdate: (d) => setState(() {
          _x = (_x + d.delta.dx).clamp(0, widget.bodyW - _fabW);
          _y = (_y + d.delta.dy).clamp(0, widget.bodyH - _fabH);
        }),
        onPanEnd: (_) => setState(() => _dragging = false),
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _scale,
          builder: (_, child) => Transform.scale(
            scale: _dragging ? 1.0 : _scale.value,
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
                    width: 60.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF25D366)
                              .withValues(alpha: 0.2 + 0.25 * _pulse.value),
                          blurRadius: 14.r + 14 * _pulse.value,
                          spreadRadius: 2.r + 3 * _pulse.value,
                        ),
                      ],
                    ),
                  ),
                ),
                // Green circle with WhatsApp icon
                Container(
                  width: 60.w,
                  height: 60.h,
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
                  child: Icon(
                    FontAwesomeIcons.whatsapp,
                    color: Colors.white,
                    size: 30.sp,
                  ),
                ),
                // 'auto.t_3e0489cbf4'.tr() gold badge on top
                Positioned(
                  top: 0.h,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37),
                      borderRadius: BorderRadius.circular(999.r),
                      boxShadow: [
                        BoxShadow(
                          color:
                              const Color(0xFFD4AF37).withValues(alpha: 0.55),
                          blurRadius: 10.r,
                        ),
                      ],
                    ),
                    child: Text(
                      'auto.t_3e0489cbf4'.tr(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
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
                    child: Icon(
                      FontAwesomeIcons.whatsapp,
                      color: Colors.white,
                      size: 26.sp,
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
                  icon: Icon(FontAwesomeIcons.whatsapp, size: 18.sp),
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
        color: EtbalyWebColors.appBarBg,
        border: const Border(
          bottom: BorderSide(color: Color(0x663D236C)),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x5528155E),
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
              const _AppBarBrand(),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _AppBarIconButton(icon: Icons.lightbulb_outline),
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
            color: Colors.white,
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
            color: EtbalyWebColors.darkPill,
            borderRadius: BorderRadius.circular(999.r),
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
              SizedBox(width: 10.w),
              Icon(
                Icons.language,
                color: EtbalyWebColors.body,
                size: 22.sp,
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
      width: 44.w,
      height: 44.h,
      decoration: BoxDecoration(
        color: EtbalyWebColors.darkPill,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0x443D365C)),
      ),
      child: Icon(icon, color: EtbalyWebColors.body, size: 22.sp),
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