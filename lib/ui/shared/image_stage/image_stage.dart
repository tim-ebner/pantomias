import 'package:flutter/material.dart';

import 'image_deck_view_model.dart';

class ImageStage extends StatelessWidget {
  const ImageStage({super.key, required this.viewModel});

  final ImageDeckViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                viewModel.imageName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Center(
                child: Image.asset(
                  viewModel.imageAssetPath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            IconButton.filledTonal(
              key: const ValueKey('toggle-image-button'),
              tooltip: viewModel.isImageShown
                  ? 'Bild ausblenden'
                  : 'Bild anzeigen',
              onPressed: viewModel.toggleImage,
              icon: Icon(
                viewModel.isImageShown
                    ? Icons.visibility_off
                    : Icons.visibility,
                size: 30.0,
              ),
            ),
          ],
        );
      },
    );
  }
}
