import 'package:admin/controllers/navigation_controller.dart';
import 'package:admin/models/admin_user_model.dart';
import 'package:admin/utils/logger_service.dart';
import 'package:admin/views/authentication/login_screen.dart';
import 'package:admin/views/homescreen/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../controllers/authentication_controller.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "/SplashScreen";

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late ThemeData themeData;

  Future<void> checkLogin() async {
    // await Future.delayed(Duration(seconds: 2));

    AdminUserModel? user = await AuthenticationController().isUserLoggedIn();
    Log().i("User From isUserLoggedIn:$user");

    NavigationController.isFirst = false;
    if(user != null) {
      Navigator.pushNamedAndRemoveUntil(NavigationController.mainScreenNavigator.currentContext!, HomeScreen.routeName, (route) => false);
    }
    else {
      Navigator.pushNamedAndRemoveUntil(NavigationController.mainScreenNavigator.currentContext!, LoginScreen.routeName, (route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      checkLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return Container(
      child: Scaffold(
        body: Center(
          child: LoadingAnimationWidget.inkDrop(color: themeData.primaryColor, size: 40),
        ),
      ),
    );
  }
}
