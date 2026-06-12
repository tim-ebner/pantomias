import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:pantomias/data/model/scored_game_settings_repository.dart';

class SetupPlayerDraft {
  SetupPlayerDraft({required this.id, this.name = ''});

  final int id;
  String name;
}

class PointModeSettings {
  const PointModeSettings({
    required this.playerNames,
    required this.roundLimit,
    required this.turnTimeLimit,
  });

  final List<String> playerNames;
  final int? roundLimit;
  final Duration? turnTimeLimit;
}

class PointModeSettingsViewModel extends ChangeNotifier {
  PointModeSettingsViewModel({
    required ScoredGameSettingsRepository scoredGameSettingsRepository,
  }) : _scoredGameSettingsRepository = scoredGameSettingsRepository {
    _loadSavedSettings();
  }

  final ScoredGameSettingsRepository _scoredGameSettingsRepository;

  int _nextSetupPlayerId = 0;
  List<SetupPlayerDraft> _setupPlayers = [];
  List<SetupPlayerDraft> get setupPlayers => List.unmodifiable(_setupPlayers);

  String _roundLimitText = '';
  String get roundLimitText => _roundLimitText;

  String _turnTimeLimitText = '';
  String get turnTimeLimitText => _turnTimeLimitText;

  bool get canRemoveSetupPlayer => _setupPlayers.length > 2;

  bool get isRoundLimitValid {
    return _isPositiveOptionalInt(_roundLimitText);
  }

  bool get isTurnTimeLimitValid {
    return _isPositiveOptionalInt(_turnTimeLimitText);
  }

  bool get canStartScoredGame =>
      _validSetupPlayerNames.length >= 2 &&
      isRoundLimitValid &&
      isTurnTimeLimitValid;

  void resetFromSavedSettings() {
    _loadSavedSettings();
    notifyListeners();
  }

  void addSetupPlayer() {
    _setupPlayers.add(_createSetupPlayer());
    notifyListeners();
  }

  void removeSetupPlayer(int playerId) {
    if (!canRemoveSetupPlayer) {
      return;
    }

    _setupPlayers.removeWhere((player) => player.id == playerId);
    notifyListeners();
  }

  void updateSetupPlayerName(int playerId, String name) {
    final playerIndex = _setupPlayers.indexWhere(
      (player) => player.id == playerId,
    );
    if (playerIndex == -1) {
      return;
    }

    _setupPlayers[playerIndex].name = name;
    notifyListeners();
  }

  void updateRoundLimit(String roundLimit) {
    _roundLimitText = roundLimit;
    notifyListeners();
  }

  void updateTurnTimeLimit(String turnTimeLimit) {
    _turnTimeLimitText = turnTimeLimit;
    notifyListeners();
  }

  PointModeSettings? createGameSettings() {
    if (!canStartScoredGame) {
      return null;
    }

    return PointModeSettings(
      playerNames: List.unmodifiable(_validSetupPlayerNames),
      roundLimit: _parseRoundLimit(),
      turnTimeLimit: _parseTurnTimeLimit(),
    );
  }

  void saveCurrentSettings() {
    unawaited(
      _scoredGameSettingsRepository.save(
        playerNames: _validSetupPlayerNames,
        roundLimitText: _roundLimitText.trim(),
        turnTimeLimitText: _turnTimeLimitText.trim(),
      ),
    );
  }

  List<String> get _validSetupPlayerNames {
    return _setupPlayers
        .map((player) => player.name.trim())
        .where((playerName) => playerName.isNotEmpty)
        .toList();
  }

  void _loadSavedSettings() {
    _nextSetupPlayerId = 0;
    final savedPlayerNames = _scoredGameSettingsRepository
        .loadPlayerNames()
        .map((playerName) => playerName.trim())
        .where((playerName) => playerName.isNotEmpty)
        .toList();

    _setupPlayers = savedPlayerNames.length >= 2
        ? savedPlayerNames
              .map((playerName) => _createSetupPlayer(name: playerName))
              .toList()
        : [_createSetupPlayer(), _createSetupPlayer()];
    _roundLimitText = _scoredGameSettingsRepository.loadRoundLimitText();
    _turnTimeLimitText = _scoredGameSettingsRepository.loadTurnTimeLimitText();
  }

  SetupPlayerDraft _createSetupPlayer({String name = ''}) {
    final player = SetupPlayerDraft(id: _nextSetupPlayerId, name: name);
    _nextSetupPlayerId += 1;
    return player;
  }

  int? _parseRoundLimit() {
    final trimmedRoundLimit = _roundLimitText.trim();
    if (trimmedRoundLimit.isEmpty) {
      return null;
    }

    return int.parse(trimmedRoundLimit);
  }

  Duration? _parseTurnTimeLimit() {
    final trimmedTurnTimeLimit = _turnTimeLimitText.trim();
    if (trimmedTurnTimeLimit.isEmpty) {
      return null;
    }

    return Duration(minutes: int.parse(trimmedTurnTimeLimit));
  }

  bool _isPositiveOptionalInt(String value) {
    final trimmedValue = value.trim();
    if (trimmedValue.isEmpty) {
      return true;
    }

    final parsedValue = int.tryParse(trimmedValue);
    return parsedValue != null && parsedValue > 0;
  }
}
