import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../backend/admin_user/admin_user_provider.dart';
import '../../backend/authentication/authentication_controller.dart';
import '../../models/admin_user_model.dart';

class AdminUserProfileScreen extends StatefulWidget {
  const AdminUserProfileScreen({Key? key}) : super(key: key);

  @override
  State<AdminUserProfileScreen> createState() => _AdminUserProfileScreenState();
}

class _AdminUserProfileScreenState extends State<AdminUserProfileScreen> {
  late ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return Container(
      child: Scaffold(
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
              IconButton(
                onPressed: () {
                  AuthenticationController().logout(context: context);
                },
                color: themeData.colorScheme.primary,
                icon: Icon(Icons.logout),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
