import 'package:admin/utils/my_safe_state.dart';
import 'package:admin/views/common/components/loading_widget.dart';
import 'package:admin/views/common/components/modal_progress_hud.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "/LoginScreen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with MySafeState {
  late ThemeData themeData;
  bool isLoading = false;

  Future<void> login() async {
    isLoading = true;
    mySetState();

    await Future.delayed(Duration(seconds: 3));

    isLoading = false;
    mySetState();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    super.pageBuild();

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: LoadingWidget(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Login Screen"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Home Body"),
              SizedBox(height: 20,),
              FlatButton(
                onPressed: () {
                  login();
                  // VisitController().createDummyVisitDataInFirestore();
                  // PatientController().createDummyPatientDataInFirestore();
                },
                child: Text("Create Visit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
