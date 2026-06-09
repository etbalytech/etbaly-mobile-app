import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:etbaly/src/imports/core_imports.dart';
import 'package:etbaly/src/theme/etbaly_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part '../widgets/home_web_hero.dart';
part '../widgets/home_web_hero_state.dart';
part '../widgets/hero_action_button.dart';
part '../widgets/hero_brand_badge.dart';
part '../widgets/hero_glow.dart';
part '../widgets/hero_background_painter.dart';
part '../widgets/airplane_brand_section.dart';
part '../widgets/airplane_brand_section_state.dart';
part '../widgets/airplane_badge.dart';
part '../widgets/airplane_stats_card.dart';
part '../widgets/airplane_stat.dart';
part '../widgets/airplane_stat_divider.dart';
part '../widgets/airplane_feature_pills.dart';
part '../widgets/floating_plane.dart';
part '../widgets/airplane_background_painter.dart';
part '../widgets/success_partners_section.dart';
part '../widgets/success_partners_section_state.dart';
part '../widgets/partners_badge.dart';
part '../widgets/partner_logo_card.dart';
part '../widgets/partner_dot.dart';
part '../widgets/partners_background_painter.dart';
part '../widgets/ideas_success_section.dart';
part '../widgets/ideas_success_section_state.dart';
part '../widgets/ideas_badge.dart';
part '../widgets/ideas_action_button.dart';
part '../widgets/ideas_floating_card.dart';
part '../widgets/ideas_success_background_painter.dart';
part '../widgets/stats_image_strip_section.dart';
part '../widgets/stats_image_strip_section_state.dart';
part '../widgets/stats_band.dart';
part '../widgets/stats_band_item.dart';
part '../widgets/stats_band_divider.dart';
part '../widgets/strip_header.dart';
part '../widgets/strip_image_card.dart';
part '../widgets/strip_lightbox.dart';
part '../widgets/stats_strip_background_painter.dart';
part '../widgets/how_we_work_section.dart';
part '../widgets/process_wave.dart';
part '../widgets/work_step_card.dart';
part '../widgets/work_step_icon.dart';
part '../widgets/work_step_number.dart';
part '../widgets/wave_connector_painter.dart';
part '../widgets/work_wave_data.dart';
part '../widgets/work_step_data.dart';
part '../widgets/how_we_work_painter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    PaintingBinding.instance.imageCache.maximumSizeBytes = 120 << 20;

    return EtbalyPage(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 28.h),
      separatorHeight: 0,
      children: const [
        _HomeWebHero(),
        _AirplaneBrandSection(),
        _SuccessPartnersSection(),
        _StatsImageStripSection(),
        _IdeasSuccessSection(),
        _HowWeWorkSection(),
      ],
    );
  }
}
