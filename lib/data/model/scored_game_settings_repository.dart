import 'package:shared_preferences/shared_preferences.dart';

class ScoredGameSettingsRepository {
  ScoredGameSettingsRepository({required SharedPreferences preferences})
    : _preferences = preferences;

  static const _playerNamesKey = 'scoredGame.playerNames';
  static const _roundLimitTextKey = 'scoredGame.roundLimitText';

  final SharedPreferences _preferences;

  List<String> loadPlayerNames() {
    return _preferences.getStringList(_playerNamesKey) ?? [];
  }

  String loadRoundLimitText() {
    return _preferences.getString(_roundLimitTextKey) ?? '';
  }

  Future<void> save({
    required List<String> playerNames,
    required String roundLimitText,
  }) async {
    await Future.wait([
      _preferences.setStringList(_playerNamesKey, playerNames),
      _preferences.setString(_roundLimitTextKey, roundLimitText),
    ]);
  }
}
