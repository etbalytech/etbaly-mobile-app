part of '../screens/home_page.dart';

class _SuccessPartnersSectionState extends State<_SuccessPartnersSection> {
  static const int _totalLogos = 51;
  static const int _logosPerGroup = 7;

  Timer? _timer;
  late final PageController _pageController;
  double _page = 0;
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.48)
      ..addListener(() {
        final nextPage = _pageController.page ?? _activeIndex.toDouble();
        if ((nextPage - _page).abs() > 0.001) {
          setState(() => _page = nextPage);
        }
      });
    _timer = Timer.periodic(const Duration(milliseconds: 2600), (_) {
      if (!mounted) return;
      final nextIndex = (_activeIndex + 1) % _totalLogos;
      _animateToLogo(nextIndex);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _animateToLogo(int index) {
    if (!_pageController.hasClients) {
      setState(() => _activeIndex = index);
      return;
    }

    if (_activeIndex == _totalLogos - 1 && index == 0) {
      _pageController.jumpToPage(0);
      setState(() {
        _activeIndex = 0;
        _page = 0;
      });
      return;
    }

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 720),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = context.width;
    final isNarrow = width < 390;
    final activeDotGroup = _activeIndex ~/ _logosPerGroup;
    final dotCount = (_totalLogos / _logosPerGroup).ceil();
    final colors = context.etbalyColors;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: context.isDarkMode
                  ? const [Color(0xFF080313), Color(0xFF05020E)]
                  : [colors.bgSecondary, colors.bgSubtle],
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _PartnersBackgroundPainter(
                    colors: colors,
                    isDark: context.isDarkMode,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  isNarrow ? 14 : 18,
                  isNarrow ? 18 : 22,
                  isNarrow ? 14 : 18,
                  isNarrow ? 6 : 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const _PartnersBadge()
                        .animate()
                        .fadeIn(duration: const Duration(milliseconds: 450))
                        .slideY(begin: -0.14),
                    SizedBox(height: 28.h),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: context.textTheme.headlineMedium?.copyWith(
                          color: colors.textMain,
                          fontSize: isNarrow ? 29 : 34,
                          fontWeight: FontWeight.w900,
                          height: 1.35,
                          letterSpacing: 0,
                        ),
                        children: [
                          TextSpan(text: 'auto.t_b9fd26d1cd'.tr()),
                          TextSpan(
                            text: 'auto.t_387648f9e4'.tr(),
                            style: TextStyle(color: colors.primary),
                          ),
                          TextSpan(text: 'auto.t_880033d8fc'.tr()),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 90))
                        .slideY(begin: 0.12),
                    SizedBox(height: isNarrow ? 34 : 44),
                    SizedBox(
                      height: isNarrow ? 190 : 215,
                      child: PageView.builder(
                        controller: _pageController,
                        clipBehavior: Clip.none,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _totalLogos,
                        onPageChanged: (index) {
                          setState(() => _activeIndex = index);
                        },
                        itemBuilder: (context, index) {
                          final distance =
                              (index - _page).abs().clamp(0.0, 1.0);
                          return _PartnerLogoCard(
                            index: index,
                            distance: distance,
                          );
                        },
                      ),
                    ),
                    SizedBox(height: isNarrow ? 18 : 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < dotCount; i++)
                          _PartnerDot(
                            active: i == activeDotGroup,
                            onTap: () {
                              _animateToLogo(i * _logosPerGroup);
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
