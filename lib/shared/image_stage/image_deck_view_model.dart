import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:pantomias/core/data/image_meta_info.dart';
import 'package:pantomias/core/data/image_meta_info_repository.dart';
import 'package:pantomias/core/data/image_show_history_repository.dart';

class ImageDeckViewModel extends ChangeNotifier {
  ImageDeckViewModel({
    required ImageMetaInfoRepository imageMetaInfoRepository,
    required ImageShowHistoryRepository imageShowHistoryRepository,
    Random? random,
  }) : _imageMetaInfoRepository = imageMetaInfoRepository,
       _imageShowHistoryRepository = imageShowHistoryRepository,
       _random = random ?? Random();

  final ImageMetaInfoRepository _imageMetaInfoRepository;
  final ImageShowHistoryRepository _imageShowHistoryRepository;
  final Random _random;

  bool _isImageShown = true;
  bool get isImageShown => _isImageShown;

  List<ImageMetaInfo> _remainingImages = [];
  ImageMetaInfo? _currentImage;
  ImageMetaInfo? get currentImage => _currentImage;

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
      if (_currentImage != null && _remainingImages.length > 1) {
        _remainingImages.removeWhere(
          (image) => image.promptId == _currentImage!.promptId,
        );
      }
    }

    final showCounts = _imageShowHistoryRepository.loadShowCounts();
    _currentImage = _pickWeighted(_remainingImages, showCounts);
    unawaited(_imageShowHistoryRepository.recordShown(_currentImage!.promptId));

    if (revealImage) {
      _isImageShown = true;
    }

    if (notify) {
      notifyListeners();
    }
  }

  ImageMetaInfo _pickWeighted(
    List<ImageMetaInfo> pool,
    Map<String, int> showCounts,
  ) {
    final weights = [
      for (final image in pool) 1 / (1 + (showCounts[image.promptId] ?? 0)),
    ];
    final totalWeight = weights.reduce((a, b) => a + b);
    var target = _random.nextDouble() * totalWeight;
    for (var i = 0; i < pool.length; i++) {
      target -= weights[i];
      if (target <= 0) {
        return pool.removeAt(i);
      }
    }
    return pool.removeLast();
  }
}
