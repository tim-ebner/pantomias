import 'package:flutter/material.dart';
import 'package:pantomias/ui/home/widgets/next_button.dart';
import 'package:pantomias/ui/shared/image_stage/image_stage.dart';

import 'quick_start_view_model.dart';

class QuickStartScreen extends StatelessWidget {
  const QuickStartScreen({super.key, required this.viewModel});

  final QuickStartViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: ImageStage(
              key: const ValueKey('quick-image-stage'),
              viewModel: viewModel,
            ),
          ),
          NextButton(
            key: const ValueKey('quick-next-button'),
            icon: Icons.flag,
            label: 'Nächstes Bild',
            labelMaxLines: 2,
            onPressed: viewModel.nextImage,
          ),
        ],
      ),
    );
  }
}
