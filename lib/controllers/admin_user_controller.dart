import 'dart:async';

import 'package:admin/controllers/data_controller.dart';
import 'package:admin/controllers/navigation_controller.dart';
import 'package:admin/models/new_document_data_model.dart';
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
        isActive: true,
        createdTime: Timestamp.now(),
      );

      NewDocumentDataModel newDocumentDataModel = await DataController().getNewDocIdAndTimeStamp();
      adminUserModel.id = newDocumentDataModel.docid;
      adminUserModel.createdTime = newDocumentDataModel.timestamp;

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

  Future<void> addAdminUserInFirestoreAndUpdateInProvider({required BuildContext context, required AdminUserModel adminUserModel}) async {
    AdminUserProvider adminUserProvider = Provider.of<AdminUserProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);

    AdminUserModel? newAdminUserModel = await AdminUserController().createAdminUserWithUsernameAndPassword(context: context, userModel: adminUserModel);
    if(newAdminUserModel != null) {
      adminUserProvider.addAdminUsersInList([newAdminUserModel]);
    }
  }

  Future<bool> deleteAdminUsers(List<String> adminUserIds) async {
    Log().i("deleteAdminUser called with adminUserIds: $adminUserIds");

    bool isDeleted = false;

    adminUserIds.removeWhere((element) => element.isEmpty);
    if(adminUserIds.isNotEmpty) {
      WriteBatch writeBatch = FirestoreController().firestore.batch();

      for (String id in adminUserIds) {
        writeBatch.delete(FirestoreController().firestore.collection(FirebaseNodes.adminUsersCollection).doc(id));
      }

      isDeleted = await writeBatch.commit().then((value) {
        Log().i("Deleted Admin User with Ids: $adminUserIds");
        return true;
      })
      .catchError((e, s) {
        Log().e("Error in Deleting Admin User with Id '$adminUserIds':$e", s);
        return false;
      });
    }

    if(isDeleted) {
      AdminUserProvider adminUserProvider = Provider.of<AdminUserProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);
      adminUserProvider.setAdminUsers(adminUserProvider.adminUsers..removeWhere((element) => adminUserIds.contains(element.id)));
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
        .limit(AppConstants.adminUsersDocumentLimitForPagination);

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
}