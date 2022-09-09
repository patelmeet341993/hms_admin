import 'package:admin/models/admin_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AdminUserProvider extends ChangeNotifier {
  AdminUserModel? _adminUserModel;
  String _adminUserId = "";
  final List<AdminUserModel> _adminUsers = <AdminUserModel>[];

  DocumentSnapshot<Map<String, dynamic>>? _lastdocument;
  bool _hasMoreUsers = false, _isUsersLoading = false;

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

  String get adminUserId => _adminUserId;

  void setAdminUserId(String adminUserId, {bool isNotify = true}) {
    _adminUserId = adminUserId;
    if(isNotify) {
      notifyListeners();
    }
  }

  int get adminUsersLength => _adminUsers.length;

  List<AdminUserModel> get adminUsers => List.from(_adminUsers.map((e) => AdminUserModel.fromMap(e.toMap())));

  void setAdminUsers(List<AdminUserModel> users, {bool isNotify = true}) {
    _adminUsers.clear();
    _adminUsers.addAll(List.from(users.map((e) => AdminUserModel.fromMap(e.toMap())).toList()));
    if(isNotify) {
      notifyListeners();
    }
  }

  void addAdminUsersInList(List<AdminUserModel> adminUserModels, {bool isNotify = true}) {
    _adminUsers.addAll(adminUserModels.map((e) => AdminUserModel.fromMap(e.toMap())).toList());
    if(isNotify) {
      notifyListeners();
    }
  }

  DocumentSnapshot<Map<String, dynamic>>? get getLastDocument => _lastdocument;
  set setLastDocument(DocumentSnapshot<Map<String, dynamic>>? documentSnapshot) => _lastdocument = documentSnapshot;

  bool get getHasMoreUsers => _hasMoreUsers;
  set setHasMoreUsers(bool hasMoreUsers) => _hasMoreUsers = hasMoreUsers;

  bool get getIsUsersLoading => _isUsersLoading;
  void setIsUsersLoading(bool isUsersLoading, {bool isNotify = true}) {
    _isUsersLoading = isUsersLoading;
    if(isNotify) {
      notifyListeners();
    }
  }
}