import 'package:flutter/material.dart';
import 'package:hms_models/backend/patient/patient_controller.dart';
import 'package:hms_models/hms_models.dart';

class ScannerScreen extends StatefulWidget {
  static const String routeName = "/ScannerScreen";
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> with SingleTickerProviderStateMixin{

  String scannedText = "";
  VisitModel? visitModel;

  void showDialogView()async{
    String code = await MyUtils.scanQRAndGetData(context: context);
    MyPrint.printOnConsole("code:$code");

    scannedText = code;
    setState(() {});

    if(code.isNotEmpty){
       getPatientData(code);
    }
  }

  Future<void> getPatientData(String patientId) async {
    MyPrint.printOnConsole("getPatientData called with patientId: $patientId");

    PatientModel? patientModel = await PatientController().getPatientModelFromPatientId(patientId: patientId);
    MyPrint.printOnConsole("patientModel:$patientModel");

    if(patientModel != null) {

    }
    else {

    }
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showDialogView();
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
            showDialogView();
          },child: const Text("Scan"),),
        ],
      ),
    );
  }
}

