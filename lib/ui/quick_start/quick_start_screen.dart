import 'package:flutter/material.dart';

import '../shared/image_stage/image_stage.dart';
import 'quick_start_view_model.dart';

class QuickStartScreen extends StatelessWidget {
  const QuickStartScreen({super.key, required this.viewModel});

  final QuickStartViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ImageStage(viewModel: viewModel),
    );
  }
}
