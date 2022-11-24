import 'package:flutter/foundation.dart';
import 'package:hms_models/hms_models.dart';

class AdminUserProvider extends ChangeNotifier {
  //region Logged In Admin User Model
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
      if(_adminUserModel != null) {
        _adminUserModel!.updateFromMap(adminUserModel.toMap());
      }
      else {
        _adminUserModel = AdminUserModel.fromMap(adminUserModel.toMap());
      }
    }
    else {
      _adminUserModel = null;
    }
    if(isNotify) {
      notifyListeners();
    }
  }
  //endregion

  //region Logged In Admin User Id
  String _adminUserId = "";

  String get adminUserId => _adminUserId;

  void setAdminUserId(String adminUserId, {bool isNotify = true}) {
    _adminUserId = adminUserId;
    if(isNotify) {
      notifyListeners();
    }
  }
  //endregion

  //region Admin User Models
  //region Admin User Ids List
  final List<String> _adminUsersIds = <String>[];

  int get adminUsersLength => _adminUsersIds.length;

  List<String> get adminUsersIds => _adminUsersIds;

  void setAdminUserIdsList({required List<String> usersIds, bool isClear = true, bool isNotify = true}) {
    if(isClear) _adminUsersIds.clear();
    _adminUsersIds.addAll(usersIds);
    if(isNotify) {
      notifyListeners();
    }
  }

  void addAdminUserIdInIdsList({required String usersId, bool isNotify = true}) {
    if(usersId.isEmpty) return;

    setAdminUserIdsList(usersIds: (_adminUsersIds..add(usersId)).toSet().toList(), isNotify: isNotify);
  }
  //endregion

  //region Admin User Models map
  final Map<String, AdminUserModel> _adminUserModelsMap = <String, AdminUserModel>{};

  Map<String, AdminUserModel> get adminUserModelsMap => _adminUserModelsMap;

  void setAdminUserModelsMap({required Map<String, AdminUserModel> users, bool isClear = true, bool isNotify = true}) {
    if(isClear) _adminUserModelsMap.clear();
    _adminUserModelsMap.addAll(users);
    if(isNotify) {
      notifyListeners();
    }
  }

  void updateUserData({required String userid, required AdminUserModel adminUserModel, bool isNotify = true}) {
    if(userid.isEmpty) return;

    AdminUserModel? model = _adminUserModelsMap[userid];
    if(model != null) {
      model.updateFromMap(adminUserModel.toMap());
    }
    else {
      _adminUserModelsMap[userid] = adminUserModel;
    }
    if(isNotify) {
      notifyListeners();
    }
  }
  //endregion

  void addAdminUsersInList({required List<AdminUserModel> adminUserModels, bool isNotify = true}) {
    for (AdminUserModel userModel in adminUserModels) {
      addAdminUserIdInIdsList(usersId: userModel.id, isNotify: false);
      updateUserData(userid: userModel.id, adminUserModel: userModel, isNotify: false);
    }
    if(isNotify) {
      notifyListeners();
    }
  }

  List<AdminUserModel> getAdminUsersModelsList() {
    List<AdminUserModel> users = <AdminUserModel>[];

    Map<String, AdminUserModel> map = adminUserModelsMap;
    for (String element in adminUsersIds) {
      AdminUserModel? model = map[element];
      if(model != null) {
        users.add(model);
      }
    }

    return users;
  }
  //endregion

  //region Last Document Snapshot of AdminUsersCollection
  DocumentSnapshot<Map<String, dynamic>>? _lastdocument;

  DocumentSnapshot<Map<String, dynamic>>? get getLastDocument => _lastdocument;
  set setLastDocument(DocumentSnapshot<Map<String, dynamic>>? documentSnapshot) => _lastdocument = documentSnapshot;
  //endregion

  //region HasMore admin users
  bool _hasMoreUsers = false;

  bool get getHasMoreUsers => _hasMoreUsers;
  set setHasMoreUsers(bool hasMoreUsers) => _hasMoreUsers = hasMoreUsers;
  //endregion

  //region Is Loading Admin Users
  bool _isUsersLoading = false;
  bool get getIsUsersLoading => _isUsersLoading;
  void setIsUsersLoading(bool isUsersLoading, {bool isNotify = true}) {
    _isUsersLoading = isUsersLoading;
    if(isNotify) {
      notifyListeners();
    }
  }
  //endregion
}