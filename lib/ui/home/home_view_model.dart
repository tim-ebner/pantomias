import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pantomias/data/model/image_meta_info_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final ImageMetaInfoRepository _imageMetaInfoRepository;

  HomeViewModel({required ImageMetaInfoRepository imageMetaInfoRepository})
    : _imageMetaInfoRepository = imageMetaInfoRepository {
    nextImage();
  }

  bool _isImageShown = true;
  bool get isImageShown => _isImageShown;

  String _imageName = "Katze";
  String get imageName => _isImageShown ? _imageName : 'Versteckt';
  String _currentImageAssetPath = 'assets/images/pants/cat.jpg';
  String get imageAssetPath => _isImageShown ? _currentImageAssetPath : 'assets/images/hidden.png';
  final Icon _hideIcon = Icon(Icons.visibility_off, size: 30.0);
  final Icon _showIcon = Icon(Icons.visibility, size: 30.0);
  Icon get toggleIcon => _isImageShown ? _hideIcon : _showIcon;

  void toggleImage() {
    _isImageShown = !_isImageShown;
    notifyListeners();
  }

  void nextImage() {
    final allImages = _imageMetaInfoRepository.getAllImageMetaInfo();
    final randomIndex = Random().nextInt(allImages.length);
    final nextImage = allImages[randomIndex];
    _imageName = nextImage.name;
    _currentImageAssetPath = nextImage.imageUrl;
    notifyListeners();
  }
}
