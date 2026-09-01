import 'package:pantomias/core/data/game_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScoredGameSettingsRepository {
  ScoredGameSettingsRepository({required SharedPreferences preferences})
    : _preferences = preferences;

  static const _playerNamesKey = 'scoredGame.playerNames';
  static const _roundLimitTextKey = 'scoredGame.roundLimitText';
  static const _turnTimeLimitTextKey = 'scoredGame.turnTimeLimitText';
  static const _gameModeKey = 'scoredGame.gameMode';

  final SharedPreferences _preferences;

  List<String> loadPlayerNames() {
    return _preferences.getStringList(_playerNamesKey) ?? [];
  }

  String loadRoundLimitText() {
    return _preferences.getString(_roundLimitTextKey) ?? '';
  }

  String loadTurnTimeLimitText() {
    return _preferences.getString(_turnTimeLimitTextKey) ?? '';
  }

  GameMode loadGameMode() {
    final storedName = _preferences.getString(_gameModeKey);
    return GameMode.values.firstWhere(
      (mode) => mode.name == storedName,
      orElse: () => GameMode.winnerNext,
    );
  }

  Future<void> save({
    required List<String> playerNames,
    required String roundLimitText,
    required String turnTimeLimitText,
  }) async {
    await Future.wait([
      _preferences.setStringList(_playerNamesKey, playerNames),
      _preferences.setString(_roundLimitTextKey, roundLimitText),
      _preferences.setString(_turnTimeLimitTextKey, turnTimeLimitText),
    ]);
  }

  Future<void> saveGameMode(GameMode gameMode) {
    return _preferences.setString(_gameModeKey, gameMode.name);
  }
}
