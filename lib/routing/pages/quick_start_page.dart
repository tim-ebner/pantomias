import 'package:flutter/material.dart';
import 'package:pantomias/core/data/image_meta_info_repository.dart';
import 'package:pantomias/features/quick_start/view/quick_start_screen.dart';
import 'package:pantomias/features/quick_start/viewmodel/quick_start_view_model.dart';
import 'package:pantomias/l10n/l10n.dart';
import 'package:pantomias/shell/app_scaffold.dart';
import 'package:pantomias/shell/home_icon_button.dart';
import 'package:pantomias/shell/title_pill.dart';
import 'package:provider/provider.dart';

class QuickStartPage extends StatefulWidget {
  const QuickStartPage({super.key});

  @override
  State<QuickStartPage> createState() => _QuickStartPageState();
}

class _QuickStartPageState extends State<QuickStartPage> {
  late final QuickStartViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = QuickStartViewModel(
      imageMetaInfoRepository: context.read<ImageMetaInfoRepository>(),
    )..start();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      toolbarHeight: 64.0,
      leadingWidth: 64.0,
      showDivider: false,
      leading: const Padding(
        padding: EdgeInsets.only(left: 20.0),
        child: HomeIconButton(),
      ),
      title: TitlePill(label: context.l10n.quickStartLabel.toUpperCase()),
      actions: const [SizedBox(width: 64.0)],
      body: QuickStartScreen(viewModel: _viewModel),
    );
  }
}
