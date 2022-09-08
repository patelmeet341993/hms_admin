import 'package:equatable/equatable.dart';

import '../utils/parsing_helper.dart';

class AdminUserModel extends Equatable {
  String id = "", name = "", username = "", password = "", role = "", description = "", imageUrl = "";
  Map<String, dynamic> scannerData = <String, dynamic>{};
  bool isActive = false;

  AdminUserModel({
    this.id = "",
    this.name = "",
    this.username = "",
    this.password = "",
    this.role = "",
    this.description = "",
    this.imageUrl = "",
    this.scannerData = const <String, dynamic>{},
    this.isActive = false,
  });

  AdminUserModel.fromMap(Map<String, dynamic> map) {
    id = ParsingHelper.parseStringMethod(map['id']);
    name = ParsingHelper.parseStringMethod(map['name']);
    username = ParsingHelper.parseStringMethod(map['username']);
    password = ParsingHelper.parseStringMethod(map['password']);
    role = ParsingHelper.parseStringMethod(map['role']);
    description = ParsingHelper.parseStringMethod(map['description']);
    imageUrl = ParsingHelper.parseStringMethod(map['imageUrl']);
    scannerData = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(map['scannerData']);
    isActive = ParsingHelper.parseBoolMethod(map['isActive']);
  }

  void updateFromMap(Map<String, dynamic> map) {
    id = ParsingHelper.parseStringMethod(map['id']);
    name = ParsingHelper.parseStringMethod(map['name']);
    username = ParsingHelper.parseStringMethod(map['username']);
    password = ParsingHelper.parseStringMethod(map['password']);
    role = ParsingHelper.parseStringMethod(map['role']);
    description = ParsingHelper.parseStringMethod(map['description']);
    imageUrl = ParsingHelper.parseStringMethod(map['imageUrl']);
    scannerData = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(map['scannerData']);
    isActive = ParsingHelper.parseBoolMethod(map['isActive']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "name": name,
      "username": username,
      "password": password,
      "role": role,
      "description": description,
      "imageUrl": imageUrl,
      "scannerData": scannerData,
      "isActive": isActive,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }

  @override
  List<Object?> get props => [id, name, username, password, role, description, imageUrl, isActive];
}