import 'dart:convert';

import 'package:admin/configs/constants.dart';
import 'package:admin/controllers/firestore_controller.dart';
import 'package:admin/controllers/navigation_controller.dart';
import 'package:admin/models/admin_user_model.dart';
import 'package:admin/providers/admin_user_provider.dart';
import 'package:admin/utils/logger_service.dart';
import 'package:admin/utils/my_toast.dart';
import 'package:admin/utils/my_utils.dart';
import 'package:admin/utils/parsing_helper.dart';
import 'package:admin/views/authentication/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/shared_pref_manager.dart';
import '../views/homescreen/homescreen.dart';

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
        if(adminUserModel.username == newModel.username && newModel.password == newModel.password) {
          adminUserProvider.setAdminUserModel(newModel);
          if(adminUserModel != newModel) {
            SharedPrefManager().setString(SharePrefrenceKeys.loggedInUser, jsonEncode(newModel.toMap()));
          }
          return newModel;
        }
        else {
          adminUserProvider.setAdminUserModel(null);
          SharedPrefManager().setString(SharePrefrenceKeys.loggedInUser, "");
          return null;
        }
      }
      else {
        adminUserProvider.setAdminUserModel(null);
        SharedPrefManager().setString(SharePrefrenceKeys.loggedInUser, "");
        return null;
      }
    }
    else {
      adminUserProvider.setAdminUserModel(null);
      SharedPrefManager().setString(SharePrefrenceKeys.loggedInUser, "");
      return null;
    }
  }

  Future<AdminUserModel?> createAdminUserWithUsernameAndPassword({required BuildContext context, required String name, required String userName, required String password, String userType = AdminUserType.admin,}) async {
    if(userName.isEmpty || password.isEmpty) {
      MyToast.showError("UserName is empty or password is empty", context);
      return null;
    }
    
    AdminUserModel? adminUserModel;

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirestoreController().firestore.collection(FirebaseNodes.adminUsersCollection).where("role", isEqualTo: userType).where("username", isEqualTo: userName).get();
    if(querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot = querySnapshot.docs.first;
      if((docSnapshot.data() ?? {}).isNotEmpty) {
        AdminUserModel model = AdminUserModel.fromMap(docSnapshot.data()!);
        if(model.username == userName && model.role == userType) {
          adminUserModel = model;
        }
      }
    }

    if(adminUserModel == null) {
      adminUserModel = AdminUserModel(
        id: MyUtils.getUniqueIdFromUuid(),
        name: name,
        username: userName,
        password: password,
        role: userType,
      );

      bool isCreationSuccess = await FirestoreController().firestore.collection(FirebaseNodes.adminUsersCollection).doc(adminUserModel.id).set(adminUserModel.toMap()).then((value) {
        Log().i("Admin User with Id:${adminUserModel!.id} Created Successfully");
        return true;
      })
      .catchError((e, s) {
        Log().e("Error in Creating Admin User:$e", s);
        return false;
      });
      Log().i("isCreationSuccess:$isCreationSuccess");

      if(isCreationSuccess) {
        return adminUserModel;
      }
      else {
        return null;
      }
    }
    else {
      MyToast.showError("User with given UserName and Role already exist", context);
      return null;
    }
  }
  
  Future<bool> loginAdminUserWithUsernameAndPassword({required BuildContext context, required String userName, required String password, String userType = AdminUserType.admin,}) async {
    bool isLoginSuccess = false;

    if(userName.isEmpty || password.isEmpty) {
      MyToast.showError("UserName is empty or password is empty", context);
      return isLoginSuccess;
    }
    
    AdminUserModel? adminUserModel;

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirestoreController().firestore.collection(FirebaseNodes.adminUsersCollection).where("role", isEqualTo: userType).where("username", isEqualTo: userName).get();
    if(querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot = querySnapshot.docs.first;
      if((docSnapshot.data() ?? {}).isNotEmpty) {
        AdminUserModel model = AdminUserModel.fromMap(docSnapshot.data()!);
        isLoginSuccess = model.username == userName && model.password == password && model.role == userType;
        if(isLoginSuccess) {
          adminUserModel = model;
        }
      }
    }
    
    AdminUserProvider adminUserProvider = Provider.of<AdminUserProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);
    adminUserProvider.setAdminUserModel(adminUserModel, isNotify: false);
    SharedPrefManager().setString(SharePrefrenceKeys.loggedInUser, adminUserModel != null ? jsonEncode(adminUserModel.toMap()) : "");

    if(isLoginSuccess) {
      Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
    }

    return isLoginSuccess;
  }

  Future<bool> logout({required BuildContext context}) async {
    bool isLoggedOut = false;

    AdminUserProvider adminUserProvider = Provider.of<AdminUserProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);
    adminUserProvider.setAdminUserModel(null, isNotify: false);
    SharedPrefManager().setString(SharePrefrenceKeys.loggedInUser, "");
    isLoggedOut = true;

    Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false);

    return isLoggedOut;
  }
}