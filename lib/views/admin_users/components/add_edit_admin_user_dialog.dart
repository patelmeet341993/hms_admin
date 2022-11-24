import 'package:admin/configs/app_strings.dart';
import 'package:admin/views/common/components/loading_widget.dart';
import 'package:admin/views/common/components/modal_progress_hud.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hms_models/configs/constants.dart';
import 'package:hms_models/models/admin_user/admin_user_model.dart';
import 'package:hms_models/utils/my_safe_state.dart';
import 'package:hms_models/utils/my_toast.dart';
import 'package:hms_models/utils/size_config.dart';

import '../../../configs/app_theme.dart';
import '../../../packages/flux/flutx.dart';
import '../../../packages/flux/utils/spacing.dart';
import '../../common/components/CustomContainer.dart';
import '../../common/components/MyCol.dart';
import '../../common/components/MyRow.dart';
import '../../common/components/ScreenMedia.dart';

class AddEditAdminUserDialog extends StatefulWidget {
  final AdminUserModel? adminUserModel;

  const AddEditAdminUserDialog({Key? key, this.adminUserModel}) : super(key: key);

  @override
  State<AddEditAdminUserDialog> createState() => _AddEditAdminUserDialogState();
}

class _AddEditAdminUserDialogState extends State<AddEditAdminUserDialog> with MySafeState {
  late ThemeData themeData;

  bool isLoading = false;

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List<String> rolesList = [];
  String? selectedRole;

  bool isActive = true;

  Future<void> addEditAdminUser() async {
    Navigator.pop(context, AdminUserModel(
      name: nameController.text,
      username: usernameController.text,
      password: passwordController.text,
      description: descriptionController.text,
      isActive: isActive,
      role: selectedRole ?? (rolesList.isNotEmpty ? rolesList.first : ""),
    ));
  }

  @override
  void initState() {
    super.initState();
    rolesList = [
      AdminUserType.admin,
      AdminUserType.reception,
      AdminUserType.doctor,
      AdminUserType.pharmacy,
      AdminUserType.laboratory,
    ];
    // selectedRole = rolesList.first;

    if(widget.adminUserModel != null) {
      AdminUserModel adminUserModel = widget.adminUserModel!;
      nameController.text = adminUserModel.name;
      usernameController.text = adminUserModel.username;
      passwordController.text = adminUserModel.password;
      descriptionController.text = adminUserModel.description;
      if(rolesList.contains(adminUserModel.role)) {
        selectedRole = adminUserModel.role;
      }
      isActive = adminUserModel.isActive;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    themeData=Theme.of(context);

    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Container(
        padding: FxSpacing.all(20),
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 800),
        child: ModalProgressHUD(
          inAsyncCall: isLoading,
          progressIndicator: LoadingWidget(),
          child: getForm(),
        ),
      ),
    );
  }

  Widget getForm() {
    return Form(
      key: _globalKey,
      child: Column(
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MyRow(
                    wrapAlignment: WrapAlignment.center,
                    children: [
                      MyCol(
                        flex: const {
                          ScreenMediaType.SM: 16,
                          ScreenMediaType.MD: 12,
                          ScreenMediaType.XL: 10,
                          ScreenMediaType.XXL: 8,
                          ScreenMediaType.XXXL: 6,
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            /*MyContainer.rounded(
                              color: themeData.primaryColor.withOpacity(0.1),
                                child: Center(
                                  child: Text("HMS",style: TextStyle(
                                      color: themeData.primaryColor,
                                      fontStyle: FontStyle.italic,fontSize: 12,fontWeight: FontWeight.w800
                                  ),
                                  ),
                                ),height: 50,width: 50,),

                            Spacing.height(24),*/
                            Text(
                              widget.adminUserModel != null ? "Edit User" : "Add User",
                              style: AppTheme.getTextStyle(
                                  themeData.textTheme.headline6!,
                                  color: themeData.colorScheme.onBackground,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                              ),
                            ),
                            Spacing.height(24),
                            getTextFieldWidget(
                              controller: nameController,
                              hint: AppStrings.name,
                              icon: Icons.person,
                              validator: (String? text) {
                                if(text?.isNotEmpty ?? false) {
                                  return null;
                                }
                                else {
                                  return "Name is Required";
                                }
                              },
                            ),
                            Spacing.height(16),
                            getTextFieldWidget(
                              controller: usernameController,
                              hint: AppStrings.username,
                              icon: Icons.alternate_email,
                              textInputType: TextInputType.emailAddress,
                              validator: (String? text) {
                                if(text?.isNotEmpty ?? false) {
                                  return null;
                                }
                                else {
                                  return "Username is Required";
                                }
                              },
                            ),
                            Spacing.height(16),
                            getTextFieldWidget(
                              controller: passwordController,
                              hint: AppStrings.password,
                              icon: Icons.password,
                              textInputType: TextInputType.visiblePassword,
                              validator: (String? text) {
                                if(text?.isNotEmpty ?? false) {
                                  return null;
                                }
                                else {
                                  return "Password is Required";
                                }
                              },
                            ),
                            Spacing.height(16),
                            getTextFieldWidget(
                              controller: descriptionController,
                              hint: AppStrings.description,
                              icon: Icons.description,
                              isTextArea: true,
                              textInputType: TextInputType.multiline,
                              /*validator: (String? text) {
                                if(text?.isNotEmpty ?? false) {
                                  return null;
                                }
                                else {
                                  return "Description is Required";
                                }
                              },*/
                            ),
                            Spacing.height(16),
                            Row(
                              children: [
                                Text(
                                  AppStrings.active,
                                  style: AppTheme.getTextStyle(
                                      themeData.textTheme.headline6!,
                                      color: themeData.colorScheme.onBackground,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                  ),
                                ),
                                Spacing.width(16),
                                CupertinoSwitch(
                                  value: isActive,
                                  activeColor: themeData.colorScheme.primary,
                                  onChanged: (bool? value) {
                                    isActive = value ?? false;
                                    mySetState();
                                  },
                                ),
                              ],
                            ),
                            Spacing.height(16),
                            Row(
                              children: [
                                Text(
                                  AppStrings.role,
                                  style: AppTheme.getTextStyle(
                                      themeData.textTheme.headline6!,
                                      color: themeData.colorScheme.onBackground,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                  ),
                                ),
                                Spacing.width(16),
                                DropdownButton<String>(
                                  value: selectedRole,
                                  hint: const Text(AppStrings.select_role),
                                  isDense: true,
                                  dropdownColor: themeData.colorScheme.onPrimary,
                                  focusColor: Colors.transparent,
                                  items: rolesList.map((e) {
                                    return DropdownMenuItem<String>(
                                      value: e,
                                      child: Text(e),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    selectedRole = value;
                                    mySetState();
                                  },
                                ),
                              ],
                            ),
                            Spacing.height(16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                getButtonWidget(text: widget.adminUserModel != null ? AppStrings.edit : AppStrings.create, onTap: () {
                                  if((_globalKey.currentState?.validate() ?? false) && (selectedRole ?? "").isNotEmpty) {
                                    addEditAdminUser();
                                  }
                                  else if((selectedRole ?? "").isEmpty) {
                                    MyToast.showError(context: context, msg: AppStrings.role_is_required,);
                                  }
                                }),
                                Spacing.width(10),
                                getButtonWidget(text: AppStrings.cancel, onTap: () {
                                  Navigator.pop(context);
                                }),
                              ],
                            ),
                            Spacing.height(16),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getTextFieldWidget({required TextEditingController controller, required String hint, required IconData icon, String? Function(String? value)? validator,
  bool isTextArea = false, TextInputType textInputType = TextInputType.text}) {
    return MyContainer.bordered(
      paddingAll:12,
      // color: themeData.bgLayer2,
      child: Row(
        crossAxisAlignment: isTextArea ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: Spacing.all(6),
            decoration: BoxDecoration(
              color: themeData.colorScheme.primary,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Icon(
                icon,
                color: themeData.colorScheme.onPrimary,
                size: 20,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: Spacing.left(16),
              child: TextFormField(
                controller: controller,
                style: AppTheme.getTextStyle(
                  themeData.textTheme.bodyText1!,
                  letterSpacing: 0.1,
                  color: themeData.colorScheme.onBackground,
                  fontWeight: FontWeight.w500
                ),
                maxLines: isTextArea ? 10 : 1,
                validator: validator,
                keyboardType: textInputType,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: AppTheme.getTextStyle(
                    themeData.textTheme.subtitle2!,
                    letterSpacing: 0.1,
                    color: themeData.colorScheme.onBackground,
                    fontWeight: FontWeight.w500,
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8),),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8),),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8),),
                    borderSide: BorderSide.none,
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.all(0),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getButtonWidget({required String text, required void Function() onTap}) {
    return ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(
          padding: MaterialStateProperty.all(Spacing.xy(32 , 0))
      ),
      child: Text(
        text,
        style: AppTheme.getTextStyle(
            themeData.textTheme.bodyText2!,
            fontWeight: FontWeight.w600,
            color: themeData.colorScheme.onPrimary,
            letterSpacing: 0.5,
        ),
      ),
    );
  }
}
