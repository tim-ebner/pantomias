import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pantomias/data/model/image_meta_info.dart';
import 'package:pantomias/data/model/image_meta_info_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final ImageMetaInfoRepository _imageMetaInfoRepository;

  HomeViewModel({required ImageMetaInfoRepository imageMetaInfoRepository})
    : _imageMetaInfoRepository = imageMetaInfoRepository {
    resetGame();
  }

  bool _isImageShown = true;
  bool get isImageShown => _isImageShown;

  late List<ImageMetaInfo> allImages;
  late String _imageName;
  String get imageName => _isImageShown ? _imageName : 'Versteckt';
  late String _currentImageAssetPath;
  String get imageAssetPath => _isImageShown ? _currentImageAssetPath : 'assets/images/hidden.webp';
  final Icon _hideIcon = Icon(Icons.visibility_off, size: 30.0);
  final Icon _showIcon = Icon(Icons.visibility, size: 30.0);
  Icon get toggleIcon => _isImageShown ? _hideIcon : _showIcon;

  void toggleImage() {
    _isImageShown = !_isImageShown;
    notifyListeners();
  }

  void resetGame() {
    _isImageShown = true;
    allImages = _imageMetaInfoRepository.getAllImageMetaInfo();
    nextImage();
    notifyListeners();
  }

  void nextImage() {
    if (allImages.isEmpty) {
      allImages = _imageMetaInfoRepository.getAllImageMetaInfo();
    }
    final randomIndex = Random().nextInt(allImages.length);
    final nextImage = allImages.removeAt(randomIndex);
    _imageName = nextImage.name;
    _currentImageAssetPath = nextImage.imageUrl;
    print(allImages);
    notifyListeners();
  }
}
