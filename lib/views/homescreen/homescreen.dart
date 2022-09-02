import 'package:admin/controllers/visit_controller.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/HomeScreen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home Screen"),
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
