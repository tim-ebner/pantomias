import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pantomias/core/data/scored_game_settings_repository.dart';
import 'package:pantomias/features/point_mode_settings/viewmodel/point_mode_settings_view_model.dart';

class _MockScoredGameSettingsRepository extends Mock
    implements ScoredGameSettingsRepository {}

void main() {
  late _MockScoredGameSettingsRepository repository;

  setUp(() {
    repository = _MockScoredGameSettingsRepository();
    when(() => repository.loadPlayerNames()).thenReturn([]);
    when(() => repository.loadRoundLimitText()).thenReturn('');
    when(() => repository.loadTurnTimeLimitText()).thenReturn('');
    when(
      () => repository.save(
        playerNames: any(named: 'playerNames'),
        roundLimitText: any(named: 'roundLimitText'),
        turnTimeLimitText: any(named: 'turnTimeLimitText'),
      ),
    ).thenAnswer((_) async {});
  });

  PointModeSettingsViewModel createViewModel() {
    final viewModel = PointModeSettingsViewModel(
      scoredGameSettingsRepository: repository,
    );
    addTearDown(viewModel.dispose);
    return viewModel;
  }

  group('initial state', () {
    test('starts with two empty players when nothing is saved', () {
      final viewModel = createViewModel();

      expect(viewModel.setupPlayers, hasLength(2));
      expect(viewModel.canStartScoredGame, isFalse);
    });

    test('restores saved players, round limit, and turn time limit', () {
      when(
        () => repository.loadPlayerNames(),
      ).thenReturn(['Ada', 'Ben', 'Cara']);
      when(() => repository.loadRoundLimitText()).thenReturn('3');
      when(() => repository.loadTurnTimeLimitText()).thenReturn('1:30');

      final viewModel = createViewModel();

      expect(
        viewModel.setupPlayers.map((player) => player.name),
        ['Ada', 'Ben', 'Cara'],
      );
      expect(viewModel.roundLimitText, '3');
      expect(viewModel.turnTimeLimitText, '1:30');
    });
  });

  group('canStartScoredGame', () {
    test('requires at least two non-empty player names', () {
      final viewModel = createViewModel();

      viewModel.updateSetupPlayerName(0, 'Alice');
      expect(viewModel.canStartScoredGame, isFalse);

      viewModel.updateSetupPlayerName(1, 'Bob');
      expect(viewModel.canStartScoredGame, isTrue);
    });

    test('blank player names do not count', () {
      final viewModel = createViewModel();

      viewModel.updateSetupPlayerName(0, 'Alice');
      viewModel.updateSetupPlayerName(1, '   ');

      expect(viewModel.canStartScoredGame, isFalse);
    });

    test('is false when round limit is not a positive integer', () {
      final viewModel = createViewModel();
      viewModel.updateSetupPlayerName(0, 'Alice');
      viewModel.updateSetupPlayerName(1, 'Bob');

      viewModel.updateRoundLimit('0');

      expect(viewModel.isRoundLimitValid, isFalse);
      expect(viewModel.canStartScoredGame, isFalse);
    });

    test('is false when turn time limit seconds are out of range', () {
      final viewModel = createViewModel();
      viewModel.updateSetupPlayerName(0, 'Alice');
      viewModel.updateSetupPlayerName(1, 'Bob');

      viewModel.updateTurnTimeLimit('1:60');

      expect(viewModel.isTurnTimeLimitValid, isFalse);
      expect(viewModel.canStartScoredGame, isFalse);
    });
  });

  group('players', () {
    test('addSetupPlayer appends a new blank player', () {
      final viewModel = createViewModel();

      viewModel.addSetupPlayer();

      expect(viewModel.setupPlayers, hasLength(3));
    });

    test('removeSetupPlayer removes the given player when above the minimum', () {
      final viewModel = createViewModel();
      viewModel.addSetupPlayer();
      final playerId = viewModel.setupPlayers.first.id;

      viewModel.removeSetupPlayer(playerId);

      expect(viewModel.setupPlayers, hasLength(2));
      expect(
        viewModel.setupPlayers.map((player) => player.id),
        isNot(contains(playerId)),
      );
    });

    test('removeSetupPlayer is a no-op at the two-player minimum', () {
      final viewModel = createViewModel();
      final playerId = viewModel.setupPlayers.first.id;

      viewModel.removeSetupPlayer(playerId);

      expect(viewModel.setupPlayers, hasLength(2));
    });

    test('canRemoveSetupPlayer is false at the two-player minimum', () {
      final viewModel = createViewModel();

      expect(viewModel.canRemoveSetupPlayer, isFalse);

      viewModel.removeSetupPlayer(viewModel.setupPlayers.first.id);

      expect(viewModel.setupPlayers, hasLength(2));
    });
  });

  group('round limit stepper', () {
    test('incrementRoundLimit starts at 1 and counts up', () {
      final viewModel = createViewModel();

      viewModel.incrementRoundLimit();
      expect(viewModel.roundLimitText, '1');

      viewModel.incrementRoundLimit();
      expect(viewModel.roundLimitText, '2');
    });

    test('decrementRoundLimit clears the field once it reaches zero', () {
      final viewModel = createViewModel();
      viewModel.updateRoundLimit('1');

      viewModel.decrementRoundLimit();

      expect(viewModel.roundLimitText, '');
    });
  });

  group('turn time limit stepper', () {
    test('incrementTurnTimeLimit steps by 30 seconds', () {
      final viewModel = createViewModel();

      viewModel.incrementTurnTimeLimit();
      expect(viewModel.turnTimeLimitText, '0:30');

      viewModel.incrementTurnTimeLimit();
      expect(viewModel.turnTimeLimitText, '1:00');
    });

    test('decrementTurnTimeLimit clears the field once it reaches zero', () {
      final viewModel = createViewModel();
      viewModel.updateTurnTimeLimit('0:30');

      viewModel.decrementTurnTimeLimit();

      expect(viewModel.turnTimeLimitText, '');
    });
  });

  group('createGameSettings', () {
    test('returns null when the setup is invalid', () {
      final viewModel = createViewModel();

      expect(viewModel.createGameSettings(), isNull);
    });

    test('returns trimmed player names and parsed limits when valid', () {
      final viewModel = createViewModel();
      viewModel.updateSetupPlayerName(0, ' Alice ');
      viewModel.updateSetupPlayerName(1, 'Bob');
      viewModel.updateRoundLimit('4');
      viewModel.updateTurnTimeLimit('2:15');

      final settings = viewModel.createGameSettings();

      expect(settings, isNotNull);
      expect(settings!.playerNames, ['Alice', 'Bob']);
      expect(settings.roundLimit, 4);
      expect(settings.turnTimeLimit, const Duration(minutes: 2, seconds: 15));
    });
  });

  test('saveCurrentSettings persists the valid player names and limits', () {
    final viewModel = createViewModel();
    viewModel.updateSetupPlayerName(0, 'Alice');
    viewModel.updateSetupPlayerName(1, 'Bob');
    viewModel.updateRoundLimit('2');

    viewModel.saveCurrentSettings();

    verify(
      () => repository.save(
        playerNames: ['Alice', 'Bob'],
        roundLimitText: '2',
        turnTimeLimitText: '',
      ),
    ).called(1);
  });
}
