import 'dart:async';

import 'package:admin/controllers/navigation_controller.dart';
import 'package:admin/providers/admin_user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../configs/app_strings.dart';
import '../configs/constants.dart';
import '../models/admin_user_model.dart';
import '../utils/logger_service.dart';
import '../utils/my_toast.dart';
import '../utils/my_utils.dart';
import 'firestore_controller.dart';

class AdminUserController {
  static StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? adminUserStreamSubscription;

  Future<AdminUserModel?> createAdminUserWithUsernameAndPassword({required BuildContext context, required AdminUserModel userModel, String userType = AdminUserType.admin,}) async {
    if(userModel.username.isEmpty || userModel.password.isEmpty) {
      MyToast.showError("UserName is empty or password is empty", context);
      return null;
    }

    AdminUserModel? adminUserModel;

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirestoreController().firestore.collection(FirebaseNodes.adminUsersCollection).where("role", isEqualTo: userType).where("username", isEqualTo: userModel.username).get();
    if(querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot = querySnapshot.docs.first;
      if((docSnapshot.data() ?? {}).isNotEmpty) {
        AdminUserModel model = AdminUserModel.fromMap(docSnapshot.data()!);
        if(model.username == userModel.username) {
          adminUserModel = model;
        }
      }
    }

    if(adminUserModel == null) {
      adminUserModel = AdminUserModel(
        id: MyUtils.getUniqueIdFromUuid(),
        name: userModel.name,
        username: userModel.username,
        password: userModel.password,
        role: userType,
        description: userModel.description,
        imageUrl: userModel.imageUrl,
        scannerData: userModel.scannerData,
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
      MyToast.showError(AppStrings.givenUserAlreadyExist, context);
      return null;
    }
  }

  void startAdminUserSubscription() async {
    AdminUserProvider adminUserProvider = Provider.of<AdminUserProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);
    String adminUserId = adminUserProvider.adminUserId;

    if(adminUserId.isNotEmpty) {
      if(adminUserStreamSubscription != null) {
        adminUserStreamSubscription!.cancel();
        adminUserStreamSubscription = null;
      }

      adminUserStreamSubscription = FirestoreController().firestore.collection(FirebaseNodes.adminUsersCollection).doc(adminUserId).snapshots().listen((DocumentSnapshot<Map<String, dynamic>> snapshot) {
        Log().i("Admin User Document Updated.\n"
            "Snapshot Exist:${snapshot.exists}\n"
            "Data:${snapshot.data()}");

        if(snapshot.exists && (snapshot.data() ?? {}).isNotEmpty) {
          AdminUserModel adminUserModel = AdminUserModel.fromMap(snapshot.data()!);
          adminUserProvider.setAdminUserId(adminUserModel.id);
          adminUserProvider.setAdminUserModel(adminUserModel);
        }
        else {
          adminUserProvider.setAdminUserId("");
          adminUserProvider.setAdminUserModel(null);
        }
      });

      Log().d("Admin User Stream Started");
    }
  }

  void stopAdminUserSubscription() async {
    AdminUserProvider adminUserProvider = Provider.of<AdminUserProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);

    if(adminUserStreamSubscription != null) {
      adminUserStreamSubscription!.cancel();
      adminUserStreamSubscription = null;
    }
    adminUserProvider.setAdminUserId("");
    adminUserProvider.setAdminUserModel(null);
  }

  Future<List<AdminUserModel>> getAdminUsers({bool isRefresh = true, bool isFromCache = false}) async {
    Log().i("getAdminUsers called with isRefresh:$isRefresh, isFromCache:$isFromCache");
    AdminUserProvider adminUserProvider = Provider.of<AdminUserProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);

    if(!isRefresh && isFromCache && adminUserProvider.adminUsersLength > 0) {
      Log().d("Returning Cached Data");
      return adminUserProvider.adminUsers;
    }

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirestoreController().firestore.collection(FirebaseNodes.adminUsersCollection).get();
    Log().i("Documents Length in Firestore for Admin Users:${querySnapshot.docs.length}");

    List<AdminUserModel> list = [];
    for (DocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshot.docs) {
      if((documentSnapshot.data() ?? {}).isNotEmpty) {
        AdminUserModel adminUserModel = AdminUserModel.fromMap(documentSnapshot.data()!);
        list.add(adminUserModel);
      }
    }
    adminUserProvider.setAdminUsers(list);
    Log().i("Final AdminUsers Length From Firestore:${list.length}");
    Log().i("Final AdminUsers Length in Provider:${adminUserProvider.adminUsersLength}");
    return list;
  }
}