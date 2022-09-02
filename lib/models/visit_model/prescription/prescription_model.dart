import '../../../utils/parsing_helper.dart';
import 'prescription_medicine_dose_model.dart';

class PrescriptionModel {
  String medicineName = "", totalDose = "";
  int repeatDurationDays = 1, totalDays = 0;
  bool isOneTimeBuyMedicine = false;      ///For Cream or Soap
  bool isLiquidMedicine = false;          ///For Syrup
  List<PrescriptionMedicineDoseModel> doses = <PrescriptionMedicineDoseModel>[];

  PrescriptionModel({
    this.medicineName = "",
    this.totalDose = "",
    this.repeatDurationDays = 1,
    this.totalDays = 0,
    this.isOneTimeBuyMedicine = false,
    this.isLiquidMedicine = false,
    this.doses = const <PrescriptionMedicineDoseModel>[],
  });

  PrescriptionModel.fromMap(Map<String, dynamic> map) {
    medicineName = ParsingHelper.parseStringMethod(map['medicineName']);
    totalDose = ParsingHelper.parseStringMethod(map['totalDose']);
    repeatDurationDays = ParsingHelper.parseIntMethod(map['repeatDurationDays'], defaultValue: 1);
    totalDays = ParsingHelper.parseIntMethod(map['totalDays']);
    isOneTimeBuyMedicine = ParsingHelper.parseBoolMethod(map['isOneTimeBuyMedicine']);
    isLiquidMedicine = ParsingHelper.parseBoolMethod(map['isLiquidMedicine']);

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
    repeatDurationDays = ParsingHelper.parseIntMethod(map['repeatDurationDays'], defaultValue: 1);
    totalDays = ParsingHelper.parseIntMethod(map['totalDays']);
    isOneTimeBuyMedicine = ParsingHelper.parseBoolMethod(map['isOneTimeBuyMedicine']);
    isLiquidMedicine = ParsingHelper.parseBoolMethod(map['isLiquidMedicine']);

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
      "repeatDurationDays" : repeatDurationDays,
      "totalDays" : totalDays,
      "isOneTimeBuyMedicine" : isOneTimeBuyMedicine,
      "isLiquidMedicine" : isLiquidMedicine,
      "doses" : doses.map((e) => e.toMap()),
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}