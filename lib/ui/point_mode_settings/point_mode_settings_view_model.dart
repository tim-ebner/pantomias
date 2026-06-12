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
  static const _turnTimeLimitStep = Duration(seconds: 30);

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
    return _isPositiveOptionalTurnTimeLimit(_turnTimeLimitText);
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

  void incrementRoundLimit() {
    final currentRoundLimit = _parseOptionalPositiveInt(_roundLimitText);
    if (currentRoundLimit == null && _roundLimitText.trim().isNotEmpty) {
      return;
    }

    _roundLimitText = ((currentRoundLimit ?? 0) + 1).toString();
    notifyListeners();
  }

  void decrementRoundLimit() {
    final currentRoundLimit = _parseOptionalPositiveInt(_roundLimitText);
    if (currentRoundLimit == null) {
      return;
    }

    final nextRoundLimit = currentRoundLimit - 1;
    _roundLimitText = nextRoundLimit > 0 ? nextRoundLimit.toString() : '';
    notifyListeners();
  }

  void updateTurnTimeLimit(String turnTimeLimit) {
    _turnTimeLimitText = turnTimeLimit;
    notifyListeners();
  }

  void incrementTurnTimeLimit() {
    final currentTurnTimeLimit = _parseOptionalTurnTimeLimit(
      _turnTimeLimitText,
    );
    if (currentTurnTimeLimit == null && _turnTimeLimitText.trim().isNotEmpty) {
      return;
    }

    _turnTimeLimitText = _formatTurnTimeLimit(
      (currentTurnTimeLimit ?? Duration.zero) + _turnTimeLimitStep,
    );
    notifyListeners();
  }

  void decrementTurnTimeLimit() {
    final currentTurnTimeLimit = _parseOptionalTurnTimeLimit(
      _turnTimeLimitText,
    );
    if (currentTurnTimeLimit == null) {
      return;
    }

    final nextTurnTimeLimit = currentTurnTimeLimit - _turnTimeLimitStep;
    _turnTimeLimitText = nextTurnTimeLimit > Duration.zero
        ? _formatTurnTimeLimit(nextTurnTimeLimit)
        : '';
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
    return _parseOptionalPositiveInt(_roundLimitText);
  }

  Duration? _parseTurnTimeLimit() {
    return _parseOptionalTurnTimeLimit(_turnTimeLimitText);
  }

  int? _parseOptionalPositiveInt(String value) {
    final trimmedValue = value.trim();
    if (trimmedValue.isEmpty) {
      return null;
    }

    final parsedValue = int.tryParse(trimmedValue);
    if (parsedValue == null || parsedValue <= 0) {
      return null;
    }

    return parsedValue;
  }

  bool _isPositiveOptionalInt(String value) {
    return value.trim().isEmpty || _parseOptionalPositiveInt(value) != null;
  }

  bool _isPositiveOptionalTurnTimeLimit(String value) {
    return value.trim().isEmpty || _parseOptionalTurnTimeLimit(value) != null;
  }

  Duration? _parseOptionalTurnTimeLimit(String value) {
    final trimmedValue = value.trim();
    if (trimmedValue.isEmpty) {
      return null;
    }

    final timeParts = trimmedValue.split(':');
    if (timeParts.length == 1) {
      final minutes = int.tryParse(timeParts.single);
      if (minutes == null || minutes <= 0) {
        return null;
      }

      return Duration(minutes: minutes);
    }

    if (timeParts.length != 2) {
      return null;
    }

    final minutes = int.tryParse(timeParts[0]);
    final seconds = int.tryParse(timeParts[1]);
    if (minutes == null ||
        seconds == null ||
        minutes < 0 ||
        seconds < 0 ||
        seconds > 59) {
      return null;
    }

    final duration = Duration(minutes: minutes, seconds: seconds);
    return duration > Duration.zero ? duration : null;
  }

  String _formatTurnTimeLimit(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
