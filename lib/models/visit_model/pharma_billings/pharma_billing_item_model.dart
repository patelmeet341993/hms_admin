import '../../../utils/parsing_helper.dart';

class PharmaBillingItemModel {
  String medicineName = "", dose = "", dosePerUnit = "";
  double unitCount = 0, price = 0, finalAmount = 0;

  PharmaBillingItemModel({
    this.medicineName = "",
    this.dose = "",
    this.dosePerUnit = "",
    this.unitCount = 0,
    this.price = 0,
    this.finalAmount = 0,
  });

  PharmaBillingItemModel.fromMap(Map<String, dynamic> map) {
    medicineName = ParsingHelper.parseStringMethod(map['medicineName']);
    dose = ParsingHelper.parseStringMethod(map['dose']);
    dosePerUnit = ParsingHelper.parseStringMethod(map['dosePerUnit']);
    unitCount = ParsingHelper.parseDoubleMethod(map['unitCount']);
    price = ParsingHelper.parseDoubleMethod(map['price']);
    finalAmount = ParsingHelper.parseDoubleMethod(map['finalAmount']);
  }

  void updateFromMap(Map<String, dynamic> map) {
    medicineName = ParsingHelper.parseStringMethod(map['medicineName']);
    dose = ParsingHelper.parseStringMethod(map['dose']);
    dosePerUnit = ParsingHelper.parseStringMethod(map['dosePerUnit']);
    unitCount = ParsingHelper.parseDoubleMethod(map['unitCount']);
    price = ParsingHelper.parseDoubleMethod(map['price']);
    finalAmount = ParsingHelper.parseDoubleMethod(map['finalAmount']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "medicineName" : medicineName,
      "dose" : dose,
      "dosePerUnit" : dosePerUnit,
      "unitCount" : unitCount,
      "price" : price,
      "finalAmount" : finalAmount,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}