import 'package:etbaly/src/imports/core_imports.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

/// A sample page colour for the dark and the light theme (the website's
/// `--web-accent` and friends).
@immutable
class ExpertiseAccent {
  const ExpertiseAccent(this.dark, this.light);

  final Color dark;
  final Color light;

  Color of(BuildContext context) => context.isDarkMode ? dark : light;
}

abstract final class ExpertiseAccents {
  static const web = ExpertiseAccent(Color(0xFF85B2FF), Color(0xFF2F61AC));
  static const mobile = ExpertiseAccent(Color(0xFF75DDC0), Color(0xFF17664F));
  static const mobileIos =
      ExpertiseAccent(Color(0xFF9EBEFF), Color(0xFF315B9C));
  static const campaigns =
      ExpertiseAccent(Color(0xFFE8C76B), Color(0xFF825D08));
  static const facebook =
      ExpertiseAccent(Color(0xFF75B4FF), Color(0xFF155BA8));
  static const facebookSoft =
      ExpertiseAccent(Color(0xFF3A77E7), Color(0xFF367ED6));
  static const instagram =
      ExpertiseAccent(Color(0xFFF59FCB), Color(0xFFA32D74));
  static const instagramSoft =
      ExpertiseAccent(Color(0xFFC653B1), Color(0xFFC14B91));
}

bool expertiseArabic(BuildContext context) =>
    context.locale.languageCode == 'ar';

/// The direction of [text] from its first strong letter (HTML `dir="auto"`),
/// so a Latin name reads left to right on an Arabic page.
TextDirection? expertiseTextDirection(String text) {
  for (final rune in text.runes) {
    final arabic = (rune >= 0x0600 && rune <= 0x08FF) ||
        (rune >= 0xFB50 && rune <= 0xFDFF) ||
        (rune >= 0xFE70 && rune <= 0xFEFF);
    if (arabic) return TextDirection.rtl;
    final latin = (rune >= 0x41 && rune <= 0x5A) ||
        (rune >= 0x61 && rune <= 0x7A) ||
        (rune >= 0xC0 && rune <= 0x24F);
    if (latin) return TextDirection.ltr;
  }
  return null;
}

/// Opens a sample (website, store listing, profile) outside the app.
Future<void> openExpertiseLink(BuildContext context, String url) async {
  final messenger = ScaffoldMessenger.maybeOf(context);
  final arabic = expertiseArabic(context);
  final uri = Uri.tryParse(url);
  var opened = false;
  if (uri != null) {
    try {
      opened = await launchUrl(uri, mode: LaunchMode.externalApplication) ||
          await launchUrl(uri);
    } catch (_) {
      opened = false;
    }
  }
  if (!opened) {
    messenger?.showSnackBar(
      SnackBar(
        content: Text(arabic ? 'تعذّر فتح الرابط.' : 'Could not open the link.'),
      ),
    );
  }
}

/// The frame of an expertise samples page: theme background with a soft glow
/// in the page colour, pull to refresh and side gutters.
class ExpertiseSamplePage extends StatelessWidget {
  const ExpertiseSamplePage({
    super.key,
    required this.accent,
    required this.header,
    required this.slivers,
    this.onRefresh,
    this.controller,
  });

  final Color accent;
  final Widget header;
  final List<Widget> slivers;
  final Future<void> Function()? onRefresh;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    final gutter = EdgeInsets.symmetric(horizontal: 16.w);
    Widget scroll = CustomScrollView(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(16.w, 22.h, 16.w, 26.h),
          sliver: SliverToBoxAdapter(child: header),
        ),
        for (final sliver in slivers)
          SliverPadding(padding: gutter, sliver: sliver),
        SliverToBoxAdapter(child: SizedBox(height: 48.h)),
      ],
    );
    if (onRefresh != null) {
      scroll = RefreshIndicator(
        onRefresh: onRefresh!,
        color: accent,
        child: scroll,
      );
    }
    return ColoredBox(
      color: context.etbalyColors.bgMain,
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -1.15),
                    radius: 1.15,
                    colors: [
                      accent.withValues(alpha: 0.11),
                      accent.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          scroll,
        ],
      ),
    );
  }
}

/// "رجوع لمجالات خبرتنا" — back to the expertise hub.
class ExpertiseBackLink extends StatelessWidget {
  const ExpertiseBackLink({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final arabic = expertiseArabic(context);
    return ExpertiseOutlineButton(
      icon: arabic ? FontAwesomeIcons.arrowRight : FontAwesomeIcons.arrowLeft,
      label: arabic ? 'رجوع لمجالات خبرتنا' : 'Back to our expertise',
      onTap: onTap ?? () => context.go(AppRoutes.expertises),
    );
  }
}

/// The website's `.web-back` button: gold text on the card colour.
class ExpertiseOutlineButton extends StatelessWidget {
  const ExpertiseOutlineButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.iconAfter = false,
    this.color,
  });

  final String label;
  final VoidCallback onTap;
  final FaIconData? icon;
  final bool iconAfter;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final tint = color ?? colors.gold;
    final iconWidget = icon == null
        ? null
        : SizedBox(
            width: 16.r,
            height: 16.r,
            child: Center(child: FaIcon(icon, size: 13.sp, color: tint)),
          );
    return Material(
      color: colors.bgCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13.r),
        side: BorderSide(color: colors.borderColor),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13.r),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 44.h),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (iconWidget != null && !iconAfter) ...[
                  iconWidget,
                  SizedBox(width: 10.w),
                ],
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: tint,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (iconWidget != null && iconAfter) ...[
                  SizedBox(width: 10.w),
                  iconWidget,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Small coloured label above a sample page title (e.g. "Websites").
class ExpertiseEyebrow extends StatelessWidget {
  const ExpertiseEyebrow({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  final FaIconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 18.r,
          height: 18.r,
          child: Center(child: FaIcon(icon, size: 14.sp, color: color)),
        ),
        SizedBox(width: 9.w),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 13.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

/// Back link, eyebrow, two-tone title and intro of a sample page.
class ExpertiseSampleHeader extends StatelessWidget {
  const ExpertiseSampleHeader({
    super.key,
    required this.accent,
    required this.eyebrow,
    required this.title,
    required this.highlight,
    required this.description,
    this.highlightOnNewLine = false,
    this.below,
  });

  final Color accent;
  final Widget eyebrow;
  final String title;
  final String highlight;
  final String description;
  final bool highlightOnNewLine;
  final Widget? below;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    return Column(
      children: [
        const ExpertiseBackLink(),
        SizedBox(height: 26.h),
        eyebrow,
        SizedBox(height: 14.h),
        Text.rich(
          TextSpan(
            text: highlightOnNewLine ? '$title\n' : '$title ',
            children: [
              TextSpan(text: highlight, style: TextStyle(color: accent)),
            ],
          ),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colors.textMain,
            fontSize: 27.sp,
            fontWeight: FontWeight.w900,
            height: 1.55,
          ),
        ),
        SizedBox(height: 14.h),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colors.textMuted,
            fontSize: 13.5.sp,
            height: 1.9,
          ),
        ),
        if (below != null) ...[
          SizedBox(height: 20.h),
          below!,
        ],
      ],
    );
  }
}

/// The bordered box that holds a page's search and filters.
class ExpertiseFilterPanel extends StatelessWidget {
  const ExpertiseFilterPanel({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    return Container(
      padding: EdgeInsets.all(17.r),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: colors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(height: 14.h),
            children[i],
          ],
        ],
      ),
    );
  }
}

InputDecoration _fieldDecoration(
  BuildContext context, {
  required Color accent,
  String? hint,
  Widget? prefix,
  Widget? suffix,
}) {
  final colors = context.etbalyColors;
  OutlineInputBorder border(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: color, width: width),
      );
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: colors.textMuted, fontSize: 13.5.sp),
    prefixIcon: prefix,
    prefixIconConstraints: BoxConstraints(minWidth: 44.w, minHeight: 48.h),
    suffixIcon: suffix,
    filled: true,
    fillColor: colors.bgMain,
    isDense: true,
    contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
    border: border(colors.borderColor),
    enabledBorder: border(colors.borderColor),
    focusedBorder: border(accent, 1.5),
  );
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 9.h),
      child: Text(
        text,
        style: TextStyle(
          color: context.etbalyColors.textMuted,
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Labelled search box with the magnifier in the page colour.
class ExpertiseSearchField extends StatelessWidget {
  const ExpertiseSearchField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.accent,
    required this.onChanged,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final Color accent;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) => TextField(
            controller: controller,
            onChanged: onChanged,
            textInputAction: TextInputAction.search,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            style: TextStyle(color: colors.textMain, fontSize: 15.sp),
            cursorColor: accent,
            decoration: _fieldDecoration(
              context,
              accent: accent,
              hint: hint,
              prefix: Center(
                widthFactor: 1,
                child: FaIcon(
                  FontAwesomeIcons.magnifyingGlass,
                  size: 15.sp,
                  color: accent,
                ),
              ),
              suffix: value.text.isEmpty
                  ? null
                  : IconButton(
                      tooltip: expertiseArabic(context) ? 'مسح' : 'Clear',
                      icon: Icon(
                        Icons.close_rounded,
                        size: 18.sp,
                        color: colors.textMuted,
                      ),
                      onPressed: () {
                        controller.clear();
                        onChanged('');
                      },
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Labelled drop-down (e.g. the industry filter).
class ExpertiseSelectField extends StatelessWidget {
  const ExpertiseSelectField({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.accent,
    required this.onChanged,
  });

  final String label;
  final String value;

  /// (value, label) pairs.
  final List<(String, String)> options;
  final Color accent;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        DropdownButtonFormField<String>(
          // Rebuilt when the value is changed from outside (e.g. "Show all").
          key: ValueKey(value),
          initialValue: value,
          isExpanded: true,
          menuMaxHeight: 420.h,
          borderRadius: BorderRadius.circular(14.r),
          dropdownColor: colors.bgCard,
          iconEnabledColor: accent,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          style: TextStyle(
            color: colors.textMain,
            fontSize: 15.sp,
            fontFamily: context.textTheme.bodyMedium?.fontFamily,
          ),
          decoration: _fieldDecoration(context, accent: accent),
          items: [
            for (final (id, text) in options)
              DropdownMenuItem(
                value: id,
                child: Text(text, overflow: TextOverflow.ellipsis),
              ),
          ],
          onChanged: (selected) {
            if (selected != null) onChanged(selected);
          },
        ),
      ],
    );
  }
}

/// A toggle button such as "Android" / "iPhone" or a specialty.
class ExpertiseChoiceButton extends StatelessWidget {
  const ExpertiseChoiceButton({
    super.key,
    required this.label,
    required this.active,
    required this.accent,
    required this.onTap,
    this.icon,
    this.fill = false,
    this.maxLines = 1,
  });

  final String label;
  final bool active;
  final Color accent;
  final VoidCallback onTap;
  final FaIconData? icon;

  /// Tinted background when active (platform switches use a stronger fill).
  final bool fill;

  /// Long labels (e.g. "نماذج مونتاج وUGC") may wrap instead of being cut.
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    final tint = active ? accent : colors.textMuted;
    return Material(
      color: active
          ? accent.withValues(alpha: fill ? 0.16 : 0.11)
          : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: active ? accent : colors.borderColor),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 44.h),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  SizedBox(
                    width: 16.r,
                    height: 16.r,
                    child: Center(child: FaIcon(icon, size: 14.sp, color: tint)),
                  ),
                  SizedBox(width: 8.w),
                ],
                Flexible(
                  child: Text(
                    label,
                    maxLines: maxLines,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: tint,
                      fontSize: 13.sp,
                      fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                      height: 1.35,
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

/// "{n} موقع" plus the "عرض الكل" reset when a filter is on.
class ExpertiseResultsBar extends StatelessWidget {
  const ExpertiseResultsBar({
    super.key,
    required this.text,
    required this.accent,
    this.onReset,
  });

  final String text;
  final Color accent;

  /// Shown only while a search or filter is active.
  final VoidCallback? onReset;

  @override
  Widget build(BuildContext context) {
    final arabic = expertiseArabic(context);
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 44.h),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              liveRegion: true,
              child: Text(
                text,
                style: TextStyle(
                  color: context.etbalyColors.textMuted,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
          if (onReset != null)
            TextButton.icon(
              onPressed: onReset,
              style: TextButton.styleFrom(foregroundColor: accent),
              icon: FaIcon(FontAwesomeIcons.rotateLeft, size: 12.sp),
              label: Text(
                arabic ? 'عرض الكل' : 'Show all',
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
              ),
            ),
        ],
      ),
    );
  }
}

/// Industry heading above a group of samples: icon tile, name and count.
class ExpertiseGroupHeading extends StatelessWidget {
  const ExpertiseGroupHeading({
    super.key,
    required this.icon,
    required this.title,
    required this.count,
    required this.accent,
  });

  final FaIconData icon;
  final String title;
  final int count;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    return Padding(
      padding: EdgeInsets.only(top: 34.h, bottom: 18.h),
      child: Row(
        children: [
          Container(
            width: 42.r,
            height: 42.r,
            decoration: BoxDecoration(
              color: colors.bgCard,
              borderRadius: BorderRadius.circular(13.r),
              border: Border.all(color: colors.borderColor),
            ),
            child: Center(child: FaIcon(icon, size: 16.sp, color: accent)),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: colors.textMain,
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: colors.borderColor),
            ),
            child: Text(
              '$count',
              style: TextStyle(color: colors.textMuted, fontSize: 12.sp),
            ),
          ),
        ],
      ),
    );
  }
}

/// Loading, error and "nothing found" panels.
class ExpertiseMessage extends StatelessWidget {
  const ExpertiseMessage({
    super.key,
    required this.accent,
    this.loading = false,
    this.icon,
    this.title,
    this.text,
    this.actionLabel,
    this.onAction,
  });

  final Color accent;
  final bool loading;
  final FaIconData? icon;
  final String? title;
  final String? text;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.etbalyColors;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 44.h),
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: colors.borderColor),
      ),
      child: Column(
        children: [
          if (loading) ...[
            SizedBox(
              width: 34.r,
              height: 34.r,
              child: CircularProgressIndicator(strokeWidth: 2, color: accent),
            ),
            SizedBox(height: 16.h),
          ],
          if (icon != null) ...[
            FaIcon(icon, size: 28.sp, color: accent),
            SizedBox(height: 16.h),
          ],
          if (title != null) ...[
            Text(
              title!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.textMain,
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 8.h),
          ],
          if (text != null)
            Text(
              text!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.textMuted,
                fontSize: 13.5.sp,
                height: 1.8,
              ),
            ),
          if (actionLabel != null && onAction != null) ...[
            SizedBox(height: 18.h),
            ExpertiseOutlineButton(label: actionLabel!, onTap: onAction!),
          ],
        ],
      ),
    );
  }
}
