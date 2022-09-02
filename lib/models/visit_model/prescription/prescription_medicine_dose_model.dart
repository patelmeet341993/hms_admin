import '../../../configs/constants.dart';
import '../../../utils/parsing_helper.dart';

class PrescriptionMedicineDoseModel {
  String doseTime = PrescriptionMedicineDoseTime.morning, dose = "";
  bool afterMeal = false, beforeMeal = false;

  PrescriptionMedicineDoseModel({
    this.doseTime = PrescriptionMedicineDoseTime.morning,
    this.afterMeal = false,
    this.beforeMeal = false,
    this.dose = "",
  });

  PrescriptionMedicineDoseModel.fromMap(Map<String, dynamic> map) {
    doseTime = ParsingHelper.parseStringMethod(map['doseTime']);
    dose = ParsingHelper.parseStringMethod(map['dose']);
    afterMeal = ParsingHelper.parseBoolMethod(map['afterMeal']);
    beforeMeal = ParsingHelper.parseBoolMethod(map['beforeMeal']);
    dose = ParsingHelper.parseStringMethod(map['doseCount']);
  }

  void updateFromMap(Map<String, dynamic> map) {
    doseTime = ParsingHelper.parseStringMethod(map['doseTime']);
    dose = ParsingHelper.parseStringMethod(map['dose']);
    afterMeal = ParsingHelper.parseBoolMethod(map['afterMeal']);
    beforeMeal = ParsingHelper.parseBoolMethod(map['beforeMeal']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "doseTime" : doseTime,
      "dose" : dose,
      "afterMeal" : afterMeal,
      "beforeMeal" : beforeMeal,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}