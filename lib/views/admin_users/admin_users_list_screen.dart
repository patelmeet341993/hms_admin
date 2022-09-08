import 'package:admin/configs/app_strings.dart';
import 'package:admin/controllers/admin_user_controller.dart';
import 'package:admin/models/admin_user_model.dart';
import 'package:admin/providers/admin_user_provider.dart';
import 'package:admin/views/common/components/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminUsersListScreen extends StatefulWidget {
  const AdminUsersListScreen({Key? key}) : super(key: key);

  @override
  State<AdminUsersListScreen> createState() => _AdminUsersListScreenState();
}

class _AdminUsersListScreenState extends State<AdminUsersListScreen> with AutomaticKeepAliveClientMixin {
  late ThemeData themeData;
  Future<List<AdminUserModel>>? futureGetData;

  List<int> flexes = [1, 3, 3, 2];

  @override
  void initState() {
    super.initState();
    AdminUserProvider adminUserProvider = Provider.of<AdminUserProvider>(context, listen: false);
    if(adminUserProvider.adminUsersLength <= 0) {
      futureGetData = AdminUserController().getAdminUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Consumer<AdminUserProvider>(
      builder: (BuildContext context, AdminUserProvider adminUserProvider, Widget? child) {
        return Container(
          child: Scaffold(
            body: SizedBox(
              height: double.maxFinite,
              width: double.maxFinite,
              child: futureGetData != null ? FutureBuilder<List<AdminUserModel>>(
                future: futureGetData,
                builder: (BuildContext context, AsyncSnapshot<List<AdminUserModel>> snapshot) {
                  if(snapshot.connectionState == ConnectionState.done) {
                    return getMainBody(adminUserProvider.adminUsers);
                  }
                  else {
                    return const LoadingWidget();
                  }
                },
              ) : getMainBody(adminUserProvider.adminUsers),
            ),
          ),
        );
      },
    );
  }

  Widget getMainBody(List<AdminUserModel> users) {
    flexes = [1, 3, 3, 3, 2, 1];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          getTableRowWidget(
            [
              "Sr No.",
              "Id",
              "Name",
              "Role",
              "Username",
              "Active",
            ],
            backgroundColor: themeData.colorScheme.primary,
            textColor: themeData.colorScheme.onPrimary,
            fontWeight: FontWeight.w700,
          ),
          /*Row(
            children: [
              Expanded(
                flex: flexes[0],
                child: getTableColumnTitleWidget("Id"),
              ),
              Expanded(
                flex: flexes[1],
                child: getTableColumnTitleWidget("Name"),
              ),
              Expanded(
                flex: flexes[2],
                child: getTableColumnTitleWidget("Role"),
              ),
              Expanded(
                flex: flexes[3],
                child: getTableColumnTitleWidget("Username"),
              ),
            ],
          ),*/
          Expanded(child: getAdminUsersListView(users))
        ],
      ),
    );
  }

  Widget getAdminUsersListView(List<AdminUserModel> users) {
    if(users.isEmpty) {
      return const Center(
        child: Text(AppStrings.no_users),
      );
    }
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (BuildContext context, int index) {
        AdminUserModel adminUserModel = users[index];

        return getAdminUserWidget(adminUserModel, index);
      },
    );
  }

  Widget getAdminUserWidget(AdminUserModel adminUserModel, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: getTableRowWidget(
          [
          (index + 1).toString(),
          adminUserModel.id,
          adminUserModel.name,
          adminUserModel.role,
          adminUserModel.username,
          adminUserModel.isActive ? "Activated" : "Deactivated",
        ],
        fontWeight: FontWeight.w600,
      ),
    );
    /*return Row(
      children: [
        Expanded(
          flex: flexes[0],
          child: getTableColumnTitleWidget(adminUserModel.id),
        ),
        Expanded(
          flex: flexes[1],
          child: getTableColumnTitleWidget(adminUserModel.name),
        ),
        Expanded(
          flex: flexes[2],
          child: getTableColumnTitleWidget(adminUserModel.role),
        ),
        Expanded(
          flex: flexes[3],
          child: getTableColumnTitleWidget(adminUserModel.username),
        ),
      ],
    );*/
  }

  Widget getTableRowWidget(List<String> values, {Color? backgroundColor, Color? textColor, FontWeight? fontWeight}) {
    return Container(
      // margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: backgroundColor ?? themeData.cardColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: List.generate(values.length, (index) {
          return Expanded(
            flex: flexes[index],
            child: getTableColumnTitleWidget(values[index], textColor: textColor, fontWeight: fontWeight),
          );
        }),
        /*children: [
          Expanded(
            flex: flexes[0],
            child: getTableColumnTitleWidget(values[0]),
          ),
          Expanded(
            flex: flexes[1],
            child: getTableColumnTitleWidget(values[1]),
          ),
          Expanded(
            flex: flexes[2],
            child: getTableColumnTitleWidget(values[2]),
          ),
          Expanded(
            flex: flexes[3],
            child: getTableColumnTitleWidget(values[3]),
          ),
        ],*/
      ),
    );
  }

  Widget getTableColumnTitleWidget(String title, {Color? textColor, FontWeight? fontWeight}) {
    return Text(
      title,
      style: themeData.textTheme.caption?.copyWith(
        color: textColor,
        fontWeight: fontWeight,
      ),
      textAlign: TextAlign.center,
    );
  }

  @override
  bool get wantKeepAlive => false;
}
