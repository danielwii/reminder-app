import 'dart:async';

import 'package:asuna_flutter/asuna_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_buffs/flutter_buffs.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void setupTrace({String? uid}) async {
  logger.fine('set trace user id:$uid');
  /*
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  final version = '${packageInfo.version}+${packageInfo.buildNumber}';
  await FirebaseAnalytics.instance.setDefaultEventParameters({
    'version': version,
    'platform': defaultTargetPlatform.name,
  });*/
  if (uid != null) {
    Sentry.configureScope((scope) {
      scope.setUser(SentryUser(id: uid));
      // scope.setExtra('connect_point', EnvironmentConfig.hostname);
    });
    /*
    FirebaseCrashlytics.instance
        .setUserIdentifier(id!);*/
    FirebaseAnalytics.instance.setUserId(id: uid);
    // FirebaseAnalytics.instance.setUserProperty(name: 'connect_point', value: EnvironmentConfig.hostname);
    /*
    FirebaseAnalytics.instance
        .setUserProperty(name: 'platform', value: defaultTargetPlatform.name);*/
  }
}

class ProviderLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    logger.finest('''
{
  "provider": "${provider.name ?? provider.runtimeType}",
  "newValue": "$newValue"
}''');
  }
}
