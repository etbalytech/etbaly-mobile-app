// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:etbaly/src/imports/core_imports.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceDetailScreen extends StatefulWidget {
  ServiceDetailScreen({super.key, required this.slug});

  final String slug;

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  static const _baseUrl = 'https://etba3ly-dm.com/';
  static const _waNumber = '201010285020';

  late final _ServiceDetail _detail;
  late final Map<String, int> _quantities;
  final Set<String> _cartIds = {};
  final _scrollCtrl = ScrollController();
  final _summaryKey = GlobalKey();

  bool get _isArabic => context.locale.languageCode == 'ar';

  List<_ServicePackage> get _cartItems =>
      _detail.packages.where((p) => _cartIds.contains(p.id)).toList();

  int get _grandTotal =>
      _cartItems.fold(0, (sum, p) => sum + p.price * (_quantities[p.id] ?? 1));

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

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _changeQty(String id, int minQty, int delta) {
    final next = (_quantities[id] ?? minQty) + delta;
    if (next >= minQty) setState(() => _quantities[id] = next);
  }

  void _toggleCart(String pkgId) {
    setState(() {
      if (_cartIds.contains(pkgId)) {
        _cartIds.remove(pkgId);
      } else {
        _cartIds.add(pkgId);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final ctx = _summaryKey.currentContext;
          if (ctx != null) {
            Scrollable.ensureVisible(
              ctx,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
            );
          }
        });
      }
    });
  }

  void _showCheckout() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _CheckoutSheet(
        cartItems: _cartItems,
        quantities: _quantities,
        grandTotal: _grandTotal,
        detail: _detail,
        waNumber: _waNumber,
        isArabic: _isArabic,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasPackages = _detail.packages.isNotEmpty;
    return Directionality(
      textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Color(0xFF070511),
        body: CustomScrollView(
          controller: _scrollCtrl,
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
                    showOrderButton: !hasPackages,
                    onOrder: () => context.go(AppRoutes.contact),
                  ),
                  // ① سياسة التعديلات أول
                  if (_detail.editPolicyImage != null) ...[
                    SizedBox(height: 28.h),
                    _EditPolicyCard(imageUrl: _netImg(_detail.editPolicyImage!)),
                  ],
                  // ② الباقات
                  if (hasPackages) ...[
                    SizedBox(height: 32.h),
                    _PackagesSectionHeader(detail: _detail),
                    SizedBox(height: 14.h),
                    for (final pkg in _detail.packages) ...[
                      _PackageCard(
                        pkg: pkg,
                        imageUrl: _netImg(pkg.image),
                        qty: _quantities[pkg.id] ?? pkg.minQty,
                        isInCart: _cartIds.contains(pkg.id),
                        onAdd: () => _toggleCart(pkg.id),
                        onIncrement: () => _changeQty(pkg.id, pkg.minQty, 1),
                        onDecrement: () => _changeQty(pkg.id, pkg.minQty, -1),
                      ),
                      SizedBox(height: 14.h),
                    ],
                    // ③ ملخص الطلب – يظهر بس لما في حاجة في الكارت
                    if (_cartIds.isNotEmpty)
                      _OrderSummaryPanel(
                        key: _summaryKey,
                        cartItems: _cartItems,
                        quantities: _quantities,
                        grandTotal: _grandTotal,
                        onCheckout: _showCheckout,
                      ),
                  ],
                  // ④ لو مفيش باقات: زرار طلب عام
                  if (!hasPackages) ...[
                    SizedBox(height: 28.h),
                    _OrderCtaCard(onTap: () => context.go(AppRoutes.contact)),
                  ],
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
  _InfoSection({
    required this.detail,
    required this.showOrderButton,
    required this.onOrder,
  });

  final _ServiceDetail detail;
  final bool showOrderButton;
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
        if (showOrderButton) ...[
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
    required this.isInCart,
    required this.onAdd,
  });

  final _ServicePackage pkg;
  final String imageUrl;
  final int qty;
  final VoidCallback onIncrement, onDecrement, onAdd;
  final bool isInCart;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 220),
      decoration: BoxDecoration(
        color: Color(0xFF0F0A1E),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isInCart
              ? Color(0xFFD4AF37).withValues(alpha: 0.7)
              : Colors.white.withValues(alpha: 0.07),
          width: isInCart ? 1.5 : 1,
        ),
        boxShadow: isInCart
            ? [
                BoxShadow(
                    color: Color(0xFFD4AF37).withValues(alpha: 0.12),
                    blurRadius: 18.r)
              ]
            : null,
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
                    Spacer(),
                    _QtyControl(
                      qty: qty,
                      minQty: pkg.minQty,
                      onIncrement: onIncrement,
                      onDecrement: onDecrement,
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onAdd,
                    icon: Icon(
                      isInCart ? Icons.check_rounded : Icons.add_shopping_cart_rounded,
                      size: 17.sp,
                    ),
                    label: Text(
                      isInCart ? 'تم الإضافة ✓' : 'أضف للطلب',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14.sp),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isInCart
                          ? Color(0xFFD4AF37).withValues(alpha: 0.15)
                          : Color(0xFFD4AF37),
                      foregroundColor: isInCart ? Color(0xFFD4AF37) : Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 13.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r)),
                      side: isInCart
                          ? BorderSide(color: Color(0xFFD4AF37).withValues(alpha: 0.5))
                          : BorderSide.none,
                    ),
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

// ─── Order Summary Panel ──────────────────────────────────────────────────────

class _OrderSummaryPanel extends StatelessWidget {
  _OrderSummaryPanel({
    super.key,
    required this.cartItems,
    required this.quantities,
    required this.grandTotal,
    required this.onCheckout,
  });

  final List<_ServicePackage> cartItems;
  final Map<String, int> quantities;
  final int grandTotal;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: Color(0xFF0D0820),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Color(0xFFD4AF37).withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFD4AF37).withValues(alpha: 0.08),
            blurRadius: 24.r,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(9.r),
                decoration: BoxDecoration(
                  color: Color(0xFFD4AF37).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: Color(0xFFD4AF37).withValues(alpha: 0.3)),
                ),
                child: Icon(Icons.receipt_long_rounded,
                    color: Color(0xFFD4AF37), size: 18.sp),
              ),
              SizedBox(width: 12.w),
              Text(
                'ملخص الطلب',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Color(0xFFD4AF37).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  '${cartItems.length} خدمة',
                  style: TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(height: 1.h, color: Colors.white.withValues(alpha: 0.06)),
          SizedBox(height: 14.h),
          // Package rows
          for (final pkg in cartItems) ...[
            _SummaryRow(pkg: pkg, qty: quantities[pkg.id] ?? 1),
            SizedBox(height: 10.h),
          ],
          Container(height: 1.h, color: Colors.white.withValues(alpha: 0.06)),
          SizedBox(height: 14.h),
          // Grand total
          Row(
            children: [
              Text(
                'الإجمالي الكلي',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Spacer(),
              Text(
                '$grandTotal',
                style: TextStyle(
                  color: Color(0xFFD4AF37),
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(width: 5.w),
              Text(
                'auto.t_fb0989a821'.tr(),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.45),
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Checkout button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onCheckout,
              icon: Icon(Icons.receipt_rounded, size: 18.sp),
              label: Text(
                'معاينة الفاتورة والدفع',
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
    ).animate().fadeIn(duration: Duration(milliseconds: 300)).slideY(begin: 0.08);
  }
}

class _SummaryRow extends StatelessWidget {
  _SummaryRow({required this.pkg, required this.qty});

  final _ServicePackage pkg;
  final int qty;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32.w,
          height: 32.h,
          decoration: BoxDecoration(
            color: Color(0xFFD4AF37).withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: Color(0xFFD4AF37).withValues(alpha: 0.4)),
          ),
          child: Center(
            child: Text(
              '$qty',
              style: TextStyle(
                color: Color(0xFFD4AF37),
                fontSize: 13.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            pkg.nameAr,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          '${pkg.price * qty}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          'auto.t_fb0989a821'.tr(),
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.4),
            fontSize: 11.sp,
          ),
        ),
      ],
    );
  }
}

// ─── Checkout Sheet ───────────────────────────────────────────────────────────

class _CheckoutSheet extends StatefulWidget {
  _CheckoutSheet({
    required this.cartItems,
    required this.quantities,
    required this.grandTotal,
    required this.detail,
    required this.waNumber,
    required this.isArabic,
  });

  final List<_ServicePackage> cartItems;
  final Map<String, int> quantities;
  final int grandTotal;
  final _ServiceDetail detail;
  final String waNumber;
  final bool isArabic;

  @override
  State<_CheckoutSheet> createState() => _CheckoutSheetState();
}

class _CheckoutSheetState extends State<_CheckoutSheet> {
  final _nameCtrl = TextEditingController();
  final _waCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _waCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_nameCtrl.text.trim().isEmpty || _waCtrl.text.trim().isEmpty) return;
    setState(() => _submitting = true);

    final lines = StringBuffer();
    lines.writeln('طلب خدمة جديد من ${widget.detail.title}');
    lines.writeln('');
    lines.writeln('الاسم: ${_nameCtrl.text.trim()}');
    lines.writeln('واتساب: ${_waCtrl.text.trim()}');
    if (_notesCtrl.text.trim().isNotEmpty) {
      lines.writeln('ملاحظات: ${_notesCtrl.text.trim()}');
    }
    lines.writeln('');
    lines.writeln('--- الباقات ---');
    for (final pkg in widget.cartItems) {
      final qty = widget.quantities[pkg.id] ?? 1;
      lines.writeln('• ${pkg.nameAr} × $qty = ${pkg.price * qty} جنيه');
    }
    lines.writeln('');
    lines.writeln('الإجمالي: ${widget.grandTotal} جنيه');

    final encoded = Uri.encodeComponent(lines.toString());
    final uri = Uri.parse('https://wa.me/${widget.waNumber}?text=$encoded');
    await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (mounted) {
      setState(() => _submitting = false);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF0D0820),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          border: Border.all(color: Color(0xFFD4AF37).withValues(alpha: 0.2)),
        ),
        padding: EdgeInsets.fromLTRB(
          20.w,
          20.h,
          20.w,
          MediaQuery.of(context).viewInsets.bottom + 24.h,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              // Title
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(9.r),
                    decoration: BoxDecoration(
                      color: Color(0xFFD4AF37).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(Icons.receipt_long_rounded,
                        color: Color(0xFFD4AF37), size: 18.sp),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'تأكيد الطلب',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          '${widget.grandTotal} جنيه — ${widget.cartItems.length} خدمة',
                          style: TextStyle(
                            color: Color(0xFFD4AF37),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Container(height: 1.h, color: Colors.white.withValues(alpha: 0.06)),
              SizedBox(height: 18.h),
              _FormField(
                controller: _nameCtrl,
                label: 'auto.t_1aff77e1a4'.tr(),
                hint: 'auto.t_f82d4f8a9c'.tr(),
                icon: Icons.person_outline_rounded,
                keyboardType: TextInputType.name,
              ),
              SizedBox(height: 12.h),
              _FormField(
                controller: _waCtrl,
                label: 'auto.t_f08db9baab'.tr(),
                hint: '01xxxxxxxxx',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                isLtr: true,
              ),
              SizedBox(height: 12.h),
              _FormField(
                controller: _notesCtrl,
                label: 'auto.t_d6f9c8b7a1'.tr(),
                hint: 'auto.t_e4c7d9b8f2'.tr(),
                icon: Icons.notes_rounded,
                maxLines: 3,
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submitting ? null : _submit,
                  icon: _submitting
                      ? SizedBox(
                          width: 18.w,
                          height: 18.h,
                          child: CircularProgressIndicator(
                              color: Colors.black, strokeWidth: 2),
                        )
                      : Icon(Icons.send_rounded, size: 17.sp),
                  label: Text(
                    'auto.t_b2e8f4c9d7'.tr(),
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15.sp),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD4AF37),
                    foregroundColor: Colors.black,
                    disabledBackgroundColor:
                        Color(0xFFD4AF37).withValues(alpha: 0.5),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r)),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Center(
                child: Text(
                  'auto.t_a3d7e5c912'.tr(),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.38),
                    fontSize: 11.sp,
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

class _FormField extends StatelessWidget {
  _FormField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.maxLines = 1,
    this.isLtr = false,
  });

  final TextEditingController controller;
  final String label, hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool isLtr;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Color(0xFFD4AF37), size: 13.sp),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(height: 7.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          textDirection: isLtr ? TextDirection.ltr : null,
          style: TextStyle(color: Colors.white, fontSize: 14.sp),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.3),
              fontSize: 13.sp,
            ),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide:
                  BorderSide(color: Colors.white.withValues(alpha: 0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide:
                  BorderSide(color: Colors.white.withValues(alpha: 0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                  color: Color(0xFFD4AF37).withValues(alpha: 0.6), width: 1.5),
            ),
          ),
        ),
      ],
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