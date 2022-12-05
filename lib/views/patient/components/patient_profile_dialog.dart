import 'dart:typed_data';

import 'package:admin/views/common/components/common_textfield.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hms_models/backend/patient/patient_controller.dart';
import 'package:hms_models/hms_models.dart';

import '../../../configs/constants.dart';
import '../../common/components/common_primary_button.dart';
import '../../common/components/loading_widget.dart';

class PatientProfileDialog extends StatefulWidget {
  final String patientId;
  final PatientModel? patientModel;
  
  const PatientProfileDialog({
    Key? key,
    required this.patientId,
    this.patientModel,
  }) : super(key: key);

  @override
  State<PatientProfileDialog> createState() => _PatientProfileDialogState();
}

class _PatientProfileDialogState extends State<PatientProfileDialog> {
  late ThemeData themeData;

  String patientId = "";
  PatientModel? patientModel;
  
  Future<void>? futureGetPatientData;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController primaryMobileController = TextEditingController();

  DateTime? dateOfBirth;
  String? gender;

  Uint8List? profilePictureBytes;
  String profilePictureImageUrl = "";

  Future<void> getPatientData() async {
    if(patientId.isEmpty) return;

    patientModel = await PatientController().getPatientModelFromPatientId(patientId: patientId);

    MyPrint.printOnConsole("patientModel in PatientProfileDialog().getPatientData():$patientModel");
  }

  Future<void> pickDateOfBirth() async {
    DateTime? dateTime = await showDatePicker(
      context: context,
      initialDate: dateOfBirth ?? DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: themeData.copyWith(
            /*colorScheme: ColorScheme.dark(
              primary: themeData.colorScheme.primary, // header background color
              onPrimary: themeData.colorScheme.onPrimary, // header text color
              onSurface: themeData.colorScheme.onPrimary, // body text color
              surface: themeData.colorScheme.primary,
            ),*/
          ),
          child: child ?? const SizedBox(),
        );
      },
    );

    dateOfBirth = dateTime ?? dateOfBirth;
    setState(() {});
  }

  Future<void> pickProfilePictureImage() async {
    FilePickerResult? pickedImage = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    PlatformFile? platformFile = pickedImage?.files.firstElement;

    if(platformFile != null) {
      profilePictureBytes = platformFile.bytes;
      setState(() {});
    }
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
      // backgroundColor: Colors.red,
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
    if(patientId.isEmpty || patientModel == null) return const SizedBox();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.4,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Profile",
              style: themeData.textTheme.headline6,
            ),
            CommonTextField(
              hint: "Name",
              textEditingController: nameController,
              isRequired: true,
              prefixIcon: Icons.person,
              validator: (String? text) {
                if(text?.isEmpty ?? true) {
                  return "Name Cannot be empty";
                }
                else {
                  return null;
                }
              },
            ),
            CommonTextField(
              hint: "Mobile Number",
              textEditingController: primaryMobileController,
              isRequired: true,
              prefixIcon: Icons.phone,
              textInputType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: (String? text) {
                if(text?.isEmpty ?? true) {
                  return "Mobile Number Cannot be empty";
                }
                else {
                  if(text!.length < 10) {
                    return "Invalid Mobile Numner";
                  }
                  else {
                    return null;
                  }
                }
              },
            ),
            getDateOfBirthSelection(),
            getGenderSelection(),
            getUploadImageSection(
              title: "Upload Profile",
              bytes: profilePictureBytes,
              url: profilePictureImageUrl,
              onPickImage: () {
                pickProfilePictureImage();
              },
              onDeleteImage: () {
                if(profilePictureBytes != null) profilePictureBytes = null;
                if(profilePictureImageUrl.isNotEmpty) profilePictureImageUrl = "";
                setState(() {});
              },
            ),
            CommonPrimaryButton(
              text: "Submit",
              onTap: () {
                bool formValid = _formKey.currentState?.validate() ?? false;
                bool dobValid = dateOfBirth != null;
                bool genderValid = gender?.isNotEmpty ?? false;

                MyPrint.printOnConsole("formValid:$formValid, dobValid:$dobValid, genderValid:$genderValid");

                if(formValid && dobValid && genderValid) {

                }
                else if(!formValid) {

                }
                else if(!dobValid) {
                  MyToast.showError(context: context, msg: "Date Of Birth is Mandatory");
                }
                else if(!genderValid) {
                  MyToast.showError(context: context, msg: "Gender is Mandatory");
                }
                else {

                }
              },
              filled: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget getDateOfBirthSelection() {
    return GestureDetector(
      onTap: () {
        pickDateOfBirth();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: themeData.inputDecorationTheme.border?.borderSide.color ?? Colors.white70),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(Icons.date_range, color: themeData.iconTheme.color?.withAlpha(150),),
            const SizedBox(width: 13,),
            Expanded(
              child: Text.rich(
                TextSpan(
                  text: dateOfBirth != null ? DatePresentation.ddMMyyyyFormatter(dateOfBirth!.millisecondsSinceEpoch.toString()) : "Select Date Of Birth",
                  style: themeData.textTheme.subtitle2?.copyWith(
                    color: themeData.textTheme.subtitle2!.color?.withAlpha(dateOfBirth != null ? 255 : 150),
                  ),
                  children: dateOfBirth == null ? [
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                  ] : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //region Gender Selection
  Widget getGenderSelection() {
    String? selectedGender;
    List<String> gendersList = AppConstants.genderList;
    if(gendersList.isNotEmpty) {
      if(!gendersList.contains(gender)) {
        gender = null;
      }
      selectedGender = gender;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Theme(
        data: themeData.copyWith(
          highlightColor: Colors.transparent,
          // splashColor: Colors.transparent,
        ),
        child: DropdownButtonFormField<String>(
          value: selectedGender,
          onChanged: (String? value) {
            gender = value;
            setState(() {});
          },
          // hint: const Text("Select Gender"),
          hint: Text.rich(
            TextSpan(
              text: "Select Gender",
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
          // underline: const SizedBox(),
          isExpanded: true,
          decoration: InputDecoration(
            prefixIcon: Icon(getGenderIconFromGenderString(gender: selectedGender)),
            contentPadding: const EdgeInsets.all(5),
          ),
          items: gendersList.map((e) {
            return DropdownMenuItem<String>(
              value: e,
              child: Text(e),
            );
          }).toList(),
        ),
      ),
    );
  }

  IconData getGenderIconFromGenderString({required String? gender}) {
    if(gender == AppConstants.genderMale) {
      return Icons.male;
    }
    else if(gender == AppConstants.genderFemale) {
      return Icons.female;
    }
    else {
      return Icons.transgender;
    }
  }
  //endregion

  Widget getUploadImageSection({required title, required Uint8List? bytes, required String url, void Function()? onPickImage, void Function()? onDeleteImage}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: themeData.colorScheme.onPrimary),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            // width: MediaQuery.of(context).size.width * 0.8,
                          )
                        : CachedNetworkImage(
                            // imageUrl: "https://picsum.photos/370/370",
                            imageUrl: url,
                            // width: MediaQuery.of(context).size.width * 0.8,
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
                margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
