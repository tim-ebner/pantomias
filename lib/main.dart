import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pantomias/data/model/image_meta_info_repository.dart';
import 'package:pantomias/data/model/scored_game_settings_repository.dart';
import 'package:pantomias/l10n/l10n.dart';
import 'package:pantomias/data/model/turn_timeout_alert.dart';
import 'package:pantomias/routing/router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();
  final scoredGameSettingsRepository = ScoredGameSettingsRepository(
    preferences: preferences,
  );

  runApp(MyApp(scoredGameSettingsRepository: scoredGameSettingsRepository));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.scoredGameSettingsRepository,
    this.turnTimeoutAlert,
    this.locale,
  });

  final ScoredGameSettingsRepository scoredGameSettingsRepository;
  final TurnTimeoutAlert? turnTimeoutAlert;
  final Locale? locale;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => ImageMetaInfoRepository()),
        Provider.value(value: scoredGameSettingsRepository),
        Provider<TurnTimeoutAlert>(
          create: (_) => turnTimeoutAlert ?? AudioVibrationTurnTimeoutAlert(),
          dispose: (_, alert) => alert.dispose(),
        ),
      ],
      child: MaterialApp.router(
        onGenerateTitle: (context) => context.l10n.appTitle,
        locale: locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          textTheme: const TextTheme(
            headlineLarge: TextStyle(
              fontSize: 40.0,
              fontWeight: FontWeight.w900,
              height: 1.0,
              letterSpacing: 0.0,
            ),
            headlineMedium: TextStyle(
              fontSize: 36.0,
              fontWeight: FontWeight.w600,
              height: 1.0,
              letterSpacing: 0.0,
            ),
          ),
        ),
        routerConfig: router(),
      ),
    );
  }
}
