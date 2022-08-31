import 'package:admin/utils/logger_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/navigation_controller.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Log().d("MyApp Build Called");

    return MultiProvider(
      providers: const [
        // ChangeNotifierProvider(create: (_) => DataProvider()),

      ],
      child: MainApp(),
    );
  }
}

class MainApp extends StatelessWidget {
  MainApp({Key? key}) : super(key: key);
  final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    Log().d("MainApp Build Called");

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationController.mainScreenNavigator,
      title: "Sportiwe",
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: NavigationController.onMainGeneratedRoutes,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: firebaseAnalytics),
      ],
    );
  }
}
