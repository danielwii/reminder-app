import 'dart:async';
import 'dart:io';

import 'package:asuna_flutter/asuna_flutter.dart' hide Platform;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_buffs/flutter_buffs.dart' hide SplashScreen, Routes;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:reminder/router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:simple_logger/simple_logger.dart';

import 'env.dart';
import 'firebase_options.dart';
import 'screens/splash.dart';
import 'utils.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runZonedGuarded(
    () async {
      logger.setLevel(
        kDebugMode ? Level.FINER : Level.FINE,
        includeCallerInfo: true,
        stackTraceLevel: Level.WARNING,
      );

      final firstRun = await IsFirstRun.isFirstRun();
      logger.info('isFirstRun $firstRun');

      if (firstRun) {
        logger.info('clean cache at first run');
        await DefaultCacheManager().emptyCache();
      }
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isIOS) {
        final iosDeviceInfo = await deviceInfo.iosInfo;
        AppContext.isPad = iosDeviceInfo.model == 'iPad';
      }

      final packageInfo = await PackageInfo.fromPlatform();
      final version = packageInfo.version;
      final buildNumber = packageInfo.buildNumber;
      logger.info(
          'platform $defaultTargetPlatform isWeb:$kIsWeb isPad:${AppContext.isPad}');
      final env = '$version+$buildNumber${kDebugMode ? "-dev" : ""}';
      logger.info('version $env');

      /// ***  Initialize Firebase App *** ///
      final firebaseApp = await Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform)
          .then((app) {
        /// Update the iOS foreground notification presentation options to allow
        /// heads up notifications.
        /// Check iOS device
        if (Platform.isIOS) {
          /*
          FirebaseMessaging.instance
              .setForegroundNotificationPresentationOptions(
            alert: true,
            badge: true,
            sound: true,
          );*/
        }
        return app;
      });
      final analytics = FirebaseAnalytics.instanceFor(app: firebaseApp);
      final observer = FirebaseAnalyticsObserver(analytics: analytics);

      await initHiveForFlutter();
      await appInitializer(
          appEnv: AppEnv(HOSTNAME: 'reminder.jp.ngrok.io'),
          serverConnection: ServerConnection(),
          setTraceUser: defaultSetTraceUser);

      // enforce orientations is up and down
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      final app = ProviderScope(
          observers: [ProviderLogger()],
          child: App(title: 'Thinking of YOU', observer: observer));
      if (!kDebugMode) {
        return SentryFlutter.init(
          (options) {
            options.debug = kDebugMode;
            options.environment = !kDebugMode ? 'production' : 'development';
            options.release = '${packageInfo.appName}@$version+$buildNumber';
            options.dsn = EnvironmentConfig.sentryDsn;
            // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
            // We recommend adjusting this value in production.
            options.tracesSampleRate = 1; // 0.2;
          },
          appRunner: () => runApp(app),
        );
      } else {
        runApp(app);
      }
    },
    (exception, stackTrace) {
      logger.severe('Unhandled Exception Found: $exception $stackTrace');
      Sentry.captureException(exception, stackTrace: stackTrace);
    },
  );
}

/// This widget is the root of your application.
class App extends HookWidget {
  final String title;
  final FirebaseAnalyticsObserver observer;

  App({super.key, required this.title, required this.observer}) {
    Routes.configureRoutes();
    Token.loadFromStorage();
    CurrentUserImpl.loadFromStorage();
    GraphQL.ins.init(AppContext.connection.resolveUrl('graphql'));
  }

  @override
  Widget build(BuildContext context) {
    useEffectOnce(() {
      AuthHandler.reg(
        userParser: (json) => CurrentUserImpl.fromJson(json)..saveToStorage(),
        onLogout: (redirect, userId) {
          CurrentUserImpl.cleanSaved();
          GraphQL.ins.client.cache.store.reset();
          FirebaseAnalytics.instance
              .logEvent(name: 'logout', parameters: {'userId': userId});
          if (redirect) {
            Routes.router.navigateTo(context, BaseRoutePath.login);
          }
        },
        onSignUp: (username, method) {
          AuthStore.ins.saveUsername(username);
          FirebaseAnalytics.instance.logSignUp(signUpMethod: method);
        },
        onLogin: (user, method) {
          AuthStore.ins.saveUsername(user.profile!.username!);
          defaultSetTraceUser(uid: user.id);
          GraphQL.ins.client.cache.store.reset();
          FirebaseAnalytics.instance.logLogin(loginMethod: method);
        },
      );
      return null;
    });
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: kDebugMode,
      // debugShowMaterialGrid: kDebugMode,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      onGenerateRoute: Routes.router.generator,
      home: const SplashScreen(),
      navigatorObservers: [observer],
      // initialRoute: BaseRoutePath.splash,
    );
  }
}
