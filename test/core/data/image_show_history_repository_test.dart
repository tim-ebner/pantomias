import 'package:flutter_test/flutter_test.dart';
import 'package:pantomias/core/data/image_show_history_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<ImageShowHistoryRepository> createRepository() async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    return ImageShowHistoryRepository(preferences: preferences);
  }

  test('loads an empty map when nothing was saved', () async {
    final repository = await createRepository();

    expect(repository.loadShowCounts(), isEmpty);
  });

  test('recordShown starts a count at 1 for a new promptId', () async {
    final repository = await createRepository();

    await repository.recordShown('cat');

    expect(repository.loadShowCounts(), {'cat': 1});
  });

  test('recordShown increments an existing count and persists it', () async {
    final repository = await createRepository();

    await repository.recordShown('cat');
    await repository.recordShown('cat');
    await repository.recordShown('cat');

    expect(repository.loadShowCounts(), {'cat': 3});
  });

  test('tracks distinct promptIds independently', () async {
    final repository = await createRepository();

    await repository.recordShown('cat');
    await repository.recordShown('dog');
    await repository.recordShown('cat');

    expect(repository.loadShowCounts(), {'cat': 2, 'dog': 1});
  });

  test('counts survive a fresh repository backed by the same preferences', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final firstRepository = ImageShowHistoryRepository(
      preferences: preferences,
    );
    await firstRepository.recordShown('cat');

    final secondRepository = ImageShowHistoryRepository(
      preferences: preferences,
    );

    expect(secondRepository.loadShowCounts(), {'cat': 1});
  });
}
