import 'src/imports/core_imports.dart';
import 'src/app.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await EasyLocalization.ensureInitialized();

  await StorageService.instance.init();
  await ThemeService.instance.init();
  await AppConfig.init();
  // The native splash is lifted by EtbalySplashGate once its logo is decoded,
  // so the hand-over to the Flutter loading screen has no white flash.

  runApp(
    const LocalizationWrapper(
      child: StateWrapper(
        child: App(),
      ),
    ),
  );
}
