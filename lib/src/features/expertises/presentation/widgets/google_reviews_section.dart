import 'package:cached_network_image/cached_network_image.dart';
import 'package:etbaly/src/imports/core_imports.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/expertise_catalogue.dart';
import '../../data/expertises_repository.dart';
import 'expertise_sample_kit.dart';

const _gold = Color(0xFFC6A64D);
const _star = Color(0xFFE7B942);
const _googleBlue = Color(0xFF4285F4);

/// "آراء عملائنا على Google": the overall rating and a few five-star reviews
/// from the website's public reviews feed, plus a button to write a review.
class GoogleReviewsSection extends StatefulWidget {
  const GoogleReviewsSection({super.key});

  @override
  State<GoogleReviewsSection> createState() => _GoogleReviewsSectionState();
}

class _GoogleReviewsSectionState extends State<GoogleReviewsSection> {
  GoogleReviewFeed? _feed;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    GoogleReviewFeed? feed;
    try {
      feed = await ExpertisesRepository.googleReviews();
    } catch (_) {
      feed = null;
    }
    if (!mounted) return;
    setState(() {
      _feed = feed;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final arabic = expertiseArabic(context);
    final feed = _feed;

    final Widget body;
    if (_loading) {
      body = _StateText(arabic ? 'جاري تحميل التقييمات…' : 'Loading reviews…');
    } else if (feed == null) {
      body = _StateText(
        arabic
            ? 'التقييمات غير متاحة هنا مؤقتًا.'
            : 'Reviews are temporarily unavailable here.',
      );
    } else if (feed.reviews.isEmpty) {
      body = _StateText(
        arabic
            ? 'لا توجد آراء مختارة متاحة حاليًا.'
            : 'No selected reviews are available right now.',
      );
    } else {
      body = Column(
        children: [
          for (final review in feed.reviews) ...[
            _ReviewCard(review: review, arabic: arabic),
            if (review != feed.reviews.last) SizedBox(height: 16.h),
          ],
        ],
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.r),
        gradient: RadialGradient(
          center: const Alignment(0.7, -1),
          radius: 1.1,
          colors: [
            const Color(0xFF9769E7).withValues(alpha: 0.12),
            const Color(0xFF9769E7).withValues(alpha: 0),
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 30.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 14.r,
                  height: 14.r,
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.google,
                      size: 12.sp,
                      color: _gold,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  'GOOGLE REVIEWS',
                  style: TextStyle(
                    color: _gold,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.4,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              arabic
                  ? 'آراء عملائنا على Google'
                  : 'What our customers say on Google',
              style: TextStyle(
                color: colors.textMain,
                fontSize: 25.sp,
                fontWeight: FontWeight.w900,
                height: 1.5,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              arabic
                  ? 'مختارات من آراء عملائنا على Google.'
                  : 'A selection of our customers’ Google reviews.',
              style: TextStyle(
                color: colors.textMuted,
                fontSize: 14.sp,
                height: 1.8,
              ),
            ),
            if (feed != null) ...[
              SizedBox(height: 16.h),
              _RatingBadge(feed: feed, arabic: arabic),
            ],
            SizedBox(height: 24.h),
            body,
            SizedBox(height: 26.h),
            _WriteReviewButton(arabic: arabic),
          ],
        ),
      ),
    );
  }
}

class _StateText extends StatelessWidget {
  const _StateText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: context.etbalyColors.textMuted,
        fontSize: 14.sp,
        height: 1.8,
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.feed, required this.arabic});

  final GoogleReviewFeed feed;
  final bool arabic;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0x10C9A84C),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: const Color(0x66C9A84C)),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '★ ',
              style: TextStyle(color: _star, fontSize: 18.sp),
            ),
            TextSpan(
              text: feed.average.toStringAsFixed(1),
              style: TextStyle(
                color: colors.textMain,
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            TextSpan(
              text: '  ${arabic ? 'متوسط كل التقييمات' : 'Average of all reviews'}'
                  ' · ${feed.total}',
              style: TextStyle(color: colors.textMuted, fontSize: 12.sp),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review, required this.arabic});

  final GoogleReview review;
  final bool arabic;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final name = review.name.isNotEmpty
        ? review.name
        : (arabic ? 'عميل Google' : 'Google reviewer');
    final date = _reviewDate(review.date, arabic);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(19.r),
        border: Border.all(color: colors.borderColor),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF070315).withValues(alpha: 0.07),
            blurRadius: 30.r,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _Avatar(photo: review.safePhoto, name: review.name),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: colors.textMain,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (date.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        date,
                        style: TextStyle(
                          color: colors.textMuted,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Semantics(
                label: 'Google',
                child: FaIcon(
                  FontAwesomeIcons.google,
                  size: 20.sp,
                  color: _googleBlue,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Semantics(
            label: '${review.stars} / 5',
            excludeSemantics: true,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                children: [
                  for (var star = 1; star <= 5; star++)
                    Padding(
                      padding: EdgeInsets.only(right: 2.w),
                      child: Text(
                        '★',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: star <= review.stars
                              ? _star
                              : const Color(0xFF8D819E),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (review.comment.isNotEmpty) ...[
            SizedBox(height: 10.h),
            // Line by line, so Google's English translation under an Arabic
            // review reads left to right.
            for (final line in review.comment.split('\n'))
              Text(
                line,
                textDirection: expertiseTextDirection(line),
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: colors.textMuted,
                  fontSize: 14.sp,
                  height: 1.9,
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.photo, required this.name});

  final String photo;
  final String name;

  @override
  Widget build(BuildContext context) {
    final size = 46.r;
    final initial = SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Color(0x2BB38BE5),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            (name.isEmpty ? 'G' : name).characters.first.toUpperCase(),
            style: TextStyle(
              color: const Color(0xFFC8A7FF),
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
    if (photo.isEmpty) return initial;
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: photo,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (context, url) => initial,
        errorWidget: (context, url, error) => initial,
      ),
    );
  }
}

class _WriteReviewButton extends StatelessWidget {
  const _WriteReviewButton({required this.arabic});

  final bool arabic;

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF211A14);
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: const Color(0xFFDFBD5A),
        borderRadius: BorderRadius.circular(13.r),
        child: InkWell(
          onTap: () => openExpertiseLink(
            context,
            ExpertisesRepository.googleWriteReviewUrl,
          ),
          borderRadius: BorderRadius.circular(13.r),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 48.h),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 11.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(FontAwesomeIcons.pen, size: 14.sp, color: ink),
                  SizedBox(width: 10.w),
                  Flexible(
                    child: Text(
                      arabic ? 'اكتب تقييمك على Google' : 'Write a Google review',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ink,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  // The website's "↗" (as an icon: Android draws the
                  // character as a coloured emoji).
                  Icon(Icons.north_east_rounded, size: 16.sp, color: ink),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const _arabicMonths = [
  'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', //
  'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
];
const _englishMonths = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', //
  'Jul', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec',
];

/// `٢٨ يونيو ٢٠٢٦` / `28 Jun 2026`, like the website (ar-EG / en-GB).
String _reviewDate(DateTime? value, bool arabic) {
  if (value == null) return '';
  final date = value.toLocal();
  if (!arabic) {
    return '${date.day} ${_englishMonths[date.month - 1]} ${date.year}';
  }
  String digits(int number) => number
      .toString()
      .split('')
      .map((d) => String.fromCharCode(0x0660 + int.parse(d)))
      .join();
  return '${digits(date.day)} ${_arabicMonths[date.month - 1]} ${digits(date.year)}';
}
