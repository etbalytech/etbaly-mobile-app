import 'package:go_router/go_router.dart';
import 'package:etbaly/src/routing/global_navigator.dart';
import 'package:etbaly/src/routing/app_routes.dart';
import 'package:etbaly/src/features/home/presentation/screens/home_page.dart';

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.home,
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
  ],
);
