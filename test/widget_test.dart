import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pantomias/main.dart';

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
      expect(find.byKey(const ValueKey('toggle-image-button')), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('toggle-image-button')));
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
    expect(find.text('1 Punkt'), findsOneWidget);
    expect(find.text('0 Punkte'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('new-scored-game-button')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('back-to-mode-selection-button')),
      findsOneWidget,
    );
  });
}

Future<void> _pumpApp(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  await tester.pumpAndSettle();
}

Future<void> _openScoredSetup(WidgetTester tester) async {
  await _pumpApp(tester);
  await tester.tap(find.byKey(const ValueKey('scored-setup-button')));
  await tester.pumpAndSettle();
}

Future<void> _startScoredGame(WidgetTester tester, {String? rounds}) async {
  await _openScoredSetup(tester);
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

  await tester.tap(find.byKey(const ValueKey('start-scored-game-button')));
  await tester.pumpAndSettle();
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
