import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../utils/parsing_helper.dart';

class PatientModel extends Equatable {
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

  Map<String, dynamic> toMap({bool json = false}) {
    return <String, dynamic>{
      "id" : id,
      "name" : name,
      "profilePicture" : profilePicture,
      "mobile" : mobile,
      "bloodGroup" : bloodGroup,
      "gender" : gender,
      "dateOfBirth" : dateOfBirth,
      "createdTime" : json ? createdTime?.toDate().toIso8601String() : createdTime,
      "totalVisits" : totalVisits,
      "active" : active,
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
    mobile,
    bloodGroup,
    gender,
    dateOfBirth?.millisecondsSinceEpoch ?? 0,
    createdTime?.millisecondsSinceEpoch ?? 0,
    totalVisits,
    active,
  ];
}