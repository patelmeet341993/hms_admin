import 'package:admin/backend/admin_user/admin_user_provider.dart';
import 'package:admin/backend/app_theme/app_theme_provider.dart';
import 'package:admin/backend/connection/connection_provider.dart';
import 'package:admin/configs/app_theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hms_models/utils/my_print.dart';
import 'package:provider/provider.dart';

import '../backend/navigation/navigation_controller.dart';
import '../backend/patient/patient_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MyPrint.printOnConsole("MyApp Build Called");

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
    MyPrint.printOnConsole("MainApp Build Called");

    return Consumer<AppThemeProvider>(
      builder: (BuildContext context, AppThemeProvider appThemeProvider, Widget? child) {
        //MyPrint.printOnConsole("ThemeMode:${appThemeProvider.themeMode}");

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
