import 'package:etbaly/src/imports/core_imports.dart';
import 'package:etbaly/src/routing/etbaly_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilWrapper(
      child: Builder(builder: _buildMaterialApp),
    );
  }

  Widget _buildMaterialApp(BuildContext context) {
    return MaterialApp.router(
      title: 'Etbaly',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(locale: context.locale),
      darkTheme: buildDarkTheme(locale: context.locale),
      themeMode: ThemeMode.dark, // Default to dark mode like web version
      routerConfig: etbalyRouter,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: (context, child) {
        final safeChild = child ?? const SizedBox.shrink();
        Widget current = safeChild;
        current = SkeletonWrapper(child: current);
        return current;
      },
    );
  }
}
