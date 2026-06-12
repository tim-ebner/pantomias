import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:pantomias/data/model/image_meta_info.dart';
import 'package:pantomias/data/model/image_meta_info_repository.dart';

class ImageDeckViewModel extends ChangeNotifier {
  ImageDeckViewModel({
    required ImageMetaInfoRepository imageMetaInfoRepository,
    Random? random,
  }) : _imageMetaInfoRepository = imageMetaInfoRepository,
       _random = random ?? Random();

  static const hiddenImageAssetPath = 'assets/images/hidden.webp';

  final ImageMetaInfoRepository _imageMetaInfoRepository;
  final Random _random;

  bool _isImageShown = true;
  bool get isImageShown => _isImageShown;

  List<ImageMetaInfo> _remainingImages = [];
  ImageMetaInfo? _currentImage;
  ImageMetaInfo? get currentImage => _currentImage;

  String get imageAssetPath {
    final currentImage = _currentImage;
    if (currentImage == null || !_isImageShown) {
      return hiddenImageAssetPath;
    }

    return currentImage.imageUrl;
  }

  void start() {
    _resetImages();
    _nextImage(revealImage: true, notify: false);
    notifyListeners();
  }

  void toggleImage() {
    _isImageShown = !_isImageShown;
    notifyListeners();
  }

  void nextImage({bool revealImage = false}) {
    _nextImage(revealImage: revealImage);
  }

  void _resetImages() {
    _isImageShown = true;
    _remainingImages = _imageMetaInfoRepository.getAllImageMetaInfo();
  }

  void _nextImage({required bool revealImage, bool notify = true}) {
    if (_remainingImages.isEmpty) {
      _remainingImages = _imageMetaInfoRepository.getAllImageMetaInfo();
    }

    final randomIndex = _random.nextInt(_remainingImages.length);
    _currentImage = _remainingImages.removeAt(randomIndex);

    if (revealImage) {
      _isImageShown = true;
    }

    if (notify) {
      notifyListeners();
    }
  }
}
