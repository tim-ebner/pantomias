import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pantomias/core/data/image_meta_info.dart';
import 'package:pantomias/core/data/image_meta_info_repository.dart';
import 'package:pantomias/shared/image_stage/image_deck_view_model.dart';

class _MockImageMetaInfoRepository extends Mock
    implements ImageMetaInfoRepository {}

void main() {
  late _MockImageMetaInfoRepository imageMetaInfoRepository;

  const images = [
    ImageMetaInfo(promptId: 'cat', imageUrl: 'cat.webp'),
    ImageMetaInfo(promptId: 'dog', imageUrl: 'dog.webp'),
  ];

  setUp(() {
    imageMetaInfoRepository = _MockImageMetaInfoRepository();
    when(
      () => imageMetaInfoRepository.getAllImageMetaInfo(),
    ).thenAnswer((_) => List.of(images));
  });

  ImageDeckViewModel createViewModel() {
    final viewModel = ImageDeckViewModel(
      imageMetaInfoRepository: imageMetaInfoRepository,
      random: Random(0),
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
}
