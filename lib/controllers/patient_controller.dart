import 'package:admin/models/patient_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../configs/constants.dart';
import '../utils/logger_service.dart';
import '../utils/my_utils.dart';
import 'firestore_controller.dart';

class PatientController {
  Future<void> createDummyPatientDataInFirestore() async {
    PatientModel patientModel = PatientModel(
      id: MyUtils.getUniqueIdFromUuid(),
      name: "Viren Desai",
      mobile: "+919988776655",
      gender: PatientGender.male,
      active: true,
      bloodGroup: "O+",
      dateOfBirth: Timestamp.fromDate(DateTime(2000, 4, 12)),
      createdTime: Timestamp.now(),
    );

    await FirestoreController().firestore.collection(FirebaseNodes.patientCollection).doc(patientModel.id).set(patientModel.toMap()).then((value) {
      Log().i("Patient Created Successfully with id:${patientModel.id}");
    })
    .catchError((e, s) {
      Log().e(e, s);
    });
  }
}