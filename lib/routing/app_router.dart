import 'package:go_router/go_router.dart';
import 'package:pantomias/features/point_mode_settings/viewmodel/point_mode_settings_view_model.dart';
import 'package:pantomias/routing/route_args.dart';
import 'package:pantomias/routing/routes.dart';

import 'pages/game_page.dart';
import 'pages/home_page.dart';
import 'pages/point_mode_settings_page.dart';
import 'pages/quick_start_page.dart';
import 'pages/result_page.dart';

GoRouter appRouter() => GoRouter(
  initialLocation: Routes.home,
  routes: [
    GoRoute(path: Routes.home, builder: (context, state) => const HomePage()),
    GoRoute(
      path: Routes.quickStart,
      builder: (context, state) => const QuickStartPage(),
    ),
    GoRoute(
      path: Routes.scoreSetup,
      builder: (context, state) => const PointModeSettingsPage(),
    ),
    GoRoute(
      path: Routes.scoreGame,
      redirect: (context, state) =>
          state.extra is PointModeSettings ? null : Routes.home,
      builder: (context, state) =>
          GamePage(settings: state.extra! as PointModeSettings),
    ),
    GoRoute(
      path: Routes.result,
      redirect: (context, state) =>
          state.extra is GameOutcome ? null : Routes.home,
      builder: (context, state) =>
          ResultPage(outcome: state.extra! as GameOutcome),
    ),
  ],
);
