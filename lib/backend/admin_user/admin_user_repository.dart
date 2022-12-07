import 'package:hms_models/hms_models.dart';

import '../common/app_controller.dart';
import '../common/data_controller.dart';

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

    if(userModel.hospitalId.isEmpty) {
      userModel.hospitalId = AppController().hospitalId;
    }

    AdminUserModel? adminUserModel;

    MyFirestoreQuerySnapshot querySnapshot = await FirebaseNodes.adminUsersCollectionReference
        .where("username", isEqualTo: userModel.username)
        .where("hospitalId", isEqualTo: userModel.hospitalId)
        .get();
    if(querySnapshot.docs.isNotEmpty) {
      MyFirestoreQueryDocumentSnapshot docSnapshot = querySnapshot.docs.first;
      AdminUserModel model = AdminUserModel.fromMap(docSnapshot.data());
      adminUserModel = model;
    }
    MyPrint.printOnConsole("adminUserModel:$adminUserModel");

    if(adminUserModel == null) {
      adminUserModel = AdminUserModel(
        id: MyUtils.getUniqueIdFromUuid(),
        name: userModel.name,
        username: userModel.username,
        password: userModel.password,
        role: userModel.role,
        description: userModel.description,
        imageUrl: userModel.imageUrl,
        hospitalId: userModel.hospitalId,
        scannerData: userModel.scannerData,
        isActive: true,
        createdTime: Timestamp.now(),
      );

      NewDocumentDataModel newDocumentDataModel = await DataController().getNewDocIdAndTimeStamp();
      adminUserModel.id = newDocumentDataModel.docId;
      adminUserModel.createdTime = newDocumentDataModel.timestamp;

      bool isCreationSuccess = await setUpdateAdminUser(adminUserId: adminUserModel.id, adminUserModel: adminUserModel, merge: false);
      MyPrint.printOnConsole("isCreationSuccess:$isCreationSuccess");

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

    bool isUpdationSuccess = await FirebaseNodes.adminUserDocumentReference(userId: adminUserId).set(data, SetOptions(merge: merge)).then((value) {
      MyPrint.printOnConsole("Admin User with Id:$adminUserId Data  Set/Updated Successfully");
      return true;
    })
    .catchError((e, s) {
      MyPrint.printOnConsole("Error in Setting/Updating Admin User:$e");
      MyPrint.printOnConsole(s);
      return false;
    });
    MyPrint.printOnConsole("isUpdationSuccess:$isUpdationSuccess");

    return isUpdationSuccess;
  }

  Future<bool> deleteAdminUsers(List<String> adminUserIds) async {
    bool isDeleted = false;

    if(adminUserIds.isEmpty) {
      return true;
    }

    WriteBatch writeBatch = FirestoreController.firestore.batch();

    for (String id in adminUserIds) {
      writeBatch.delete(FirebaseNodes.adminUserDocumentReference(userId: id));
    }

    isDeleted = await writeBatch.commit().then((value) {
      MyPrint.printOnConsole("Deleted Admin User with Ids: $adminUserIds");
      return true;
    })
    .catchError((e, s) {
      MyPrint.printOnConsole("Error in Deleting Admin User with Id '$adminUserIds':$e");
      MyPrint.printOnConsole(s);
      return false;
    });

    return isDeleted;
  }

  Future<List<AdminUserModel>> getAdminUsersWithType({required String hospitalId, required List<String> types}) async {
    MyPrint.printOnConsole("AdminUserRepository.getAdminUsersWithType() called with hospitalId:'$hospitalId'");
    
    List<AdminUserModel> adminUsers = <AdminUserModel>[];
    
    try {
      if(hospitalId.isNotEmpty) {
        MyFirestoreQuerySnapshot querySnapshot = await FirebaseNodes.adminUsersCollectionReference
            .where("hospitalId", isEqualTo: hospitalId)
            .where("role", whereIn: types)
            .get();
        MyPrint.printOnConsole("querySnapshot length:${querySnapshot.docs.length}");

        for (MyFirestoreQueryDocumentSnapshot value in querySnapshot.docs) {
          if(value.data().isNotEmpty) {
            adminUsers.add(AdminUserModel.fromMap(value.data()));
          }
        }

        MyPrint.printOnConsole("Final adminUsers length:${adminUsers.length}");
      }
      else {
        MyPrint.printOnConsole("Hospital Id is Empty");
      }
    }
    catch(e, s) {
      MyPrint.printOnConsole("Error in AdminUserRepository.getAdminUsersWithType():$e");
      MyPrint.logOnConsole(s);
    }
    
    return adminUsers;
  }
}