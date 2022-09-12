import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../utils/parsing_helper.dart';

class PatientModel extends Equatable {
  String id = "", name = "", profilePicture = "", bloodGroup = "", gender = "", primaryMobile = "";
  Timestamp? dateOfBirth, createdTime;
  int totalVisits = 0;
  bool active = false;
  List<String> userMobiles = [];

  PatientModel({
    this.id = "",
    this.name = "",
    this.profilePicture = "",
    this.bloodGroup = "",
    this.gender = "",
    this.primaryMobile = "",
    this.dateOfBirth,
    this.createdTime,
    this.totalVisits = 0,
    this.active = false,
    this.userMobiles = const [],
  });

  PatientModel.fromMap(Map<String, dynamic> map) {
    id = ParsingHelper.parseStringMethod(map['id']);
    name = ParsingHelper.parseStringMethod(map['name']);
    profilePicture = ParsingHelper.parseStringMethod(map['profilePicture']);
    bloodGroup = ParsingHelper.parseStringMethod(map['bloodGroup']);
    gender = ParsingHelper.parseStringMethod(map['gender']);
    primaryMobile = ParsingHelper.parseStringMethod(map['primaryMobile']);
    dateOfBirth = ParsingHelper.parseTimestampMethod(map['dateOfBirth']);
    createdTime = ParsingHelper.parseTimestampMethod(map['createdTime']);
    totalVisits = ParsingHelper.parseIntMethod(map['totalVisits']);
    active = ParsingHelper.parseBoolMethod(map['active']);
    userMobiles = ParsingHelper.parseListMethod<dynamic, String>(map['userMobiles']).toSet().toList();
  }

  void updateFromMap(Map<String, dynamic> map) {
    id = ParsingHelper.parseStringMethod(map['id']);
    name = ParsingHelper.parseStringMethod(map['name']);
    profilePicture = ParsingHelper.parseStringMethod(map['profilePicture']);
    bloodGroup = ParsingHelper.parseStringMethod(map['bloodGroup']);
    gender = ParsingHelper.parseStringMethod(map['gender']);
    primaryMobile = ParsingHelper.parseStringMethod(map['primaryMobile']);
    dateOfBirth = ParsingHelper.parseTimestampMethod(map['dateOfBirth']);
    createdTime = ParsingHelper.parseTimestampMethod(map['createdTime']);
    totalVisits = ParsingHelper.parseIntMethod(map['totalVisits']);
    active = ParsingHelper.parseBoolMethod(map['active']);
    userMobiles = ParsingHelper.parseListMethod<dynamic, String>(map['userMobiles']).toSet().toList();
  }

  Map<String, dynamic> toMap({bool json = false}) {
    return <String, dynamic>{
      "id" : id,
      "name" : name,
      "profilePicture" : profilePicture,
      "bloodGroup" : bloodGroup,
      "gender" : gender,
      "primaryMobile" : primaryMobile,
      "dateOfBirth" : dateOfBirth,
      "createdTime" : json ? createdTime?.toDate().toIso8601String() : createdTime,
      "totalVisits" : totalVisits,
      "active" : active,
      "userMobiles" : userMobiles.toSet().toList(),
    };
  }

  @override
  String toString({bool json = false}) {
    return toMap(json: json).toString();
  }

  @override
  List<Object?> get props => [
    id,
    name,
    profilePicture,
    bloodGroup,
    gender,
    primaryMobile,
    dateOfBirth?.millisecondsSinceEpoch ?? 0,
    createdTime?.millisecondsSinceEpoch ?? 0,
    totalVisits,
    active,
    userMobiles,
  ];
}