import 'dart:async';
import 'dart:io';

import 'package:admin/backend/common/app_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hms_models/hms_models.dart';

import 'configs/credentials.dart';

/// Runs the app in [runZonedGuarded] to handle all types of errors, including [FlutterError]s.
/// Any error that is caught will be send to Sentry backend
Future<void>? runErrorSafeApp(VoidCallback appRunner, {bool isDev = false, required String hospitalId}) {
  return runZonedGuarded<Future<void>>(
    () async {
      await initApp(isDev: isDev, hospitalId: hospitalId);
      appRunner();
    },
    (e, s) {
      MyPrint.printOnConsole("Error in runZonedGuarded:$e");
      MyPrint.printOnConsole(s);
      // AnalyticsController().recordError(e, stackTrace);
    },
  );
}

/// It provides initial initialisation the app and its global services
Future<void> initApp({bool isDev = false, required String hospitalId}) async {
  WidgetsFlutterBinding.ensureInitialized();
  AppController().isDev = isDev;
  AppController().hospitalId = hospitalId;

  List<Future> futures = [];

  if (kIsWeb) {
    FirebaseOptions options = getFirebaseOptions(isDev: isDev);
    MyPrint.printOnConsole(options);

    futures.addAll([
      Firebase.initializeApp(
        options: options,
      ),
      SystemChrome.setPreferredOrientations(<DeviceOrientation>[
        DeviceOrientation.landscapeLeft,
      ]),
    ]);
  }
  else {
    if(Platform.isAndroid || Platform.isIOS) {
      HttpOverrides.global = MyHttpOverrides();
      HttpClient httpClient = HttpClient();
      httpClient.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

      futures.addAll([
        Firebase.initializeApp(),
        SystemChrome.setPreferredOrientations(<DeviceOrientation>[
          DeviceOrientation.portraitUp,
        ]),
      ]);
    }
  }

  await Future.wait(futures);

  if(!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    await Future.wait([
      FirebaseMessaging.instance.requestPermission(),
      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      ),
    ]);
  }
  MyPrint.printOnConsole('Running ${isDev ? 'dev' : 'prod'} version...');
}
