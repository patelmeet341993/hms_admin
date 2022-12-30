import 'package:admin/backend/navigation/navigation_controller.dart';
import 'package:admin/backend/patient/my_patient_controller.dart';
import 'package:admin/backend/patient/patient_provider.dart';
import 'package:admin/views/common/components/common_text.dart';
import 'package:flutter/material.dart';
import 'package:hms_models/backend/patient/patient_controller.dart';
import 'package:hms_models/hms_models.dart';
import 'package:provider/provider.dart';

import '../../configs/styles.dart';
import '../common/components/header_widget.dart';

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

    if(code.id.isNotEmpty) {
      if(code.type == QRCodeTypes.patient) {
        handlePatientData(code.id);
      }
    }
  }

  Future<void> handlePatientData(String patientId) async {
    MyPrint.printOnConsole("getPatientData called with patientId: $patientId");

    PatientModel? patientModel = await PatientController().getPatientModelFromPatientId(patientId: patientId);
    MyPrint.printOnConsole("patientModel:$patientModel");

    if(patientModel != null) {
      PatientProvider patientProvider = Provider.of<PatientProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);
      MyPatientController myPatientController = MyPatientController(patientProvider: patientProvider);

      //region If Profile Not Completed, then first show dialog to complete that then proceed further,
      //if profile completion failed, return
      if(!patientModel.isProfileComplete) {
        MyToast.showError(context: context, msg: "Patient Profile Not Complete");

        bool isProfileCompleted = await myPatientController.showUpdatePatientProfileDialog(
          context: context,
          patientId: patientId,
          patientModel: patientModel,
        );
        MyPrint.printOnConsole("isProfileCompleted:$isProfileCompleted");

        if(!isProfileCompleted) return;

        /*patientModel = await PatientController().getPatientModelFromPatientId(patientId: patientId);
        if(!(patientModel?.isProfileComplete ?? false)) return;*/
      }
      else {
        MyToast.showSuccess(context: context, msg: "Patient Profile Completed");
      }
      //endregion

      await myPatientController.showPatientProfileDetailsDialog(
        context: context,
        patientId: patientId,
        patientModel: patientModel,
      );

      MyPrint.printOnConsole("handlePatientData completed");
    }
    else {
      MyToast.showError(context: context, msg: "Patient Not Found");
    }
  }


  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   scanQRCode();
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return SingleChildScrollView(
  //     child: Column(
  //       children: [
  //         Text("scannedText: $scannedText"),
  //         MaterialButton(onPressed: (){
  //           scanQRCode();
  //         },child: const Text("Scan"),),
  //       ],
  //     ),
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderWidget(title: 'Scanner',
          suffixWidget: Tooltip(
              message: 'Open Scanner',
              child: InkWell(
                onTap: (){  scanQRCode(); },
                child: Icon( Icons.qr_code, color: Styles.lightPrimaryColor,),
              ),),
          ),
          SizedBox(height: 10,),
          CommonBoldText(text: scannedText.isNotEmpty?"Received Information : $scannedText":"Open Scanner for Scanning QR Code"),
        ],
      ),
    );
  }




}

