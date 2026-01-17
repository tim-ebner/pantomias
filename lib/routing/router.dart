import 'package:go_router/go_router.dart';
import 'package:pantomias/routing/routes.dart';
import 'package:provider/provider.dart';

import '../ui/home/home_page.dart';
import '../ui/home/home_view_model.dart';

GoRouter router() => GoRouter(
  initialLocation: Routes.home,
  routes: [
    GoRoute(
      path: Routes.home,
      builder: (context, state) {
        final viewModel = HomeViewModel(imageMetaInfoRepository: context.read());
        return HomePage(viewModel: viewModel);
      },
    ),
  ],
);
