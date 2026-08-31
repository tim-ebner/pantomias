import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pantomias/features/home/view/home_screen.dart';
import 'package:pantomias/routing/routes.dart';
import 'package:pantomias/shell/app_scaffold.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: const AppTitle(),
      body: HomeScreen(
        onStartQuickStart: () => context.go(Routes.quickStart),
        onStartScoredSetup: () => context.go(Routes.scoreSetup),
      ),
    );
  }
}
