import 'package:admin/backend/visit/my_visit_controller.dart';
import 'package:flutter/material.dart';
import 'package:hms_models/backend/patient/patient_controller.dart';
import 'package:hms_models/models/patient/patient_model.dart';
import 'package:hms_models/utils/my_print.dart';
import 'package:hms_models/utils/size_config.dart';

import '../../../configs/app_theme.dart';
import '../../common/components/loading_widget.dart';

class PatientProfileDetailsDialog extends StatefulWidget {
  final String patientId;
  final PatientModel? patientModel;

  const PatientProfileDetailsDialog({
    Key? key,
    required this.patientId,
    this.patientModel,
  }) : super(key: key);

  @override
  State<PatientProfileDetailsDialog> createState() => _PatientProfileDetailsDialogState();
}

class _PatientProfileDetailsDialogState extends State<PatientProfileDetailsDialog> {
  late ThemeData themeData;

  String patientId = "";
  PatientModel? patientModel;

  Future<void>? futureGetPatientData;

  Future<void> getPatientData() async {
    if(patientId.isEmpty) return;

    patientModel = await PatientController().getPatientModelFromPatientId(patientId: patientId);

    MyPrint.printOnConsole("patientModel in PatientProfileDialog().getPatientData():$patientModel");
  }

  @override
  void initState() {
    super.initState();
    patientId = widget.patientId;
    patientModel = widget.patientModel;

    if(patientModel == null) {
      futureGetPatientData = getPatientData();
    }
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return Dialog(
      child: futureGetPatientData != null ? FutureBuilder(
        future: futureGetPatientData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            return getMainBody();
          }
          else {
            return const LoadingWidget();
          }
        },
      ) : getMainBody(),
    );
  }

  Widget getMainBody() {
    if(patientId.isEmpty || patientModel == null) return const Center(child: Text("Patient Data Not Available"),);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.4,
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Column(
        children: [
          Text(patientModel!.name),
          Text(patientModel!.gender),
          Text(patientModel!.bloodGroup),
          ElevatedButton(
            onPressed: () {
              MyVisitController().showAddVisitDialog(context: context, patientId: patientId, patientModel: patientModel);
            },
            style: ButtonStyle(padding: MaterialStateProperty.all(Spacing.xy(32 , 0))),
            child: Text(
              "Add Visit",
              style: AppTheme.getTextStyle(
                themeData.textTheme.bodyText2!,
                fontWeight: FontWeight.w600,
                color: themeData.colorScheme.onPrimary,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
