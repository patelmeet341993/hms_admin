import 'package:admin/views/admin_users/admin_users_list_screen.dart';
import 'package:admin/views/common/models/home_screen_component_model.dart';
import 'package:flutter/material.dart';
import 'package:hms_models/configs/constants.dart';
import 'package:hms_models/hms_models.dart';

import '../views/Scanner/scanner.dart';
import '../views/homescreen/dashboard_screen.dart';
import '../views/profile/admin_user_profile_screen.dart';
import 'app_strings.dart';

//App Version
const String app_version = "1.0.0";

//Shared Preference Keys
class SharePrefrenceKeys {
  static const String appThemeMode = "themeMode";
  static const String loggedInUser = "loggedInUser";
}

class AppConstants {
  static const List<String> userTypesForLogin = [AdminUserType.admin, AdminUserType.reception];

  static const int adminUsersDocumentLimitForPagination = 20;
  static const int adminUsersRefreshIndexForPagination = 5;

  static String hospitalId = "Hospital_1";

  static const String genderMale = "Male";
  static const String genderFemale = "Female";
  static const String genderOther = "Other";

  static const List<String> genderList = [AppConstants.genderMale, AppConstants.genderFemale, AppConstants.genderOther];
}

class AppUIConfiguration {
  static double borderRadius = 7;
}

class HomeScreenComponentsList {
  final List<HomeScreenComponentModel> _masterOptions = [
    const HomeScreenComponentModel(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, screen: DashboardScreen(), title: "Dashboard"),
    const HomeScreenComponentModel(icon: Icons.history, activeIcon: Icons.history, screen: Text("History"), title: "History"),
    const HomeScreenComponentModel(icon: Icons.file_copy_outlined, activeIcon: Icons.file_copy, screen: Text("Treatment"), title: "Treatment"),
    const HomeScreenComponentModel(icon: Icons.people_alt_outlined, activeIcon: Icons.people, screen: AdminUsersListScreen(title: "Admin Users"), title: "Admin Users"),
    const HomeScreenComponentModel(icon: Icons.person_outline, activeIcon: Icons.person, screen: AdminUserProfileScreen(), title: "Profile"),
  ];

  final List<HomeScreenComponentModel> _adminOptions = [
    const HomeScreenComponentModel(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, screen: DashboardScreen(), title: "Dashboard"),
    const HomeScreenComponentModel(icon: Icons.history, activeIcon: Icons.history, screen: Text("History"), title: "History"),
    const HomeScreenComponentModel(icon: Icons.file_copy_outlined, activeIcon: Icons.file_copy, screen: Text("Treatment"), title: "Treatment"),
    const HomeScreenComponentModel(icon: FontAwesomeIcons.qrcode, activeIcon: FontAwesomeIcons.qrcode, screen: ScannerScreen(), title: AppStrings.scanner),
    const HomeScreenComponentModel(icon: Icons.people_alt_outlined, activeIcon: Icons.people, screen: AdminUsersListScreen(title: "Admin Users"), title: "Admin Users"),
    const HomeScreenComponentModel(icon: Icons.person_outline, activeIcon: Icons.person, screen: AdminUserProfileScreen(), title: "Profile"),
  ];

  final List<HomeScreenComponentModel> _receptionOptions = [
    const HomeScreenComponentModel(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, screen: DashboardScreen(), title: "Dashboard"),
    const HomeScreenComponentModel(icon: Icons.people_alt_outlined, activeIcon: Icons.people, screen: AdminUsersListScreen(title: "Admin Users"), title: "Admin Users"),
    const HomeScreenComponentModel(icon: Icons.person_outline, activeIcon: Icons.person, screen: AdminUserProfileScreen(), title: "Profile"),
  ];

  List<HomeScreenComponentModel> getHomeScreenComponentsRolewise(String role) {
    if(role == AdminUserType.admin) {
      return _adminOptions;
    }
    else if(role == AdminUserType.reception) {
      return _receptionOptions;
    }
    else {
      return [];
    }
  }
}

