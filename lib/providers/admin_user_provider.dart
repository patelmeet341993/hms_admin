import 'package:admin/models/admin_user_model.dart';
import 'package:flutter/foundation.dart';

class AdminUserProvider extends ChangeNotifier {
  AdminUserModel? _adminUserModel;

  AdminUserModel? getAdminUserModel() {
    if(_adminUserModel != null) {
      return AdminUserModel.fromMap(_adminUserModel!.toMap());
    }
    else {
      return null;
    }
  }

  void setAdminUserModel(AdminUserModel? adminUserModel, {bool isNotify = true}) {
    if(adminUserModel != null) {
      _adminUserModel = AdminUserModel.fromMap(adminUserModel.toMap());
    }
    else {
      _adminUserModel = null;
    }
    if(isNotify) {
      notifyListeners();
    }
  }
}