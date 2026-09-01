import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pantomias/core/data/image_meta_info.dart';
import 'package:pantomias/core/data/image_meta_info_repository.dart';
import 'package:pantomias/core/data/image_show_history_repository.dart';
import 'package:pantomias/shared/image_stage/image_deck_view_model.dart';

class _MockImageMetaInfoRepository extends Mock
    implements ImageMetaInfoRepository {}

class _MockImageShowHistoryRepository extends Mock
    implements ImageShowHistoryRepository {}

void main() {
  late _MockImageMetaInfoRepository imageMetaInfoRepository;
  late _MockImageShowHistoryRepository imageShowHistoryRepository;

  const images = [
    ImageMetaInfo(promptId: 'cat', imageUrl: 'cat.webp'),
    ImageMetaInfo(promptId: 'dog', imageUrl: 'dog.webp'),
  ];

  setUp(() {
    imageMetaInfoRepository = _MockImageMetaInfoRepository();
    when(
      () => imageMetaInfoRepository.getAllImageMetaInfo(),
    ).thenAnswer((_) => List.of(images));

    imageShowHistoryRepository = _MockImageShowHistoryRepository();
    when(
      () => imageShowHistoryRepository.loadShowCounts(),
    ).thenReturn({});
    when(
      () => imageShowHistoryRepository.recordShown(any()),
    ).thenAnswer((_) async {});
  });

  ImageDeckViewModel createViewModel({Random? random}) {
    final viewModel = ImageDeckViewModel(
      imageMetaInfoRepository: imageMetaInfoRepository,
      imageShowHistoryRepository: imageShowHistoryRepository,
      random: random ?? Random(0),
    );
    addTearDown(viewModel.dispose);
    return viewModel;
  }

  test('start picks a shown image from the repository', () {
    final viewModel = createViewModel();

    viewModel.start();

    expect(viewModel.isImageShown, isTrue);
    expect(viewModel.currentImage, isNotNull);
    expect(images.map((i) => i.promptId), contains(viewModel.currentImage!.promptId));
  });

  test('toggleImage hides and reveals the current image', () {
    final viewModel = createViewModel();
    viewModel.start();

    viewModel.toggleImage();
    expect(viewModel.isImageShown, isFalse);

    viewModel.toggleImage();
    expect(viewModel.isImageShown, isTrue);
  });

  test('nextImage cycles through every image without repeats before reshuffling', () {
    final viewModel = createViewModel();
    viewModel.start();

    final seen = <String>{viewModel.currentImage!.promptId};
    viewModel.nextImage();
    seen.add(viewModel.currentImage!.promptId);

    expect(seen, images.map((i) => i.promptId).toSet());
  });

  test('nextImage with revealImage forces the image to be shown', () {
    final viewModel = createViewModel();
    viewModel.start();
    viewModel.toggleImage();
    expect(viewModel.isImageShown, isFalse);

    viewModel.nextImage(revealImage: true);

    expect(viewModel.isImageShown, isTrue);
  });

  test('start and nextImage record the picked image in show history', () {
    final viewModel = createViewModel();

    viewModel.start();
    verify(
      () => imageShowHistoryRepository.recordShown(
        viewModel.currentImage!.promptId,
      ),
    ).called(1);

    viewModel.nextImage();
    verify(
      () => imageShowHistoryRepository.recordShown(
        viewModel.currentImage!.promptId,
      ),
    ).called(1);
  });

  test('weighted draw strongly prefers a never-shown image over a heavily-shown one', () {
    when(() => imageShowHistoryRepository.loadShowCounts()).thenReturn({
      'cat': 1000,
      'dog': 0,
    });
    final viewModel = createViewModel(random: Random(42));

    viewModel.start();

    expect(viewModel.currentImage!.promptId, 'dog');
  });

  test('the just-shown image is excluded from the immediately-following reshuffle', () {
    final threeImages = [
      const ImageMetaInfo(promptId: 'cat', imageUrl: 'cat.webp'),
      const ImageMetaInfo(promptId: 'dog', imageUrl: 'dog.webp'),
      const ImageMetaInfo(promptId: 'bird', imageUrl: 'bird.webp'),
    ];
    when(
      () => imageMetaInfoRepository.getAllImageMetaInfo(),
    ).thenAnswer((_) => List.of(threeImages));
    final viewModel = createViewModel();
    viewModel.start();

    // Exhaust the pool (2 more draws after the initial one from start()).
    viewModel.nextImage();
    viewModel.nextImage();
    final lastOfPass = viewModel.currentImage!.promptId;

    // Reshuffle boundary: the very next pick must not repeat lastOfPass.
    viewModel.nextImage();

    expect(viewModel.currentImage!.promptId, isNot(lastOfPass));
  });
}
