import 'package:flutter/material.dart';
import 'package:pantomias/app.dart';
import 'package:pantomias/core/data/image_show_history_repository.dart';
import 'package:pantomias/core/data/scored_game_settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();
  final scoredGameSettingsRepository = ScoredGameSettingsRepository(
    preferences: preferences,
  );
  final imageShowHistoryRepository = ImageShowHistoryRepository(
    preferences: preferences,
  );

  runApp(
    MyApp(
      scoredGameSettingsRepository: scoredGameSettingsRepository,
      imageShowHistoryRepository: imageShowHistoryRepository,
    ),
  );
}
