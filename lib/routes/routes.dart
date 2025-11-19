import 'package:auto_route/auto_route.dart';
import 'package:education_gen_ui/routes/routes.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: ChatRoute.page, initial: true),
  ];
}
