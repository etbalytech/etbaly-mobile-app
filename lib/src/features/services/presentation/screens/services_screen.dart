import 'package:etbaly/src/features/services/presentation/widgets/services_showcase_section.dart';
import 'package:etbaly/src/features/services/presentation/widgets/why_choose_us_section.dart';
import 'package:etbaly/src/imports/core_imports.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return EtbalyPage(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 28.h),
      separatorHeight: 0,
      children: const [
        EtbalyServicesShowcaseSection(),
        EtbalyWhyChooseUsSection(),
      ],
    );
  }
}
