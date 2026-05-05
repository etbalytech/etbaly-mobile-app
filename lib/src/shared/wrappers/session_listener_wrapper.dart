import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/providers/session_bloc.dart';
import '../../routing/app_routes.dart';
import '../../routing/global_navigator.dart';


class SessionListenerWrapper extends StatelessWidget {
  final Widget child;
  const SessionListenerWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionBloc, SessionState>(
      listenWhen: (prev, next) => prev.status != next.status,
      listener: (context, state) {
        if (state.status != SessionStatus.unknown) {
          FlutterNativeSplash.remove();
          final ctx = rootContext;
          final router = ctx == null ? null : GoRouter.maybeOf(ctx);
          if (router == null) return;
          if (state.status == SessionStatus.authenticated) {
            router.go(AppRoutes.home);
          } else if (state.status == SessionStatus.unauthenticated) {
            router.go(AppRoutes.onboarding);
          }
        }
      },
      child: child,
    );
  }
}
