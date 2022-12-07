import 'package:admin/backend/navigation/navigation_controller.dart';
import 'package:admin/views/authentication/login_screen.dart';
import 'package:admin/views/homescreen/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:hms_models/hms_models.dart';

import '../backend/admin_user/admin_user_controller.dart';
import '../backend/admin_user/admin_user_provider.dart';
import '../backend/authentication/authentication_controller.dart';
import 'common/components/common_text.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "/SplashScreen";

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late ThemeData themeData;

  Future<void> checkLogin() async {
    // await Future.delayed(Duration(seconds: 5));

    AdminUserModel? user = await AuthenticationController().isUserLoggedIn();
    MyPrint.printOnConsole("User From isUserLoggedIn:$user");

    NavigationController.isFirst = false;
    if(user != null) {
      AdminUserProvider adminUserProvider = Provider.of<AdminUserProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);
      AdminUserController(adminUserProvider: adminUserProvider).startAdminUserSubscription();
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
      color: themeData.backgroundColor,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          child: Column(
            children: [
              /*Center(
                child: LoadingAnimationWidget.inkDrop(color: themeData.backgroundColor, size: 40),
              ),*/
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                   Container(
                       padding: const EdgeInsets.all(8),
                       decoration: BoxDecoration(
                         border: Border.all(color: Colors.black,width: 2),
                         borderRadius: BorderRadius.circular(5)
                       ),
                       child: Icon(Icons.vaccines,color: themeData.primaryColor,size: 80),
                   ),
                   const SizedBox(height: 18),
                   const CommonBoldText(text: "Hospital Management \n System",fontSize: 20,textAlign: TextAlign.center,),
                  ],
                ),
              ),
              Center(
                child: LoadingAnimationWidget.inkDrop(color: themeData.primaryColor, size: 40),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
