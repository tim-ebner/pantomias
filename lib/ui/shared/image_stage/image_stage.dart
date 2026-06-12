import 'package:flutter/material.dart';
import 'package:pantomias/l10n/l10n.dart';

import 'image_deck_view_model.dart';

class ImageStage extends StatelessWidget {
  const ImageStage({super.key, required this.viewModel});

  final ImageDeckViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        final currentImage = viewModel.currentImage;
        final imageLabel = currentImage == null
            ? ''
            : viewModel.isImageShown
            ? context.l10n.pantomimePrompt(currentImage.promptId)
            : context.l10n.imageHiddenLabel;

        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                imageLabel,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: GestureDetector(
                key: const ValueKey('image-stage-picture'),
                behavior: HitTestBehavior.opaque,
                onTap: viewModel.toggleImage,
                child: Center(
                  child: Image.asset(
                    viewModel.imageAssetPath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
