import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pantomias/data/model/image_meta_info.dart';
import 'package:pantomias/data/model/image_meta_info_repository.dart';
import 'package:pantomias/data/model/scored_game_settings_repository.dart';
import 'package:pantomias/data/model/turn_timeout_alert.dart';
import 'package:pantomias/l10n/l10n.dart';
import 'package:pantomias/main.dart';
import 'package:pantomias/ui/home/widgets/next_button.dart';
import 'package:pantomias/ui/shared/image_stage/image_deck_view_model.dart';
import 'package:pantomias/ui/shared/image_stage/image_stage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('shows German mode selection on app start', (tester) async {
    await _pumpApp(tester);

    expect(find.text('Schnellstart'), findsOneWidget);
    expect(find.text('Spiel mit Punkten'), findsOneWidget);
  });

  testWidgets('shows English mode selection and scored setup copy', (
    tester,
  ) async {
    await _pumpApp(tester, locale: const Locale('en'));

    expect(find.text('Quick Start'), findsOneWidget);
    expect(find.text('Points Game'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('scored-setup-button')));
    await tester.pumpAndSettle();

    expect(find.text('Points Game'), findsOneWidget);
    expect(find.text('Add Player'), findsOneWidget);
    expect(find.text('Rounds (optional)'), findsOneWidget);
    expect(find.text('Time (Min:Sec, optional)'), findsOneWidget);
    expect(find.text('Start Game'), findsOneWidget);

    await _enterScoredSetup(tester, time: '0');

    expect(_startScoredGameButton(tester).onPressed, isNull);
    expect(find.text('Please enter a positive time'), findsOneWidget);
  });

  testWidgets('image stage localizes prompt and hidden label', (tester) async {
    await _pumpImageStage(tester, locale: const Locale('de'));

    expect(find.text('Katze'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('image-stage-picture')));
    await tester.pumpAndSettle();
    expect(find.text('Versteckt'), findsOneWidget);

    await _pumpImageStage(tester, locale: const Locale('en'));

    expect(find.text('Cat'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('image-stage-picture')));
    await tester.pumpAndSettle();
    expect(find.text('Hidden'), findsOneWidget);
  });

  testWidgets(
    'quick start opens the existing game flow and can hide the image',
    (tester) async {
      await _pumpApp(tester);

      await tester.tap(find.byKey(const ValueKey('quick-start-button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('quick-next-button')), findsOneWidget);
      expect(find.byKey(const ValueKey('toggle-image-button')), findsNothing);

      await tester.tap(find.byKey(const ValueKey('image-stage-picture')));
      await tester.pumpAndSettle();

      expect(find.text('Versteckt'), findsOneWidget);
    },
  );

  testWidgets('scored setup blocks empty players and allows valid players', (
    tester,
  ) async {
    await _openScoredSetup(tester);

    expect(_startScoredGameButton(tester).onPressed, isNull);

    await tester.enterText(
      find.byKey(const ValueKey('player-name-field-0')),
      'Alice',
    );
    await tester.pump();
    await tester.enterText(
      find.byKey(const ValueKey('player-name-field-1')),
      'Bob',
    );
    await tester.pump();

    expect(_startScoredGameButton(tester).onPressed, isNotNull);
  });

  testWidgets('scored setup restores saved players, rounds, and time', (
    tester,
  ) async {
    await _pumpApp(
      tester,
      savedPlayerNames: ['Ada', 'Ben'],
      savedRoundLimitText: '3',
      savedTurnTimeLimitText: '2',
    );

    await tester.tap(find.byKey(const ValueKey('scored-setup-button')));
    await tester.pumpAndSettle();

    expect(_textFormFieldText(tester, 'player-name-field-0'), 'Ada');
    expect(_textFormFieldText(tester, 'player-name-field-1'), 'Ben');
    expect(_textFormFieldText(tester, 'round-limit-field'), '3');
    expect(_textFormFieldText(tester, 'turn-time-limit-field'), '2');

    await tester.enterText(
      find.byKey(const ValueKey('player-name-field-0')),
      'Cara',
    );
    await tester.pump();
    await tester.enterText(
      find.byKey(const ValueKey('round-limit-field')),
      '4',
    );
    await tester.pump();
    await tester.enterText(
      find.byKey(const ValueKey('turn-time-limit-field')),
      '5',
    );
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('start-scored-game-button')));
    await tester.pumpAndSettle();

    expect(find.text('Am Zug: Cara'), findsOneWidget);
    expect(find.text('Runde 1 von 4'), findsOneWidget);
    expect(find.text('5:00'), findsOneWidget);
  });

  testWidgets('scored setup blocks zero time limit', (tester) async {
    await _openScoredSetup(tester);
    await _enterScoredSetup(tester, time: '0');

    expect(_startScoredGameButton(tester).onPressed, isNull);
    expect(find.text('Bitte positive Zeit eingeben'), findsOneWidget);
  });

  testWidgets('scored setup steppers adjust rounds and timer', (tester) async {
    await _openScoredSetup(tester);

    await _tapWhenVisible(
      tester,
      find.byKey(const ValueKey('round-limit-increment-button')),
    );
    await _tapWhenVisible(
      tester,
      find.byKey(const ValueKey('round-limit-increment-button')),
    );
    await _tapWhenVisible(
      tester,
      find.byKey(const ValueKey('round-limit-decrement-button')),
    );

    expect(_textFormFieldText(tester, 'round-limit-field'), '1');

    await _tapWhenVisible(
      tester,
      find.byKey(const ValueKey('turn-time-limit-increment-button')),
    );
    await _tapWhenVisible(
      tester,
      find.byKey(const ValueKey('turn-time-limit-increment-button')),
    );
    await _tapWhenVisible(
      tester,
      find.byKey(const ValueKey('turn-time-limit-decrement-button')),
    );

    expect(_textFormFieldText(tester, 'turn-time-limit-field'), '0:30');
  });

  testWidgets(
    'guessed turn scores the active player and rotates to the next player',
    (tester) async {
      await _startScoredGame(tester);

      expect(find.text('Am Zug: Alice'), findsOneWidget);
      expect(_scoreText(tester, 0), '0');
      expect(_scoreText(tester, 1), '0');

      await tester.tap(find.byKey(const ValueKey('guessed-button')));
      await tester.pumpAndSettle();

      expect(find.text('Am Zug: Bob'), findsOneWidget);
      expect(_scoreText(tester, 0), '1');
      expect(_scoreText(tester, 1), '0');
    },
  );

  testWidgets('not guessed turn rotates without adding a point', (
    tester,
  ) async {
    await _startScoredGame(tester);

    await tester.tap(find.byKey(const ValueKey('not-guessed-button')));
    await tester.pumpAndSettle();

    expect(find.text('Am Zug: Bob'), findsOneWidget);
    expect(_scoreText(tester, 0), '0');
    expect(_scoreText(tester, 1), '0');
  });

  testWidgets('timed scored game alerts at timeout without rotating', (
    tester,
  ) async {
    final turnTimeoutAlert = _FakeTurnTimeoutAlert();
    await _startScoredGame(
      tester,
      time: '1',
      turnTimeoutAlert: turnTimeoutAlert,
    );

    expect(find.text('Am Zug: Alice'), findsOneWidget);
    expect(find.text('1:00'), findsOneWidget);

    await tester.pump(const Duration(minutes: 1));
    await tester.pump();

    expect(turnTimeoutAlert.playCount, 1);
    expect(find.text('Zeit abgelaufen'), findsOneWidget);
    expect(find.text('Am Zug: Alice'), findsOneWidget);
    expect(_scoreText(tester, 0), '0');
    expect(_scoreText(tester, 1), '0');

    await tester.tap(find.byKey(const ValueKey('guessed-button')));
    await tester.pumpAndSettle();

    expect(find.text('Am Zug: Bob'), findsOneWidget);
    expect(_scoreText(tester, 0), '1');
    expect(find.text('1:00'), findsOneWidget);
  });

  testWidgets('timed scored game accepts seconds', (tester) async {
    final turnTimeoutAlert = _FakeTurnTimeoutAlert();
    await _startScoredGame(
      tester,
      time: '0:30',
      turnTimeoutAlert: turnTimeoutAlert,
    );

    expect(find.text('0:30'), findsOneWidget);

    await tester.pump(const Duration(seconds: 30));
    await tester.pump();

    expect(turnTimeoutAlert.playCount, 1);
    expect(find.text('Zeit abgelaufen'), findsOneWidget);
  });

  testWidgets('scored setup blocks invalid timer seconds', (tester) async {
    await _openScoredSetup(tester);
    await _enterScoredSetup(tester, time: '1:60');

    expect(_startScoredGameButton(tester).onPressed, isNull);
    expect(find.text('Bitte positive Zeit eingeben'), findsOneWidget);
  });

  testWidgets('untimed scored game does not show or trigger the timer', (
    tester,
  ) async {
    final turnTimeoutAlert = _FakeTurnTimeoutAlert();
    await _startScoredGame(tester, turnTimeoutAlert: turnTimeoutAlert);

    expect(find.byKey(const ValueKey('turn-timer-label')), findsNothing);

    await tester.pump(const Duration(minutes: 2));
    await tester.pump();

    expect(turnTimeoutAlert.playCount, 0);
    expect(find.text('Am Zug: Alice'), findsOneWidget);
  });

  testWidgets('scored game shows results after the configured rounds', (
    tester,
  ) async {
    await _startScoredGame(tester, rounds: '1');

    await tester.tap(find.byKey(const ValueKey('guessed-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('not-guessed-button')));
    await tester.pumpAndSettle();

    expect(find.text('Ergebnis'), findsOneWidget);
    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Bob'), findsOneWidget);
    expect(find.text('1 Pkt'), findsOneWidget);
    expect(find.text('0 Pkt'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('new-scored-game-button')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('back-to-mode-selection-button')),
      findsNothing,
    );
    expect(find.byKey(const ValueKey('mode-selection-button')), findsOneWidget);
    expect(
      tester
          .getTopLeft(find.byKey(const ValueKey('new-scored-game-button')))
          .dy,
      greaterThan(tester.getBottomLeft(find.text('Bob')).dy),
    );
  });

  testWidgets('English game flow localizes timer and results copy', (
    tester,
  ) async {
    final turnTimeoutAlert = _FakeTurnTimeoutAlert();
    await _startScoredGame(
      tester,
      rounds: '1',
      time: '1',
      turnTimeoutAlert: turnTimeoutAlert,
      locale: const Locale('en'),
    );

    expect(find.text('Turn: Alice'), findsOneWidget);
    expect(find.text('Round 1 of 1'), findsOneWidget);
    expect(find.text('1:00'), findsOneWidget);

    await tester.pump(const Duration(minutes: 1));
    await tester.pump();

    expect(turnTimeoutAlert.playCount, 1);
    expect(find.text("Time's up"), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('guessed-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('not-guessed-button')));
    await tester.pumpAndSettle();

    expect(find.text('Results'), findsOneWidget);
    expect(find.text('1 pt'), findsOneWidget);
    expect(find.text('0 pts'), findsOneWidget);
    expect(find.text('1ST PLACE'), findsOneWidget);
    expect(find.text('2. place'), findsOneWidget);
    expect(find.text('New Points Game'), findsOneWidget);
  });

  testWidgets('scored results fit four ranked players in the viewport', (
    tester,
  ) async {
    await _startScoredGameWithPlayers(
      tester,
      playerNames: ['Alice', 'Bob', 'Cara', 'Dana'],
      rounds: '1',
    );

    await tester.tap(find.byKey(const ValueKey('guessed-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('guessed-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('guessed-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('not-guessed-button')));
    await tester.pumpAndSettle();

    expect(find.text('Dana'), findsOneWidget);
    expect(
      tester.getBottomLeft(find.text('Dana')).dy,
      lessThanOrEqualTo(tester.getSize(find.byType(Scaffold)).height),
    );
  });

  testWidgets('starting a scored game persists setup for the next app start', (
    tester,
  ) async {
    final settingsRepository = await _createSettingsRepository();

    await _pumpApp(tester, settingsRepository: settingsRepository);
    await tester.tap(find.byKey(const ValueKey('scored-setup-button')));
    await tester.pumpAndSettle();
    await _enterScoredSetup(tester, rounds: '2', time: '3');

    await tester.tap(find.byKey(const ValueKey('start-scored-game-button')));
    await tester.pumpAndSettle();

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await _pumpApp(tester, settingsRepository: settingsRepository);
    await tester.tap(find.byKey(const ValueKey('scored-setup-button')));
    await tester.pumpAndSettle();

    expect(_textFormFieldText(tester, 'player-name-field-0'), 'Alice');
    expect(_textFormFieldText(tester, 'player-name-field-1'), 'Bob');
    expect(_textFormFieldText(tester, 'round-limit-field'), '2');
    expect(_textFormFieldText(tester, 'turn-time-limit-field'), '3');
  });

  testWidgets('new scored game restarts with same players and rounds', (
    tester,
  ) async {
    await _startScoredGame(tester, rounds: '1');

    await tester.tap(find.byKey(const ValueKey('guessed-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('not-guessed-button')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('new-scored-game-button')));
    await tester.pumpAndSettle();

    expect(find.text('Am Zug: Alice'), findsOneWidget);
    expect(find.text('Runde 1 von 1'), findsOneWidget);
    expect(_scoreText(tester, 0), '0');
    expect(_scoreText(tester, 1), '0');
  });
}

Future<void> _pumpApp(
  WidgetTester tester, {
  ScoredGameSettingsRepository? settingsRepository,
  TurnTimeoutAlert? turnTimeoutAlert,
  List<String>? savedPlayerNames,
  String savedRoundLimitText = '',
  String savedTurnTimeLimitText = '',
  Locale locale = const Locale('de'),
}) async {
  settingsRepository ??= await _createSettingsRepository();
  if (savedPlayerNames != null ||
      savedRoundLimitText.isNotEmpty ||
      savedTurnTimeLimitText.isNotEmpty) {
    await settingsRepository.save(
      playerNames: savedPlayerNames ?? [],
      roundLimitText: savedRoundLimitText,
      turnTimeLimitText: savedTurnTimeLimitText,
    );
  }

  await tester.pumpWidget(
    MyApp(
      scoredGameSettingsRepository: settingsRepository,
      turnTimeoutAlert: turnTimeoutAlert,
      locale: locale,
    ),
  );
  await tester.pump();
}

Future<void> _pumpImageStage(
  WidgetTester tester, {
  required Locale locale,
}) async {
  final viewModel = ImageDeckViewModel(
    imageMetaInfoRepository: _SingleImageMetaInfoRepository(),
  )..start();
  addTearDown(viewModel.dispose);

  await tester.pumpWidget(
    MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: ImageStage(viewModel: viewModel)),
    ),
  );
  await tester.pump();
}

Future<ScoredGameSettingsRepository> _createSettingsRepository() async {
  SharedPreferences.setMockInitialValues({});
  final preferences = await SharedPreferences.getInstance();
  return ScoredGameSettingsRepository(preferences: preferences);
}

Future<void> _openScoredSetup(
  WidgetTester tester, {
  TurnTimeoutAlert? turnTimeoutAlert,
  Locale locale = const Locale('de'),
}) async {
  await _pumpApp(tester, turnTimeoutAlert: turnTimeoutAlert, locale: locale);
  await tester.tap(find.byKey(const ValueKey('scored-setup-button')));
  await tester.pumpAndSettle();
}

Future<void> _startScoredGame(
  WidgetTester tester, {
  String? rounds,
  String? time,
  TurnTimeoutAlert? turnTimeoutAlert,
  Locale locale = const Locale('de'),
}) async {
  await _startScoredGameWithPlayers(
    tester,
    playerNames: ['Alice', 'Bob'],
    rounds: rounds,
    time: time,
    turnTimeoutAlert: turnTimeoutAlert,
    locale: locale,
  );
}

Future<void> _startScoredGameWithPlayers(
  WidgetTester tester, {
  required List<String> playerNames,
  String? rounds,
  String? time,
  TurnTimeoutAlert? turnTimeoutAlert,
  Locale locale = const Locale('de'),
}) async {
  await _openScoredSetup(
    tester,
    turnTimeoutAlert: turnTimeoutAlert,
    locale: locale,
  );

  for (var playerIndex = 2; playerIndex < playerNames.length; playerIndex++) {
    await tester.tap(find.byKey(const ValueKey('add-player-button')));
    await tester.pumpAndSettle();
  }

  for (final entry in playerNames.asMap().entries) {
    await tester.enterText(
      find.byKey(ValueKey('player-name-field-${entry.key}')),
      entry.value,
    );
    await tester.pump();
  }

  if (rounds != null) {
    await tester.enterText(
      find.byKey(const ValueKey('round-limit-field')),
      rounds,
    );
    await tester.pump();
  }

  if (time != null) {
    await tester.enterText(
      find.byKey(const ValueKey('turn-time-limit-field')),
      time,
    );
    await tester.pump();
  }

  await _tapWhenVisible(
    tester,
    find.byKey(const ValueKey('start-scored-game-button')),
  );
  await tester.pumpAndSettle();
}

Future<void> _enterScoredSetup(
  WidgetTester tester, {
  String? rounds,
  String? time,
}) async {
  await tester.enterText(
    find.byKey(const ValueKey('player-name-field-0')),
    'Alice',
  );
  await tester.pump();
  await tester.enterText(
    find.byKey(const ValueKey('player-name-field-1')),
    'Bob',
  );
  await tester.pump();

  if (rounds != null) {
    await tester.enterText(
      find.byKey(const ValueKey('round-limit-field')),
      rounds,
    );
    await tester.pump();
  }

  if (time != null) {
    await tester.enterText(
      find.byKey(const ValueKey('turn-time-limit-field')),
      time,
    );
    await tester.pump();
  }
}

Future<void> _tapWhenVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pump();
}

NextButton _startScoredGameButton(WidgetTester tester) {
  return tester.widget<NextButton>(
    find.byKey(const ValueKey('start-scored-game-button')),
  );
}

String _scoreText(WidgetTester tester, int playerIndex) {
  final scoreText = tester.widget<Text>(
    find.byKey(ValueKey('player-score-$playerIndex')),
  );
  return scoreText.data ?? '';
}

TextFormField _textFormField(WidgetTester tester, String key) {
  final field = find.byKey(ValueKey(key));
  final nestedField = find.descendant(
    of: field,
    matching: find.byType(TextFormField),
  );
  if (nestedField.evaluate().isNotEmpty) {
    return tester.widget<TextFormField>(nestedField);
  }

  return tester.widget<TextFormField>(field);
}

String _textFormFieldText(WidgetTester tester, String key) {
  final field = _textFormField(tester, key);
  return field.controller?.text ?? field.initialValue ?? '';
}

class _SingleImageMetaInfoRepository extends ImageMetaInfoRepository {
  @override
  List<ImageMetaInfo> getAllImageMetaInfo() {
    return [
      const ImageMetaInfo(
        promptId: 'cat',
        imageUrl: 'assets/images/pants/cat.webp',
      ),
    ];
  }
}

class _FakeTurnTimeoutAlert implements TurnTimeoutAlert {
  int playCount = 0;

  @override
  Future<void> play() async {
    playCount += 1;
  }

  @override
  Future<void> dispose() async {}
}
