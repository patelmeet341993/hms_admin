import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../utils/parsing_helper.dart';

class AdminUserModel extends Equatable {
  String id = "", name = "", username = "", password = "", role = "", description = "", imageUrl = "", hospitalId = "";
  Map<String, dynamic> scannerData = <String, dynamic>{};
  bool isActive = false, isUndeletable = false;
  Timestamp? createdTime;

  AdminUserModel({
    this.id = "",
    this.name = "",
    this.username = "",
    this.password = "",
    this.role = "",
    this.description = "",
    this.imageUrl = "",
    this.hospitalId = "",
    this.scannerData = const <String, dynamic>{},
    this.isActive = false,
    this.isUndeletable = false,
    this.createdTime,
  });

  AdminUserModel.fromMap(Map<String, dynamic> map) {
    id = ParsingHelper.parseStringMethod(map['id']);
    name = ParsingHelper.parseStringMethod(map['name']);
    username = ParsingHelper.parseStringMethod(map['username']);
    password = ParsingHelper.parseStringMethod(map['password']);
    role = ParsingHelper.parseStringMethod(map['role']);
    description = ParsingHelper.parseStringMethod(map['description']);
    imageUrl = ParsingHelper.parseStringMethod(map['imageUrl']);
    hospitalId = ParsingHelper.parseStringMethod(map['hospitalId']);
    scannerData = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(map['scannerData']);
    isActive = ParsingHelper.parseBoolMethod(map['isActive']);
    isUndeletable = ParsingHelper.parseBoolMethod(map['isUndeletable']);
    createdTime = ParsingHelper.parseTimestampMethod(map['createdTime']);
  }

  void updateFromMap(Map<String, dynamic> map) {
    id = ParsingHelper.parseStringMethod(map['id']);
    name = ParsingHelper.parseStringMethod(map['name']);
    username = ParsingHelper.parseStringMethod(map['username']);
    password = ParsingHelper.parseStringMethod(map['password']);
    role = ParsingHelper.parseStringMethod(map['role']);
    description = ParsingHelper.parseStringMethod(map['description']);
    imageUrl = ParsingHelper.parseStringMethod(map['imageUrl']);
    hospitalId = ParsingHelper.parseStringMethod(map['hospitalId']);
    scannerData = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(map['scannerData']);
    isActive = ParsingHelper.parseBoolMethod(map['isActive']);
    isUndeletable = ParsingHelper.parseBoolMethod(map['isUndeletable']);
    createdTime = ParsingHelper.parseTimestampMethod(map['createdTime']);
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return <String, dynamic>{
      "id": id,
      "name": name,
      "username": username,
      "password": password,
      "role": role,
      "description": description,
      "imageUrl": imageUrl,
      "hospitalId": hospitalId,
      "scannerData": scannerData,
      "isActive": isActive,
      "isUndeletable": isUndeletable,
      "createdTime": toJson ? createdTime?.toDate().toIso8601String() : createdTime,
    };
  }

  @override
  String toString({bool toJson = false}) {
    return toMap(toJson: toJson).toString();
  }

  @override
  List<Object?> get props => [id, name, username, password, role, description, imageUrl, hospitalId, isActive, isUndeletable, createdTime];
}