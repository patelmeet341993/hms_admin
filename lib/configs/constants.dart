import 'package:admin/views/admin_users/admin_users_list_screen.dart';
import 'package:admin/views/common/models/home_screen_component_model.dart';
import 'package:flutter/material.dart';

import '../backend/common/firestore_controller.dart';
import '../views/homescreen/dashboard_screen.dart';
import '../views/profile/admin_user_profile_screen.dart';
import 'typedefs.dart';

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
}

class AppUIConfiguration {
  static double borderRadius = 7;
}

class PatientGender {
  static const String male = "Male";
  static const String female = "Female";
  static const String other = "Other";
}

class MedicineType {
  static const String tablet = "Tablet";
  static const String syrup = "Syrup";
  static const String other = "Other";
}


class AdminUserType {
  static const String admin = "Admin";
  static const String doctor = "Doctor";
  static const String pharmacy = "Pharmacy";
  static const String laboratory = "Laboratory";
  static const String reception = "Reception";
}

class FirebaseNodes {
  //region Admin Users
  static const String adminUsersCollection = "admin_users";

  static MyFirestoreCollectionReference get adminUsersCollectionReference => FirestoreController.collectionReference(
    collectionName: FirebaseNodes.adminUsersCollection,
  );

  static MyFirestoreDocumentReference adminUserDocumentReference({String? userId}) => FirestoreController.documentReference(
    collectionName: FirebaseNodes.adminUsersCollection,
    documentId: userId,
  );
  //endregion

  //region Patient
  static const String patientCollection = "patient";

  static MyFirestoreCollectionReference get patientCollectionReference => FirestoreController.collectionReference(
    collectionName: FirebaseNodes.patientCollection,
  );

  static MyFirestoreDocumentReference patientDocumentReference({String? patientId}) => FirestoreController.documentReference(
    collectionName: FirebaseNodes.patientCollection,
    documentId: patientId,
  );
  //endregion

  //region Visits
  static const String visitsCollection = "visits";

  static MyFirestoreCollectionReference get visitsCollectionReference => FirestoreController.collectionReference(
    collectionName: FirebaseNodes.visitsCollection,
  );

  static MyFirestoreDocumentReference visitDocumentReference({String? visitId}) => FirestoreController.documentReference(
    collectionName: FirebaseNodes.visitsCollection,
    documentId: visitId,
  );
  //endregion

  //region Timestamp Collection
  static const String timestampCollection = "timestamp_collection";

  static MyFirestoreCollectionReference get timestampCollectionReference => FirestoreController.collectionReference(
    collectionName: FirebaseNodes.timestampCollection,
  );
  //endregion
}

class PrescriptionMedicineDoseTime {
  static const String morning = "Morning";
  static const String afternoon = "Afternoon";
  static const String evening = "Evening";
  static const String night = "Night";
}

class PaymentModes {
  static const String cash = "Cash";
  static const String upi = "UPI";
  static const String creditCard = "Credit Card";
  static const String debitCard = "Debit Card";
}

class PaymentStatus {
  static const String pending = "Pending";
  static const String paid = "Paid";
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

