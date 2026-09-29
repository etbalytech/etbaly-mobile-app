import 'package:etbaly/src/features/services/data/services_catalog_data.dart';
import 'package:etbaly/src/features/services/data/services_catalog_repository.dart';
import 'package:etbaly/src/features/services/presentation/widgets/services_packages_section.dart';
import 'package:etbaly/src/features/services/presentation/widgets/services_showcase_section.dart';
import 'package:etbaly/src/features/services/presentation/widgets/why_choose_us_section.dart';
import 'package:etbaly/src/imports/core_imports.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  // The packages catalogue is managed from the dashboard (like on the website),
  // so it is loaded from the API; the last answer is kept for offline use.
  List<InternalPackage>? _packages;
  bool _loading = true;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final cached = await ServicesCatalogRepository.cached();
    if (!mounted) return;
    setState(() {
      if (cached != null) _packages = cached;
      _loading = cached == null;
      _failed = false;
    });
    try {
      final fresh = await ServicesCatalogRepository.fetch();
      if (!mounted) return;
      setState(() {
        _packages = fresh;
        _loading = false;
        _failed = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        // Only an error when there is nothing (not even a cached catalogue) to show.
        _failed = _packages == null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return EtbalyPage(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 28.h),
      separatorHeight: 0,
      children: [
        const EtbalyServicesShowcaseSection(),
        const EtbalyWhyChooseUsSection(),
        EtbalyPackagesCatalogSection(
          packages: _packages,
          loading: _loading,
          failed: _failed,
          onRetry: _load,
        ),
        const EtbalyServicesPayCta(),
      ],
    );
  }
}
