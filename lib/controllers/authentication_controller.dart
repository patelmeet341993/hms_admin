import 'dart:convert';

import 'package:admin/controllers/admin_user_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../configs/app_strings.dart';
import '../configs/constants.dart';
import '../models/admin_user_model.dart';
import '../providers/admin_user_provider.dart';
import '../utils/logger_service.dart';
import '../utils/my_toast.dart';
import '../utils/parsing_helper.dart';
import '../utils/shared_pref_manager.dart';
import '../views/authentication/login_screen.dart';
import '../views/homescreen/homescreen.dart';
import 'firestore_controller.dart';
import 'navigation_controller.dart';

class AuthenticationController {
  Future<AdminUserModel?> isUserLoggedIn() async {
    AdminUserProvider adminUserProvider = Provider.of<AdminUserProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);

    String userJson = await SharedPrefManager().getString(SharePrefrenceKeys.loggedInUser) ?? "";

    AdminUserModel? adminUserModel;

    try {
      dynamic object = jsonDecode(userJson);
      if(object is Map) {
        Map<String, dynamic> map = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(object);
        adminUserModel = AdminUserModel.fromMap(map);
      }
    }
    catch(e, s) {
      Log().e("Error in Decoding User Data From Shared Preference:$e", s);
    }

    if(adminUserModel != null && adminUserModel.id.isNotEmpty) {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await FirestoreController().firestore.collection(FirebaseNodes.adminUsersCollection).doc(adminUserModel.id).get();

      if(documentSnapshot.exists && (documentSnapshot.data() ?? {}).isNotEmpty) {
        AdminUserModel newModel = AdminUserModel.fromMap(documentSnapshot.data()!);
        if(adminUserModel.username == newModel.username && adminUserModel.password == newModel.password) {
          adminUserProvider.setAdminUserId(newModel.id);
          adminUserProvider.setAdminUserModel(newModel);
          if(adminUserModel != newModel) {
            SharedPrefManager().setString(SharePrefrenceKeys.loggedInUser, jsonEncode(newModel.toMap()));
          }
          return newModel;
        }
        else {
          adminUserProvider.setAdminUserId("");
          adminUserProvider.setAdminUserModel(null);
          SharedPrefManager().setString(SharePrefrenceKeys.loggedInUser, "");
          return null;
        }
      }
      else {
        adminUserProvider.setAdminUserId("");
        adminUserProvider.setAdminUserModel(null);
        SharedPrefManager().setString(SharePrefrenceKeys.loggedInUser, "");
        return null;
      }
    }
    else {
      adminUserProvider.setAdminUserId("");
      adminUserProvider.setAdminUserModel(null);
      SharedPrefManager().setString(SharePrefrenceKeys.loggedInUser, "");
      return null;
    }
  }
  
  Future<bool> loginAdminUserWithUsernameAndPassword({required BuildContext context, required String userName, required String password, List<String> userTypes = AppConstants.userTypesForLogin,}) async {
    bool isLoginSuccess = false;

    if(userName.isEmpty || password.isEmpty) {
      MyToast.showError(AppStrings.usernameOrPasswordIsEmpty, context);
      return isLoginSuccess;
    }

    if(userTypes.isEmpty) {
      userTypes.addAll(AppConstants.userTypesForLogin);
    }

    AdminUserModel? adminUserModel;

    Query<Map<String, dynamic>> query = FirestoreController().firestore.collection(FirebaseNodes.adminUsersCollection).where("username", isEqualTo: userName);
    if(userTypes.isNotEmpty) {
      query = query.where("role", whereIn: userTypes);
    }
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();
    if(querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot = querySnapshot.docs.first;
      if((docSnapshot.data() ?? {}).isNotEmpty) {
        AdminUserModel model = AdminUserModel.fromMap(docSnapshot.data()!);
        isLoginSuccess = model.username == userName && model.password == password && (userTypes.isNotEmpty ? userTypes.contains(model.role) : true);
        if(isLoginSuccess) {
          adminUserModel = model;
        }
      }
    }
    
    AdminUserProvider adminUserProvider = Provider.of<AdminUserProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);
    adminUserProvider.setAdminUserId(adminUserModel?.id ?? "", isNotify: false);
    adminUserProvider.setAdminUserModel(adminUserModel, isNotify: false);
    SharedPrefManager().setString(SharePrefrenceKeys.loggedInUser, adminUserModel != null ? jsonEncode(adminUserModel.toMap(toJson: true)) : "");

    if(isLoginSuccess) {
      AdminUserController().startAdminUserSubscription();
      Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
    }

    return isLoginSuccess;
  }

  Future<bool> logout({required BuildContext context}) async {
    bool isLoggedOut = false;

    AdminUserProvider adminUserProvider = Provider.of<AdminUserProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);
    adminUserProvider.setAdminUserId("");
    adminUserProvider.setAdminUserModel(null, isNotify: false);
    AdminUserController().stopAdminUserSubscription();
    SharedPrefManager().setString(SharePrefrenceKeys.loggedInUser, "");
    isLoggedOut = true;

    Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false);

    return isLoggedOut;
  }
}