import 'dart:async';
import 'dart:io';

import 'package:admin/controllers/app_controller.dart';
import 'package:admin/utils/logger_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'configs/credentials.dart';
import 'utils/my_http_overrides.dart';

/// Runs the app in [runZonedGuarded] to handle all types of errors, including [FlutterError]s.
/// Any error that is caught will be send to Sentry backend
Future<void>? runErrorSafeApp(VoidCallback appRunner, {bool isDev = false}) {
  return runZonedGuarded<Future<void>>(
    () async {
      await initApp(isDev: isDev);
      appRunner();
    },
    (e, stackTrace) {
      Log().e(e, stackTrace);
      // AnalyticsController().recordError(e, stackTrace);
    },
  );
}

/// It provides initial initialisation the app and its global services
Future<void> initApp({bool isDev = false}) async {
  WidgetsFlutterBinding.ensureInitialized();
  AppController().isDev = isDev;

  List<Future> futures = [
    Firebase.initializeApp(options: getFirebaseOptions(isDev: isDev),),
  ];

  if (!kIsWeb) {
    HttpOverrides.global = MyHttpOverrides();
    HttpClient httpClient = HttpClient();
    httpClient.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

    futures.addAll([
      SystemChrome.setPreferredOrientations(<DeviceOrientation>[
        DeviceOrientation.portraitUp,
      ]),
      FirebaseMessaging.instance.requestPermission(),
      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      ),
    ]);
  }
  else {
    futures.addAll([
      SystemChrome.setPreferredOrientations(<DeviceOrientation>[
        DeviceOrientation.landscapeLeft,
      ]),
    ]);
  }

  await Future.wait(futures);
  Log.tag = 'hms';
  Log().d('Running ${isDev ? 'dev' : 'prod'} version...');
}
