import 'dart:async';

import 'package:admin/backend/admin_user/admin_user_provider.dart';
import 'package:admin/backend/admin_user/admin_user_repository.dart';
import 'package:admin/backend/common/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:hms_models/hms_models.dart';

import '../../configs/app_strings.dart';
import '../../configs/constants.dart';

class AdminUserController {
  final AdminUserProvider adminUserProvider;
  late AdminUserRepository adminUserRepository;

  AdminUserController({required this.adminUserProvider}) {
    adminUserRepository = AdminUserRepository();
  }

  static StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? adminUserStreamSubscription;

  Future<bool> addAdminUserInFirestoreAndUpdateInProvider({required BuildContext context, required AdminUserModel adminUserModel}) async {
    MyPrint.printOnConsole("addAdminUserInFirestoreAndUpdateInProvider called with adminUserModel:$adminUserModel");

    bool isCreated = false;
    AdminUserModel? newAdminUserModel = await adminUserRepository.createAdminUserWithUsernameAndPassword(
      userModel: adminUserModel,
      onValidationFailed: () {
        MyToast.showError(context: context, msg: "UserName is empty or password is empty",);
      },
      onUserAlreadyExistEvent: () {
        MyToast.showError(context: context, msg: AppStrings.givenUserAlreadyExist,);
      },
    );
    if(newAdminUserModel != null) {
      isCreated = true;
      adminUserProvider.addAdminUsersInList(adminUserModels: [newAdminUserModel]);
    }

    return isCreated;
  }

  Future<bool> deleteAdminUsers(List<String> adminUserIds) async {
    MyPrint.printOnConsole("deleteAdminUser called with adminUserIds: $adminUserIds");

    bool isDeleted = false;

    adminUserIds.removeWhere((element) => element.isEmpty);
    if(adminUserIds.isNotEmpty) {
      isDeleted = await adminUserRepository.deleteAdminUsers(adminUserIds);

      if(isDeleted) {
        adminUserProvider.setAdminUserIdsList(usersIds: adminUserProvider.adminUsersIds..removeWhere((element) => adminUserIds.contains(element)));
      }
    }
    else {
      isDeleted = true;
    }

    return isDeleted;
  }

  void startAdminUserSubscription() async {
    String adminUserId = adminUserProvider.adminUserId;

    if(adminUserId.isNotEmpty) {
      if(adminUserStreamSubscription != null) {
        adminUserStreamSubscription!.cancel();
        adminUserStreamSubscription = null;
      }

      adminUserStreamSubscription = FirebaseNodes.adminUserDocumentReference(userId: adminUserId).snapshots().listen((DocumentSnapshot<Map<String, dynamic>> snapshot) {
        MyPrint.printOnConsole("Admin User Document Updated.\n"
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

      MyPrint.printOnConsole("Admin User Stream Started");
    }
  }

  void stopAdminUserSubscription() async {
    if(adminUserStreamSubscription != null) {
      adminUserStreamSubscription!.cancel();
      adminUserStreamSubscription = null;
    }
    adminUserProvider.setAdminUserId("");
    adminUserProvider.setAdminUserModel(null);
  }

  Future<List<AdminUserModel>> getAdminUsers({bool isRefresh = true, bool isFromCache = false, bool isNotify = true}) async {
    MyPrint.printOnConsole("getAdminUsers called with isRefresh:$isRefresh, isFromCache:$isFromCache");

    if(!isRefresh && isFromCache && adminUserProvider.adminUsersLength > 0) {
      MyPrint.printOnConsole("Returning Cached Data");
      return adminUserProvider.getAdminUsersModelsList();
    }

    if (isRefresh) {
      MyPrint.printOnConsole("Refresh");
      adminUserProvider.setHasMoreUsers = true; // flag for more products available or not
      adminUserProvider.setLastDocument = null; // flag for last document from where next 10 records to be fetched
      adminUserProvider.setIsUsersLoading(false, isNotify: isNotify);
      adminUserProvider.setAdminUserIdsList(usersIds: <String>[], isNotify: isNotify);
    }

    try {
      if (!adminUserProvider.getHasMoreUsers) {
        MyPrint.printOnConsole('No More Users');
        return adminUserProvider.getAdminUsersModelsList();
      }
      if (adminUserProvider.getIsUsersLoading) return adminUserProvider.getAdminUsersModelsList();

      adminUserProvider.setIsUsersLoading(true, isNotify: isNotify);

      Query<Map<String, dynamic>> query = FirebaseNodes.adminUsersCollectionReference
        .where("hospitalId", isEqualTo: AppController().hospitalId)
        .limit(AppConstants.adminUsersDocumentLimitForPagination)
        .orderBy("createdTime", descending: false);

      //For Last Document
      DocumentSnapshot<Map<String, dynamic>>? snapshot = adminUserProvider.getLastDocument;
      if(snapshot != null) {
        MyPrint.printOnConsole("LastDocument not null");
        query = query.startAfterDocument(snapshot);
      }
      else {
        MyPrint.printOnConsole("LastDocument null");
      }

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();
      MyPrint.printOnConsole("Documents Length in Firestore for Admin Users:${querySnapshot.docs.length}");

      if (querySnapshot.docs.length < AppConstants.adminUsersDocumentLimitForPagination) adminUserProvider.setHasMoreUsers = false;

      if(querySnapshot.docs.isNotEmpty) adminUserProvider.setLastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];

      List<AdminUserModel> list = [];
      for (DocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshot.docs) {
        if((documentSnapshot.data() ?? {}).isNotEmpty) {
          AdminUserModel adminUserModel = AdminUserModel.fromMap(documentSnapshot.data()!);
          list.add(adminUserModel);
        }
      }
      adminUserProvider.addAdminUsersInList(adminUserModels: list, isNotify: false);
      adminUserProvider.setIsUsersLoading(false);
      MyPrint.printOnConsole("Final AdminUsers Length From Firestore:${list.length}");
      MyPrint.printOnConsole("Final AdminUsers Length in Provider:${adminUserProvider.adminUsersLength}");
      return list;
    }
    catch(e, s) {
      MyPrint.printOnConsole("Error in AdminUserController().getAdminUsers():$e");
      MyPrint.printOnConsole(s);
      adminUserProvider.setHasMoreUsers = true;
      adminUserProvider.setLastDocument = null;
      adminUserProvider.setAdminUserIdsList(usersIds: [], isNotify: false);
      return [];
    }
  }

  Future<bool> enableDisableAdminUser(String adminUserId, bool isActive) async {
    MyPrint.printOnConsole("enableDisableAdminUser called for adminUserId:$adminUserId, isActive:$isActive");

    bool isSuccessful = false;

    isSuccessful = await adminUserRepository.setUpdateAdminUser(adminUserId: adminUserId, data: {"isActive" : isActive}, merge: true);
    MyPrint.printOnConsole("enableDisableAdminUser isSuccessful:$isSuccessful");

    return isSuccessful;
  }

  Future<bool> updateAdminUserProfileDataAndUpdateInListInProvider({required BuildContext context, required AdminUserModel adminUserModel}) async {
    MyPrint.printOnConsole("updateAdminUserProfileData called with adminUserModel:$adminUserModel");

    bool isSuccessful = false;

    String hospitalId = adminUserModel.hospitalId.isNotEmpty ? adminUserModel.hospitalId : AppController().hospitalId;
    adminUserModel.hospitalId = hospitalId;

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseNodes.adminUsersCollectionReference
        .where("username", isEqualTo: adminUserModel.username)
        .where("hospitalId", isEqualTo: hospitalId)
        .get();
    if(querySnapshot.docs.isNotEmpty) {
      if(querySnapshot.docs.first.id != adminUserModel.id) {
        MyToast.showError(context: context, msg: "Someone else is already having this username",);
        return false;
      }
    }

    isSuccessful = await adminUserRepository.setUpdateAdminUser(adminUserId: adminUserModel.id, data: {
      "name" : adminUserModel.name,
      "username" : adminUserModel.username,
      "password" : adminUserModel.password,
      "description" : adminUserModel.description,
      "role" : adminUserModel.role,
      "isActive" : adminUserModel.isActive,
      "hospitalId" : hospitalId,
    }, merge: true);
    MyPrint.printOnConsole("updateAdminUserProfileData isSuccessful:$isSuccessful");

    if(isSuccessful) {
      adminUserProvider.updateUserData(userid: adminUserModel.id, adminUserModel: adminUserModel);
    }

    return isSuccessful;
  }


}