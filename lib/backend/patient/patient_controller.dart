import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hms_models/configs/constants.dart';
import 'package:hms_models/models/common/new_document_data_model.dart';
import 'package:hms_models/models/patient/patient_model.dart';
import 'package:hms_models/utils/my_print.dart';
import 'package:hms_models/utils/my_utils.dart';
import 'package:provider/provider.dart';

import '../common/data_controller.dart';
import '../navigation/navigation_controller.dart';
import 'patient_provider.dart';

class PatientController {
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

    PatientProvider patientProvider = Provider.of<PatientProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseNodes.patientCollectionReference.where("userMobiles", arrayContainsAny: [mobileNumber]).get();
    MyPrint.printOnConsole("Patient Documents Length For Mobile Number '${mobileNumber}' :${querySnapshot.docs.length}");

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
}