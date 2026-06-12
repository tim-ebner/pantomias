import 'package:flutter/material.dart';
import 'package:pantomias/data/model/image_meta_info_repository.dart';
import 'package:pantomias/data/model/scored_game_settings_repository.dart';
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
  const MyApp({super.key, required this.scoredGameSettingsRepository});

  final ScoredGameSettingsRepository scoredGameSettingsRepository;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => ImageMetaInfoRepository()),
        Provider.value(value: scoredGameSettingsRepository),
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
