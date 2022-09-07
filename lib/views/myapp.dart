import 'package:admin/configs/app_theme.dart';
import 'package:admin/providers/admin_user_provider.dart';
import 'package:admin/providers/app_theme_provider.dart';
import 'package:admin/providers/connection_provider.dart';
import 'package:admin/utils/logger_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/navigation_controller.dart';
import '../providers/patient_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Log().d("MyApp Build Called");

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppThemeProvider>(create: (_) => AppThemeProvider(), lazy: false),
        ChangeNotifierProvider<ConnectionProvider>(create: (_) => ConnectionProvider(), lazy: false),
        ChangeNotifierProvider<AdminUserProvider>(create: (_) => AdminUserProvider(), lazy: false),
        ChangeNotifierProvider<PatientProvider>(create: (_) => PatientProvider(), lazy: false),
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

    return Consumer<AppThemeProvider>(
      builder: (BuildContext context, AppThemeProvider appThemeProvider, Widget? child) {
        //Log().i("ThemeMode:${appThemeProvider.themeMode}");

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: NavigationController.mainScreenNavigator,
          title: "HMS Admin",
          theme: AppTheme.getThemeFromThemeMode(appThemeProvider.themeMode),
          onGenerateRoute: NavigationController.onMainGeneratedRoutes,
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: firebaseAnalytics),
          ],
        );
      },
    );
  }
}
