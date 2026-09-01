import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pantomias/features/result/view/result_screen.dart';
import 'package:pantomias/features/result/viewmodel/result_view_model.dart';
import 'package:pantomias/routing/route_args.dart';
import 'package:pantomias/routing/routes.dart';
import 'package:pantomias/shell/app_scaffold.dart';
import 'package:pantomias/shell/home_icon_button.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key, required this.outcome});

  final GameOutcome outcome;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late final ResultViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ResultViewModel(players: widget.outcome.players);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _restartGame() {
    context.go(Routes.scoreGame, extra: widget.outcome.settings);
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
      title: const SizedBox.shrink(),
      actions: const [SizedBox(width: 64.0)],
      body: ResultScreen(viewModel: _viewModel, onRestartGame: _restartGame),
    );
  }
}
