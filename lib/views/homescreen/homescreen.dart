import 'package:admin/views/homescreen/components/custom_bottom_navigation_bar.dart';
import 'package:admin/views/homescreen/dashboard_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/HomeScreen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return mainBody();
  }

  Widget mainBody(){
    return CustomBottomNavigation(
      icons: const [
        Icons.dashboard_outlined,
        Icons.history,
        Icons.file_copy_outlined
      ],
      activeIcons: const [
        Icons.dashboard,
        Icons.history,
        Icons.file_copy
      ],
      screens: [
        DashboardScreen(),
        Container(child: const Text("History"),),
        Container(child: const Text("Treatment"),),
      ],
      titles: const ["Dashboard", "History", "Treatment"],
      color: themeData.colorScheme.onBackground,
      activeColor: themeData.colorScheme.primary,
      navigationBackground: themeData.backgroundColor,
      brandTextColor: themeData.colorScheme.onBackground,
      initialIndex: 2,
      splashColor: themeData.splashColor,
      highlightColor: themeData.highlightColor,
      backButton: Container(),
      floatingActionButton: Container(),
      iconSize: 20,
      activeIconSize: 20,
      verticalDividerColor: themeData.dividerColor,
      bottomNavigationElevation: 8,
    );
  }
}
