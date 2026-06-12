import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pantomias/data/model/image_meta_info.dart';
import 'package:pantomias/data/model/image_meta_info_repository.dart';
import 'package:pantomias/data/model/scored_game_settings_repository.dart';

enum HomeScreenState { start, quickStart, scoreSetup, scoreGame, scoreResults }

class SetupPlayerDraft {
  SetupPlayerDraft({required this.id, this.name = ''});

  final int id;
  String name;
}

class PlayerScore {
  PlayerScore({required this.name, this.score = 0});

  final String name;
  int score;
}

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required ImageMetaInfoRepository imageMetaInfoRepository,
    required ScoredGameSettingsRepository scoredGameSettingsRepository,
  }) : _imageMetaInfoRepository = imageMetaInfoRepository,
       _scoredGameSettingsRepository = scoredGameSettingsRepository {
    _resetScoredSetup();
  }

  static const hiddenImageAssetPath = 'assets/images/hidden.webp';

  final ImageMetaInfoRepository _imageMetaInfoRepository;
  final ScoredGameSettingsRepository _scoredGameSettingsRepository;
  final Random _random = Random();

  HomeScreenState _screenState = HomeScreenState.start;
  HomeScreenState get screenState => _screenState;

  bool _isImageShown = true;
  bool get isImageShown => _isImageShown;

  List<ImageMetaInfo> _remainingImages = [];
  ImageMetaInfo? _currentImage;

  String get imageName {
    final currentImage = _currentImage;
    if (currentImage == null) {
      return '';
    }

    return _isImageShown ? currentImage.name : 'Versteckt';
  }

  String get imageAssetPath {
    final currentImage = _currentImage;
    if (currentImage == null || !_isImageShown) {
      return hiddenImageAssetPath;
    }

    return currentImage.imageUrl;
  }

  final Icon _hideIcon = const Icon(Icons.visibility_off, size: 30.0);
  final Icon _showIcon = const Icon(Icons.visibility, size: 30.0);
  Icon get toggleIcon => _isImageShown ? _hideIcon : _showIcon;

  int _nextSetupPlayerId = 0;
  List<SetupPlayerDraft> _setupPlayers = [];
  List<SetupPlayerDraft> get setupPlayers => List.unmodifiable(_setupPlayers);

  String _roundLimitText = '';
  String get roundLimitText => _roundLimitText;

  List<PlayerScore> _players = [];
  List<PlayerScore> get players => List.unmodifiable(_players);

  int _activePlayerIndex = 0;
  int get activePlayerIndex => _activePlayerIndex;
  PlayerScore? get activePlayer =>
      _players.isEmpty ? null : _players[_activePlayerIndex];

  int _completedTurns = 0;
  int get completedTurns => _completedTurns;

  int? _roundLimit;
  int? get roundLimit => _roundLimit;

  int get currentRound {
    if (_players.isEmpty) {
      return 1;
    }

    return (_completedTurns ~/ _players.length) + 1;
  }

  int? get totalTurns =>
      _roundLimit == null ? null : _roundLimit! * _players.length;

  bool get canRemoveSetupPlayer => _setupPlayers.length > 2;

  bool get isRoundLimitValid {
    final trimmedRoundLimit = _roundLimitText.trim();
    if (trimmedRoundLimit.isEmpty) {
      return true;
    }

    final parsedRoundLimit = int.tryParse(trimmedRoundLimit);
    return parsedRoundLimit != null && parsedRoundLimit > 0;
  }

  bool get canStartScoredGame =>
      _validSetupPlayerNames.length >= 2 && isRoundLimitValid;

  List<String> get _validSetupPlayerNames {
    return _setupPlayers
        .map((player) => player.name.trim())
        .where((playerName) => playerName.isNotEmpty)
        .toList();
  }

  List<PlayerScore> get rankedPlayers {
    final rankedPlayers = List<PlayerScore>.of(_players);
    rankedPlayers.sort((first, second) => second.score.compareTo(first.score));
    return rankedPlayers;
  }

  void showModeSelection() {
    _screenState = HomeScreenState.start;
    notifyListeners();
  }

  void startQuickStart() {
    _screenState = HomeScreenState.quickStart;
    _resetImages();
    _nextImage(revealImage: true, notify: false);
    notifyListeners();
  }

  void startScoredSetup() {
    _screenState = HomeScreenState.scoreSetup;
    _resetScoredSetup();
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

  void startScoredGame() {
    if (!canStartScoredGame) {
      return;
    }

    final playerNames = _validSetupPlayerNames;
    final roundLimitText = _roundLimitText.trim();
    _startScoredGame(playerNames: playerNames, roundLimit: _parseRoundLimit());
    unawaited(
      _scoredGameSettingsRepository.save(
        playerNames: playerNames,
        roundLimitText: roundLimitText,
      ),
    );
    notifyListeners();
  }

  void restartScoredGame() {
    if (_players.length < 2) {
      startScoredSetup();
      return;
    }

    _startScoredGame(
      playerNames: _players.map((player) => player.name).toList(),
      roundLimit: _roundLimit,
    );
    notifyListeners();
  }

  void toggleImage() {
    _isImageShown = !_isImageShown;
    notifyListeners();
  }

  void nextImage() {
    _nextImage(revealImage: false);
  }

  void markGuessed() {
    _completeScoredTurn(wasGuessed: true);
  }

  void markNotGuessed() {
    _completeScoredTurn(wasGuessed: false);
  }

  void _completeScoredTurn({required bool wasGuessed}) {
    if (_screenState != HomeScreenState.scoreGame || _players.isEmpty) {
      return;
    }

    if (wasGuessed) {
      _players[_activePlayerIndex].score += 1;
    }

    _completedTurns += 1;

    if (_roundLimit != null && _completedTurns >= totalTurns!) {
      _screenState = HomeScreenState.scoreResults;
      _isImageShown = true;
      notifyListeners();
      return;
    }

    _activePlayerIndex = (_activePlayerIndex + 1) % _players.length;
    _nextImage(revealImage: true, notify: false);
    notifyListeners();
  }

  void _resetScoredSetup() {
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
  }

  void _startScoredGame({
    required List<String> playerNames,
    required int? roundLimit,
  }) {
    _players = playerNames
        .map((playerName) => PlayerScore(name: playerName))
        .toList();
    _activePlayerIndex = 0;
    _completedTurns = 0;
    _roundLimit = roundLimit;
    _screenState = HomeScreenState.scoreGame;
    _resetImages();
    _nextImage(revealImage: true, notify: false);
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

  void _resetImages() {
    _isImageShown = true;
    _remainingImages = _imageMetaInfoRepository.getAllImageMetaInfo();
  }

  void _nextImage({required bool revealImage, bool notify = true}) {
    if (_remainingImages.isEmpty) {
      _remainingImages = _imageMetaInfoRepository.getAllImageMetaInfo();
    }

    final randomIndex = _random.nextInt(_remainingImages.length);
    _currentImage = _remainingImages.removeAt(randomIndex);

    if (revealImage) {
      _isImageShown = true;
    }

    if (notify) {
      notifyListeners();
    }
  }
}
