import 'dart:async';

import 'package:admin/controllers/admin_user/admin_user_repository.dart';
import 'package:admin/controllers/navigation_controller.dart';
import 'package:admin/providers/admin_user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configs/app_strings.dart';
import '../../configs/constants.dart';
import '../../models/admin_user_model.dart';
import '../../utils/logger_service.dart';
import '../../utils/my_toast.dart';
import '../firestore_controller.dart';

class AdminUserController {
  static StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? adminUserStreamSubscription;

  Future<bool> addAdminUserInFirestoreAndUpdateInProvider({required BuildContext context, required AdminUserModel adminUserModel}) async {
    Log().d("addAdminUserInFirestoreAndUpdateInProvider called with adminUserModel:$adminUserModel");
    AdminUserProvider adminUserProvider = Provider.of<AdminUserProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);

    bool isCreated = false;
    AdminUserModel? newAdminUserModel = await AdminUserRepository().createAdminUserWithUsernameAndPassword(
      userModel: adminUserModel,
      onValidationFailed: () {
        MyToast.showError("UserName is empty or password is empty", context);
      },
      onUserAlreadyExistEvent: () {
        MyToast.showError(AppStrings.givenUserAlreadyExist, context);
      },
    );
    if(newAdminUserModel != null) {
      isCreated = true;
      adminUserProvider.addAdminUsersInList([newAdminUserModel]);
    }

    return isCreated;
  }

  Future<bool> deleteAdminUsers(List<String> adminUserIds) async {
    Log().i("deleteAdminUser called with adminUserIds: $adminUserIds");

    bool isDeleted = false;

    adminUserIds.removeWhere((element) => element.isEmpty);
    if(adminUserIds.isNotEmpty) {
      isDeleted = await AdminUserRepository().deleteAdminUsers(adminUserIds);

      if(isDeleted) {
        AdminUserProvider adminUserProvider = Provider.of<AdminUserProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);
        adminUserProvider.setAdminUsers(adminUserProvider.adminUsers..removeWhere((element) => adminUserIds.contains(element.id)));
      }
    }
    else {
      isDeleted = true;
    }

    return isDeleted;
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

  Future<List<AdminUserModel>> getAdminUsers({bool isRefresh = true, bool isFromCache = false, bool isNotify = true}) async {
    Log().i("getAdminUsers called with isRefresh:$isRefresh, isFromCache:$isFromCache");
    AdminUserProvider adminUserProvider = Provider.of<AdminUserProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);

    if(!isRefresh && isFromCache && adminUserProvider.adminUsersLength > 0) {
      Log().d("Returning Cached Data");
      return adminUserProvider.adminUsers;
    }

    if (isRefresh) {
      Log().d("Refresh");
      adminUserProvider.setHasMoreUsers = true; // flag for more products available or not
      adminUserProvider.setLastDocument = null; // flag for last document from where next 10 records to be fetched
      adminUserProvider.setIsUsersLoading(false, isNotify: isNotify);
      adminUserProvider.setAdminUsers([], isNotify: isNotify);
    }

    try {
      if (!adminUserProvider.getHasMoreUsers) {
        Log().d('No More Users');
        return adminUserProvider.adminUsers;
      }
      if (adminUserProvider.getIsUsersLoading) return adminUserProvider.adminUsers;

      adminUserProvider.setIsUsersLoading(true, isNotify: isNotify);

      Query<Map<String, dynamic>> query = FirestoreController()
        .firestore
        .collection(FirebaseNodes.adminUsersCollection)
        .limit(AppConstants.adminUsersDocumentLimitForPagination)
        .orderBy("createdTime", descending: false);

      //For Last Document
      DocumentSnapshot<Map<String, dynamic>>? snapshot = adminUserProvider.getLastDocument;
      if(snapshot != null) {
        Log().d("LastDocument not null");
        query = query.startAfterDocument(snapshot);
      }
      else {
        Log().d("LastDocument null");
      }

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();
      Log().i("Documents Length in Firestore for Admin Users:${querySnapshot.docs.length}");

      if (querySnapshot.docs.length < AppConstants.adminUsersDocumentLimitForPagination) adminUserProvider.setHasMoreUsers = false;

      if(querySnapshot.docs.isNotEmpty) adminUserProvider.setLastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];

      List<AdminUserModel> list = [];
      for (DocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshot.docs) {
        if((documentSnapshot.data() ?? {}).isNotEmpty) {
          AdminUserModel adminUserModel = AdminUserModel.fromMap(documentSnapshot.data()!);
          list.add(adminUserModel);
        }
      }
      adminUserProvider.addAdminUsersInList(list, isNotify: false);
      adminUserProvider.setIsUsersLoading(false);
      Log().i("Final AdminUsers Length From Firestore:${list.length}");
      Log().i("Final AdminUsers Length in Provider:${adminUserProvider.adminUsersLength}");
      return list;
    }
    catch(e, s) {
      Log().e("Error in AdminUserController().getAdminUsers():$e", s);
      adminUserProvider.setHasMoreUsers = true;
      adminUserProvider.setLastDocument = null;
      adminUserProvider.setAdminUsers([], isNotify: false);
      return [];
    }
  }

  Future<bool> enableDisableAdminUser(String adminUserId, bool isActive) async {
    Log().d("enableDisableAdminUser called for adminUserId:$adminUserId, isActive:$isActive");

    bool isSuccessful = false;

    isSuccessful = await AdminUserRepository().setUpdateAdminUser(adminUserId: adminUserId, data: {"isActive" : isActive}, merge: true);
    Log().i("enableDisableAdminUser isSuccessful:$isSuccessful");

    return isSuccessful;
  }

  Future<bool> updateAdminUserProfileDataAndUpdateInListInProvider({required BuildContext context, required AdminUserModel adminUserModel}) async {
    Log().d("updateAdminUserProfileData called with adminUserModel:$adminUserModel");

    bool isSuccessful = false;

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirestoreController().firestore.collection(FirebaseNodes.adminUsersCollection).where("username", isEqualTo: adminUserModel.username).get();
    if(querySnapshot.docs.isNotEmpty) {
      if(querySnapshot.docs.first.id != adminUserModel.id) {
        MyToast.showError("Someone else is already having this username", context);
        return false;
      }
    }

    isSuccessful = await AdminUserRepository().setUpdateAdminUser(adminUserId: adminUserModel.id, data: {
      "name" : adminUserModel.name,
      "username" : adminUserModel.username,
      "password" : adminUserModel.password,
      "description" : adminUserModel.description,
      "role" : adminUserModel.role,
      "isActive" : adminUserModel.isActive,
    }, merge: true);
    Log().i("updateAdminUserProfileData isSuccessful:$isSuccessful");

    if(isSuccessful) {
      AdminUserProvider adminUserProvider = Provider.of<AdminUserProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);
      adminUserProvider.updateUserData(adminUserModel.id, adminUserModel);
    }

    return isSuccessful;
  }
}