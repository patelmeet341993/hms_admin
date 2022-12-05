import 'package:admin/backend/navigation/navigation_controller.dart';
import 'package:admin/backend/patient/my_patient_controller.dart';
import 'package:admin/backend/patient/patient_provider.dart';
import 'package:flutter/material.dart';
import 'package:hms_models/backend/patient/patient_controller.dart';
import 'package:hms_models/hms_models.dart';
import 'package:provider/provider.dart';

class ScannerScreen extends StatefulWidget {
  static const String routeName = "/ScannerScreen";
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> with SingleTickerProviderStateMixin{
  String scannedText = "";
  VisitModel? visitModel;

  Future<void> scanQRCode() async {
    QRCodeDataModel code = await MyUtils.scanQRAndGetQRCodeDataModel(context: context);
    MyPrint.printOnConsole("code:$code");

    scannedText = code.toEncodedString();
    setState(() {});

    if(code.id.isNotEmpty && code.type == QRCodeTypes.patient){
       getPatientData(code.id);
    }
  }

  Future<void> getPatientData(String patientId) async {
    MyPrint.printOnConsole("getPatientData called with patientId: $patientId");

    PatientModel? patientModel = await PatientController().getPatientModelFromPatientId(patientId: patientId);
    MyPrint.printOnConsole("patientModel:$patientModel");

    if(patientModel != null) {
      if(patientModel.isProfileComplete) {
        MyToast.showSuccess(context: context, msg: "Patient Profile Completed");
      }
      else {
        MyToast.showError(context: context, msg: "Patient Profile Not Complete");

        PatientProvider patientProvider = Provider.of<PatientProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);
        MyPatientController(patientProvider: patientProvider).showPatientProfileCompleteDialog(
          context: context,
          patientId: patientId,
          patientModel: patientModel,
        );
      }
    }
    else {
      MyToast.showError(context: context, msg: "Patient Not Found");
    }
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scanQRCode();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text("scannedText: $scannedText"),
          MaterialButton(onPressed: (){
            scanQRCode();
          },child: const Text("Scan"),),
        ],
      ),
    );
  }
}

