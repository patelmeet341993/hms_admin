import 'package:admin/configs/constants.dart';
import 'package:admin/controllers/firestore_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminUserController {
  Future<bool> loginAdminUserWithUsernameAndPassword({required String userName, required String password, String userType = AdminUserType.admin,}) async {
    bool isLoginSuccess = false;

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirestoreController().firestore.collection(FirebaseNodes.adminUsersCollection).where("role", isEqualTo: userType).get();

    return isLoginSuccess;
  }
}