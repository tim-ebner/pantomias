import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pantomias/l10n/l10n.dart';
import 'package:pantomias/shared/commons.dart';

/// Shared AppBar/Scaffold chrome used by every route's page widget.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions = const [],
    this.centerTitle = true,
    this.toolbarHeight = 80.0,
    this.titleSpacing = NavigationToolbar.kMiddleSpacing,
  });

  static const _titleBarDividerColor = Color(0xFFE3ECE8);

  final Widget title;
  final Widget body;
  final List<Widget> actions;
  final bool centerTitle;
  final double toolbarHeight;
  final double titleSpacing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: pageBackgroundColor,
        foregroundColor: brandColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        centerTitle: centerTitle,
        toolbarHeight: toolbarHeight,
        titleSpacing: titleSpacing,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: pageBackgroundColor,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        shape: const Border(bottom: BorderSide(color: _titleBarDividerColor)),
        iconTheme: const IconThemeData(color: brandColor, size: 32.0),
        actionsIconTheme: const IconThemeData(color: brandColor, size: 32.0),
        title: title,
        actions: actions,
      ),
      body: SafeArea(child: body),
    );
  }
}

/// The static "Pantomias" app-name title used by every route except the
/// game route, which shows the round/active-player instead.
class AppTitle extends StatelessWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.appTitle,
      style: const TextStyle(
        color: brandColor,
        fontSize: 40.0,
        fontWeight: FontWeight.w900,
        height: 1.0,
        letterSpacing: 0.0,
      ),
    );
  }
}
