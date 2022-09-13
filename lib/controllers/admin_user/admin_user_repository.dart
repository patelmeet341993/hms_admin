import 'package:cloud_firestore/cloud_firestore.dart';

import '../../configs/constants.dart';
import '../../models/admin_user_model.dart';
import '../../models/new_document_data_model.dart';
import '../../utils/logger_service.dart';
import '../../utils/my_utils.dart';
import '../data_controller.dart';
import '../firestore_controller.dart';

class AdminUserRepository {
  Future<AdminUserModel?> createAdminUserWithUsernameAndPassword({required AdminUserModel userModel, void Function()? onValidationFailed, void Function()? onUserAlreadyExistEvent}) async {
    if(userModel.username.isEmpty || userModel.password.isEmpty) {
      if(onValidationFailed != null) {
        onValidationFailed();
      }
      return null;
    }

    if(userModel.role.isEmpty) {
      userModel.role = AdminUserType.reception;
    }

    AdminUserModel? adminUserModel;

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirestoreController().firestore.collection(FirebaseNodes.adminUsersCollection).where("username", isEqualTo: userModel.username).get();
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
        role: userModel.role,
        description: userModel.description,
        imageUrl: userModel.imageUrl,
        hospitalId: AppConstants.hospitalId,
        scannerData: userModel.scannerData,
        isActive: true,
        createdTime: Timestamp.now(),
      );

      NewDocumentDataModel newDocumentDataModel = await DataController().getNewDocIdAndTimeStamp();
      adminUserModel.id = newDocumentDataModel.docid;
      adminUserModel.createdTime = newDocumentDataModel.timestamp;

      bool isCreationSuccess = await setUpdateAdminUser(adminUserId: adminUserModel.id, adminUserModel: adminUserModel, merge: false);
      Log().i("isCreationSuccess:$isCreationSuccess");

      if(isCreationSuccess) {
        return adminUserModel;
      }
      else {
        return null;
      }
    }
    else {
      if(onUserAlreadyExistEvent != null) {
        onUserAlreadyExistEvent();
      }
      return null;
    }
  }

  Future<bool> setUpdateAdminUser({required String adminUserId, AdminUserModel? adminUserModel, Map<String, dynamic>? data, bool merge = true}) async {
    if(adminUserId.isEmpty) {
      return false;
    }

    if((adminUserModel == null && (data ?? {}).isEmpty) || (adminUserModel != null && ((data ?? {}).isNotEmpty))) {
      return false;
    }

    if(data == null || data.isEmpty) {
      data = adminUserModel!.toMap();
    }

    bool isUpdationSuccess = await FirestoreController().firestore.collection(FirebaseNodes.adminUsersCollection).doc(adminUserId).set(data, SetOptions(merge: merge)).then((value) {
      Log().i("Admin User with Id:$adminUserId Data  Set/Updated Successfully");
      return true;
    })
    .catchError((e, s) {
      Log().e("Error in Setting/Updating Admin User:$e", s);
      return false;
    });
    Log().i("isUpdationSuccess:$isUpdationSuccess");

    return isUpdationSuccess;
  }

  Future<bool> deleteAdminUsers(List<String> adminUserIds) async {
    bool isDeleted = false;

    if(adminUserIds.isEmpty) {
      return true;
    }

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

    return isDeleted;
  }
}