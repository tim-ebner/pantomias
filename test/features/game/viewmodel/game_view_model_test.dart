import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pantomias/core/data/game_mode.dart';
import 'package:pantomias/core/data/image_meta_info.dart';
import 'package:pantomias/core/data/image_meta_info_repository.dart';
import 'package:pantomias/core/data/image_show_history_repository.dart';
import 'package:pantomias/core/services/turn_timeout_alert.dart';
import 'package:pantomias/features/game/viewmodel/game_view_model.dart';

class _MockImageMetaInfoRepository extends Mock
    implements ImageMetaInfoRepository {}

class _MockImageShowHistoryRepository extends Mock
    implements ImageShowHistoryRepository {}

class _MockTurnTimeoutAlert extends Mock implements TurnTimeoutAlert {}

void main() {
  late _MockImageMetaInfoRepository imageMetaInfoRepository;
  late _MockImageShowHistoryRepository imageShowHistoryRepository;
  late _MockTurnTimeoutAlert turnTimeoutAlert;

  setUp(() {
    imageMetaInfoRepository = _MockImageMetaInfoRepository();
    imageShowHistoryRepository = _MockImageShowHistoryRepository();
    turnTimeoutAlert = _MockTurnTimeoutAlert();
    when(() => imageMetaInfoRepository.getAllImageMetaInfo()).thenAnswer(
      (_) => [
        const ImageMetaInfo(promptId: 'cat', imageUrl: 'cat.webp'),
        const ImageMetaInfo(promptId: 'dog', imageUrl: 'dog.webp'),
      ],
    );
    when(() => imageShowHistoryRepository.loadShowCounts()).thenReturn({});
    when(
      () => imageShowHistoryRepository.recordShown(any()),
    ).thenAnswer((_) async {});
  });

  GameViewModel createViewModel() {
    final viewModel = GameViewModel(
      imageMetaInfoRepository: imageMetaInfoRepository,
      imageShowHistoryRepository: imageShowHistoryRepository,
      turnTimeoutAlert: turnTimeoutAlert,
    );
    addTearDown(viewModel.dispose);
    return viewModel;
  }

  test('start sets up players, round, and active player', () {
    final viewModel = createViewModel();

    viewModel.start(
      playerNames: ['Alice', 'Bob'],
      roundLimit: 2,
      turnTimeLimit: null,
      gameMode: GameMode.sequence,
    );

    expect(viewModel.players.map((p) => p.name), ['Alice', 'Bob']);
    expect(viewModel.players.every((p) => p.score == 0), isTrue);
    expect(viewModel.activePlayer?.name, 'Alice');
    expect(viewModel.currentRound, 1);
    expect(viewModel.totalTurns, 4);
  });

  test('completeTurn awards a point only when guessed', () {
    final viewModel = createViewModel();
    viewModel.start(
      playerNames: ['Alice', 'Bob'],
      roundLimit: null,
      turnTimeLimit: null,
      gameMode: GameMode.sequence,
    );

    viewModel.completeTurn(wasGuessed: true);

    expect(viewModel.players.first.score, 1);
    expect(viewModel.activePlayer?.name, 'Bob');

    viewModel.completeTurn(wasGuessed: false);

    expect(viewModel.players[1].score, 0);
    expect(viewModel.activePlayer?.name, 'Alice');
  });

  test('completeTurn rotates back to the first player after a full round', () {
    final viewModel = createViewModel();
    viewModel.start(
      playerNames: ['Alice', 'Bob', 'Cara'],
      roundLimit: null,
      turnTimeLimit: null,
      gameMode: GameMode.sequence,
    );

    viewModel.completeTurn(wasGuessed: false);
    viewModel.completeTurn(wasGuessed: false);
    expect(viewModel.activePlayer?.name, 'Cara');

    viewModel.completeTurn(wasGuessed: false);
    expect(viewModel.activePlayer?.name, 'Alice');
    expect(viewModel.currentRound, 2);
  });

  test('completeTurn reports finished once the round limit is reached', () {
    final viewModel = createViewModel();
    viewModel.start(
      playerNames: ['Alice', 'Bob'],
      roundLimit: 1,
      turnTimeLimit: null,
      gameMode: GameMode.sequence,
    );

    expect(viewModel.completeTurn(wasGuessed: true), isFalse);
    expect(viewModel.completeTurn(wasGuessed: false), isTrue);
  });

  test('rankedPlayers sorts by score descending', () {
    final viewModel = createViewModel();
    viewModel.start(
      playerNames: ['Alice', 'Bob', 'Cara'],
      roundLimit: null,
      turnTimeLimit: null,
      gameMode: GameMode.sequence,
    );

    viewModel.completeTurn(wasGuessed: false); // Alice: 0
    viewModel.completeTurn(wasGuessed: true); // Bob: 1
    viewModel.completeTurn(wasGuessed: false); // Cara: 0

    final ranked = viewModel.rankedPlayers;
    expect(ranked.first.name, 'Bob');
    expect(ranked.first.score, 1);
  });

  test('canRestart requires at least two players', () {
    final viewModel = createViewModel();

    expect(viewModel.canRestart, isFalse);

    viewModel.start(
      playerNames: ['Alice', 'Bob'],
      roundLimit: 1,
      turnTimeLimit: null,
      gameMode: GameMode.sequence,
    );

    expect(viewModel.canRestart, isTrue);
  });

  test(
    'restart resets scores and turns while keeping players and settings',
    () {
      final viewModel = createViewModel();
      viewModel.start(
        playerNames: ['Alice', 'Bob'],
        roundLimit: 2,
        turnTimeLimit: null,
        gameMode: GameMode.sequence,
      );
      viewModel.completeTurn(wasGuessed: true);

      viewModel.restart();

      expect(viewModel.players.map((p) => p.name), ['Alice', 'Bob']);
      expect(viewModel.players.every((p) => p.score == 0), isTrue);
      expect(viewModel.activePlayer?.name, 'Alice');
      expect(viewModel.completedTurns, 0);
      expect(viewModel.roundLimit, 2);
    },
  );

  group('winnerNext mode', () {
    test('completeTurn awards the point to the chosen guesser and makes them '
        'active', () {
      final viewModel = createViewModel();
      viewModel.start(
        playerNames: ['Alice', 'Bob', 'Cara'],
        roundLimit: null,
        turnTimeLimit: null,
        gameMode: GameMode.winnerNext,
      );

      viewModel.completeTurn(wasGuessed: true, guesserIndex: 2);

      expect(viewModel.players[2].score, 1);
      expect(viewModel.players[0].score, 0);
      expect(viewModel.players[1].score, 0);
      expect(viewModel.activePlayer?.name, 'Cara');
    });

    test('completeTurn falls back to the active player when guesserIndex is '
        'missing or out of range', () {
      final viewModel = createViewModel();
      viewModel.start(
        playerNames: ['Alice', 'Bob'],
        roundLimit: null,
        turnTimeLimit: null,
        gameMode: GameMode.winnerNext,
      );

      viewModel.completeTurn(wasGuessed: true);

      expect(viewModel.players.first.score, 1);
      expect(viewModel.activePlayer?.name, 'Alice');

      viewModel.completeTurn(wasGuessed: true, guesserIndex: 99);

      expect(viewModel.activePlayer?.name, 'Alice');
      expect(viewModel.players.first.score, 2);
    });

    test('completeTurn without a guess still rotates to the next player', () {
      final viewModel = createViewModel();
      viewModel.start(
        playerNames: ['Alice', 'Bob', 'Cara'],
        roundLimit: null,
        turnTimeLimit: null,
        gameMode: GameMode.winnerNext,
      );

      viewModel.completeTurn(wasGuessed: false);

      expect(viewModel.activePlayer?.name, 'Bob');
      expect(viewModel.players.every((p) => p.score == 0), isTrue);
    });
  });
}
