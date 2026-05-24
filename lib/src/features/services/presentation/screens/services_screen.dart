import 'package:etbaly/src/features/services/presentation/widgets/services_showcase_section.dart';
import 'package:etbaly/src/features/services/presentation/widgets/why_choose_us_section.dart';
import 'package:etbaly/src/imports/core_imports.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const EtbalyPage(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 28),
      separatorHeight: 0,
      children: [
        EtbalyServicesShowcaseSection(),
        EtbalyWhyChooseUsSection(),
      ],
    );
  }
}
