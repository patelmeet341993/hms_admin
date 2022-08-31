import 'package:admin/views/authentication/login_screen.dart';
import 'package:admin/views/homescreen/homescreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/logger_service.dart';
import '../views/splashscreen.dart';

class NavigationController {
  static NavigationController? _instance;
  static String chatRoomId = "";
  static bool isNoInternetScreenShown = false;
  static bool isFirst = true;

  factory NavigationController() {
    _instance ??= NavigationController._();
    return _instance!;
  }

  NavigationController._();

  static final GlobalKey<NavigatorState> mainScreenNavigator = GlobalKey<NavigatorState>();

  static bool isUserProfileTabInitialized = false;


  static bool checkDataAndNavigateToSplashScreen() {
    Log().d("checkDataAndNavigateToSplashScreen called, isFirst:$isFirst");

    if(isFirst) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        isFirst = false;
        Navigator.pushNamedAndRemoveUntil(mainScreenNavigator.currentContext!, SplashScreen.routeName, (route) => false);
      });
    }

    return isFirst;
  }

  static Route? onMainGeneratedRoutes(RouteSettings settings) {
    Log().d("OnMainGeneratedRoutes called for ${settings.name}");

    // if(navigationCount == 2 && Uri.base.hasFragment && Uri.base.fragment != "/") {
    //   return null;
    // }

    if(!["/", SplashScreen.routeName].contains(settings.name) && NavigationController.checkDataAndNavigateToSplashScreen()) {
      return null;
    }

    Log().d("Not First Page");
    Widget? page;

    switch (settings.name) {
      case "/": {
        page = const SplashScreen();
        break;
      }
      case SplashScreen.routeName: {
        page = const SplashScreen();
        break;
      }
      case LoginScreen.routeName: {
        page = const LoginScreen();
        break;
      }
      case HomeScreen.routeName: {
        page = const HomeScreen();
        break;
      }
    }

    if (page != null) {
      return PageRouteBuilder(
        pageBuilder: (c, a1, a2) => page!,
        //transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
        transitionsBuilder: (c, anim, a2, child) => SizeTransition(sizeFactor: anim, child: child),
        transitionDuration: const Duration(milliseconds: 0),
        settings: settings,
      );
    }
  }
}
