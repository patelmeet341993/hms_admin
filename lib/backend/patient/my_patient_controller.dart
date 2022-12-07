import 'package:admin/backend/patient/my_patient_repository.dart';
import 'package:admin/views/patient/components/patient_profile_details_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hms_models/hms_models.dart';

import '../../views/patient/components/update_patient_profile_dialog.dart';
import '../common/data_controller.dart';
import 'patient_provider.dart';

class MyPatientController {
  final PatientProvider patientProvider;
  late MyPatientRepository _myPatientRepository;
  
  MyPatientController({required this.patientProvider, MyPatientRepository? repository}) {
    _myPatientRepository = repository ?? MyPatientRepository();
  }
  
  Future<void> createDummyPatientDataInFirestore() async {
    PatientModel patientModel = PatientModel(
      id: MyUtils.getUniqueIdFromUuid(),
      name: "Viren Desai",
      gender: PatientGender.male,
      active: true,
      bloodGroup: "O+",
      dateOfBirth: Timestamp.fromDate(DateTime(2000, 4, 12)),
      createdTime: Timestamp.now(),
      primaryMobile: "+919988776655",
      userMobiles: const [
        "+919988776655",
      ],
    );

    await FirebaseNodes.patientDocumentReference(patientId: patientModel.id).set(patientModel.toMap()).then((value) {
      MyPrint.printOnConsole("Patient Created Successfully with id:${patientModel.id}");
    })
    .catchError((e, s) {
      MyPrint.printOnConsole("Error in PatientController().createDummyPatientDataInFirestore():$e");
      MyPrint.printOnConsole(s);
    });
  }

  Future<PatientModel?> createPatient({required String mobile}) async {
    NewDocumentDataModel newDocumentDataModel = await DataController().getNewDocIdAndTimeStamp();

    PatientModel patientModel = PatientModel(
      id: newDocumentDataModel.docId,
      createdTime: newDocumentDataModel.timestamp,
      active: false,
      primaryMobile: mobile,
      userMobiles: [mobile],
    );

    bool isPatientCreated = await FirebaseNodes.patientDocumentReference(patientId: patientModel.id).set(patientModel.toMap()).then((value) {
      return true;
    })
    .catchError((e, s) {
      MyPrint.printOnConsole("Error in Creating Patient Model:$e");
      MyPrint.printOnConsole(s);
      return false;
    });
    MyPrint.printOnConsole("isPatientCreated:$isPatientCreated");

    if(isPatientCreated) {
      return patientModel;
    }
    else {
      return null;
    }
  }

  Future<List<PatientModel>> getPatientsForMobileNumber({required String mobileNumber}) async {
    MyPrint.printOnConsole("getPatientsForMobileNumber called with mobile number: $mobileNumber");
    List<PatientModel> patients = [];

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseNodes.patientCollectionReference.where("userMobiles", arrayContainsAny: [mobileNumber]).get();
    MyPrint.printOnConsole("Patient Documents Length For Mobile Number '$mobileNumber' :${querySnapshot.docs.length}");

    for (DocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshot.docs) {
      if((documentSnapshot.data() ?? {}).isNotEmpty) {
        PatientModel patientModel = PatientModel.fromMap(documentSnapshot.data()!);
        patients.add(patientModel);
      }
    }
    patientProvider.addPatientModelsInList(patientModels: patients, isNotify: false);
    if(patients.isNotEmpty) {
      patientProvider.setCurrentPatient(patientModel: patients.first, isNotify: false);
    }
    else {
      patientProvider.setCurrentPatient(patientModel: null, isNotify: false);
    }

    return patients;
  }
  
  Future<bool> showUpdatePatientProfileDialog({required BuildContext context, required String patientId, PatientModel? patientModel}) async {
    if(patientId.isEmpty) return false;

    dynamic value = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return UpdatePatientProfileDialog(
          patientId: patientId,
          patientModel: patientModel,
        );
      },
    );

    return ParsingHelper.parseBoolMethod(value);
  }

  Future<bool> showPatientProfileDetailsDialog({required BuildContext context, required String patientId, PatientModel? patientModel}) async {
    if(patientId.isEmpty) return false;

    dynamic value = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return PatientProfileDetailsDialog(
          patientId: patientId,
          patientModel: patientModel,
        );
      },
    );

    return ParsingHelper.parseBoolMethod(value);
  }
}