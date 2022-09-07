import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/authentication_controller.dart';
import '../../models/admin_user_model.dart';
import '../../providers/admin_user_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home Screen"),
          actions: [
            IconButton(
              onPressed: () {
                AuthenticationController().logout(context: context);
              },
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Home Body"),
              const SizedBox(height: 20,),
              Consumer<AdminUserProvider>(
                builder: (BuildContext context, AdminUserProvider adminUserProvider, Widget? child) {
                  AdminUserModel? adminUserModel = adminUserProvider.getAdminUserModel();
                  if(adminUserModel == null) {
                    return const Text("Not Logged in");
                  }
                  return Column(
                    children: [
                      Text("User Name:${adminUserProvider.getAdminUserModel()!.name}"),
                      Text("User Role:${adminUserProvider.getAdminUserModel()!.role}"),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20,),
              FlatButton(
                onPressed: () {
                  // VisitController().createDummyVisitDataInFirestore();
                  // PatientController().createDummyPatientDataInFirestore();
                },
                child: const Text("Create Visit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
