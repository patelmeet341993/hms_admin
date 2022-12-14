import 'package:flutter/material.dart';

import '../../controllers/visit_controller.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "/LoginScreen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                  VisitController().createDummyVisitDataInFirestore();
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
