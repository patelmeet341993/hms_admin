import 'package:admin/backend/app_theme/app_theme_provider.dart';
import 'package:admin/views/common/components/loading_widget.dart';
import 'package:admin/views/common/components/modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hms_models/utils/my_print.dart';
import 'package:hms_models/utils/my_safe_state.dart';
import 'package:hms_models/utils/my_toast.dart';
import 'package:hms_models/utils/size_config.dart';
import 'package:provider/provider.dart';

import '../../backend/authentication/authentication_controller.dart';
import '../common/components/brand_icon.dart';
import '../common/components/common_text.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "/LoginScreen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with MySafeState {
  late ThemeData themeData;
  bool isLoading = false;

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> login(String userName, String password) async {
    isLoading = true;
    mySetState();

    // await Future.delayed(const Duration(seconds: 3));
    bool isLoggedIn = await AuthenticationController().loginAdminUserWithUsernameAndPassword(context: context, userName: userName, password: password,);
    MyPrint.printOnConsole("isLoggedIn:$isLoggedIn");

    isLoading = false;
    mySetState();

    if(!isLoggedIn) {
      MyToast.showError(context: context, msg: "Login Failed",);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    super.pageBuild();

    return Consumer<AppThemeProvider>(
      builder: (context, AppThemeProvider appThemeProvider,_) {
        return ModalProgressHUD(
          inAsyncCall: isLoading,
          progressIndicator: const LoadingWidget(),
          child: Scaffold(
            backgroundColor: Colors.grey.shade100,
            body: Center(
              child: Container(
              //  color: Colors.red,
                child: mainBody(),
                // constraints: BoxConstraints(maxWidth: 700),
                // margin: Spacing.x(200),

                // child: Form(
                //   key: _globalKey,
                //   child: ,
                //   // child: Column(
                //   //   mainAxisAlignment: MainAxisAlignment.center,
                //   //   crossAxisAlignment: CrossAxisAlignment.center,
                //   //   children: [
                //   //     const Text("Admin Login"),
                //   //     const SizedBox(height: 20,),
                //   //     TextFormField(
                //   //       controller: usernameController,
                //   //       decoration: const InputDecoration(
                //   //         hintText: "Username",
                //   //       ),
                //   //       validator: (String? text) {
                //   //         if(text?.isNotEmpty ?? false) {
                //   //           return null;
                //   //         }
                //   //         else {
                //   //           return "Username is Required";
                //   //         }
                //   //       },
                //   //     ),
                //   //     const SizedBox(height: 20,),
                //   //     TextFormField(
                //   //       controller: passwordController,
                //   //       keyboardType: TextInputType.visiblePassword,
                //   //       decoration: const InputDecoration(
                //   //         hintText: "Password",
                //   //       ),
                //   //       validator: (String? text) {
                //   //         if(text?.isNotEmpty ?? false) {
                //   //           return null;
                //   //         }
                //   //         else {
                //   //           return "Password is Required";
                //   //         }
                //   //       },
                //   //     ),
                //   //     const SizedBox(height: 20,),
                //   //     FlatButton(
                //   //       onPressed: () {
                //   //         if(_globalKey.currentState?.validate() ?? false) {
                //   //           login(usernameController.text, passwordController.text);
                //   //         }
                //   //         // VisitController().createDummyVisitDataInFirestore();
                //   //         // PatientController().createDummyPatientDataInFirestore();
                //   //       },
                //   //       color: themeData.colorScheme.primary,
                //   //       child: Text(
                //   //         AppStrings.login,
                //   //         style: AppTheme.getTextStyle(themeData.textTheme.caption!),
                //   //       ),
                //   //     ),
                //   //   ],
                //   // ),
                // ),
              ),
            ),
          ),
        );
      }
    );
  }

  Widget mainBody(){
    return Form(
      key: _globalKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 14,
            child: Container(

              padding: EdgeInsets.symmetric(vertical: 50,horizontal: 100),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  BrandIcon(),
                  SizedBox(height: 10),
                  CommonBoldText(text: "Hospital Management System",fontSize: 20  ,textAlign: TextAlign.center,),

                  Spacing.height(25),
                  SizedBox(
                      width: 500,
                      child: getEmailTextField()),
                  Spacing.height(15),
                  SizedBox(
                      width: 500,
                      child: getPasswordTextField()),
                  Spacing.height(15),
                  InkWell(
                    onTap: () {
                      /*MyVisitController().createDummyVisitDataInFirestore();
                      return;*/

                      if(_globalKey.currentState?.validate() ?? false) {
                        login(usernameController.text, passwordController.text);
                      }
                      // PatientController().createDummyPatientDataInFirestore();
                    },
                    child: Container(
                     // width: 500,
                      padding: EdgeInsets.symmetric( horizontal: 80,vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: themeData.primaryColor
                      ),
                      child: CommonBoldText(
                        text: 'Login',
                        fontSize: 18,
                        color: Colors.white,
                        textAlign: TextAlign.center,

                      )
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget getEmailTextField(){
    return TextFormField(
      controller: usernameController,
      style: TextStyle(
        color: Colors.black,
        fontSize:16

      ),
       cursorHeight: 25,
      decoration: InputDecoration(
        hintText: "Enter Username",
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(4.0),
          ),
          borderSide: BorderSide(color: themeData.colorScheme.onBackground),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(4.0),),
          borderSide: BorderSide(color: themeData.colorScheme.onBackground),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(4.0),
          ),
          borderSide: BorderSide(color: themeData.colorScheme.onBackground),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(4.0),
          ),
          borderSide: BorderSide(color: themeData.colorScheme.onBackground),
        ),
        filled: true,
        fillColor: themeData.colorScheme.background,
        prefixIcon: Icon(
          Icons.person,
          size: 22,
          color: themeData.colorScheme.onBackground.withAlpha(200),
        ),
        prefixIconColor: themeData.primaryColor,

        isDense: true,
        contentPadding:  EdgeInsets.zero,
      ),
      autofocus: false,
      textCapitalization: TextCapitalization.sentences,
      validator: (text) {
          if(text?.isNotEmpty ?? false) {
            return null;
          }
          else {
            return "UserId is Required";
          }
      },
    );
  }

  Widget getPasswordTextField(){
    return TextFormField(
      controller: passwordController,
      style: TextStyle(
        color: Colors.black,
        fontSize:16

      ),
       cursorHeight: 25,
      onFieldSubmitted: (val){
        if(_globalKey.currentState?.validate() ?? false) {
          login(usernameController.text, passwordController.text);
        }
      },
      decoration: InputDecoration(
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(4.0),
          ),
          borderSide: BorderSide(color: themeData.colorScheme.onBackground),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(4.0),),
          borderSide: BorderSide(color: themeData.colorScheme.onBackground),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(4.0),
          ),
          borderSide: BorderSide(color: themeData.colorScheme.onBackground),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(4.0),
          ),
          borderSide: BorderSide(color: themeData.colorScheme.onBackground),
        ),
        filled: true,
        fillColor: themeData.colorScheme.background,
        prefixIcon: Icon(
          Icons.lock,
          size: 22,
          color: themeData.colorScheme.onBackground.withAlpha(200),
        ),
        prefixIconColor: themeData.primaryColor,

        isDense: true,
        contentPadding:  EdgeInsets.zero,
      ),
      autofocus: false,
      textCapitalization: TextCapitalization.sentences,
      validator: (text) {
        if(text?.isNotEmpty ?? false) {
         return null;
        }
        else {
         return "Password is Required";
        }
      },
    );
  }

}


/*MyContainer.bordered(
                  paddingAll:12,
                  // color: customAppTheme.bgLayer2,
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: Spacing.all(6),
                        decoration: BoxDecoration(
                            color:
                            themeData.colorScheme.primary,
                            borderRadius: const BorderRadius.all(
                                Radius.circular(8))),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Icon(
                            Icons.lock,
                            color:
                            themeData.colorScheme.onPrimary,
                            size: 20,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: Spacing.left(16),
                          child: TextFormField(
                            controller: passwordController,
                            style: AppTheme.getTextStyle(
                                themeData.textTheme.bodyText1!,
                                letterSpacing: 0.1,
                                color: themeData
                                    .colorScheme.onBackground,
                                fontWeight: FontWeight.w500),
                            validator: (String? text) {
                              if(text?.isNotEmpty ?? false) {
                                return null;
                              }
                              else {
                                return "Password is Required";
                              }
                            },
                            decoration: InputDecoration(
                              hintText: "Password",
                              hintStyle: AppTheme.getTextStyle(
                                  themeData.textTheme.subtitle2!,
                                  letterSpacing: 0.1,
                                  color: themeData
                                      .colorScheme.onBackground,
                                  fontWeight: FontWeight.w500),

                              border: const OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  borderSide: BorderSide.none),
                              enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  borderSide: BorderSide.none),
                              focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  borderSide: BorderSide.none),
                              isDense: true,
                              contentPadding: const EdgeInsets.all(0),
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      )
                    ],
                  ),
                ),*/

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

// Row(
//   children: <Widget>[
//     Container(
//       padding: Spacing.all(6),
//       decoration: BoxDecoration(
//           color:
//           themeData.colorScheme.primary,
//           borderRadius: const BorderRadius.all(
//               Radius.circular(8))),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(8),
//         child: Icon(
//           Icons.email,
//           color: themeData.colorScheme.onPrimary,
//           size: 20,
//         ),
//       ),
//     ),
//    /* Container(
//       margin: Spacing.left(16),
//       child: TextFormField(
//         controller: usernameController,
//         style: AppTheme.getTextStyle(
//             themeData.textTheme.bodyText1!,
//             letterSpacing: 0.1,
//             color: themeData
//                 .colorScheme.onBackground,
//             fontWeight: FontWeight.w500),
//         validator: (String? text) {
//                   if(text?.isNotEmpty ?? false) {
//                     return null;
//                   }
//                   else {
//                     return "Username is Required";
//                   }
//                 },
//         decoration: InputDecoration(
//           hintText: "UserName",
//           hintStyle: AppTheme.getTextStyle(
//               themeData.textTheme.subtitle2!,
//               letterSpacing: 0.1,
//               color: themeData
//                   .colorScheme.onBackground,
//               fontWeight: FontWeight.w500),
//
//
//           border: const OutlineInputBorder(
//               borderRadius:
//               BorderRadius.all(
//                 Radius.circular(8),
//               ),
//               borderSide: BorderSide.none),
//           enabledBorder: const OutlineInputBorder(
//               borderRadius:
//               BorderRadius.all(
//                 Radius.circular(8),
//               ),
//               borderSide: BorderSide.none),
//           focusedBorder: const OutlineInputBorder(
//               borderRadius:
//               BorderRadius.all(
//                 Radius.circular(8),
//               ),
//               borderSide: BorderSide.none),
//           isDense: true,
//           contentPadding: const EdgeInsets.all(0),
//         ),
//         textCapitalization:
//         TextCapitalization.sentences,
//       ),
//     )*/
//   ],
// ),
// Align(
//   alignment: Alignment.topRight,
//   child: InkWell(
//     onTap: () {
//       // Navigator.push(
//       //     context,
//       //     MaterialPageRoute(
//       //         builder: (context) =>
//       //             FoodPasswordScreen()));
//     },
//     child: Text(
//       "Forgot password",
//       style: AppTheme.getTextStyle(
//           themeData.textTheme.bodyText2!,
//           color: themeData
//               .colorScheme.onBackground,
//           letterSpacing: 0,
//           fontWeight: FontWeight.w500),
//     ),
//   ),
// ),