import 'package:flutter/material.dart';
import 'package:pantomias/l10n/l10n.dart';
import 'package:pantomias/shared/widgets/next_button.dart';
import 'package:pantomias/shared/widgets/stage_card.dart';

import '../viewmodel/quick_start_view_model.dart';

class QuickStartScreen extends StatelessWidget {
  const QuickStartScreen({super.key, required this.viewModel});

  final QuickStartViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        final currentImage = viewModel.currentImage;

        return Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 24.0),
          child: Column(
            children: [
              Expanded(
                child: StageCard(
                  key: const ValueKey('image-stage-picture'),
                  isRevealed: viewModel.isImageShown,
                  promptWord: currentImage == null
                      ? ''
                      : context.l10n.pantomimePrompt(currentImage.promptId),
                  imageAssetPath: currentImage?.imageUrl,
                  feedback: null,
                  onTap: viewModel.toggleImage,
                ),
              ),
              const SizedBox(height: 16.0),
              NextButton(
                key: const ValueKey('quick-next-button'),
                icon: Icons.flag,
                label: context.l10n.nextImageLabel,
                labelMaxLines: 2,
                onPressed: viewModel.nextImage,
              ),
            ],
          ),
        );
      },
    );
  }
}
