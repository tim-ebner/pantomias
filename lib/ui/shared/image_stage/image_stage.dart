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
