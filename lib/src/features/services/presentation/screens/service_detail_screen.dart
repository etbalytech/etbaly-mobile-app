// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:etbaly/src/imports/core_imports.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceDetailScreen extends StatefulWidget {
  ServiceDetailScreen({super.key, required this.slug});

  final String slug;

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  static const _baseUrl = 'https://etba3ly-dm.com/';

  late final _ServiceDetail _detail;
  late final Map<String, int> _quantities;

  bool get _isArabic => context.locale.languageCode == 'ar';

  static String _assetImage(String slug) {
    final map = {'mobile-app': 'mobile'};
    return 'assets/images/services/${map[slug] ?? slug}.webp';
  }

  String _netImg(String path) => Uri.encodeFull('$_baseUrl$path');

  @override
  void initState() {
    super.initState();
    _detail = _details[widget.slug] ?? _details['design']!;
    _quantities = {for (final p in _detail.packages) p.id: p.minQty};
  }

  void _changeQty(String id, int minQty, int delta) {
    final next = (_quantities[id] ?? minQty) + delta;
    if (next >= minQty) setState(() => _quantities[id] = next);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Color(0xFF070511),
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _HeroSection(
                assetImage: _assetImage(widget.slug),
                detail: _detail,
                onBack: () => context.pop(),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(18.w, 24.h, 18.w, 40.h),
              sliver: SliverList.list(
                children: [
                  _InfoSection(
                    detail: _detail,
                    onOrder: () => context.go(AppRoutes.contact),
                  ),
                  if (_detail.packages.isNotEmpty) ...[
                    SizedBox(height: 32.h),
                    _PackagesSectionHeader(detail: _detail),
                    SizedBox(height: 14.h),
                    for (final pkg in _detail.packages)
                      Padding(
                        padding: EdgeInsets.only(bottom: 14.h),
                        child: _PackageCard(
                          pkg: pkg,
                          imageUrl: _netImg(pkg.image),
                          qty: _quantities[pkg.id] ?? pkg.minQty,
                          onIncrement: () => _changeQty(pkg.id, pkg.minQty, 1),
                          onDecrement: () => _changeQty(pkg.id, pkg.minQty, -1),
                        ),
                      ),
                  ],
                  if (_detail.editPolicyImage != null) ...[
                    SizedBox(height: 32.h),
                    _EditPolicyCard(
                        imageUrl: _netImg(_detail.editPolicyImage!)),
                  ],
                  SizedBox(height: 32.h),
                  _WhatIncludedSection(detail: _detail),
                  SizedBox(height: 28.h),
                  _OrderCtaCard(onTap: () => context.go(AppRoutes.contact)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Hero Section ─────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  _HeroSection({
    required this.assetImage,
    required this.detail,
    required this.onBack,
  });

  final String assetImage;
  final _ServiceDetail detail;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260.h,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            assetImage,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => ColoredBox(color: Color(0xFF12082A)),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x55000000), Color(0xFF070511)],
                stops: [0.0, 1.0],
              ),
            ),
          ),
          Positioned(
            top: 52.h,
            right: Directionality.of(context) == TextDirection.rtl ? 16.w : null,
            left: Directionality.of(context) == TextDirection.ltr ? 16.w : null,
            child: GestureDetector(
              onTap: onBack,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(999.r),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.18)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Directionality.of(context) == TextDirection.rtl
                          ? Icons.arrow_forward_rounded
                          : Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 15.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'auto.t_4561404281'.tr(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Info Section ─────────────────────────────────────────────────────────────

class _InfoSection extends StatelessWidget {
  _InfoSection({required this.detail, required this.onOrder});

  final _ServiceDetail detail;
  final VoidCallback onOrder;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
          decoration: BoxDecoration(
            color: Color(0xFFD4AF37).withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(999.r),
            border:
                Border.all(color: Color(0xFFD4AF37).withValues(alpha: 0.35)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.circle, color: Color(0xFFD4AF37), size: 6.sp),
              SizedBox(width: 8.w),
              Icon(detail.icon, color: Color(0xFFD4AF37), size: 14.sp),
              SizedBox(width: 6.w),
              Text(
                'auto.t_300f7da948'.tr(),
                style: TextStyle(
                  color: Color(0xFFD4AF37),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 14.h),
        Text(
          detail.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 28.sp,
            fontWeight: FontWeight.w900,
            height: 1.2,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          detail.description,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.62),
            fontSize: 14.sp,
            height: 1.75,
          ),
        ),
        SizedBox(height: 20.h),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onOrder,
            icon: Icon(Icons.send_rounded, size: 17.sp),
            label: Text(
              'auto.t_af67816c17'.tr(),
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15.sp),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFD4AF37),
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r)),
            ),
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: Duration(milliseconds: 420))
        .slideY(begin: 0.08);
  }
}

// ─── Packages Section Header ──────────────────────────────────────────────────

class _PackagesSectionHeader extends StatelessWidget {
  _PackagesSectionHeader({required this.detail});

  final _ServiceDetail detail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 1.h, color: Colors.white.withValues(alpha: 0.07)),
        SizedBox(height: 24.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Color(0xFFD4AF37).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(999.r),
            border:
                Border.all(color: Color(0xFFD4AF37).withValues(alpha: 0.28)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star_rounded, color: Color(0xFFD4AF37), size: 12.sp),
              SizedBox(width: 6.w),
              Text(
                'auto.t_300f7da948'.tr(),
                style: TextStyle(
                  color: Color(0xFFD4AF37),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(Icons.circle, color: Color(0xFFD4AF37), size: 4.sp),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          detail.packagesSectionTitle ?? 'auto.t_1df235e8a0'.tr(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          'auto.t_71e720e707'.tr(),
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.48),
            fontSize: 13.sp,
          ),
        ),
      ],
    );
  }
}

// ─── Package Card ─────────────────────────────────────────────────────────────

class _PackageCard extends StatelessWidget {
  _PackageCard({
    required this.pkg,
    required this.imageUrl,
    required this.qty,
    required this.onIncrement,
    required this.onDecrement,
  });

  final _ServicePackage pkg;
  final String imageUrl;
  final int qty;
  final VoidCallback onIncrement, onDecrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF0F0A1E),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => ColoredBox(color: Color(0xFF1A1035)),
              errorWidget: (_, __, ___) => ColoredBox(
                color: Color(0xFF1A1035),
                child: Icon(Icons.image_not_supported_outlined,
                    color: Colors.white24, size: 40.sp),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pkg.nameAr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  pkg.descAr,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.58),
                    fontSize: 13.sp,
                    height: 1.65,
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${pkg.price}',
                      style: TextStyle(
                        color: Color(0xFFD4AF37),
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Padding(
                      padding: EdgeInsets.only(bottom: 3.h),
                      child: Text(
                        'auto.t_fb0989a821'.tr(),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.48),
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                Row(
                  children: [
                    Text(
                      'auto.t_a95134401a'.tr(),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Spacer(),
                    _QtyControl(
                      qty: qty,
                      minQty: pkg.minQty,
                      onIncrement: onIncrement,
                      onDecrement: onDecrement,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  'auto.t_7111ba03cc'.tr(args: [pkg.minQty.toString()]),
                  style: TextStyle(
                    color: Color(0xFFD4AF37).withValues(alpha: 0.65),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyControl extends StatelessWidget {
  _QtyControl({
    required this.qty,
    required this.minQty,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int qty, minQty;
  final VoidCallback onIncrement, onDecrement;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Color(0xFF1A1035),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QtyBtn(
            icon: Icons.add,
            onTap: onIncrement,
          ),
          SizedBox(
            width: 36.w,
            child: Text(
              '$qty',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          _QtyBtn(
            icon: Icons.remove,
            onTap: onDecrement,
            disabled: qty <= minQty,
          ),
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  _QtyBtn({
    required this.icon,
    required this.onTap,
    this.disabled = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: SizedBox(
        width: 36.w,
        height: 36.h,
        child: Icon(
          icon,
          size: 18.sp,
          color: disabled ? Colors.white.withValues(alpha: 0.2) : Colors.white,
        ),
      ),
    );
  }
}

// ─── Edit Policy Card ─────────────────────────────────────────────────────────

class _EditPolicyCard extends StatelessWidget {
  _EditPolicyCard({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF0F0A1E),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.contain,
            width: double.infinity,
            placeholder: (_, __) => SizedBox(
              height: 180.h,
              child: ColoredBox(color: Color(0xFF1A1035)),
            ),
            errorWidget: (_, __, ___) => SizedBox.shrink(),
          ),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(9.r),
                      decoration: BoxDecoration(
                        color: Color(0xFFD4AF37).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: Color(0xFFD4AF37).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Icon(Icons.edit_note_rounded,
                          color: Color(0xFFD4AF37), size: 18.sp),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'auto.t_5a6ac77983'.tr(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  'auto.t_9e16e6281a'.tr(),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.62),
                    height: 1.75,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── What's Included Section ──────────────────────────────────────────────────

class _WhatIncludedSection extends StatelessWidget {
  _WhatIncludedSection({required this.detail});

  final _ServiceDetail detail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 1.h, color: Colors.white.withValues(alpha: 0.07)),
        SizedBox(height: 24.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(999.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.layers_rounded, color: Colors.white54, size: 12.sp),
              SizedBox(width: 6.w),
              Text(
                'auto.t_1711387d68'.tr(),
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(Icons.circle, color: Colors.white30, size: 4.sp),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'auto.t_5dbfac2282'.tr(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          'auto.t_cf29174de1'.tr(),
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.48),
            fontSize: 13.sp,
          ),
        ),
        SizedBox(height: 16.h),
        ...detail.points.map(
          (pt) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _PointCard(point: pt),
          ),
        ),
      ],
    );
  }
}

class _PointCard extends StatelessWidget {
  _PointCard({required this.point});

  final _DetailPoint point;

  @override
  Widget build(BuildContext context) {
    final accent = point.accentGold ? Color(0xFFD4AF37) : Color(0xFF7C3AED);

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Color(0xFF0F0A1E),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42.w,
            height: 42.h,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: accent.withValues(alpha: 0.28)),
            ),
            child: Icon(point.icon, color: accent, size: 20.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  point.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  point.description,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.58),
                    fontSize: 13.sp,
                    height: 1.65,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Order CTA Card ───────────────────────────────────────────────────────────

class _OrderCtaCard extends StatelessWidget {
  _OrderCtaCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(22.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A0A2E), Color(0xFF0F0820)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Color(0xFF7C3AED).withValues(alpha: 0.28)),
      ),
      child: Column(
        children: [
          Text(
            'auto.t_3e331b6b6c'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'auto.t_9cda1ed5f2'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.55),
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 18.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onTap,
              icon: Icon(Icons.send_rounded, size: 18.sp),
              label: Text(
                'auto.t_af67816c17'.tr(),
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15.sp),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD4AF37),
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Data Models ──────────────────────────────────────────────────────────────

class _ServiceDetail {
  _ServiceDetail({
    required this.title,
    required this.description,
    required this.icon,
    required this.points,
    this.packages = const [],
    this.editPolicyImage,
    this.packagesSectionTitle,
  });

  final String title, description;
  final IconData icon;
  final List<_DetailPoint> points;
  final List<_ServicePackage> packages;
  final String? editPolicyImage, packagesSectionTitle;
}

class _ServicePackage {
  _ServicePackage({
    required this.id,
    required this.nameAr,
    required this.descAr,
    required this.price,
    required this.image,
  });

  final String id, nameAr, descAr, image;
  final int price;
  final int minQty = 1;
}

class _DetailPoint {
  _DetailPoint({
    required this.title,
    required this.description,
    required this.icon,
    this.accentGold = false,
  });

  final String title, description;
  final IconData icon;
  final bool accentGold;
}

// ─── Service Data ─────────────────────────────────────────────────────────────

final _details = <String, _ServiceDetail>{
  'design': _ServiceDetail(
    title: 'auto.t_1ccbb8befd'.tr(),
    description: 'auto.t_ae433e7e1d'.tr(),
    icon: Icons.brush,
    packagesSectionTitle: 'auto.t_e0b4927f11'.tr(),
    editPolicyImage: 'packages/design/edit-policy.webp',
    packages: [
      _ServicePackage(
        id: 'social-design',
        nameAr: 'auto.t_ac09dd25d6'.tr(),
        descAr: 'auto.t_4c5d91e8ee'.tr(),
        price: 250,
        image: 'packages/design/2.webp',
      ),
      _ServicePackage(
        id: 'identity',
        nameAr: 'auto.t_abc98e2d21'.tr(),
        descAr: 'auto.t_a3a0b415ae'.tr(),
        price: 3000,
        image: 'packages/design/4.webp',
      ),
      _ServicePackage(
        id: 'logo',
        nameAr: 'auto.t_aeec0ab0d8'.tr(),
        descAr: 'auto.t_8010acff05'.tr(),
        price: 500,
        image: 'packages/design/1.webp',
      ),
      _ServicePackage(
        id: 'about-us',
        nameAr: 'auto.t_1a4470754d'.tr(),
        descAr: 'auto.t_1a6d2d23dc'.tr(),
        price: 1000,
        image: 'packages/design/3.webp',
      ),
    ],
    points: [
      _DetailPoint(
        title: 'auto.t_5dbc6132d0'.tr(),
        description: 'auto.t_081f21ba48'.tr(),
        icon: Icons.palette,
      ),
      _DetailPoint(
        title: 'auto.t_5f404405a8'.tr(),
        description: 'auto.t_1710674483'.tr(),
        icon: Icons.auto_awesome,
        accentGold: true,
      ),
      _DetailPoint(
        title: 'auto.t_4ecca60ff5'.tr(),
        description: 'auto.t_c8283f1894'.tr(),
        icon: Icons.inventory_2,
      ),
    ],
  ),
  'social': _ServiceDetail(
    title: 'auto.t_fec25e47d8'.tr(),
    description: 'auto.t_c8bdf704cb'.tr(),
    icon: Icons.groups,
    packagesSectionTitle: 'auto.t_d596c2886f'.tr(),
    packages: [
      _ServicePackage(
        id: 'start',
        nameAr: 'auto.t_fde0d94d26'.tr(),
        descAr: 'auto.t_0950f86d26'.tr(),
        price: 1500,
        image: 'packages/social/1.webp',
      ),
      _ServicePackage(
        id: 'boost',
        nameAr: 'auto.t_62088b1c95'.tr(),
        descAr: 'auto.t_c81a62b199'.tr(),
        price: 2500,
        image: 'packages/social/2.webp',
      ),
      _ServicePackage(
        id: 'pro',
        nameAr: 'auto.t_dae936f079'.tr(),
        descAr: 'auto.t_41e7986085'.tr(),
        price: 4000,
        image: 'packages/social/3.webp',
      ),
      _ServicePackage(
        id: 'pro-max',
        nameAr: 'auto.t_00d8510f95'.tr(),
        descAr: 'auto.t_aab44f0381'.tr(),
        price: 8000,
        image: 'packages/social/4.webp',
      ),
    ],
    points: [
      _DetailPoint(
        title: 'auto.t_1282b3ea04'.tr(),
        description: 'auto.t_e1ef9838ba'.tr(),
        icon: Icons.calendar_month,
      ),
      _DetailPoint(
        title: 'auto.t_8ec69ca100'.tr(),
        description: 'auto.t_5279470715'.tr(),
        icon: Icons.forum,
      ),
      _DetailPoint(
        title: 'auto.t_0504b29cd7'.tr(),
        description: 'auto.t_edd53c15c6'.tr(),
        icon: Icons.insights,
        accentGold: true,
      ),
    ],
  ),
  'ads': _ServiceDetail(
    title: 'auto.t_e9e1e060a2'.tr(),
    description: 'auto.t_135228e1e8'.tr(),
    icon: Icons.campaign,
    points: [
      _DetailPoint(
        title: 'auto.t_552a7fb024'.tr(),
        description: 'auto.t_f130e84398'.tr(),
        icon: Icons.tune,
      ),
      _DetailPoint(
        title: 'auto.t_36db49811f'.tr(),
        description: 'auto.t_866299b707'.tr(),
        icon: Icons.science,
        accentGold: true,
      ),
      _DetailPoint(
        title: 'auto.t_b0a85e4b52'.tr(),
        description: 'auto.t_adf7a7f6cb'.tr(),
        icon: Icons.trending_up,
      ),
    ],
  ),
  'web': _ServiceDetail(
    title: 'auto.t_1edbc0fd7b'.tr(),
    description: 'auto.t_a9fc68419e'.tr(),
    icon: Icons.language,
    points: [
      _DetailPoint(
        title: 'auto.t_bee2a1ff6a'.tr(),
        description: 'auto.t_bd35e2ae5d'.tr(),
        icon: Icons.web,
      ),
      _DetailPoint(
        title: 'auto.t_c62e7e8997'.tr(),
        description: 'auto.t_afd7c55790'.tr(),
        icon: Icons.business_center,
      ),
      _DetailPoint(
        title: 'auto.t_770010bb0c'.tr(),
        description: 'auto.t_8fb142b9d0'.tr(),
        icon: Icons.phone_iphone,
        accentGold: true,
      ),
    ],
  ),
  'mobile-app': _ServiceDetail(
    title: 'auto.t_75b4366b3d'.tr(),
    description: 'auto.t_5db77d126a'.tr(),
    icon: Icons.phone_iphone,
    points: [
      _DetailPoint(
        title: 'auto.t_294b49ddbc'.tr(),
        description: 'auto.t_3992a992ce'.tr(),
        icon: Icons.dashboard_customize,
      ),
      _DetailPoint(
        title: 'auto.t_7b4c4622db'.tr(),
        description: 'auto.t_8e95cb0723'.tr(),
        icon: Icons.devices,
        accentGold: true,
      ),
      _DetailPoint(
        title: 'auto.t_5bdb3f8dfd'.tr(),
        description: 'auto.t_480283bf2d'.tr(),
        icon: Icons.support_agent,
      ),
    ],
  ),
  'video': _ServiceDetail(
    title: 'auto.t_c9b57e62ee'.tr(),
    description: 'auto.t_99d3c11a19'.tr(),
    icon: Icons.play_circle,
    points: [
      _DetailPoint(
        title: 'auto.t_d0f5719db6'.tr(),
        description: 'auto.t_d82a5c1d45'.tr(),
        icon: Icons.movie,
      ),
      _DetailPoint(
        title: 'auto.t_0d15adbecc'.tr(),
        description: 'auto.t_eeccc05b35'.tr(),
        icon: Icons.smart_display,
        accentGold: true,
      ),
      _DetailPoint(
        title: 'auto.t_f63905e988'.tr(),
        description: 'auto.t_f2fcdcb3ba'.tr(),
        icon: Icons.animation,
      ),
    ],
  ),
  'seo': _ServiceDetail(
    title: 'auto.t_943b26af5b'.tr(),
    description: 'auto.t_8c020b582c'.tr(),
    icon: Icons.manage_search,
    points: [
      _DetailPoint(
        title: 'auto.t_f82b26c88c'.tr(),
        description: 'auto.t_c28ca048ad'.tr(),
        icon: Icons.key,
      ),
      _DetailPoint(
        title: 'auto.t_e892ef7090'.tr(),
        description: 'auto.t_60ca8af2da'.tr(),
        icon: Icons.article,
      ),
      _DetailPoint(
        title: 'auto.t_a171df3e97'.tr(),
        description: 'auto.t_a37af36351'.tr(),
        icon: Icons.speed,
        accentGold: true,
      ),
    ],
  ),
  'boost': _ServiceDetail(
    title: 'auto.t_1a06e7a5bd'.tr(),
    description: 'auto.t_29f06e4f78'.tr(),
    icon: Icons.bolt,
    points: [
      _DetailPoint(
        title: 'auto.t_8181f653a0'.tr(),
        description: 'auto.t_29ed77f1d9'.tr(),
        icon: Icons.person_add,
      ),
      _DetailPoint(
        title: 'auto.t_248a216d9b'.tr(),
        description: 'auto.t_14f4770f4b'.tr(),
        icon: Icons.public,
        accentGold: true,
      ),
      _DetailPoint(
        title: 'auto.t_e93681beb5'.tr(),
        description: 'auto.t_012c258a6e'.tr(),
        icon: Icons.view_list,
      ),
    ],
  ),
  'moderator': _ServiceDetail(
    title: 'auto.t_c7351ab69b'.tr(),
    description: 'auto.t_68540d252d'.tr(),
    icon: Icons.support_agent,
    points: [
      _DetailPoint(
        title: 'auto.t_606f2f5b1a'.tr(),
        description: 'auto.t_18dda6f40a'.tr(),
        icon: Icons.mark_chat_read,
      ),
      _DetailPoint(
        title: 'auto.t_a76c295c46'.tr(),
        description: 'auto.t_7289bcc8cd'.tr(),
        icon: Icons.people_alt,
        accentGold: true,
      ),
      _DetailPoint(
        title: 'auto.t_624ace75f5'.tr(),
        description: 'auto.t_ba153a930b'.tr(),
        icon: Icons.fact_check,
      ),
    ],
  ),
  'brand-plan': _ServiceDetail(
    title: 'auto.t_192a0586bb'.tr(),
    description: 'auto.t_c5a4895378'.tr(),
    icon: Icons.diamond,
    points: [
      _DetailPoint(
        title: 'auto.t_0ed3b0ddb2'.tr(),
        description: 'auto.t_2ac18ab812'.tr(),
        icon: Icons.explore,
      ),
      _DetailPoint(
        title: 'auto.t_ed3d29d919'.tr(),
        description: 'auto.t_7c3c3371da'.tr(),
        icon: Icons.record_voice_over,
      ),
      _DetailPoint(
        title: 'auto.t_58c3ee1b8a'.tr(),
        description: 'auto.t_a6e3b52e67'.tr(),
        icon: Icons.map,
        accentGold: true,
      ),
    ],
  ),
};