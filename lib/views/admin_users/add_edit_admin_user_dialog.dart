import 'package:admin/configs/constants.dart';
import 'package:flutter/material.dart';

import '../../configs/app_theme.dart';
import '../../packages/flux/flutx.dart';
import '../../packages/flux/utils/spacing.dart';
import '../../utils/SizeConfig.dart';
import '../common/components/CustomContainer.dart';
import '../common/components/MyCol.dart';
import '../common/components/MyRow.dart';
import '../common/components/ScreenMedia.dart';

class AddEditAdminUserDialog extends StatefulWidget {
  const AddEditAdminUserDialog({Key? key}) : super(key: key);

  @override
  State<AddEditAdminUserDialog> createState() => _AddEditAdminUserDialogState();
}

class _AddEditAdminUserDialogState extends State<AddEditAdminUserDialog> {
  late ThemeData themeData;

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List<String> rolesList = [];
  String? selectedRole;

  bool isActive = true;

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
  }

  @override
  Widget build(BuildContext context) {
    themeData=Theme.of(context);

    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Container(
        padding: FxSpacing.all(20),
        constraints: BoxConstraints(maxWidth: 500),
        child: getForm(),
      ),
    );
  }

  Widget getForm() {
    return Form(
      key: _globalKey,
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
                      "Add User",
                      style: AppTheme.getTextStyle(
                          themeData.textTheme.headline6!,
                          color: themeData.colorScheme.onBackground,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5),
                    ),
                    Spacing.height(24),
                    getTextFieldWidget(
                      controller: nameController,
                      hint: "Name",
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
                      hint: "UserName",
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
                      hint: "Password",
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
                      hint: "Description",
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        getButtonWidget(text: "Create", onTap: () {
                          if(_globalKey.currentState?.validate() ?? false) {

                          }
                        }),
                        Spacing.width(10),
                        getButtonWidget(text: "Cancel", onTap: () {
                          Navigator.pop(context);
                        }),
                      ],
                    ),
                    Spacing.height(16),
                    // InkWell(
                    //   onTap: () {
                    //     // Navigator.push(
                    //     //     context,
                    //     //     MaterialPageRoute(
                    //     //         builder: (context) =>
                    //     //             FoodRegisterScreen()));
                    //   },
                    //   child: Text(
                    //     "I haven't an account",
                    //     style: AppTheme.getTextStyle(
                    //         themeData.textTheme.bodyText2!,
                    //         color: themeData.colorScheme.onBackground,
                    //         fontWeight: FontWeight.w500,
                    //         decoration: TextDecoration.underline),
                    //   ),
                    // )
                  ],
                ),
              )
            ],
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
