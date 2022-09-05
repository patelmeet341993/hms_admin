import 'package:admin/controllers/authentication_controller.dart';
import 'package:admin/controllers/visit_controller.dart';
import 'package:admin/models/admin_user_model.dart';
import 'package:admin/providers/admin_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          actions: [
            IconButton(
              onPressed: () {
                AuthenticationController().logout(context: context);
              },
              icon: Icon(Icons.logout),
            )
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Home Body"),
              SizedBox(height: 20,),
              Consumer<AdminUserProvider>(
                builder: (BuildContext context, AdminUserProvider adminUserProvider, Widget? child) {
                  AdminUserModel? adminUserModel = adminUserProvider.getAdminUserModel();
                  if(adminUserModel == null) {
                    return Text("Not Logged in");
                  }
                  return Column(
                    children: [
                      Text("User Name:${adminUserProvider.getAdminUserModel()!.name}"),
                      Text("User Role:${adminUserProvider.getAdminUserModel()!.role}"),
                    ],
                  );
                },
              ),
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
