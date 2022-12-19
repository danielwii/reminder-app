import 'package:asuna_flutter/asuna_flutter.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_buffs/flutter_buffs.dart' hide SplashScreen;

import 'screens/home.dart';
import 'screens/login.dart';
import 'screens/splash.dart';

class Routes {
  static late FluroRouter router;

  static void configureRoutes() {
    logger.info('configure routes...');
    router = FluroRouter();
    router.notFoundHandler =
        Handler(handlerFunc: (context, Map<String, List<String>> params) {
      logger.warning("ROUTE WAS NOT FOUND !!!");
      return;
    });
    router.define(BaseRoutePath.root,
        handler: Handler(
          handlerFunc: (context, Map<String, dynamic> params) =>
              HomeScreen(/*params["id"][0]*/),
        ));
    router.define(BaseRoutePath.login,
        handler: Handler(
          handlerFunc: (context, Map<String, dynamic> params) =>
              LoginScreen(/*params["id"][0]*/),
        ));
    router.define(BaseRoutePath.splash,
        handler: Handler(
          handlerFunc: (context, Map<String, dynamic> params) =>
              const SplashScreen(),
        ));
  }
}
