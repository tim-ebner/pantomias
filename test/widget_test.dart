import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pantomias/data/model/scored_game_settings_repository.dart';
import 'package:pantomias/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('shows mode selection on app start', (tester) async {
    await _pumpApp(tester);

    expect(find.text('Schnellstart'), findsOneWidget);
    expect(find.text('Spiel mit Punkten'), findsOneWidget);
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

  testWidgets('scored setup restores saved players and rounds as editable', (
    tester,
  ) async {
    await _pumpApp(
      tester,
      savedPlayerNames: ['Ada', 'Ben'],
      savedRoundLimitText: '3',
    );

    await tester.tap(find.byKey(const ValueKey('scored-setup-button')));
    await tester.pumpAndSettle();

    expect(_textFormField(tester, 'player-name-field-0').initialValue, 'Ada');
    expect(_textFormField(tester, 'player-name-field-1').initialValue, 'Ben');
    expect(_textFormField(tester, 'round-limit-field').initialValue, '3');

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

    await tester.tap(find.byKey(const ValueKey('start-scored-game-button')));
    await tester.pumpAndSettle();

    expect(find.text('Am Zug: Cara'), findsOneWidget);
    expect(find.text('Runde 1 von 4'), findsOneWidget);
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
    await _enterScoredSetup(tester, rounds: '2');

    await tester.tap(find.byKey(const ValueKey('start-scored-game-button')));
    await tester.pumpAndSettle();

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await _pumpApp(tester, settingsRepository: settingsRepository);
    await tester.tap(find.byKey(const ValueKey('scored-setup-button')));
    await tester.pumpAndSettle();

    expect(_textFormField(tester, 'player-name-field-0').initialValue, 'Alice');
    expect(_textFormField(tester, 'player-name-field-1').initialValue, 'Bob');
    expect(_textFormField(tester, 'round-limit-field').initialValue, '2');
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
  List<String>? savedPlayerNames,
  String savedRoundLimitText = '',
}) async {
  settingsRepository ??= await _createSettingsRepository();
  if (savedPlayerNames != null || savedRoundLimitText.isNotEmpty) {
    await settingsRepository.save(
      playerNames: savedPlayerNames ?? [],
      roundLimitText: savedRoundLimitText,
    );
  }

  await tester.pumpWidget(
    MyApp(scoredGameSettingsRepository: settingsRepository),
  );
  await tester.pumpAndSettle();
}

Future<ScoredGameSettingsRepository> _createSettingsRepository() async {
  SharedPreferences.setMockInitialValues({});
  final preferences = await SharedPreferences.getInstance();
  return ScoredGameSettingsRepository(preferences: preferences);
}

Future<void> _openScoredSetup(WidgetTester tester) async {
  await _pumpApp(tester);
  await tester.tap(find.byKey(const ValueKey('scored-setup-button')));
  await tester.pumpAndSettle();
}

Future<void> _startScoredGame(WidgetTester tester, {String? rounds}) async {
  await _startScoredGameWithPlayers(
    tester,
    playerNames: ['Alice', 'Bob'],
    rounds: rounds,
  );
}

Future<void> _startScoredGameWithPlayers(
  WidgetTester tester, {
  required List<String> playerNames,
  String? rounds,
}) async {
  await _openScoredSetup(tester);

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

  await tester.tap(find.byKey(const ValueKey('start-scored-game-button')));
  await tester.pumpAndSettle();
}

Future<void> _enterScoredSetup(WidgetTester tester, {String? rounds}) async {
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
}

FilledButton _startScoredGameButton(WidgetTester tester) {
  return tester.widget<FilledButton>(
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
  return tester.widget<TextFormField>(find.byKey(ValueKey(key)));
}
