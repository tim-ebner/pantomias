import 'package:flutter_test/flutter_test.dart';
import 'package:pantomias/core/data/image_meta_info_repository.dart';

void main() {
  test('returns a non-empty list with unique prompt ids', () {
    final repository = ImageMetaInfoRepository();

    final allImages = repository.getAllImageMetaInfo();

    expect(allImages, isNotEmpty);
    expect(allImages.map((image) => image.promptId).toSet(), hasLength(allImages.length));
  });

  test('every image url points at a webp asset under assets/images/pants', () {
    final repository = ImageMetaInfoRepository();

    final allImages = repository.getAllImageMetaInfo();

    for (final image in allImages) {
      expect(image.imageUrl, startsWith('assets/images/pants/'));
      expect(image.imageUrl, endsWith('.webp'));
    }
  });
}
