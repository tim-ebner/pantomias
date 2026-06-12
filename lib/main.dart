import 'package:flutter/material.dart';
import 'package:pantomias/data/model/image_meta_info_repository.dart';
import 'package:pantomias/data/model/scored_game_settings_repository.dart';
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
  });

  final ScoredGameSettingsRepository scoredGameSettingsRepository;
  final TurnTimeoutAlert? turnTimeoutAlert;

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
        title: 'Pantomias',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        ),
        routerConfig: router(),
      ),
    );
  }
}
