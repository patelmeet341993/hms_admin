import 'package:admin/views/common/components/common_text.dart';
import 'package:admin/views/common/components/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:hms_models/models/admin_user/admin_user_model.dart';
import 'package:provider/provider.dart';

import '../../backend/admin_user/admin_user_provider.dart';
import '../../backend/authentication/authentication_controller.dart';
import '../common/components/common_popup.dart';

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
           // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderWidget(title: 'Profile',
              suffixWidget: IconButton(
                onPressed: () {
                  showDialog(context: context, builder: (context){
                    return CommonPopup(
                      text: 'Are you sure you want to logout?',
                      rightOnTap: ()async{
                        AuthenticationController().logout(context: context);
                      },
                    );
                  });
                },
                color: themeData.colorScheme.primary,
                icon: Icon(Icons.logout),
              ),
              ),
             // const SizedBox(height: 20,),
              Consumer<AdminUserProvider>(
                builder: (BuildContext context, AdminUserProvider adminUserProvider, Widget? child) {
                  AdminUserModel? adminUserModel = adminUserProvider.getAdminUserModel();
                  if(adminUserModel == null) {
                    return const Text("Not Logged in");
                  }
                  return Padding(
                    padding:  EdgeInsets.symmetric(horizontal:20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        CommonBoldText(text: "Name: ${adminUserProvider.getAdminUserModel()!.name}",fontSize: 18,),
                        CommonBoldText(text: "Role: ${adminUserProvider.getAdminUserModel()!.role}",fontSize: 18),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}
