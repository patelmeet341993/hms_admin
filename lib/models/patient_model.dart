import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/parsing_helper.dart';

class PatientModel {
  String id = "", name = "", profilePicture = "", mobile = "", bloodGroup = "", gender = "";
  Timestamp? dateOfBirth, createdTime;
  int totalVisits = 0;
  bool active = false;

  PatientModel({
    this.id = "",
    this.name = "",
    this.profilePicture = "",
    this.mobile = "",
    this.bloodGroup = "",
    this.gender = "",
    this.dateOfBirth,
    this.createdTime,
    this.totalVisits = 0,
    this.active = false,
  });

  PatientModel.fromMap(Map<String, dynamic> map) {
    id = ParsingHelper.parseStringMethod(map['id']);
    name = ParsingHelper.parseStringMethod(map['name']);
    profilePicture = ParsingHelper.parseStringMethod(map['profilePicture']);
    mobile = ParsingHelper.parseStringMethod(map['mobile']);
    bloodGroup = ParsingHelper.parseStringMethod(map['bloodGroup']);
    gender = ParsingHelper.parseStringMethod(map['gender']);
    dateOfBirth = ParsingHelper.parseTimestampMethod(map['dateOfBirth']);
    createdTime = ParsingHelper.parseTimestampMethod(map['createdTime']);
    totalVisits = ParsingHelper.parseIntMethod(map['totalVisits']);
    active = ParsingHelper.parseBoolMethod(map['active']);
  }

  void updateFromMap(Map<String, dynamic> map) {
    id = ParsingHelper.parseStringMethod(map['id']);
    name = ParsingHelper.parseStringMethod(map['name']);
    profilePicture = ParsingHelper.parseStringMethod(map['profilePicture']);
    mobile = ParsingHelper.parseStringMethod(map['mobile']);
    bloodGroup = ParsingHelper.parseStringMethod(map['bloodGroup']);
    gender = ParsingHelper.parseStringMethod(map['gender']);
    dateOfBirth = ParsingHelper.parseTimestampMethod(map['dateOfBirth']);
    createdTime = ParsingHelper.parseTimestampMethod(map['createdTime']);
    totalVisits = ParsingHelper.parseIntMethod(map['totalVisits']);
    active = ParsingHelper.parseBoolMethod(map['active']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id" : id,
      "name" : name,
      "profilePicture" : profilePicture,
      "mobile" : mobile,
      "bloodGroup" : bloodGroup,
      "gender" : gender,
      "dateOfBirth" : dateOfBirth,
      "createdTime" : createdTime,
      "totalVisits" : totalVisits,
      "active" : active,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}