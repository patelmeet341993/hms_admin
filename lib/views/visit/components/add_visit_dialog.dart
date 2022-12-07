import 'dart:typed_data';

import 'package:admin/backend/admin_user/admin_user_controller.dart';
import 'package:admin/backend/admin_user/admin_user_provider.dart';
import 'package:admin/backend/common/app_controller.dart';
import 'package:admin/views/common/components/common_textfield.dart';
import 'package:admin/views/common/components/modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:hms_models/hms_models.dart';

import '../../../backend/visit/my_visit_controller.dart';
import '../../common/components/common_primary_button.dart';
import '../../common/components/loading_widget.dart';

class AddVisitDialog extends StatefulWidget {
  final String patientId;
  final PatientModel? patientModel;
  
  const AddVisitDialog({
    Key? key,
    required this.patientId,
    this.patientModel,
  }) : super(key: key);

  @override
  State<AddVisitDialog> createState() => _AddVisitDialogState();
}

class _AddVisitDialogState extends State<AddVisitDialog> {
  late ThemeData themeData;
  late MyVisitController myVisitController;
  late VisitController visitController;

  bool isLoading = false;

  String patientId = "";
  late PatientModel patientModel;
  
  Future<void>? futureGetData;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController descriptionController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  List<AdminUserModel> doctorsList = <AdminUserModel>[];
  AdminUserModel? currentDoctor;

  Future<void> getData() async {
    if(widget.patientModel == null) {
      if(patientId.isEmpty) return;

      PatientModel? model = await PatientController().getPatientModelFromPatientId(patientId: patientId);

      if(model != null) {
        patientModel = model;
      }
      else {
        MyToast.showError(context: context, msg: "Patient Data not available");
        Navigator.pop(context);
        return;
      }
    }
    else {
      patientModel = widget.patientModel!;
    }
    MyPrint.printOnConsole("patientModel in PatientProfileDialog().getPatientData():$patientModel");

    doctorsList = await AdminUserController(adminUserProvider: AdminUserProvider()).getDoctorsList();
    MyPrint.printOnConsole("doctorsList length in Page:${doctorsList.length}");
  }

  Future<void> addVisit() async {
    if(currentDoctor != null) {
      isLoading = true;
      setState(() {});

      VisitModel? createdVisitModel = await visitController.createNewVisit(
        patientModel: patientModel,
        doctorId: currentDoctor!.id,
        doctorName: currentDoctor!.name,
        hospitalId: AppController().hospitalId,
        description: descriptionController.text,
        weight: ParsingHelper.parseDoubleMethod(weightController.text),
      );
      MyPrint.printOnConsole("createdVisitModel:$createdVisitModel");

      isLoading = false;
      setState(() {});

      if(createdVisitModel != null) {
        MyToast.showSuccess(context: context, msg: "Visit Created Successfully");
        Navigator.pop(context, true);
      }
      else {
        MyToast.showError(context: context, msg: "Some error occurred while creating visit");
      }
    }
  }
  
  @override
  void initState() {
    super.initState();
    myVisitController = MyVisitController();
    visitController = VisitController();
    patientId = widget.patientId;

    futureGetData = getData();
  }
  
  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return Dialog(
      child: futureGetData != null ? FutureBuilder(
        future: futureGetData,
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
    if(patientId.isEmpty) return const SizedBox();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.4,
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: const LoadingWidget(),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                getAddVisitText(),
                getDescriptionTextField(),
                getWeightTextField(),
                getDoctorSelection(),
                getSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getAddVisitText() {
    return Text(
      "Add Visit",
      style: themeData.textTheme.headline6,
    );
  }

  Widget getDescriptionTextField() {
    return CommonTextField(
      hint: "Description",
      textEditingController: descriptionController,
      isRequired: true,
      prefixIcon: Icons.description,
      validator: (String? text) {
        if(text?.isEmpty ?? true) {
          return "Description Cannot be empty";
        }
        else {
          return null;
        }
      },
    );
  }

  Widget getWeightTextField() {
    return CommonTextField(
      hint: "Weight",
      textEditingController: weightController,
      isRequired: true,
      prefixIcon: Icons.speed,
      textInputType: const TextInputType.numberWithOptions(signed: false),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (String? text) {
        if(text?.isEmpty ?? true) {
          return "Weight Cannot be empty";
        }
        else {
          if(double.tryParse(text!) == null) {
            return "Invalid Weight";
          }
          else {
            return null;
          }
        }
      },
    );
  }

  Widget getDoctorSelection() {
    if(currentDoctor != null && !doctorsList.contains(currentDoctor)) {
      currentDoctor = null;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Theme(
        data: themeData.copyWith(
          highlightColor: Colors.transparent,
          // splashColor: Colors.transparent,
        ),
        child: DropdownButtonFormField<AdminUserModel>(
          value: currentDoctor,
          onChanged: (AdminUserModel? value) {
            currentDoctor = value;
            setState(() {});
          },
          hint: Text.rich(
            TextSpan(
              text: "Select Doctor",
              style: themeData.textTheme.subtitle2?.copyWith(
                color: themeData.textTheme.subtitle2!.color?.withAlpha(150),
              ),
              children: const [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          style: themeData.textTheme.subtitle2,
          dropdownColor: themeData.backgroundColor,
          isExpanded: true,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(10),
          ),
          items: doctorsList.map((e) {
            return DropdownMenuItem<AdminUserModel>(
              value: e,
              child: Text("${e.name}${e.description.isNotEmpty ? " (${e.description})" : ""}"),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget getSubmitButton() {
    return CommonPrimaryButton(
      text: "Submit",
      onTap: () {
        bool formValid = _formKey.currentState?.validate() ?? false;
        bool currentDoctorValid = currentDoctor != null;

        MyPrint.printOnConsole("formValid:$formValid, currentDoctorValid:$currentDoctorValid");

        if(formValid && currentDoctorValid) {
          addVisit();
        }
        else if(!formValid) {

        }
        else if(!currentDoctorValid) {
          MyToast.showError(context: context, msg: "Doctor is Mandatory");
        }
        else {

        }
      },
      filled: true,
    );
  }

  //Supporting Widgets
  Widget getUploadImageSection({required title, required Uint8List? bytes, required String url, void Function()? onPickImage, void Function()? onDeleteImage}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: themeData.colorScheme.onBackground),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: themeData.textTheme.subtitle1,
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              bytes != null || url.isNotEmpty
              ? Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8, right: 8),
                      child: bytes != null
                        ? Image.memory(
                            bytes,
                            width: 200,
                            height: 200,
                          )
                        : CachedNetworkImage(
                            // imageUrl: "https://picsum.photos/370/370",
                            imageUrl: url,
                            width: 200,
                            height: 200,
                            placeholder: (_, __) {
                              return const Center(child: LoadingWidget());
                            },
                          ),
                    ),
                    GestureDetector(
                      onTap: onDeleteImage,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, size: 19,),
                      ),
                    ),
                  ],
                )
              : CommonPrimaryButton(
                text: "Select Image",
                onTap: onPickImage,
                filled: false,
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
