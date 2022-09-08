import '../../../utils/parsing_helper.dart';
import 'prescription_medicine_dose_model.dart';

class PrescriptionModel {
  String medicineName = "", totalDose = "", instructions = "";
  int repeatDurationDays = 1, totalDays = 0;
  String medicineType = "";
  List<PrescriptionMedicineDoseModel> doses = <PrescriptionMedicineDoseModel>[];

  PrescriptionModel({
    this.medicineName = "",
    this.totalDose = "",
    this.instructions = "",
    this.repeatDurationDays = 1,
    this.totalDays = 0,
    this.medicineType = "",
    this.doses = const <PrescriptionMedicineDoseModel>[],
  });

  PrescriptionModel.fromMap(Map<String, dynamic> map) {
    medicineName = ParsingHelper.parseStringMethod(map['medicineName']);
    totalDose = ParsingHelper.parseStringMethod(map['totalDose']);
    instructions = ParsingHelper.parseStringMethod(map['instructions']);
    repeatDurationDays = ParsingHelper.parseIntMethod(map['repeatDurationDays'], defaultValue: 1);
    totalDays = ParsingHelper.parseIntMethod(map['totalDays']);
    medicineType = ParsingHelper.parseStringMethod(map['medicineType']);

    List<PrescriptionMedicineDoseModel> dosesModelsList = <PrescriptionMedicineDoseModel>[];
    List<Map> doseMapsList = ParsingHelper.parseListMethod<dynamic, Map<dynamic, dynamic>>(map['doses']);
    for (Map<dynamic, dynamic> doseMap in doseMapsList) {
      Map<String, dynamic> doseMap2 = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(doseMap);

      if(doseMap2.isNotEmpty) {
        dosesModelsList.add(PrescriptionMedicineDoseModel.fromMap(doseMap2));
      }
    }
    doses = dosesModelsList;
  }

  void updateFromMap(Map<String, dynamic> map) {
    medicineName = ParsingHelper.parseStringMethod(map['medicineName']);
    totalDose = ParsingHelper.parseStringMethod(map['totalDose']);
    instructions = ParsingHelper.parseStringMethod(map['instructions']);
    repeatDurationDays = ParsingHelper.parseIntMethod(map['repeatDurationDays'], defaultValue: 1);
    totalDays = ParsingHelper.parseIntMethod(map['totalDays']);
    medicineType = ParsingHelper.parseStringMethod(map['medicineType']);

    List<PrescriptionMedicineDoseModel> dosesModelsList = <PrescriptionMedicineDoseModel>[];
    List<Map> doseMapsList = ParsingHelper.parseListMethod<dynamic, Map<dynamic, dynamic>>(map['doses']);
    for (Map<dynamic, dynamic> doseMap in doseMapsList) {
      Map<String, dynamic> doseMap2 = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(doseMap);

      if(doseMap2.isNotEmpty) {
        dosesModelsList.add(PrescriptionMedicineDoseModel.fromMap(doseMap2));
      }
    }
    doses = dosesModelsList;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "medicineName" : medicineName,
      "totalDose" : totalDose,
      "instructions" : instructions,
      "repeatDurationDays" : repeatDurationDays,
      "totalDays" : totalDays,
      "medicineType" : medicineType,
      "doses" : doses.map((e) => e.toMap()),
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}