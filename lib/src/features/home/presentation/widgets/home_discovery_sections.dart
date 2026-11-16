part of '../screens/home_page.dart';

class _HomeServicesSection extends StatelessWidget {
  const _HomeServicesSection();

  @override
  Widget build(BuildContext context) {
    final ar = context.locale.languageCode == 'ar';
    final services = [
      (
        Icons.palette_outlined,
        ar ? 'التصميم والهوية' : 'Design & branding',
        'design'
      ),
      (
        Icons.forum_outlined,
        ar ? 'إدارة السوشيال ميديا' : 'Social media',
        'social'
      ),
      (Icons.language_rounded, ar ? 'تصميم المواقع' : 'Websites', 'web'),
      (
        Icons.phone_android_rounded,
        ar ? 'تطبيقات الموبايل' : 'Mobile apps',
        'mobile-app'
      ),
      (
        Icons.campaign_outlined,
        ar ? 'الحملات الإعلانية' : 'Advertising',
        'ads'
      ),
      (
        Icons.videocam_outlined,
        ar ? 'تصوير ومونتاج' : 'Video production',
        'video'
      ),
    ];
    return _HomeDiscoveryCard(
      icon: Icons.auto_awesome_rounded,
      title: ar ? 'خدمات تساعدك تكبر' : 'Services that help you grow',
      description: ar
          ? 'من الفكرة للتنفيذ، اختار الخدمة المناسبة لنشاطك.'
          : 'From idea to execution, find the right service for your business.',
      child: Column(children: [
        ...services.map((service) => _HomeDiscoveryLink(
              icon: service.$1,
              label: service.$2,
              onTap: () => context.push('${AppRoutes.services}/${service.$3}'),
            )),
        TextButton.icon(
          onPressed: () => context.go(AppRoutes.services),
          icon: const Icon(Icons.arrow_forward_rounded),
          label: Text(ar ? 'شوف كل الخدمات' : 'Explore all services'),
        ),
      ]),
    );
  }
}

class _HomePortfolioSection extends StatelessWidget {
  const _HomePortfolioSection();

  @override
  Widget build(BuildContext context) {
    final ar = context.locale.languageCode == 'ar';
    return _HomeDiscoveryCard(
      icon: Icons.collections_outlined,
      title: ar ? 'نماذج من أعمالنا' : 'Explore our work',
      description: ar
          ? 'شوف أمثلة من تصميماتنا وفيديوهات مشاريعنا.'
          : 'Discover examples of our designs and project videos.',
      child: Column(children: [
        _HomeDiscoveryLink(
            icon: Icons.image_outlined,
            label: ar ? 'صور المشاريع والتصميمات' : 'Project photos & designs',
            onTap: () => context.push(AppRoutes.expertiseDesigns)),
        _HomeDiscoveryLink(
            icon: Icons.play_circle_outline_rounded,
            label: ar ? 'فيديوهات المشاريع والريلز' : 'Project videos & reels',
            onTap: () => context.push(AppRoutes.expertiseReels)),
        TextButton.icon(
            onPressed: () => context.go(AppRoutes.expertises),
            icon: const Icon(Icons.arrow_forward_rounded),
            label: Text(ar ? 'كل مجالات خبرتنا' : 'All areas of expertise')),
      ]),
    );
  }
}

class _HomeNewsletterSection extends StatefulWidget {
  const _HomeNewsletterSection();

  @override
  State<_HomeNewsletterSection> createState() => _HomeNewsletterSectionState();
}

class _HomeNewsletterSectionState extends State<_HomeNewsletterSection> {
  final _email = TextEditingController();
  bool _loading = false;
  String? _message;
  bool _success = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _subscribe() async {
    final ar = context.locale.languageCode == 'ar';
    final email = _email.text.trim();
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      setState(() {
        _success = false;
        _message =
            ar ? 'اكتب بريد إلكتروني صحيح.' : 'Enter a valid email address.';
      });
      return;
    }
    setState(() {
      _loading = true;
      _message = null;
    });
    try {
      final result = await Dio().post<dynamic>(
        'https://etba3ly-dm.com/api-email/subscribe.php',
        data: {'email': email, 'lang': ar ? 'ar' : 'en'},
        options: Options(
            contentType: Headers.formUrlEncodedContentType,
            receiveTimeout: const Duration(seconds: 20),
            sendTimeout: const Duration(seconds: 20)),
      );
      if (!mounted) return;
      final data = result.data;
      if (data is! Map || data['status'] != 'ok') {
        setState(() {
          _success = false;
          _message = ar
              ? 'تعذر إتمام الاشتراك. حاول مرة أخرى.'
              : 'Could not complete your subscription. Please try again.';
        });
        return;
      }
      final duplicate = data['new'] == false;
      final code = '${data['discount_code'] ?? ''}'.trim();
      setState(() {
        _success = true;
        _message = (duplicate
                ? (ar
                    ? 'بريدك مشترك بالفعل.'
                    : 'Your email is already subscribed.')
                : (ar ? 'تم اشتراكك بنجاح.' : 'Subscribed successfully.')) +
            (code.isEmpty
                ? ''
                : '\n${ar ? 'كود الخصم' : 'Discount code'}: $code');
      });
      _email.clear();
    } on DioException catch (error) {
      if (!mounted) return;
      final limited = error.response?.statusCode == 429;
      setState(() {
        _success = false;
        _message = limited
            ? (ar
                ? 'محاولات كتير؛ انتظر قليلًا وحاول تاني.'
                : 'Too many attempts. Please wait and try again.')
            : (ar
                ? 'تعذر الاتصال. تأكد من الإنترنت وحاول تاني.'
                : 'Connection failed. Check your internet and try again.');
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ar = context.locale.languageCode == 'ar';
    return _HomeDiscoveryCard(
      icon: Icons.mark_email_unread_outlined,
      title: ar ? 'خليك دايمًا على اطلاع' : 'Stay in the loop',
      description: ar
          ? 'اشترك ببريدك عشان توصلك أخبار وعروض اطبعلي.'
          : 'Subscribe for Etba3ly news and offers.',
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            textDirection: TextDirection.ltr,
            enabled: !_loading,
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.alternate_email_rounded),
                hintText: ar ? 'بريدك الإلكتروني' : 'Your email address'),
            onSubmitted: (_) {
              if (!_loading) _subscribe();
            }),
        SizedBox(height: 10.h),
        FilledButton(
            onPressed: _loading ? null : _subscribe,
            child: _loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : Text(ar ? 'اشترك الآن' : 'Subscribe')),
        if (_message != null) ...[
          SizedBox(height: 8.h),
          Semantics(
              liveRegion: true,
              child: Text(_message!,
                  style: TextStyle(
                      color: _success
                          ? Colors.green
                          : Theme.of(context).colorScheme.error)))
        ],
      ]),
    );
  }
}

class _HomeContactSection extends StatelessWidget {
  const _HomeContactSection();
  @override
  Widget build(BuildContext context) {
    final ar = context.locale.languageCode == 'ar';
    return _HomeDiscoveryCard(
        icon: Icons.support_agent_rounded,
        title: ar ? 'جاهز تبدأ؟' : 'Ready to get started?',
        description: ar
            ? 'كلّم فريقنا وخلينا نساعدك تختار الحل المناسب.'
            : 'Talk to our team and find the right solution.',
        child: FilledButton.icon(
            onPressed: () => context.go(AppRoutes.contact),
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            label: Text(ar ? 'تواصل معنا' : 'Contact us')));
  }
}

class _HomeDiscoveryCard extends StatelessWidget {
  const _HomeDiscoveryCard(
      {required this.icon,
      required this.title,
      required this.description,
      required this.child});
  final IconData icon;
  final String title;
  final String description;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(18.r),
        decoration: BoxDecoration(
            color: colors.bgCard,
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(color: colors.borderColor),
            boxShadow: [
              BoxShadow(
                  color: colors.primary.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8))
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(14.r)),
                child: Icon(icon, color: colors.gold)),
            SizedBox(width: 12.w),
            Expanded(
                child: Text(title,
                    style: context.textTheme.titleMedium?.copyWith(
                        color: colors.textMain, fontWeight: FontWeight.w800)))
          ]),
          SizedBox(height: 10.h),
          Text(description,
              style: context.textTheme.bodyMedium
                  ?.copyWith(color: colors.textMuted, height: 1.6)),
          SizedBox(height: 14.h),
          child,
        ]),
      ),
    );
  }
}

class _HomeDiscoveryLink extends StatelessWidget {
  const _HomeDiscoveryLink(
      {required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    return Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Material(
            color: colors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14.r),
            child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(14.r),
                child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
                    child: Row(children: [
                      Icon(icon, color: colors.gold, size: 21.sp),
                      SizedBox(width: 10.w),
                      Expanded(
                          child: Text(label,
                              style: context.textTheme.bodyMedium?.copyWith(
                                  color: colors.textMain,
                                  fontWeight: FontWeight.w700))),
                      Icon(Icons.chevron_right_rounded, color: colors.primary)
                    ])))));
  }
}
