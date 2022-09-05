import 'package:admin/configs/app_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../configs/constants.dart';
import '../models/admin_user_model.dart';
import '../utils/logger_service.dart';
import '../utils/my_toast.dart';
import '../utils/my_utils.dart';
import 'firestore_controller.dart';

class AdminUserController {
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
}