import 'package:flutter_test/flutter_test.dart';
import 'package:pantomias/core/data/game_mode.dart';
import 'package:pantomias/core/data/scored_game_settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<ScoredGameSettingsRepository> createRepository() async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    return ScoredGameSettingsRepository(preferences: preferences);
  }

  test('loads empty defaults when nothing was saved', () async {
    final repository = await createRepository();

    expect(repository.loadPlayerNames(), isEmpty);
    expect(repository.loadRoundLimitText(), '');
    expect(repository.loadTurnTimeLimitText(), '');
    expect(repository.loadGameMode(), GameMode.winnerNext);
  });

  test('saveGameMode persists the chosen mode for later loads', () async {
    final repository = await createRepository();

    await repository.saveGameMode(GameMode.sequence);

    expect(repository.loadGameMode(), GameMode.sequence);

    await repository.saveGameMode(GameMode.winnerNext);

    expect(repository.loadGameMode(), GameMode.winnerNext);
  });

  test('save persists player names and limits for later loads', () async {
    final repository = await createRepository();

    await repository.save(
      playerNames: ['Alice', 'Bob'],
      roundLimitText: '3',
      turnTimeLimitText: '1:30',
    );

    expect(repository.loadPlayerNames(), ['Alice', 'Bob']);
    expect(repository.loadRoundLimitText(), '3');
    expect(repository.loadTurnTimeLimitText(), '1:30');
  });

  test('save overwrites previously persisted values', () async {
    final repository = await createRepository();
    await repository.save(
      playerNames: ['Alice'],
      roundLimitText: '1',
      turnTimeLimitText: '0:30',
    );

    await repository.save(
      playerNames: ['Cara', 'Dana'],
      roundLimitText: '5',
      turnTimeLimitText: '',
    );

    expect(repository.loadPlayerNames(), ['Cara', 'Dana']);
    expect(repository.loadRoundLimitText(), '5');
    expect(repository.loadTurnTimeLimitText(), '');
  });
}
