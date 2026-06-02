// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'dart:async';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:etbaly/src/imports/core_imports.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

String _serviceLocaleText(BuildContext context, String ar, String en) =>
    context.locale.languageCode == 'en' ? en : ar;

class ServiceDetailScreen extends StatefulWidget {
  ServiceDetailScreen({super.key, required this.slug});

  final String slug;

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  static const _baseUrl = 'https://etba3ly-dm.com/';
  static const _waNumber = '201010285020';

  late final Map<String, int> _quantities;
  final Set<String> _cartIds = {};
  final _scrollCtrl = ScrollController();
  final _summaryKey = GlobalKey();
  late final DateTime _comingSoonTarget;
  late Duration _comingSoonRemaining;
  Timer? _comingSoonTimer;

  // ads-specific: which geographic category is expanded
  String? _selectedAdsCategoryId;

  bool get _isArabic => context.locale.languageCode == 'ar';

  _ServiceDetail get _detail => _details[widget.slug] ?? _details['design']!;

  // all packages available for this service (includes ads sub-packages)
  List<_ServicePackage> get _allPackages => widget.slug == 'ads'
      ? _adsCategories.expand((c) => c.packages).toList()
      : _detail.packages;

  List<_ServicePackage> get _cartItems =>
      _allPackages.where((p) => _cartIds.contains(p.id)).toList();

  int get _grandTotal =>
      _cartItems.fold(0, (sum, p) => sum + p.price * (_quantities[p.id] ?? 1));

  static String _assetImage(String slug) {
    final map = {'mobile-app': 'mobile'};
    return 'assets/images/services/${map[slug] ?? slug}.webp';
  }

  String _packageAsset(String path) => 'assets/images/$path';

  String _netImg(String path) => Uri.encodeFull('$_baseUrl$path');

  @override
  void initState() {
    super.initState();
    final detail = _detail;
    _quantities = {for (final p in detail.packages) p.id: p.minQty};
    _comingSoonTarget = DateTime(2026, 5, 24).add(
      const Duration(hours: 720),
    );
    _comingSoonRemaining = _comingSoonTarget.difference(DateTime.now());
    if (widget.slug == 'mobile-app') {
      _comingSoonTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        final next = _comingSoonTarget.difference(DateTime.now());
        if (mounted) {
          setState(() {
            _comingSoonRemaining = next.isNegative ? Duration.zero : next;
          });
        }
      });
    }
    if (widget.slug == 'ads') {
      for (final cat in _adsCategories) {
        for (final p in cat.packages) {
          _quantities[p.id] = p.minQty;
        }
      }
    }
  }

  @override
  void dispose() {
    _comingSoonTimer?.cancel();
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
    if (widget.slug == 'mobile-app') {
      return Directionality(
        textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: _MobileAppComingSoonScreen(
          remaining: _comingSoonRemaining,
          onBack: () => context.pop(),
        ),
      );
    }

    if (widget.slug == 'boost') {
      return Directionality(
        textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: _BoostServiceScreen(onBack: () => context.pop()),
      );
    }

    if (widget.slug == 'brand-plan') {
      return Directionality(
        textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: _BrandPlanServiceScreen(onBack: () => context.pop()),
      );
    }

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
                    showOrderButton: !hasPackages && widget.slug != 'ads',
                    onOrder: () => context.go(AppRoutes.contact),
                  ),
                  // ① سياسة التعديلات أول
                  if (_detail.editPolicyImage != null) ...[
                    SizedBox(height: 28.h),
                    _EditPolicyCard(
                      assetImage: _packageAsset(_detail.editPolicyImage!),
                      imageUrl: _netImg(_detail.editPolicyImage!),
                    ),
                  ],
                  // ② الباقات
                  if (hasPackages) ...[
                    SizedBox(height: 32.h),
                    _PackagesSectionHeader(detail: _detail),
                    SizedBox(height: 14.h),
                    for (final pkg in _detail.packages) ...[
                      _PackageCard(
                        pkg: pkg,
                        assetImage: _packageAsset(pkg.image),
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
                  // ④ إعلانات ممولة – اختيار الكاتيجوري قبل الباقات
                  if (widget.slug == 'ads') ...[
                    _AdsCategoriesSection(
                      categories: _adsCategories,
                      selectedCategoryId: _selectedAdsCategoryId,
                      quantities: _quantities,
                      cartIds: _cartIds,
                      netImg: _netImg,
                      onSelectCategory: (id) => setState(() {
                        _selectedAdsCategoryId =
                            _selectedAdsCategoryId == id ? null : id;
                      }),
                      onAdd: _toggleCart,
                      onIncrement: (id) => _changeQty(id, 1, 1),
                      onDecrement: (id) => _changeQty(id, 1, -1),
                    ),
                    if (_cartIds.isNotEmpty) ...[
                      SizedBox(height: 14.h),
                      _OrderSummaryPanel(
                        key: _summaryKey,
                        cartItems: _cartItems,
                        quantities: _quantities,
                        grandTotal: _grandTotal,
                        onCheckout: _showCheckout,
                      ),
                    ],
                  ],
                  // ⑤ لو مفيش باقات ومش ads: زرار طلب عام
                  if (!hasPackages && widget.slug != 'ads') ...[
                    SizedBox(height: 28.h),
                    _OrderCtaCard(onTap: () => context.go(AppRoutes.contact)),
                  ],
                  // ⑥ CTA banner في آخر الصفحة دايماً
                  SizedBox(height: 32.h),
                  _ServiceCtaBanner(
                    onTap: () => context.go(AppRoutes.contact),
                  ),
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
            right:
                Directionality.of(context) == TextDirection.rtl ? 16.w : null,
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
                      Icons.chevron_right_rounded,
                      color: Colors.white,
                      size: 18.sp,
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

class _MobileAppComingSoonScreen extends StatelessWidget {
  const _MobileAppComingSoonScreen({
    required this.remaining,
    required this.onBack,
  });

  final Duration remaining;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final days = remaining.inDays;
    final hours = remaining.inHours.remainder(24);
    final minutes = remaining.inMinutes.remainder(60);
    final seconds = remaining.inSeconds.remainder(60);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0E18),
      body: Stack(
        children: [
          Positioned.fill(
              child: CustomPaint(painter: _ComingSoonBackgroundPainter())),
          SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.sizeOf(context).height -
                      MediaQuery.paddingOf(context).top -
                      MediaQuery.paddingOf(context).bottom,
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(22.w, 12.h, 22.w, 28.h),
                  child: Column(
                    children: [
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: _ComingSoonBackButton(onTap: onBack),
                      ),
                      SizedBox(height: 18.h),
                      _OrbitLogo(),
                      SizedBox(height: 42.h),
                      _ComingSoonBadge(),
                      SizedBox(height: 34.h),
                      Text(
                        _serviceLocaleText(
                          context,
                          'فريقنا يعمل بكامل طاقته لتقديم تجربة استثنائية. نعدك بشيء رائع يستحق الانتظار',
                          'Our team is working at full capacity to deliver an exceptional experience. Something worth the wait is coming.',
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFFB9A3FF),
                          fontSize: 17.sp,
                          height: 1.8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 34.h),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _TimeTile(
                                value: days,
                                label:
                                    _serviceLocaleText(context, 'يوم', 'Days')),
                            _TimeSeparator(),
                            _TimeTile(
                                value: hours,
                                label: _serviceLocaleText(
                                    context, 'ساعة', 'Hours')),
                            _TimeSeparator(),
                            _TimeTile(
                                value: minutes,
                                label: _serviceLocaleText(
                                    context, 'دقيقة', 'Minutes')),
                            _TimeSeparator(),
                            _TimeTile(
                                value: seconds,
                                label: _serviceLocaleText(
                                    context, 'ثانية', 'Seconds')),
                          ],
                        ),
                      ),
                      SizedBox(height: 44.h),
                      _ProgressSection(),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BoostServiceScreen extends StatefulWidget {
  const _BoostServiceScreen({required this.onBack});

  final VoidCallback onBack;

  @override
  State<_BoostServiceScreen> createState() => _BoostServiceScreenState();
}

class _BoostServiceScreenState extends State<_BoostServiceScreen> {
  static const _usdToEgpWithMargin = 367.5;

  final _linkCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _waCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  String _selectedPlatform = 'all';
  String _search = '';
  String? _selectedCategory;
  _BoostSmmService? _selectedService;
  bool _sameAsMobile = false;

  bool get _isArabic => context.locale.languageCode == 'ar';

  @override
  void dispose() {
    _linkCtrl.dispose();
    _qtyCtrl.dispose();
    _nameCtrl.dispose();
    _mobileCtrl.dispose();
    _waCtrl.dispose();
    _emailCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  List<_BoostSmmService> get _platformServices {
    final tab = _boostTabs.firstWhere((t) => t.id == _selectedPlatform);
    if (tab.id == 'all') return _boostServices;
    if (tab.id == 'other') {
      final known = _boostTabs
          .where((t) => t.id != 'all' && t.id != 'other')
          .map((t) => t.keyword)
          .where((k) => k.isNotEmpty)
          .toList();
      return _boostServices
          .where((s) =>
              !known.any((k) => s.category.contains(k) || s.name.contains(k)))
          .toList();
    }
    return _boostServices
        .where((s) =>
            s.category.contains(tab.keyword) || s.name.contains(tab.keyword))
        .toList();
  }

  List<String> get _categories {
    final set = <String>{};
    for (final service in _platformServices) {
      set.add(service.category);
    }
    return set.toList();
  }

  List<_BoostSmmService> get _filteredServices {
    var list = _selectedCategory == null
        ? _platformServices
        : _platformServices
            .where((s) => s.category == _selectedCategory)
            .toList();
    final q = _search.trim();
    if (q.isNotEmpty) {
      list = list
          .where((s) =>
              s.name.contains(q) ||
              s.nameEn.toLowerCase().contains(q.toLowerCase()) ||
              s.category.contains(q) ||
              s.categoryEn.toLowerCase().contains(q.toLowerCase()) ||
              s.id.toString().contains(q))
          .toList();
    }
    return list;
  }

  String _serviceName(_BoostSmmService service) =>
      _isArabic ? service.name : service.nameEn;

  String _serviceCategory(_BoostSmmService service) =>
      _isArabic ? service.category : service.categoryEn;

  String _categoryTitle(String category) {
    _BoostSmmService? match;
    for (final service in _boostServices) {
      if (service.category == category) {
        match = service;
        break;
      }
    }
    if (match == null) return category;
    return _serviceCategory(match);
  }

  int get _qty => int.tryParse(_qtyCtrl.text) ?? 0;
  double get _ratePerUnit => _selectedService == null
      ? 0
      : (_selectedService!.rateUsd / 1000) * _usdToEgpWithMargin;
  double get _total => _ratePerUnit * _qty;

  String get _avgTime {
    final svc = _selectedService;
    if (svc == null) return '';
    if (svc.max <= 1000) return _isArabic ? '1-2 ساعة' : '1-2 hours';
    if (svc.max <= 10000) return _isArabic ? '6-24 ساعة' : '6-24 hours';
    if (svc.max <= 100000) return _isArabic ? '1-3 أيام' : '1-3 days';
    return _isArabic ? '3-7 أيام' : '3-7 days';
  }

  void _selectPlatform(String id) {
    setState(() {
      _selectedPlatform = id;
      _selectedCategory = null;
      _selectedService = null;
      _qtyCtrl.clear();
    });
  }

  void _selectService(_BoostSmmService service) {
    setState(() {
      _selectedService = service;
      _selectedCategory = service.category;
      _qtyCtrl.text = service.min.toString();
    });
  }

  Future<void> _showCategoryPicker() async {
    final value = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFF16152A),
      builder: (_) => _BoostPickerSheet<String>(
        title: _isArabic ? 'اختر الفئة' : 'Choose category',
        items: _categories,
        itemTitle: _categoryTitle,
        itemSubtitle: (_) => null,
      ),
    );
    if (value != null) {
      setState(() {
        _selectedCategory = value;
        _selectedService = null;
        _qtyCtrl.clear();
      });
    }
  }

  Future<void> _showServicePicker() async {
    final value = await showModalBottomSheet<_BoostSmmService>(
      context: context,
      backgroundColor: const Color(0xFF16152A),
      isScrollControlled: true,
      builder: (_) => _BoostPickerSheet<_BoostSmmService>(
        title: _isArabic ? 'اختر الخدمة' : 'Choose service',
        items: _filteredServices,
        itemTitle: (item) => '#${item.id}  ${_serviceName(item)}',
        itemSubtitle: (item) => _isArabic
            ? '${item.rateEgpPerThousand} ج.م لكل 1000'
            : '${item.rateEgpPerThousand} EGP per 1000',
      ),
    );
    if (value != null) _selectService(value);
  }

  Future<void> _submit() async {
    final svc = _selectedService;
    if (svc == null) return;
    final msg = StringBuffer()
      ..writeln(
          _isArabic ? 'طلب تزويد سوشيال ميديا' : 'Social media boost request')
      ..writeln('${_isArabic ? 'الخدمة' : 'Service'}: ${_serviceName(svc)}')
      ..writeln('${_isArabic ? 'الفئة' : 'Category'}: ${_serviceCategory(svc)}')
      ..writeln('${_isArabic ? 'الرابط' : 'Link'}: ${_linkCtrl.text.trim()}')
      ..writeln('${_isArabic ? 'الكمية' : 'Quantity'}: ${_qtyCtrl.text.trim()}')
      ..writeln(
          '${_isArabic ? 'التكلفة' : 'Cost'}: ${_total.toStringAsFixed(2)} ${_isArabic ? 'جنيه' : 'EGP'}')
      ..writeln('${_isArabic ? 'الاسم' : 'Name'}: ${_nameCtrl.text.trim()}')
      ..writeln(
          '${_isArabic ? 'الموبايل' : 'Mobile'}: ${_mobileCtrl.text.trim()}')
      ..writeln('${_isArabic ? 'واتساب' : 'WhatsApp'}: ${_waCtrl.text.trim()}');
    final url = Uri.parse(
        'https://wa.me/201010285020?text=${Uri.encodeComponent(msg.toString())}');
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E18),
      body: Stack(
        children: [
          Positioned.fill(
              child: CustomPaint(painter: _ComingSoonBackgroundPainter())),
          SafeArea(
            child: ListView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 36.h),
              children: [
                Center(
                  child: _BoostBackButton(onTap: widget.onBack),
                ),
                SizedBox(height: 70.h),
                _BoostHero(),
                SizedBox(height: 28.h),
                _BoostTabs(
                  selectedId: _selectedPlatform,
                  onSelect: _selectPlatform,
                ),
                SizedBox(height: 18.h),
                _BoostSearchField(
                  onChanged: (value) => setState(() {
                    _search = value;
                    _selectedCategory = null;
                    _selectedService = null;
                  }),
                ),
                _BoostFieldLabel(_isArabic ? 'الفئة' : 'Category'),
                _BoostSelectButton(
                  value: _selectedCategory == null
                      ? (_isArabic ? 'اختر الفئة' : 'Choose category')
                      : _categoryTitle(_selectedCategory!),
                  placeholder: _selectedCategory == null,
                  onTap: _showCategoryPicker,
                ),
                _BoostFieldLabel(_isArabic ? 'الخدمة' : 'Service'),
                _BoostSelectButton(
                  value: _selectedService == null
                      ? (_isArabic ? 'اختر الخدمة' : 'Choose service')
                      : '#${_selectedService!.id}  ${_serviceName(_selectedService!)}\n≈ ${_selectedService!.rateEgpPerThousand} EGP ${_isArabic ? 'لكل 1000' : 'per 1000'}',
                  placeholder: _selectedService == null,
                  onTap: _showServicePicker,
                ),
                _BoostFieldLabel(_isArabic ? 'الرابط' : 'Link'),
                _BoostTextField(controller: _linkCtrl, hint: 'https://...'),
                _BoostFieldLabel(_isArabic ? 'الكمية' : 'Quantity'),
                _BoostTextField(
                  controller: _qtyCtrl,
                  hint: _isArabic ? 'أدخل الكمية' : 'Enter quantity',
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                ),
                if (_selectedService != null) ...[
                  SizedBox(height: 6.h),
                  Text(
                    _isArabic
                        ? 'الحد الأدنى: ${_selectedService!.min} - الحد الأقصى: ${_selectedService!.max}'
                        : 'Min: ${_selectedService!.min} - Max: ${_selectedService!.max}',
                    style: TextStyle(
                        color: const Color(0xFF8B7DC8), fontSize: 12.sp),
                  ),
                  _BoostFieldLabel(_isArabic ? 'متوسط الوقت' : 'Average time'),
                  _BoostReadonlyBox(_avgTime),
                ],
                _BoostFieldLabel(_isArabic ? 'التكلفة' : 'Cost'),
                _BoostReadonlyBox(_total > 0
                    ? '${_total.toStringAsFixed(2)} ${_isArabic ? 'ج.م' : 'EGP'}'
                    : ''),
                SizedBox(height: 22.h),
                Text(
                  _isArabic ? 'بيانات التواصل' : 'Contact details',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                _BoostFieldLabel(_isArabic ? 'الاسم الكامل *' : 'Full name *'),
                _BoostTextField(
                    controller: _nameCtrl,
                    hint: _isArabic
                        ? 'أدخل اسمك الكامل'
                        : 'Enter your full name'),
                _BoostFieldLabel(
                    _isArabic ? 'رقم الموبايل *' : 'Mobile number *'),
                _BoostTextField(
                  controller: _mobileCtrl,
                  hint: '01xxxxxxxxx',
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    if (_sameAsMobile) _waCtrl.text = value;
                  },
                ),
                _BoostFieldLabel(_isArabic ? 'واتساب *' : 'WhatsApp *'),
                Row(
                  children: [
                    Expanded(
                      child: _BoostTextField(
                        controller: _waCtrl,
                        hint: '01xxxxxxxxx',
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    GestureDetector(
                      onTap: () => setState(() {
                        _sameAsMobile = !_sameAsMobile;
                        if (_sameAsMobile) _waCtrl.text = _mobileCtrl.text;
                      }),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 14.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF16152A),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: const Color(0xFF2A2448)),
                        ),
                        child: Text(
                          _isArabic ? 'نفس الموبايل' : 'Same as mobile',
                          style: TextStyle(
                            color: _sameAsMobile
                                ? const Color(0xFFD4AF37)
                                : const Color(0xFF8B7DC8),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                _BoostFieldLabel(_isArabic ? 'البريد الإلكتروني *' : 'Email *'),
                _BoostTextField(
                    controller: _emailCtrl, hint: 'example@email.com'),
                _BoostFieldLabel(_isArabic ? 'ملاحظات' : 'Notes'),
                _BoostTextField(
                    controller: _notesCtrl,
                    hint: _isArabic ? 'أي تفاصيل إضافية' : 'Any extra details',
                    maxLines: 3),
                SizedBox(height: 22.h),
                ElevatedButton.icon(
                  onPressed: _selectedService == null ? null : _submit,
                  icon: Icon(Icons.send_rounded, size: 18.sp),
                  label: Text(
                    _isArabic ? 'إرسال الطلب' : 'Send request',
                    style:
                        TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w900),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6F3FF5),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFF252040),
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r)),
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

class _BoostHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: const Color(0xFF6F3FF5).withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(999.r),
            border: Border.all(
                color: const Color(0xFF6F3FF5).withValues(alpha: 0.42)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(FontAwesomeIcons.rocket,
                  color: const Color(0xFFB9A3FF), size: 13.sp),
              SizedBox(width: 8.w),
              Text(
                _serviceLocaleText(context, 'خدمات التعزيز', 'Boost services'),
                style: TextStyle(
                  color: const Color(0xFFB9A3FF),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 22.h),
        Text(
          _serviceLocaleText(
            context,
            'تزويد منصات السوشيال ميديا',
            'Social Media Boosting',
          ),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFFEDE8FF),
            fontSize: 31.sp,
            height: 1.2,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 14.h),
        Text(
          _serviceLocaleText(
            context,
            'عزّز حضورك الرقمي بخدمات متخصصة عالية الجودة — متابعين، لايكات، مشاهدات وأكثر على جميع منصات التواصل الاجتماعي بأسعار تنافسية وتسليم سريع.',
            'Boost your digital presence with specialized high-quality services: followers, likes, views, and more across all social platforms with competitive prices and fast delivery.',
          ),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF8B7DC8),
            fontSize: 14.sp,
            height: 1.8,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 26.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _BoostStat(
              value: '10,000+',
              label:
                  _serviceLocaleText(context, 'طلب مكتمل', 'Completed orders'),
            ),
            _BoostStatSeparator(),
            _BoostStat(
              value: _serviceLocaleText(context, '24 ساعة', '24 hours'),
              label: _serviceLocaleText(context, 'دعم مستمر', 'Support'),
            ),
            _BoostStatSeparator(),
            _BoostStat(
              value: '100%',
              label:
                  _serviceLocaleText(context, 'آمن وموثوق', 'Safe and trusted'),
            ),
          ],
        ),
        SizedBox(height: 32.h),
        Container(
            height: 1, color: const Color(0xFF6F3FF5).withValues(alpha: 0.25)),
      ],
    );
  }
}

class _BoostStat extends StatelessWidget {
  const _BoostStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: const Color(0xFFB9A3FF),
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFF8B7DC8),
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _BoostStatSeparator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 34.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      color: const Color(0xFF2A2448),
    );
  }
}

class _BoostBackButton extends StatelessWidget {
  const _BoostBackButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 15.h),
        decoration: BoxDecoration(
          color: const Color(0xFFD4AF37).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
              color: const Color(0xFFD4AF37).withValues(alpha: 0.34)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.arrow_forward_rounded,
                color: const Color(0xFFD4AF37), size: 18.sp),
            SizedBox(width: 10.w),
            Text(
              _serviceLocaleText(
                context,
                'الرجوع إلى خدماتنا',
                'Back to services',
              ),
              style: TextStyle(
                color: const Color(0xFFD4AF37),
                fontSize: 14.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BoostTabs extends StatelessWidget {
  const _BoostTabs({required this.selectedId, required this.onSelect});

  final String selectedId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _boostTabs.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3.8,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
      ),
      itemBuilder: (context, index) {
        final tab = _boostTabs[index];
        final active = tab.id == selectedId;
        return GestureDetector(
          onTap: () => onSelect(tab.id),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 180),
            decoration: BoxDecoration(
              gradient: active
                  ? LinearGradient(
                      colors: [Color(0xFFB9A3FF), Color(0xFF6F3FF5)])
                  : null,
              color: active ? null : const Color(0xFF16152A),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color:
                    active ? const Color(0xFF6F3FF5) : const Color(0xFF2A2448),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(tab.icon,
                    color: active ? Colors.white : const Color(0xFF8B7DC8),
                    size: 16.sp),
                SizedBox(width: 8.w),
                Text(
                  tab.localizedName(context),
                  style: TextStyle(
                    color: active ? Colors.white : const Color(0xFF8B7DC8),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BoostSearchField extends StatelessWidget {
  const _BoostSearchField({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: TextStyle(color: Colors.white, fontSize: 14.sp),
      decoration: InputDecoration(
        hintText: _serviceLocaleText(context, 'بحث', 'Search'),
        hintStyle: TextStyle(color: const Color(0xFF8B7DC8), fontSize: 14.sp),
        prefixIcon: Icon(Icons.search_rounded,
            color: const Color(0xFF8B7DC8), size: 20.sp),
        filled: true,
        fillColor: const Color(0xFF16152A),
        contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 18.w),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999.r),
          borderSide: BorderSide(color: const Color(0xFF2A2448)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999.r),
          borderSide: BorderSide(color: const Color(0xFF6F3FF5)),
        ),
      ),
    );
  }
}

class _BoostFieldLabel extends StatelessWidget {
  const _BoostFieldLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, bottom: 7.h),
      child: Text(
        label,
        textAlign: TextAlign.right,
        style: TextStyle(
          color: const Color(0xFF8B7DC8),
          fontSize: 12.sp,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _BoostSelectButton extends StatelessWidget {
  const _BoostSelectButton({
    required this.value,
    required this.placeholder,
    required this.onTap,
  });

  final String value;
  final bool placeholder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
        decoration: BoxDecoration(
          color: const Color(0xFF16152A),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFF2A2448)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: placeholder ? const Color(0xFF8B7DC8) : Colors.white,
                  fontSize: 13.sp,
                  height: 1.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Icon(Icons.keyboard_arrow_down_rounded,
                color: const Color(0xFF8B7DC8), size: 22.sp),
          ],
        ),
      ),
    );
  }
}

class _BoostTextField extends StatelessWidget {
  const _BoostTextField({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.maxLines = 1,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: onChanged,
      style: TextStyle(color: Colors.white, fontSize: 14.sp),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: const Color(0xFF8B7DC8), fontSize: 13.sp),
        filled: true,
        fillColor: const Color(0xFF16152A),
        contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: const Color(0xFF2A2448)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: const Color(0xFF6F3FF5)),
        ),
      ),
    );
  }
}

class _BoostReadonlyBox extends StatelessWidget {
  const _BoostReadonlyBox(this.value);
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: const Color(0xFF16152A),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF2A2448)),
      ),
      child: Text(
        value,
        style: TextStyle(
          color:
              value.isEmpty ? const Color(0xFF8B7DC8) : const Color(0xFFD4AF37),
          fontSize: 14.sp,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _BoostPickerSheet<T> extends StatelessWidget {
  const _BoostPickerSheet({
    required this.title,
    required this.items,
    required this.itemTitle,
    required this.itemSubtitle,
  });

  final String title;
  final List<T> items;
  final String Function(T) itemTitle;
  final String? Function(T) itemSubtitle;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 14.h),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: items.length,
                separatorBuilder: (_, __) => SizedBox(height: 8.h),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final subtitle = itemSubtitle(item);
                  return ListTile(
                    onTap: () => Navigator.pop(context, item),
                    tileColor: const Color(0xFF1E1B30),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r)),
                    title: Text(
                      itemTitle(item),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800),
                    ),
                    subtitle: subtitle == null
                        ? null
                        : Text(
                            subtitle,
                            style: TextStyle(
                                color: const Color(0xFFD4AF37),
                                fontSize: 11.sp),
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BoostTab {
  const _BoostTab(this.id, this.name, this.nameEn, this.icon, this.keyword);

  final String id;
  final String name;
  final String nameEn;
  final IconData icon;
  final String keyword;

  String localizedName(BuildContext context) =>
      context.locale.languageCode == 'en' ? nameEn : name;
}

class _BoostSmmService {
  const _BoostSmmService({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.category,
    required this.categoryEn,
    required this.rateUsd,
    required this.min,
    required this.max,
  });

  final int id;
  final String name;
  final String nameEn;
  final String category;
  final String categoryEn;
  final double rateUsd;
  final int min;
  final int max;

  String get rateEgpPerThousand => (rateUsd * 367.5).toStringAsFixed(2);
}

const _boostTabs = [
  _BoostTab('all', 'الكل', 'All', FontAwesomeIcons.tableCellsLarge, ''),
  _BoostTab(
      'facebook', 'فيسبوك', 'Facebook', FontAwesomeIcons.facebookF, 'فيس'),
  _BoostTab('instagram', 'انستجرام', 'Instagram', FontAwesomeIcons.instagram,
      'انستجرام'),
  _BoostTab('tiktok', 'تيك توك', 'TikTok', FontAwesomeIcons.tiktok, 'تيك'),
  _BoostTab('youtube', 'يوتيوب', 'YouTube', FontAwesomeIcons.youtube, 'يوتيوب'),
  _BoostTab('twitter', 'تويتر', 'X', FontAwesomeIcons.xTwitter, 'تويتر'),
  _BoostTab(
      'snapchat', 'سناب شات', 'Snapchat', FontAwesomeIcons.snapchat, 'سناب'),
  _BoostTab(
      'whatsapp', 'واتساب', 'WhatsApp', FontAwesomeIcons.whatsapp, 'Whatsapp'),
  _BoostTab('telegram', 'تيليجرام', 'Telegram', FontAwesomeIcons.telegram,
      'تيليجرام'),
  _BoostTab(
      'linkedin', 'لينكد إن', 'LinkedIn', FontAwesomeIcons.linkedinIn, 'لينكد'),
  _BoostTab('twitch', 'تويتش', 'Twitch', FontAwesomeIcons.twitch, 'تويتش'),
  _BoostTab('other', 'أخرى', 'Other', FontAwesomeIcons.plus, ''),
];

const _boostServices = [
  _BoostSmmService(
    id: 101,
    name: 'متابعين فيسبوك مصريين جودة عالية',
    nameEn: 'High-quality Egyptian Facebook followers',
    category: 'فيس بوك - متابعين مصريين EG',
    categoryEn: 'Facebook - Egyptian followers EG',
    rateUsd: 0.42,
    min: 100,
    max: 50000,
  ),
  _BoostSmmService(
    id: 102,
    name: 'لايكات فيسبوك منشور مصريين',
    nameEn: 'Egyptian Facebook post likes',
    category: 'فيس بوك - رياكت منشور مصريين رخيصة',
    categoryEn: 'Facebook - Egyptian post reactions',
    rateUsd: 0.31,
    min: 50,
    max: 20000,
  ),
  _BoostSmmService(
    id: 201,
    name: 'متابعين انستجرام جودة عالية',
    nameEn: 'High-quality Instagram followers',
    category: 'انستجرام - متابعين',
    categoryEn: 'Instagram - Followers',
    rateUsd: 0.55,
    min: 100,
    max: 100000,
  ),
  _BoostSmmService(
    id: 202,
    name: 'مشاهدات ريلز انستجرام',
    nameEn: 'Instagram Reels views',
    category: 'انستجرام - مشاهدات',
    categoryEn: 'Instagram - Views',
    rateUsd: 0.18,
    min: 500,
    max: 500000,
  ),
  _BoostSmmService(
    id: 301,
    name: 'متابعين تيك توك',
    nameEn: 'TikTok followers',
    category: 'تيك توك - متابعين',
    categoryEn: 'TikTok - Followers',
    rateUsd: 0.49,
    min: 100,
    max: 100000,
  ),
  _BoostSmmService(
    id: 302,
    name: 'مشاهدات تيك توك سريعة',
    nameEn: 'Fast TikTok views',
    category: 'تيك توك - مشاهدات',
    categoryEn: 'TikTok - Views',
    rateUsd: 0.12,
    min: 1000,
    max: 1000000,
  ),
  _BoostSmmService(
    id: 401,
    name: 'مشاهدات يوتيوب عالية الجودة',
    nameEn: 'High-quality YouTube views',
    category: 'يوتيوب - مشاهدات',
    categoryEn: 'YouTube - Views',
    rateUsd: 0.80,
    min: 1000,
    max: 250000,
  ),
  _BoostSmmService(
    id: 402,
    name: 'مشتركين يوتيوب',
    nameEn: 'YouTube subscribers',
    category: 'يوتيوب - مشتركين',
    categoryEn: 'YouTube - Subscribers',
    rateUsd: 2.10,
    min: 100,
    max: 20000,
  ),
  _BoostSmmService(
    id: 501,
    name: 'متابعين تويتر X',
    nameEn: 'X Twitter followers',
    category: 'تويتر - متابعين',
    categoryEn: 'X Twitter - Followers',
    rateUsd: 0.70,
    min: 100,
    max: 50000,
  ),
  _BoostSmmService(
    id: 601,
    name: 'متابعين سناب شات',
    nameEn: 'Snapchat followers',
    category: 'سناب شات - متابعين',
    categoryEn: 'Snapchat - Followers',
    rateUsd: 1.15,
    min: 100,
    max: 20000,
  ),
  _BoostSmmService(
    id: 701,
    name: 'Whatsapp Poll Votes',
    nameEn: 'WhatsApp poll votes',
    category: 'Whatsapp Poll Votes [Main Provider]',
    categoryEn: 'WhatsApp poll votes [Main Provider]',
    rateUsd: 0.90,
    min: 100,
    max: 20000,
  ),
  _BoostSmmService(
    id: 801,
    name: 'متابعين تيليجرام',
    nameEn: 'Telegram followers',
    category: 'تيليجرام - متابعين',
    categoryEn: 'Telegram - Followers',
    rateUsd: 0.38,
    min: 100,
    max: 100000,
  ),
  _BoostSmmService(
    id: 901,
    name: 'لينكد إن متابعين',
    nameEn: 'LinkedIn followers',
    category: 'لينكد إن [ ميكس] 🔥 متابعين',
    categoryEn: 'LinkedIn [Mix] followers',
    rateUsd: 1.25,
    min: 100,
    max: 30000,
  ),
  _BoostSmmService(
    id: 1001,
    name: 'تويتش متابعين',
    nameEn: 'Twitch followers',
    category: 'تويتش 🔥 متابعين',
    categoryEn: 'Twitch followers',
    rateUsd: 0.95,
    min: 100,
    max: 50000,
  ),
];

class _BrandPlanServiceScreen extends StatefulWidget {
  const _BrandPlanServiceScreen({required this.onBack});

  final VoidCallback onBack;

  @override
  State<_BrandPlanServiceScreen> createState() =>
      _BrandPlanServiceScreenState();
}

class _BrandPlanServiceScreenState extends State<_BrandPlanServiceScreen> {
  int _adsDays = 5;
  int _dailySpend = 240;
  bool _customDesign = false;
  bool _videoMontage = false;
  bool _ugc = false;
  int _customDesignQty = 1;
  int _videoMontageQty = 1;
  int _ugcQty = 1;

  int get _adsTotal => _adsDays * _dailySpend;
  int get _addonsTotal =>
      (_customDesign ? _customDesignQty * 500 : 0) +
      (_videoMontage ? _videoMontageQty * 800 : 0) +
      (_ugc ? _ugcQty * 600 : 0);
  int get _subtotal => _adsTotal + _addonsTotal;
  int get _commission => (_subtotal * 0.2).round();
  int get _grandTotal => _subtotal + _commission;
  bool get _isArabic => context.locale.languageCode == 'ar';

  void _setAdsDays(int delta) {
    setState(() {
      _adsDays = math.max(5, _adsDays + delta);
      if (_adsTotal < 1200) _dailySpend = (1200 / _adsDays).ceil();
    });
  }

  void _setDailySpend(int delta) {
    setState(() {
      _dailySpend = math.max(10, _dailySpend + delta);
      if (_adsTotal < 1200) _dailySpend = (1200 / _adsDays).ceil();
    });
  }

  void _changeAddonQty(String id, int delta) {
    setState(() {
      switch (id) {
        case 'design':
          _customDesignQty = math.max(1, _customDesignQty + delta);
        case 'video':
          _videoMontageQty = math.max(1, _videoMontageQty + delta);
        case 'ugc':
          _ugcQty = math.max(1, _ugcQty + delta);
      }
    });
  }

  Future<void> _orderPlan() async {
    final lines = StringBuffer()
      ..writeln(_isArabic ? 'طلب خطة براند مخصصة' : 'Custom brand plan request')
      ..writeln(_isArabic
          ? 'إعلانات فيسبوك وانستجرام: $_adsDays أيام × $_dailySpend ج.م'
          : 'Facebook and Instagram ads: $_adsDays days x $_dailySpend EGP')
      ..writeln(_isArabic
          ? 'إجمالي الإعلانات: $_adsTotal ج.م'
          : 'Ads total: $_adsTotal EGP');
    if (_customDesign) lines.writeln('Customised Design × $_customDesignQty');
    if (_videoMontage) lines.writeln('Video Montage × $_videoMontageQty');
    if (_ugc) lines.writeln('UGC × $_ugcQty');
    lines
      ..writeln(
          _isArabic ? 'المجموع: $_subtotal ج.م' : 'Subtotal: $_subtotal EGP')
      ..writeln(_isArabic
          ? 'نسبتنا 20%: $_commission ج.م'
          : 'Our 20% fee: $_commission EGP')
      ..writeln(_isArabic
          ? 'الإجمالي الكلي: $_grandTotal ج.م'
          : 'Grand total: $_grandTotal EGP');
    await launchUrl(
      Uri.parse(
          'https://wa.me/201010285020?text=${Uri.encodeComponent(lines.toString())}'),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E18),
      body: Stack(
        children: [
          Positioned.fill(
              child: CustomPaint(painter: _ComingSoonBackgroundPainter())),
          SafeArea(
            child: ListView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 36.h),
              children: [
                Center(child: _BoostBackButton(onTap: widget.onBack)),
                SizedBox(height: 44.h),
                _BrandHero(),
                SizedBox(height: 26.h),
                _BrandEditPolicyCard(),
                SizedBox(height: 28.h),
                _BrandImagesGrid(),
                SizedBox(height: 42.h),
                _BrandCalculatorHeader(),
                SizedBox(height: 20.h),
                _BrandAdsCard(
                  adsDays: _adsDays,
                  dailySpend: _dailySpend,
                  adsTotal: _adsTotal,
                  onDaysMinus: () => _setAdsDays(-1),
                  onDaysPlus: () => _setAdsDays(1),
                  onSpendMinus: () => _setDailySpend(-10),
                  onSpendPlus: () => _setDailySpend(10),
                ),
                SizedBox(height: 18.h),
                _BrandAddonCard(
                  title: 'Customised Design',
                  desc: _serviceLocaleText(
                    context,
                    'تصميمات مخصصة احترافية لحملتك الإعلانية',
                    'Professional custom designs for your ad campaign',
                  ),
                  icon: Icons.palette_rounded,
                  price: 500,
                  enabled: _customDesign,
                  qty: _customDesignQty,
                  onToggle: () =>
                      setState(() => _customDesign = !_customDesign),
                  onMinus: () => _changeAddonQty('design', -1),
                  onPlus: () => _changeAddonQty('design', 1),
                ),
                SizedBox(height: 14.h),
                _BrandAddonCard(
                  title: 'Video Montage',
                  desc: _serviceLocaleText(
                    context,
                    'مونتاج فيديو احترافي لمحتوى حملتك',
                    'Professional video montage for your campaign content',
                  ),
                  icon: Icons.movie_creation_rounded,
                  price: 800,
                  enabled: _videoMontage,
                  qty: _videoMontageQty,
                  onToggle: () =>
                      setState(() => _videoMontage = !_videoMontage),
                  onMinus: () => _changeAddonQty('video', -1),
                  onPlus: () => _changeAddonQty('video', 1),
                ),
                SizedBox(height: 14.h),
                _BrandAddonCard(
                  title: 'UGC',
                  desc: _serviceLocaleText(
                    context,
                    'محتوى مستخدم حقيقي وموثوق لزيادة التفاعل',
                    'Authentic user-generated content to increase engagement',
                  ),
                  icon: Icons.person_pin_circle_rounded,
                  price: 600,
                  enabled: _ugc,
                  qty: _ugcQty,
                  onToggle: () => setState(() => _ugc = !_ugc),
                  onMinus: () => _changeAddonQty('ugc', -1),
                  onPlus: () => _changeAddonQty('ugc', 1),
                ),
                SizedBox(height: 22.h),
                _BrandSummaryCard(
                  adsTotal: _adsTotal,
                  customDesign: _customDesign,
                  customDesignQty: _customDesignQty,
                  videoMontage: _videoMontage,
                  videoMontageQty: _videoMontageQty,
                  ugc: _ugc,
                  ugcQty: _ugcQty,
                  subtotal: _subtotal,
                  commission: _commission,
                  grandTotal: _grandTotal,
                  onOrder: _orderPlan,
                ),
                SizedBox(height: 70.h),
                _BrandFinalCta(onTap: _orderPlan),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: const Color(0xFFD4AF37).withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(999.r),
            border: Border.all(
                color: const Color(0xFFD4AF37).withValues(alpha: 0.35)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _OrbitDot(color: const Color(0xFFD4AF37), size: 7.w),
              SizedBox(width: 9.w),
              Icon(Icons.brush_rounded,
                  color: const Color(0xFFD4AF37), size: 14.sp),
              SizedBox(width: 7.w),
              Text(
                _serviceLocaleText(
                    context, 'خطة براند مخصصة', 'Custom brand plan'),
                style: TextStyle(
                  color: const Color(0xFFD4AF37),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        Text(
          _serviceLocaleText(
              context, 'خدمات خطة براند مخصصة', 'Custom brand plan services'),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFFEDE8FF),
            fontSize: 31.sp,
            height: 1.18,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          _serviceLocaleText(
            context,
            'خطة تسويقية متكاملة ومخصصة لعلامتك التجارية لتحقيق أهدافك التسويقية بفعالية',
            'A complete custom marketing plan built around your brand goals.',
          ),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFFB9A3FF),
            fontSize: 14.sp,
            height: 1.7,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _BrandEditPolicyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1B30),
        borderRadius: BorderRadius.circular(20.r),
        border:
            Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.26)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14.r),
            child: _ServiceDetailImage(
              assetImage: 'assets/images/packages/design/edit-policy.webp',
              networkImage:
                  'https://etba3ly-dm.com/packages/design/edit-policy.webp',
              fit: BoxFit.cover,
              fallbackIcon: Icons.file_present_rounded,
            ),
          ),
          SizedBox(height: 18.h),
          Icon(Icons.edit_document,
              color: const Color(0xFFD4AF37), size: 34.sp),
          SizedBox(height: 10.h),
          Text(
            _serviceLocaleText(context, 'سياسة التعديلات', 'Revision policy'),
            style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 10.h),
          Text(
            _serviceLocaleText(
              context,
              'نحرص على تقديم أفضل جودة ممكنة في التصميمات والفيديوهات. لذلك نوفر تعديل مجاني واحد بعد التسليم لضبط النتيجة النهائية بالشكل المناسب لرؤيتك، وأي تعديلات إضافية بعد ذلك قد تشمل رسوم حسب حجم التعديل.',
              'We provide one free revision after delivery to fine-tune the final result. Extra revisions may include fees depending on the requested changes.',
            ),
            style: TextStyle(
                color: const Color(0xFFB9A3FF), fontSize: 14.sp, height: 1.75),
          ),
        ],
      ),
    );
  }
}

class _BrandImagesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final images = [
      'packages/customised/Customised_1.webp',
      'packages/customised/Customised_2.webp',
      'packages/customised/Customised_3.webp',
    ];
    return Column(
      children: [
        for (final image in images) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: AspectRatio(
              aspectRatio: 1,
              child: _ServiceDetailImage(
                assetImage: 'assets/images/$image',
                networkImage: 'https://etba3ly-dm.com/$image',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ],
    );
  }
}

class _BrandCalculatorHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: const Color(0xFFD4AF37).withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(999.r),
            border: Border.all(
                color: const Color(0xFFD4AF37).withValues(alpha: 0.30)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _OrbitDot(color: const Color(0xFFD4AF37), size: 7.w),
              SizedBox(width: 9.w),
              Icon(Icons.calculate_rounded,
                  color: const Color(0xFFD4AF37), size: 14.sp),
              SizedBox(width: 7.w),
              Text(
                _serviceLocaleText(context, 'احسب خطتك', 'Calculate plan'),
                style: TextStyle(
                    color: const Color(0xFFD4AF37),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
        SizedBox(height: 18.h),
        Text(
          _serviceLocaleText(
              context, 'خطة براند مخصصة Customised', 'Customised brand plan'),
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontSize: 28.sp,
              fontWeight: FontWeight.w900),
        ),
        SizedBox(height: 12.h),
        Container(
          width: 56.w,
          height: 3.h,
          decoration: BoxDecoration(
            color: const Color(0xFFD4AF37),
            borderRadius: BorderRadius.circular(999.r),
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          _serviceLocaleText(
            context,
            'اختر مكونات خطتك واحسب التكلفة الإجمالية بشكل فوري',
            'Choose your plan items and calculate the total instantly',
          ),
          textAlign: TextAlign.center,
          style: TextStyle(
              color: const Color(0xFFB9A3FF), fontSize: 14.sp, height: 1.6),
        ),
      ],
    );
  }
}

class _BrandAdsCard extends StatelessWidget {
  const _BrandAdsCard({
    required this.adsDays,
    required this.dailySpend,
    required this.adsTotal,
    required this.onDaysMinus,
    required this.onDaysPlus,
    required this.onSpendMinus,
    required this.onSpendPlus,
  });

  final int adsDays, dailySpend, adsTotal;
  final VoidCallback onDaysMinus, onDaysPlus, onSpendMinus, onSpendPlus;

  @override
  Widget build(BuildContext context) {
    return _BrandCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF1877F2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.facebook_rounded,
                    color: Colors.white, size: 28.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _serviceLocaleText(context, 'إعلانات فيسبوك وانستجرام',
                          'Facebook and Instagram ads'),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      _serviceLocaleText(
                        context,
                        'الحد الأدنى 5 أيام - الحد الأدنى للصرف الإعلاني 1,200 ج.م',
                        'Minimum 5 days - minimum ad spend 1,200 EGP',
                      ),
                      style: TextStyle(
                          color: const Color(0xFFB9A3FF),
                          fontSize: 12.sp,
                          height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          _BrandStepper(
              label: _serviceLocaleText(context, 'عدد الأيام', 'Days'),
              value: adsDays,
              note: _serviceLocaleText(
                  context, 'الحد الأدنى 5 أيام', 'Minimum 5 days'),
              onMinus: onDaysMinus,
              onPlus: onDaysPlus),
          SizedBox(height: 16.h),
          _BrandStepper(
              label: _serviceLocaleText(
                  context, 'الصرف اليومي (ج.م)', 'Daily spend (EGP)'),
              value: dailySpend,
              note: _serviceLocaleText(
                  context,
                  'الحد الأدنى 1,200 ج.م / 5 أيام',
                  'Minimum 1,200 EGP / 5 days'),
              onMinus: onSpendMinus,
              onPlus: onSpendPlus),
          SizedBox(height: 16.h),
          Text(
              _serviceLocaleText(
                  context, 'إجمالي الصرف الإعلاني', 'Total ad spend'),
              style: TextStyle(
                  color: const Color(0xFFB9A3FF),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800)),
          SizedBox(height: 8.h),
          _BrandGoldBox(
              _serviceLocaleText(context, '$adsTotal ج.م', '$adsTotal EGP')),
        ],
      ),
    );
  }
}

class _BrandAddonCard extends StatelessWidget {
  const _BrandAddonCard({
    required this.title,
    required this.desc,
    required this.icon,
    required this.price,
    required this.enabled,
    required this.qty,
    required this.onToggle,
    required this.onMinus,
    required this.onPlus,
  });

  final String title, desc;
  final IconData icon;
  final int price, qty;
  final bool enabled;
  final VoidCallback onToggle, onMinus, onPlus;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: _BrandCard(
        active: enabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 28.w,
                  height: 28.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        enabled ? const Color(0xFFD4AF37) : Colors.transparent,
                    border: Border.all(color: const Color(0xFFD4AF37)),
                  ),
                  child: Icon(enabled ? Icons.check : Icons.add,
                      color: enabled ? Colors.black : const Color(0xFFD4AF37),
                      size: 17.sp),
                ),
                Spacer(),
                Icon(icon, color: const Color(0xFFD4AF37), size: 28.sp),
              ],
            ),
            SizedBox(height: 18.h),
            Text(title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w900)),
            SizedBox(height: 7.h),
            Text(desc,
                style: TextStyle(
                    color: const Color(0xFFB9A3FF),
                    fontSize: 13.sp,
                    height: 1.5)),
            SizedBox(height: 14.h),
            if (enabled) ...[
              _BrandStepper(
                  label: _serviceLocaleText(context, 'الكمية', 'Quantity'),
                  value: qty,
                  note:
                      _serviceLocaleText(context, 'الحد الأدنى 1', 'Minimum 1'),
                  onMinus: onMinus,
                  onPlus: onPlus,
                  small: true),
              SizedBox(height: 12.h),
            ],
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                      text: '$price',
                      style: TextStyle(
                          color: const Color(0xFFD4AF37),
                          fontWeight: FontWeight.w900,
                          fontSize: 17.sp)),
                  TextSpan(
                      text: _serviceLocaleText(
                          context, ' ج.م / اشتراك', ' EGP / subscription'),
                      style: TextStyle(
                          color: const Color(0xFFB9A3FF),
                          fontWeight: FontWeight.w800,
                          fontSize: 12.sp)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandSummaryCard extends StatelessWidget {
  const _BrandSummaryCard({
    required this.adsTotal,
    required this.customDesign,
    required this.customDesignQty,
    required this.videoMontage,
    required this.videoMontageQty,
    required this.ugc,
    required this.ugcQty,
    required this.subtotal,
    required this.commission,
    required this.grandTotal,
    required this.onOrder,
  });

  final int adsTotal,
      customDesignQty,
      videoMontageQty,
      ugcQty,
      subtotal,
      commission,
      grandTotal;
  final bool customDesign, videoMontage, ugc;
  final VoidCallback onOrder;

  @override
  Widget build(BuildContext context) {
    return _BrandCard(
      child: Column(
        children: [
          _BrandSummaryRow(
              icon: FontAwesomeIcons.facebookF,
              label:
                  _serviceLocaleText(context, 'إجمالي الإعلانات', 'Ads total'),
              value: _serviceLocaleText(
                  context, '$adsTotal ج.م', '$adsTotal EGP')),
          if (customDesign)
            _BrandSummaryRow(
                icon: FontAwesomeIcons.palette,
                label: 'Customised Design × $customDesignQty',
                value: _serviceLocaleText(
                    context,
                    '${customDesignQty * 500} ج.م',
                    '${customDesignQty * 500} EGP')),
          if (videoMontage)
            _BrandSummaryRow(
                icon: FontAwesomeIcons.film,
                label: 'Video Montage × $videoMontageQty',
                value: _serviceLocaleText(
                    context,
                    '${videoMontageQty * 800} ج.م',
                    '${videoMontageQty * 800} EGP')),
          if (ugc)
            _BrandSummaryRow(
                icon: FontAwesomeIcons.user,
                label: 'UGC × $ugcQty',
                value: _serviceLocaleText(
                    context, '${ugcQty * 600} ج.م', '${ugcQty * 600} EGP')),
          Divider(color: const Color(0xFF332D55), height: 24.h),
          _BrandSummaryRow(
              label: _serviceLocaleText(context, 'المجموع', 'Subtotal'),
              value: _serviceLocaleText(
                  context, '$subtotal ج.م', '$subtotal EGP')),
          _BrandSummaryRow(
              icon: FontAwesomeIcons.percent,
              label: _serviceLocaleText(context, 'نسبتنا 20%', 'Our 20% fee'),
              value: _serviceLocaleText(
                  context, '$commission ج.م', '$commission EGP'),
              muted: true),
          _BrandSummaryRow(
              icon: FontAwesomeIcons.star,
              label:
                  _serviceLocaleText(context, 'الإجمالي الكلي', 'Grand total'),
              value: _serviceLocaleText(
                  context, '$grandTotal ج.م', '$grandTotal EGP'),
              total: true),
          SizedBox(height: 18.h),
          _GoldActionButton(
              label: _serviceLocaleText(
                  context, 'اطلب خطتك الآن', 'Order your plan now'),
              onTap: onOrder),
        ],
      ),
    );
  }
}

class _BrandFinalCta extends StatelessWidget {
  const _BrandFinalCta({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(22.r),
      color: const Color(0xFF0A0812),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _serviceLocaleText(
                context, 'هل أنت مستعد لتنطلق?', 'Ready to get started?'),
            textAlign: TextAlign.right,
            style: TextStyle(
                color: Colors.white,
                fontSize: 27.sp,
                fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 8.h),
          Text(
            _serviceLocaleText(
              context,
              'انضم إلى أكثر من 5000 شركة وثقت في اطبعلي لبناء حضورها الرقمي',
              'Join 5,000+ businesses that trusted Etbaaly to build their digital presence',
            ),
            textAlign: TextAlign.right,
            style: TextStyle(
                color: const Color(0xFFB9A3FF), fontSize: 14.sp, height: 1.6),
          ),
          SizedBox(height: 22.h),
          _GoldActionButton(
              label: _serviceLocaleText(context, 'احجز استشارتك المجانية',
                  'Book your free consultation'),
              onTap: onTap),
        ],
      ),
    );
  }
}

class _BrandCard extends StatelessWidget {
  const _BrandCard({required this.child, this.active = false});

  final Widget child;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1B30),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: active
              ? const Color(0xFFD4AF37)
              : const Color(0xFF6F3FF5).withValues(alpha: 0.25),
          width: active ? 1.5 : 1,
        ),
      ),
      child: child,
    );
  }
}

class _BrandStepper extends StatelessWidget {
  const _BrandStepper({
    required this.label,
    required this.value,
    required this.note,
    required this.onMinus,
    required this.onPlus,
    this.small = false,
  });

  final String label, note;
  final int value;
  final VoidCallback onMinus, onPlus;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: const Color(0xFFB9A3FF),
                fontSize: 13.sp,
                fontWeight: FontWeight.w900)),
        SizedBox(height: 8.h),
        Row(
          children: [
            _StepBtn(icon: Icons.remove, onTap: onMinus),
            SizedBox(width: 8.w),
            Container(
              width: small ? 56.w : 86.w,
              height: 44.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF16152A),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: const Color(0xFF332D55)),
              ),
              child: Text('$value',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w900)),
            ),
            SizedBox(width: 8.w),
            _StepBtn(icon: Icons.add, onTap: onPlus),
          ],
        ),
        SizedBox(height: 6.h),
        Text(note,
            style: TextStyle(color: const Color(0xFF8B7DC8), fontSize: 11.sp)),
      ],
    );
  }
}

class _StepBtn extends StatelessWidget {
  const _StepBtn({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42.w,
        height: 42.w,
        decoration: BoxDecoration(
          color: const Color(0xFF16152A),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
              color: const Color(0xFFD4AF37).withValues(alpha: 0.45)),
        ),
        child: Icon(icon, color: const Color(0xFFD4AF37), size: 20.sp),
      ),
    );
  }
}

class _BrandGoldBox extends StatelessWidget {
  const _BrandGoldBox(this.value);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: const Color(0xFFD4AF37).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border:
            Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.35)),
      ),
      child: Text(value,
          style: TextStyle(
              color: const Color(0xFFD4AF37),
              fontSize: 22.sp,
              fontWeight: FontWeight.w900)),
    );
  }
}

class _BrandSummaryRow extends StatelessWidget {
  const _BrandSummaryRow({
    required this.label,
    required this.value,
    this.icon,
    this.muted = false,
    this.total = false,
  });

  final IconData? icon;
  final String label, value;
  final bool muted, total;

  @override
  Widget build(BuildContext context) {
    final color = total
        ? const Color(0xFFD4AF37)
        : (muted ? const Color(0xFFB9A3FF) : Colors.white);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Text(value,
              style: TextStyle(
                  color: color,
                  fontSize: total ? 18.sp : 14.sp,
                  fontWeight: FontWeight.w900)),
          Spacer(),
          Text(label,
              style: TextStyle(
                  color: color,
                  fontSize: total ? 17.sp : 14.sp,
                  fontWeight: FontWeight.w900)),
          if (icon != null) ...[
            SizedBox(width: 8.w),
            FaIcon(icon, color: const Color(0xFFD4AF37), size: 15.sp),
          ],
        ],
      ),
    );
  }
}

class _GoldActionButton extends StatelessWidget {
  const _GoldActionButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFD4AF37),
      borderRadius: BorderRadius.circular(999.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
                color: Colors.black,
                fontSize: 15.sp,
                fontWeight: FontWeight.w900),
          ),
        ),
      ),
    );
  }
}

class _ComingSoonBackButton extends StatelessWidget {
  const _ComingSoonBackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.30),
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chevron_right_rounded, color: Colors.white, size: 18.sp),
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
    );
  }
}

class _OrbitLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 126.w,
      height: 126.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 112.w,
            height: 112.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.32)),
            ),
          ),
          Container(
            width: 88.w,
            height: 88.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: const Color(0xFFB9A3FF).withValues(alpha: 0.24)),
            ),
          ),
          Positioned(
            top: 13.h,
            left: 22.w,
            child: _OrbitDot(color: const Color(0xFFD4AF37), size: 8.w),
          ),
          Positioned(
            bottom: 10.h,
            child: _OrbitDot(color: const Color(0xFF7C3AED), size: 6.w),
          ),
          Container(
            width: 72.w,
            height: 72.w,
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF252040),
              border: Border.all(color: const Color(0xFFD4AF37), width: 2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.14),
                  blurRadius: 22.r,
                ),
              ],
            ),
            child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }
}

class _OrbitDot extends StatelessWidget {
  const _OrbitDot({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _ComingSoonBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 11.h),
      decoration: BoxDecoration(
        color: const Color(0xFFD4AF37).withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999.r),
        border:
            Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _OrbitDot(color: const Color(0xFFD4AF37), size: 8.w),
          SizedBox(width: 10.w),
          Text(
            _serviceLocaleText(context, 'قادمون قريباً', 'Coming soon'),
            style: TextStyle(
              color: const Color(0xFFD4AF37),
              fontSize: 15.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeTile extends StatelessWidget {
  const _TimeTile({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64.w,
          height: 62.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF252040).withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
                color: const Color(0xFFB9A3FF).withValues(alpha: 0.18)),
          ),
          child: Text(
            value.toString().padLeft(2, '0'),
            style: TextStyle(
              color: const Color(0xFFD4AF37),
              fontSize: 30.sp,
              height: 1,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFFB9A3FF),
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _TimeSeparator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 28.h, left: 8.w, right: 8.w),
      child: Text(
        ':',
        style: TextStyle(
          color: const Color(0xFFD4AF37).withValues(alpha: 0.46),
          fontSize: 34.sp,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _ProgressSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              '25%',
              style: TextStyle(
                color: const Color(0xFFD4AF37),
                fontSize: 13.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            Spacer(),
            Row(
              children: [
                FaIcon(FontAwesomeIcons.code,
                    color: const Color(0xFFB9A3FF), size: 13.sp),
                SizedBox(width: 8.w),
                Text(
                  _serviceLocaleText(context, 'نسبة الإنجاز', 'Progress'),
                  style: TextStyle(
                    color: const Color(0xFFB9A3FF),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 16.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(999.r),
          child: SizedBox(
            height: 10.h,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ColoredBox(color: Colors.white.withValues(alpha: 0.16)),
                FractionallySizedBox(
                  alignment: AlignmentDirectional.centerStart,
                  widthFactor: 0.25,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF6F3FF5),
                          const Color(0xFFD4AF37)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/*
class HomeButton extends StatelessWidget {
  const HomeButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xFF332D55),
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
              color: const Color(0xFFB9A3FF).withValues(alpha: 0.16)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'الصفحة الرئيسية',
              style: TextStyle(
                color: const Color(0xFFEDE8FF),
                fontSize: 14.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(width: 10.w),
            Icon(Icons.arrow_forward_rounded,
                color: const Color(0xFFB9A3FF), size: 20.sp),
          ],
        ),
      ),
    );
  }
}

*/
class _ComingSoonBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF221447),
          const Color(0xFF0F0E18),
          const Color(0xFF171029),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bg);

    final dotPaint = Paint()
      ..color = const Color(0xFFB9A3FF).withValues(alpha: 0.045)
      ..strokeWidth = 1;
    const step = 22.0;
    for (double x = 0; x < size.width; x += step) {
      for (double y = 0; y < size.height; y += step) {
        canvas.drawCircle(Offset(x, y), 0.8, dotPaint);
      }
    }

    final linePaint = Paint()
      ..color = const Color(0xFF8B5CF6).withValues(alpha: 0.48)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final paths = <Path>[
      Path()
        ..moveTo(size.width * 0.02, size.height * 0.28)
        ..lineTo(size.width * 0.21, size.height * 0.10),
      Path()
        ..moveTo(0, size.height * 0.86)
        ..lineTo(size.width * 0.28, size.height)
        ..lineTo(size.width * 0.55, size.height * 0.86)
        ..lineTo(size.width * 0.76, size.height),
      Path()
        ..moveTo(size.width, size.height * 0.78)
        ..lineTo(size.width * 0.78, size.height * 0.91)
        ..lineTo(size.width * 0.66, size.height * 0.84),
      Path()
        ..moveTo(size.width * 0.46, size.height)
        ..lineTo(size.width * 0.46, size.height * 0.86),
      Path()
        ..moveTo(size.width * 0.92, 0)
        ..lineTo(size.width, size.height * 0.07),
    ];
    for (final path in paths) {
      canvas.drawPath(path, linePaint);
    }

    final radius = math.min(size.width, size.height) * 0.42;
    final glow = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF6F3FF5).withValues(alpha: 0.22),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.52, size.height * 0.56),
          radius: radius,
        ),
      );
    canvas.drawCircle(
        Offset(size.width * 0.52, size.height * 0.56), radius, glow);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

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
          detail.packageTitle(context),
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
    required this.assetImage,
    required this.imageUrl,
    required this.qty,
    required this.onIncrement,
    required this.onDecrement,
    required this.isInCart,
    required this.onAdd,
  });

  final _ServicePackage pkg;
  final String assetImage;
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
            child: _ServiceDetailImage(
              assetImage: assetImage,
              networkImage: imageUrl,
              fit: BoxFit.cover,
              fallbackIcon: Icons.image_not_supported_outlined,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pkg.name(context),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  pkg.desc(context),
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
                      isInCart
                          ? Icons.check_rounded
                          : Icons.add_shopping_cart_rounded,
                      size: 17.sp,
                    ),
                    label: Text(
                      _serviceLocaleText(
                          context,
                          isInCart ? 'تم الإضافة ✓' : 'أضف للطلب',
                          isInCart ? 'Added ✓' : 'Add to order'),
                      style: TextStyle(
                          fontWeight: FontWeight.w900, fontSize: 14.sp),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isInCart
                          ? Color(0xFFD4AF37).withValues(alpha: 0.15)
                          : Color(0xFFD4AF37),
                      foregroundColor:
                          isInCart ? Color(0xFFD4AF37) : Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 13.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r)),
                      side: isInCart
                          ? BorderSide(
                              color: Color(0xFFD4AF37).withValues(alpha: 0.5))
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

class _ServiceDetailImage extends StatelessWidget {
  const _ServiceDetailImage({
    required this.assetImage,
    required this.networkImage,
    required this.fit,
    this.fallbackIcon = Icons.image_outlined,
  });

  final String assetImage;
  final String networkImage;
  final BoxFit fit;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetImage,
      fit: fit,
      width: double.infinity,
      errorBuilder: (_, __, ___) => CachedNetworkImage(
        imageUrl: networkImage,
        fit: fit,
        width: double.infinity,
        placeholder: (_, __) => ColoredBox(color: Color(0xFF1A1035)),
        errorWidget: (_, __, ___) => ColoredBox(
          color: Color(0xFF1A1035),
          child: Center(
            child: Icon(
              fallbackIcon,
              color: Colors.white24,
              size: 40.sp,
            ),
          ),
        ),
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
  _EditPolicyCard({
    required this.assetImage,
    required this.imageUrl,
  });

  final String assetImage;
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
          _ServiceDetailImage(
            assetImage: assetImage,
            networkImage: imageUrl,
            fit: BoxFit.contain,
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

// ─── Service CTA Banner ───────────────────────────────────────────────────────

class _ServiceCtaBanner extends StatelessWidget {
  _ServiceCtaBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(22.w, 28.h, 22.w, 28.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF1A0A38), Color(0xFF0F0820), Color(0xFF0A0618)],
        ),
        border: Border.all(color: Color(0xFFD4AF37).withValues(alpha: 0.22)),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFD4AF37).withValues(alpha: 0.06),
            blurRadius: 32.r,
          ),
        ],
      ),
      child: CustomPaint(
        painter: _CtaGridPainter(),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
              decoration: BoxDecoration(
                color: Color(0xFFD4AF37).withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(999.r),
                border: Border.all(
                    color: Color(0xFFD4AF37).withValues(alpha: 0.30)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.rocket_launch_rounded,
                      color: Color(0xFFD4AF37), size: 13.sp),
                  SizedBox(width: 6.w),
                  Text(
                    'auto.t_300f7da948'.tr(),
                    style: TextStyle(
                      color: Color(0xFFD4AF37),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'auto.t_b3e8f9c2d1'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 26.sp,
                fontWeight: FontWeight.w900,
                height: 1.2,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'auto.t_a4d7c8e9f2'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.58),
                fontSize: 13.sp,
                height: 1.65,
              ),
            ),
            SizedBox(height: 22.h),
            Material(
              color: Color(0xFFD4AF37),
              borderRadius: BorderRadius.circular(999.r),
              child: InkWell(
                borderRadius: BorderRadius.circular(999.r),
                onTap: onTap,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'auto.t_c5b9d4f8e3'.tr(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(Icons.arrow_forward_rounded,
                          color: Colors.black, size: 18.sp),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: Duration(milliseconds: 420))
        .slideY(begin: 0.06);
  }
}

class _CtaGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x0FD4AF37)
      ..strokeWidth = 1;
    const step = 48.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
    final totalQty = cartItems.fold(0, (s, p) => s + (quantities[p.id] ?? 1));
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
                  border: Border.all(
                      color: Color(0xFFD4AF37).withValues(alpha: 0.3)),
                ),
                child: Icon(Icons.receipt_long_rounded,
                    color: Color(0xFFD4AF37), size: 18.sp),
              ),
              SizedBox(width: 12.w),
              Text(
                _serviceLocaleText(context, 'ملخص الطلب', 'Order summary'),
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
                  _serviceLocaleText(
                      context, '$totalQty وحدة', '$totalQty items'),
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
                _serviceLocaleText(context, 'الإجمالي الكلي', 'Grand total'),
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
                _serviceLocaleText(
                    context, 'معاينة الفاتورة والدفع', 'Preview invoice'),
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
    )
        .animate()
        .fadeIn(duration: Duration(milliseconds: 300))
        .slideY(begin: 0.08);
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
            pkg.name(context),
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
  final _phoneCtrl = TextEditingController();
  final _waCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  bool _sameAsPhone = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _phoneCtrl.addListener(_syncWa);
  }

  void _syncWa() {
    if (_sameAsPhone) _waCtrl.text = _phoneCtrl.text;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _waCtrl.dispose();
    _emailCtrl.dispose();
    _companyCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final waNum = _sameAsPhone ? _phoneCtrl.text.trim() : _waCtrl.text.trim();
    if (_nameCtrl.text.trim().isEmpty ||
        _phoneCtrl.text.trim().isEmpty ||
        waNum.isEmpty) {
      return;
    }
    setState(() => _submitting = true);

    final lines = StringBuffer();
    lines.writeln(widget.isArabic
        ? 'طلب خدمة جديد من ${widget.detail.title}'
        : 'New service request for ${widget.detail.title}');
    lines.writeln('');
    lines.writeln(
        '${widget.isArabic ? 'الاسم' : 'Name'}: ${_nameCtrl.text.trim()}');
    lines.writeln(
        '${widget.isArabic ? 'الموبايل' : 'Mobile'}: ${_phoneCtrl.text.trim()}');
    lines.writeln('${widget.isArabic ? 'واتساب' : 'WhatsApp'}: $waNum');
    if (_emailCtrl.text.trim().isNotEmpty) {
      lines.writeln(
          '${widget.isArabic ? 'البريد الإلكتروني' : 'Email'}: ${_emailCtrl.text.trim()}');
    }
    if (_companyCtrl.text.trim().isNotEmpty) {
      lines.writeln(
          '${widget.isArabic ? 'اسم الشركة' : 'Company'}: ${_companyCtrl.text.trim()}');
    }
    if (_notesCtrl.text.trim().isNotEmpty) {
      lines.writeln(
          '${widget.isArabic ? 'تفاصيل الطلب' : 'Order details'}: ${_notesCtrl.text.trim()}');
    }
    lines.writeln('');
    lines.writeln(widget.isArabic ? '--- الباقات ---' : '--- Packages ---');
    for (final pkg in widget.cartItems) {
      final qty = widget.quantities[pkg.id] ?? 1;
      lines.writeln(
          '• ${pkg.name(context)} × $qty = ${pkg.price * qty} ${widget.isArabic ? 'جنيه' : 'EGP'}');
    }
    lines.writeln('');
    lines.writeln(
        '${widget.isArabic ? 'الإجمالي' : 'Total'}: ${widget.grandTotal} ${widget.isArabic ? 'جنيه' : 'EGP'}');

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
                          widget.isArabic ? 'تأكيد الطلب' : 'Confirm order',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Builder(builder: (_) {
                          final totalQty = widget.cartItems.fold(
                              0, (s, p) => s + (widget.quantities[p.id] ?? 1));
                          return Text(
                            widget.isArabic
                                ? '${widget.grandTotal} جنيه — $totalQty وحدة'
                                : '${widget.grandTotal} EGP - $totalQty items',
                            style: TextStyle(
                              color: Color(0xFFD4AF37),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Container(
                  height: 1.h, color: Colors.white.withValues(alpha: 0.06)),
              SizedBox(height: 14.h),
              // ─── ملخص الخدمات المختارة ───────────────────────────────
              if (widget.cartItems.isNotEmpty) ...[
                _FormSectionLabel(
                    icon: Icons.receipt_outlined,
                    title: widget.isArabic
                        ? 'الخدمات المختارة'
                        : 'Selected services'),
                SizedBox(height: 10.h),
                for (final pkg in widget.cartItems) ...[
                  Padding(
                    padding: EdgeInsets.only(bottom: 6.h),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline_rounded,
                            color: Color(0xFFD4AF37), size: 14.sp),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            pkg.name(context),
                            style: TextStyle(
                                color: Colors.white70, fontSize: 13.sp),
                          ),
                        ),
                        Text(
                          '${pkg.price * (widget.quantities[pkg.id] ?? 1)} ${widget.isArabic ? 'جنيه' : 'EGP'}',
                          style: TextStyle(
                            color: Color(0xFFD4AF37),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                Container(
                    height: 1.h, color: Colors.white.withValues(alpha: 0.06)),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Text(widget.isArabic ? 'الإجمالي' : 'Total',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800)),
                    Spacer(),
                    Text(
                        '${widget.grandTotal} ${widget.isArabic ? 'جنيه' : 'EGP'}',
                        style: TextStyle(
                            color: Color(0xFFD4AF37),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w900)),
                  ],
                ),
                SizedBox(height: 16.h),
                Container(
                    height: 1.h, color: Colors.white.withValues(alpha: 0.06)),
                SizedBox(height: 14.h),
              ],
              // ─── البيانات الشخصية ────────────────────────────────────
              _FormSectionLabel(
                  icon: Icons.person_outline,
                  title: widget.isArabic
                      ? 'البيانات الشخصية'
                      : 'Personal details'),
              SizedBox(height: 12.h),
              _FormField(
                controller: _nameCtrl,
                label: widget.isArabic ? 'الاسم الكامل *' : 'Full name *',
                hint: widget.isArabic
                    ? 'أدخل اسمك الكامل'
                    : 'Enter your full name',
                icon: Icons.person_outline_rounded,
                keyboardType: TextInputType.name,
              ),
              SizedBox(height: 10.h),
              _FormField(
                controller: _phoneCtrl,
                label: widget.isArabic ? 'رقم الموبايل *' : 'Mobile number *',
                hint: '01xxxxxxxxx',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                isLtr: true,
              ),
              SizedBox(height: 10.h),
              _FormField(
                controller: _waCtrl,
                label: widget.isArabic ? 'رقم الواتساب *' : 'WhatsApp number *',
                hint: '01xxxxxxxxx',
                icon: Icons.chat_rounded,
                keyboardType: TextInputType.phone,
                isLtr: true,
                enabled: !_sameAsPhone,
              ),
              SizedBox(height: 6.h),
              GestureDetector(
                onTap: () => setState(() {
                  _sameAsPhone = !_sameAsPhone;
                  if (_sameAsPhone) _waCtrl.text = _phoneCtrl.text;
                }),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: Checkbox(
                        value: _sameAsPhone,
                        onChanged: (v) => setState(() {
                          _sameAsPhone = v ?? false;
                          if (_sameAsPhone) _waCtrl.text = _phoneCtrl.text;
                        }),
                        activeColor: Color(0xFFD4AF37),
                        checkColor: Colors.black,
                        side: BorderSide(color: Colors.white30),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.r)),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      widget.isArabic ? 'نفس رقم الموبايل' : 'Same as mobile',
                      style: TextStyle(color: Colors.white70, fontSize: 13.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              _FormField(
                controller: _emailCtrl,
                label: widget.isArabic ? 'البريد الإلكتروني' : 'Email',
                hint: 'example@email.com',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                isLtr: true,
              ),
              SizedBox(height: 10.h),
              _FormField(
                controller: _companyCtrl,
                label: widget.isArabic
                    ? 'اسم الشركة (اختياري)'
                    : 'Company (optional)',
                hint: widget.isArabic
                    ? 'اسم شركتك أو نشاطك التجاري'
                    : 'Your company or business name',
                icon: Icons.business_outlined,
              ),
              SizedBox(height: 14.h),
              // ─── تفاصيل الطلب ────────────────────────────────────────
              _FormSectionLabel(
                  icon: Icons.receipt_long_outlined,
                  title: widget.isArabic ? 'تفاصيل الطلب' : 'Order details'),
              SizedBox(height: 12.h),
              _FormField(
                controller: _notesCtrl,
                label:
                    widget.isArabic ? 'اكتب تفاصيل طلبك' : 'Write your request',
                hint: widget.isArabic
                    ? 'اكتب تفاصيل طلبك مثلاً: الهدف + الميزانية + أي تفاصيل إضافية...'
                    : 'Share your goal, budget, and any extra details...',
                icon: Icons.notes_rounded,
                maxLines: 4,
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
                    style:
                        TextStyle(fontWeight: FontWeight.w900, fontSize: 15.sp),
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
    this.enabled = true,
  });

  final TextEditingController controller;
  final String label, hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool isLtr;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                color: enabled
                    ? Color(0xFFD4AF37)
                    : Color(0xFFD4AF37).withValues(alpha: 0.4),
                size: 13.sp),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                color: enabled ? Colors.white70 : Colors.white38,
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
          enabled: enabled,
          textDirection: isLtr ? TextDirection.ltr : null,
          style: TextStyle(
              color: enabled ? Colors.white : Colors.white38, fontSize: 14.sp),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.3),
              fontSize: 13.sp,
            ),
            filled: true,
            fillColor: enabled
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.white.withValues(alpha: 0.02),
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
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide:
                  BorderSide(color: Colors.white.withValues(alpha: 0.05)),
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

class _FormSectionLabel extends StatelessWidget {
  _FormSectionLabel({required this.icon, required this.title});
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Color(0xFFD4AF37), size: 14.sp),
            SizedBox(width: 7.w),
            Text(
              title,
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Container(height: 1.h, color: Colors.white.withValues(alpha: 0.06)),
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
    this.packagesSectionTitleEn,
  });

  final String title, description;
  final IconData icon;
  final List<_DetailPoint> points;
  final List<_ServicePackage> packages;
  final String? editPolicyImage, packagesSectionTitle, packagesSectionTitleEn;

  String packageTitle(BuildContext context) {
    if (context.locale.languageCode == 'en') {
      return packagesSectionTitleEn ??
          packagesSectionTitle ??
          'auto.t_1df235e8a0'.tr();
    }
    return packagesSectionTitle ?? 'auto.t_1df235e8a0'.tr();
  }
}

class _ServicePackage {
  _ServicePackage({
    required this.id,
    required this.nameAr,
    required this.descAr,
    this.nameEn,
    this.descEn,
    required this.price,
    required this.image,
    this.platformId,
  });

  final String id, nameAr, descAr, image;
  final String? nameEn, descEn;
  final int price;
  final String? platformId;
  final int minQty = 1;

  String name(BuildContext context) =>
      context.locale.languageCode == 'en' ? (nameEn ?? nameAr) : nameAr;

  String desc(BuildContext context) =>
      context.locale.languageCode == 'en' ? (descEn ?? descAr) : descAr;
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

Map<String, _ServiceDetail> get _details => <String, _ServiceDetail>{
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
        editPolicyImage: 'packages/design/edit-policy.webp',
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
        editPolicyImage: 'packages/design/edit-policy.webp',
        packagesSectionTitle: 'اختر باقة موقعك',
        packagesSectionTitleEn: 'Choose your website package',
        packages: [
          _ServicePackage(
            id: 'web-portfolio',
            nameAr: 'تصميم موقع تعريفي Portfolio',
            nameEn: 'Portfolio website design',
            descAr:
                'موقع احترافي لعرض أعمالك وخدماتك بشكل عصري يعكس هويتك ويعزز حضورك الرقمي.',
            descEn:
                'A professional website to present your work and services with a modern identity-driven experience.',
            price: 5000,
            image: 'packages/web/3.webp',
          ),
          _ServicePackage(
            id: 'web-business',
            nameAr: 'إنشاء موقع ويب',
            nameEn: 'Website development',
            descAr:
                'تصميم وتطوير موقع ويب احترافي متجاوب مع جميع الأجهزة بسرعة عالية وتجربة استخدام مميزة.',
            descEn:
                'Professional responsive website design and development with fast performance and a polished user experience.',
            price: 15000,
            image: 'packages/web/1.webp',
          ),
          _ServicePackage(
            id: 'web-ecommerce',
            nameAr: 'إنشاء متجر إلكتروني',
            nameEn: 'E-commerce store development',
            descAr:
                'متجر إلكتروني متكامل لإدارة المنتجات والطلبات مع ربط وسائل الدفع والشحن وتحسين تجربة المستخدم.',
            descEn:
                'A complete online store for products and orders with payment, shipping, and optimized shopping flows.',
            price: 20000,
            image: 'packages/web/2.webp',
          ),
        ],
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
        editPolicyImage: 'packages/design/edit-policy.webp',
        packagesSectionTitle: 'اختر نوع تطبيقك',
        packagesSectionTitleEn: 'Choose your app type',
        packages: [
          _ServicePackage(
            id: 'mobile-basic',
            nameAr: 'تطبيق موبايل أساسي',
            nameEn: 'Basic mobile app',
            descAr:
                'تطبيق موبايل بسيط بواجهة عصرية يشمل الشاشات الأساسية وتسجيل الدخول.',
            descEn:
                'A simple mobile app with a modern interface, core screens, and login.',
            price: 5000,
            image: 'packages/mobile/1.webp',
          ),
          _ServicePackage(
            id: 'mobile-ecommerce',
            nameAr: 'تطبيق تجارة إلكترونية',
            nameEn: 'E-commerce mobile app',
            descAr:
                'تطبيق متجر إلكتروني متكامل مع بوابة دفع وسلة مشتريات ولوحة تحكم.',
            descEn:
                'A complete store app with payment gateway, cart, and admin dashboard.',
            price: 15000,
            image: 'packages/mobile/2.webp',
          ),
          _ServicePackage(
            id: 'mobile-booking',
            nameAr: 'تطبيق حجز وإدارة',
            nameEn: 'Booking and management app',
            descAr:
                'تطبيق حجوزات متكامل مع إشعارات فورية وإدارة مواعيد وتقارير.',
            descEn:
                'A booking app with real-time notifications, schedule management, and reports.',
            price: 12000,
            image: 'packages/mobile/3.webp',
          ),
        ],
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
        editPolicyImage: 'packages/design/edit-policy.webp',
        packagesSectionTitle: 'اختر خدمة الفيديو',
        packagesSectionTitleEn: 'Choose your video service',
        packages: [
          _ServicePackage(
            id: 'voice-over',
            nameAr: 'فويس أوفر تسجيل صوت',
            nameEn: 'Voice-over recording',
            descAr:
                'تسجيل صوت احترافي بجودة عالية مناسب للإعلانات والفيديوهات التعليمية والتوعوية.',
            descEn:
                'High-quality professional voice recording for ads, educational videos, and awareness content.',
            price: 900,
            image: 'packages/video/4.webp',
          ),
          _ServicePackage(
            id: 'ugc-video',
            nameAr: 'UGC Video',
            descAr:
                'فيديو واقعي بموديل احترافي يعرض المنتج أو الخدمة بشكل جذاب ومناسب للإعلانات الممولة.',
            descEn:
                'Realistic UGC-style video with a professional model to present your product or service for paid ads.',
            price: 3000,
            image: 'packages/video/1.webp',
          ),
          _ServicePackage(
            id: 'video-edit',
            nameAr: 'تعديل فيديو',
            nameEn: 'Video editing',
            descAr:
                'مونتاج احترافي يشمل القص والدمج وإضافة المؤثرات والنصوص وتصدير بجودة عالية.',
            descEn:
                'Professional editing with cutting, merging, effects, text overlays, and high-quality export.',
            price: 1000,
            image: 'packages/video/2.webp',
          ),
          _ServicePackage(
            id: 'video-production',
            nameAr: 'فيديو مونتاج',
            nameEn: 'Video montage',
            descAr:
                'فيديو تسويقي كامل بمونتاج احترافي وفويس أوفر مع إمكانية إضافة لقطات ذكاء اصطناعي.',
            descEn:
                'A complete marketing video with professional montage, voice-over, and optional AI shots.',
            price: 1500,
            image: 'packages/video/3.webp',
          ),
        ],
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
        editPolicyImage: 'packages/design/edit-policy.webp',
        packagesSectionTitle: 'باقة تحسين محركات البحث',
        packagesSectionTitleEn: 'SEO package',
        packages: [
          _ServicePackage(
            id: 'seo-service',
            nameAr: 'خدمات SEO',
            nameEn: 'SEO services',
            descAr:
                'تحسين ظهور موقعك في نتائج البحث لزيادة الزيارات والوصول إلى عملاء مهتمين بخدماتك بشكل احترافي.',
            descEn:
                'Improve your search visibility to increase traffic and reach customers actively looking for your services.',
            price: 8000,
            image: 'packages/seo/seo.webp',
          ),
        ],
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
        packagesSectionTitle: 'باقات تعزيز السوشيال ميديا',
        packagesSectionTitleEn: 'Social media boost packages',
        packages: [
          _ServicePackage(
            id: 'boost-fb-eg',
            nameAr: '1000 متابعين فيسبوك مصريين',
            nameEn: '1,000 Egyptian Facebook followers',
            descAr:
                'متابعين مصريين حقيقيين لصفحتك على فيسبوك — تسليم سريع وجودة مضمونة.',
            descEn:
                'Real Egyptian followers for your Facebook page with fast delivery and guaranteed quality.',
            price: 150,
            image: 'packages/ads/2.webp',
          ),
          _ServicePackage(
            id: 'boost-ig',
            nameAr: '1000 متابعين انستجرام',
            nameEn: '1,000 Instagram followers',
            descAr:
                'متابعين عالي الجودة لحسابك على انستجرام مع ضمان استقرار العداد.',
            descEn: 'High-quality Instagram followers with stable delivery.',
            price: 200,
            image: 'packages/ads/1.webp',
          ),
          _ServicePackage(
            id: 'boost-tiktok',
            nameAr: '5000 مشاهدات تيك توك',
            nameEn: '5,000 TikTok views',
            descAr:
                'مشاهدات حقيقية لفيديوهاتك على تيك توك لزيادة الانتشار والوصول.',
            descEn: 'Real TikTok video views to increase reach and visibility.',
            price: 150,
            image: 'packages/ads/1.webp',
          ),
          _ServicePackage(
            id: 'boost-yt',
            nameAr: '500 مشترك يوتيوب',
            nameEn: '500 YouTube subscribers',
            descAr:
                'مشتركين حقيقيين لقناتك على يوتيوب لتسريع النمو والمصداقية.',
            descEn:
                'Real YouTube subscribers to support growth and credibility.',
            price: 300,
            image: 'packages/ads/2.webp',
          ),
        ],
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
        editPolicyImage: 'packages/design/edit-policy.webp',
        packagesSectionTitle: 'باقة إدارة التفاعل',
        packagesSectionTitleEn: 'Engagement management package',
        packages: [
          _ServicePackage(
            id: 'moderator-service',
            nameAr: 'خدمة Moderator',
            nameEn: 'Moderator service',
            descAr:
                'إدارة احترافية للرسائل والتعليقات والرد على العملاء بسرعة لتحسين تجربة العملاء وزيادة المبيعات.',
            descEn:
                'Professional management for messages, comments, and fast customer replies to improve experience and sales.',
            price: 4000,
            image: 'packages/moderator/moderator.webp',
          ),
        ],
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
        editPolicyImage: 'packages/design/edit-policy.webp',
        packagesSectionTitle: 'اختر باقة البراند',
        packagesSectionTitleEn: 'Choose your brand package',
        packages: [
          _ServicePackage(
            id: 'brand-social',
            nameAr: 'تصميم سوشيال ميديا',
            nameEn: 'Social media design',
            descAr:
                'تصميمات احترافية لمنصات التواصل الاجتماعي تعكس هوية علامتك التجارية.',
            descEn:
                'Professional social media designs that reflect your brand identity.',
            price: 250,
            image: 'packages/design/2.webp',
          ),
          _ServicePackage(
            id: 'brand-identity',
            nameAr: 'هوية بصرية كاملة',
            nameEn: 'Full visual identity',
            descAr:
                'هوية بصرية متكاملة تشمل لوجو + غلاف + سلوجات + كافة المواد التسويقية.',
            descEn:
                'A complete visual identity including logo, cover, slogans, and marketing materials.',
            price: 3000,
            image: 'packages/design/4.webp',
          ),
          _ServicePackage(
            id: 'brand-logo',
            nameAr: 'تصميم لوجو احترافي',
            nameEn: 'Professional logo design',
            descAr:
                'لوجو + غلاف + سلوجات بتصميم عالي الجودة يمثل علامتك التجارية.',
            descEn:
                'Logo, cover, and slogans with high-quality design that represents your brand.',
            price: 500,
            image: 'packages/design/1.webp',
          ),
          _ServicePackage(
            id: 'brand-about',
            nameAr: 'تصميم About Us',
            nameEn: 'About Us design',
            descAr: 'تصميم صفحة التعريف بشركتك بأسلوب احترافي وجذاب يعكس قيمك.',
            descEn:
                'A professional and attractive company profile page design that reflects your values.',
            price: 1000,
            image: 'packages/design/3.webp',
          ),
        ],
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

// ─── Ads Categories Data ──────────────────────────────────────────────────────

class _AdsCategory {
  _AdsCategory({
    required this.id,
    required this.nameAr,
    required this.descAr,
    this.nameEn,
    this.descEn,
    required this.image,
    required this.features,
    this.featuresEn,
    required this.packages,
  });
  final String id, nameAr, descAr, image;
  final String? nameEn, descEn;
  final List<String> features;
  final List<String>? featuresEn;
  final List<_ServicePackage> packages;

  String name(BuildContext context) =>
      context.locale.languageCode == 'en' ? (nameEn ?? nameAr) : nameAr;

  String desc(BuildContext context) =>
      context.locale.languageCode == 'en' ? (descEn ?? descAr) : descAr;

  List<String> localizedFeatures(BuildContext context) =>
      context.locale.languageCode == 'en' ? (featuresEn ?? features) : features;
}

final _adsCategories = [
  _AdsCategory(
    id: 'international',
    nameAr: 'الوطن العربي والاتحاد الأوروبي',
    nameEn: 'Arab world and European Union',
    descAr:
        'حملات إعلانية دولية تستهدف الجمهور العربي والأوروبي بمعايير عالمية وأسواق واسعة',
    descEn:
        'International ad campaigns targeting Arab and European audiences with global standards and broad markets.',
    image: 'packages/ads/1.webp',
    features: ['وصول عالمي', 'الاتحاد الأوروبي', 'الوطن العربي'],
    featuresEn: ['Global reach', 'European Union', 'Arab world'],
    packages: [
      _ServicePackage(
          id: 'intl-fb',
          nameAr: 'إعلانات فيسبوك',
          nameEn: 'Facebook ads',
          descAr: 'حملات مستهدفة على فيسبوك للجمهور الدولي',
          descEn: 'Targeted Facebook campaigns for international audiences',
          price: 2500,
          image: '',
          platformId: 'facebook'),
      _ServicePackage(
          id: 'intl-ig',
          nameAr: 'إعلانات انستجرام',
          nameEn: 'Instagram ads',
          descAr: 'إعلانات احترافية على انستجرام للأسواق الدولية',
          descEn: 'Professional Instagram ads for international markets',
          price: 2800,
          image: '',
          platformId: 'instagram'),
      _ServicePackage(
          id: 'intl-tiktok',
          nameAr: 'إعلانات تيك توك',
          nameEn: 'TikTok ads',
          descAr: 'حملات على تيك توك للوصول لملايين المشاهدين',
          descEn: 'TikTok campaigns to reach millions of viewers',
          price: 3500,
          image: '',
          platformId: 'tiktok'),
      _ServicePackage(
          id: 'intl-snapchat',
          nameAr: 'إعلانات سناب شات',
          nameEn: 'Snapchat ads',
          descAr: 'استهداف دقيق للشباب العربي والدولي على سناب شات',
          descEn: 'Precise Snapchat targeting for Arab and international youth',
          price: 3800,
          image: '',
          platformId: 'snapchat'),
      _ServicePackage(
          id: 'intl-youtube',
          nameAr: 'إعلانات يوتيوب',
          nameEn: 'YouTube ads',
          descAr: 'إعلانات مرئية قوية على يوتيوب للوصول الواسع',
          descEn: 'Powerful video ads on YouTube for broad reach',
          price: 4500,
          image: '',
          platformId: 'youtube'),
      _ServicePackage(
          id: 'intl-google',
          nameAr: 'إعلانات جوجل',
          nameEn: 'Google ads',
          descAr: 'إعلانات بحث وعرض على جوجل لأعلى عائد استثماري',
          descEn: 'Google search and display ads for strong ROI',
          price: 5500,
          image: '',
          platformId: 'google'),
      _ServicePackage(
          id: 'intl-telegram',
          nameAr: 'إعلانات تيليجرام',
          nameEn: 'Telegram ads',
          descAr: 'إعلانات على تيليجرام للوصول الفوري والمباشر',
          descEn: 'Telegram ads for direct and immediate reach',
          price: 1000,
          image: '',
          platformId: 'telegram'),
    ],
  ),
  _AdsCategory(
    id: 'egypt',
    nameAr: 'إعلانات داخل مصر',
    nameEn: 'Ads inside Egypt',
    descAr:
        'حملات إعلانية مستهدفة للجمهور المصري على جميع المنصات بأسعار تنافسية',
    descEn:
        'Targeted ad campaigns for Egyptian audiences across platforms at competitive prices.',
    image: 'packages/ads/2.webp',
    features: ['الجمهور المصري', 'بالجنيه المصري', 'تنفيذ سريع'],
    featuresEn: ['Egyptian audience', 'EGP pricing', 'Fast execution'],
    packages: [
      _ServicePackage(
          id: 'eg-fb',
          nameAr: 'إعلانات فيسبوك',
          nameEn: 'Facebook ads',
          descAr: 'حملات مستهدفة على فيسبوك للجمهور المصري',
          descEn: 'Targeted Facebook campaigns for Egyptian audiences',
          price: 1500,
          image: '',
          platformId: 'facebook'),
      _ServicePackage(
          id: 'eg-ig',
          nameAr: 'إعلانات انستجرام',
          nameEn: 'Instagram ads',
          descAr: 'إعلانات احترافية على انستجرام في مصر',
          descEn: 'Professional Instagram ads in Egypt',
          price: 1800,
          image: '',
          platformId: 'instagram'),
      _ServicePackage(
          id: 'eg-tiktok',
          nameAr: 'إعلانات تيك توك',
          nameEn: 'TikTok ads',
          descAr: 'حملات على تيك توك للشباب المصري',
          descEn: 'TikTok campaigns for Egyptian youth',
          price: 2000,
          image: '',
          platformId: 'tiktok'),
      _ServicePackage(
          id: 'eg-snapchat',
          nameAr: 'إعلانات سناب شات',
          nameEn: 'Snapchat ads',
          descAr: 'استهداف دقيق للمصريين على سناب شات',
          descEn: 'Precise Snapchat targeting for Egyptian audiences',
          price: 2500,
          image: '',
          platformId: 'snapchat'),
      _ServicePackage(
          id: 'eg-youtube',
          nameAr: 'إعلانات يوتيوب',
          nameEn: 'YouTube ads',
          descAr: 'إعلانات مرئية على يوتيوب للجمهور المصري',
          descEn: 'YouTube video ads for Egyptian audiences',
          price: 2500,
          image: '',
          platformId: 'youtube'),
      _ServicePackage(
          id: 'eg-google',
          nameAr: 'إعلانات جوجل',
          nameEn: 'Google ads',
          descAr: 'إعلانات بحث وعرض على جوجل في مصر',
          descEn: 'Google search and display ads in Egypt',
          price: 2500,
          image: '',
          platformId: 'google'),
    ],
  ),
];

// ─── Platform helpers ─────────────────────────────────────────────────────────

IconData _platformIcon(String id) => switch (id) {
      'facebook' => FontAwesomeIcons.facebook,
      'instagram' => FontAwesomeIcons.instagram,
      'tiktok' => FontAwesomeIcons.tiktok,
      'snapchat' => FontAwesomeIcons.snapchat,
      'youtube' => FontAwesomeIcons.youtube,
      'google' => FontAwesomeIcons.google,
      'telegram' => FontAwesomeIcons.telegram,
      _ => FontAwesomeIcons.bullhorn,
    };

Color _platformColor(String id) => switch (id) {
      'facebook' => const Color(0xFF1877F2),
      'instagram' => const Color(0xFFE1306C),
      'tiktok' => const Color(0xFF010101),
      'snapchat' => const Color(0xFFFFFC00),
      'youtube' => const Color(0xFFFF0000),
      'google' => const Color(0xFF4285F4),
      'telegram' => const Color(0xFF2CA5E0),
      _ => const Color(0xFFD4AF37),
    };

// ─── Ads Categories Section ───────────────────────────────────────────────────

class _AdsCategoriesSection extends StatelessWidget {
  _AdsCategoriesSection({
    required this.categories,
    required this.selectedCategoryId,
    required this.quantities,
    required this.cartIds,
    required this.netImg,
    required this.onSelectCategory,
    required this.onAdd,
    required this.onIncrement,
    required this.onDecrement,
  });

  final List<_AdsCategory> categories;
  final String? selectedCategoryId;
  final Map<String, int> quantities;
  final Set<String> cartIds;
  final String Function(String) netImg;
  final ValueChanged<String> onSelectCategory;
  final ValueChanged<String> onAdd;
  final ValueChanged<String> onIncrement;
  final ValueChanged<String> onDecrement;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
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
              Icon(Icons.campaign_rounded,
                  color: Color(0xFFD4AF37), size: 12.sp),
              SizedBox(width: 6.w),
              Text(
                _serviceLocaleText(
                    context, 'اختر نطاق إعلاناتك', 'Choose your ad region'),
                style: TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          _serviceLocaleText(context, 'إعلانات داخل مصر أم خارجها?',
              'Ads inside Egypt or internationally?'),
          style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.w900),
        ),
        SizedBox(height: 5.h),
        Text(
          _serviceLocaleText(
            context,
            'اضغط على الكارت المناسب لك وستظهر لك باقات كل منصة مع أسعارها',
            'Tap the right card to show each platform package and pricing.',
          ),
          style: TextStyle(
              color: Colors.white.withValues(alpha: 0.48), fontSize: 13.sp),
        ),
        SizedBox(height: 18.h),
        for (final cat in categories) ...[
          _AdsCategoryCard(
            category: cat,
            isExpanded: selectedCategoryId == cat.id,
            quantities: quantities,
            cartIds: cartIds,
            netImg: netImg,
            onToggle: () => onSelectCategory(cat.id),
            onAdd: onAdd,
            onIncrement: onIncrement,
            onDecrement: onDecrement,
          ),
          SizedBox(height: 14.h),
        ],
      ],
    );
  }
}

class _AdsCategoryCard extends StatelessWidget {
  _AdsCategoryCard({
    required this.category,
    required this.isExpanded,
    required this.quantities,
    required this.cartIds,
    required this.netImg,
    required this.onToggle,
    required this.onAdd,
    required this.onIncrement,
    required this.onDecrement,
  });

  final _AdsCategory category;
  final bool isExpanded;
  final Map<String, int> quantities;
  final Set<String> cartIds;
  final String Function(String) netImg;
  final VoidCallback onToggle;
  final ValueChanged<String> onAdd;
  final ValueChanged<String> onIncrement;
  final ValueChanged<String> onDecrement;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: Color(0xFF0F0A1E),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isExpanded
              ? Color(0xFFD4AF37).withValues(alpha: 0.7)
              : Colors.white.withValues(alpha: 0.07),
          width: isExpanded ? 1.5 : 1,
        ),
        boxShadow: isExpanded
            ? [
                BoxShadow(
                    color: Color(0xFFD4AF37).withValues(alpha: 0.1),
                    blurRadius: 18.r)
              ]
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category image
          AspectRatio(
            aspectRatio: 16 / 9,
            child: _ServiceDetailImage(
              assetImage: 'assets/images/${category.image}',
              networkImage: netImg(category.image),
              fit: BoxFit.cover,
              fallbackIcon: Icons.campaign_rounded,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name(context),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 6.h),
                Text(
                  category.desc(context),
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.58),
                      fontSize: 13.sp,
                      height: 1.6),
                ),
                SizedBox(height: 12.h),
                // Feature chips
                Wrap(
                  spacing: 8.w,
                  runSpacing: 6.h,
                  children: category
                      .localizedFeatures(context)
                      .map((f) => Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 5.h),
                            decoration: BoxDecoration(
                              color: Color(0xFFD4AF37).withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(999.r),
                              border: Border.all(
                                  color:
                                      Color(0xFFD4AF37).withValues(alpha: 0.3)),
                            ),
                            child: Text(
                              f,
                              style: TextStyle(
                                  color: Color(0xFFD4AF37),
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700),
                            ),
                          ))
                      .toList(),
                ),
                SizedBox(height: 14.h),
                // Expand/collapse button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onToggle,
                    icon: Icon(
                      isExpanded
                          ? Icons.expand_less_rounded
                          : Icons.expand_more_rounded,
                      size: 18.sp,
                    ),
                    label: Text(
                      _serviceLocaleText(
                        context,
                        isExpanded ? 'إخفاء الباقات' : 'عرض الباقات',
                        isExpanded ? 'Hide packages' : 'Show packages',
                      ),
                      style: TextStyle(
                          fontWeight: FontWeight.w900, fontSize: 14.sp),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isExpanded
                          ? Color(0xFFD4AF37).withValues(alpha: 0.15)
                          : Color(0xFFD4AF37),
                      foregroundColor:
                          isExpanded ? Color(0xFFD4AF37) : Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 13.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r)),
                      side: isExpanded
                          ? BorderSide(
                              color: Color(0xFFD4AF37).withValues(alpha: 0.5))
                          : BorderSide.none,
                    ),
                  ),
                ),
                // Platform packages (expanded)
                if (isExpanded) ...[
                  SizedBox(height: 16.h),
                  Container(
                      height: 1.h, color: Colors.white.withValues(alpha: 0.06)),
                  SizedBox(height: 14.h),
                  for (final pkg in category.packages) ...[
                    _PlatformPackageCard(
                      pkg: pkg,
                      qty: quantities[pkg.id] ?? 1,
                      isInCart: cartIds.contains(pkg.id),
                      onAdd: () => onAdd(pkg.id),
                      onIncrement: () => onIncrement(pkg.id),
                      onDecrement: () => onDecrement(pkg.id),
                    ),
                    SizedBox(height: 10.h),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlatformPackageCard extends StatelessWidget {
  _PlatformPackageCard({
    required this.pkg,
    required this.qty,
    required this.isInCart,
    required this.onAdd,
    required this.onIncrement,
    required this.onDecrement,
  });

  final _ServicePackage pkg;
  final int qty;
  final bool isInCart;
  final VoidCallback onAdd, onIncrement, onDecrement;

  @override
  Widget build(BuildContext context) {
    final pid = pkg.platformId ?? 'default';
    final pColor = _platformColor(pid);
    final pIcon = _platformIcon(pid);

    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Color(0xFF0D0820),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isInCart
              ? pColor.withValues(alpha: 0.6)
              : Colors.white.withValues(alpha: 0.07),
          width: isInCart ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: icon + info
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color:
                      pColor.withValues(alpha: pid == 'snapchat' ? 1.0 : 0.15),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: FaIcon(pIcon,
                      color: pid == 'snapchat' ? Colors.black : pColor,
                      size: 18.sp),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pkg.name(context),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      pkg.desc(context),
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.48),
                          fontSize: 11.sp),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              // Price
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${pkg.price}',
                    style: TextStyle(
                        color: Color(0xFFD4AF37),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w900,
                        height: 1),
                  ),
                  Text(
                    'auto.t_fb0989a821'.tr(),
                    style: TextStyle(color: Colors.white38, fontSize: 10.sp),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.h),
          // Row 2: qty controls + add button
          Row(
            children: [
              _CompactQtyControl(
                qty: qty,
                minQty: pkg.minQty,
                onIncrement: onIncrement,
                onDecrement: onDecrement,
              ),
              Spacer(),
              GestureDetector(
                onTap: onAdd,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 180),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: isInCart
                        ? pColor.withValues(alpha: 0.15)
                        : pColor.withValues(
                            alpha: pid == 'snapchat' ? 1.0 : 0.9),
                    borderRadius: BorderRadius.circular(8.r),
                    border: isInCart
                        ? Border.all(color: pColor.withValues(alpha: 0.5))
                        : null,
                  ),
                  child: Text(
                    _serviceLocaleText(
                      context,
                      isInCart ? 'تم الإضافة ✓' : 'أضف للطلب',
                      isInCart ? 'Added ✓' : 'Add to order',
                    ),
                    style: TextStyle(
                      color: isInCart
                          ? pColor
                          : (pid == 'snapchat' ? Colors.black : Colors.white),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompactQtyControl extends StatelessWidget {
  _CompactQtyControl({
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
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QtyBtn(icon: Icons.add, onTap: onIncrement),
          SizedBox(
            width: 28.w,
            child: Text(
              '$qty',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
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
