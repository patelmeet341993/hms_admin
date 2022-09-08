import 'package:admin/configs/app_strings.dart';
import 'package:admin/controllers/admin_user_controller.dart';
import 'package:admin/models/admin_user_model.dart';
import 'package:admin/providers/admin_user_provider.dart';
import 'package:admin/views/common/components/loading_widget.dart';
import 'package:admin/views/common/components/my_table/my_table_cell_model.dart';
import 'package:admin/views/common/components/my_table/my_table_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/SizeConfig.dart';

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
    flexes = [1, 3, 3, 3, 2, 1, 1];
    List<String> titles = ["Sr No.", "Id", "Name", "Role", "Username", "Active", "Edit"];

    Color textColor = themeData.colorScheme.onPrimary;
    FontWeight fontWeight = FontWeight.w800;
    double fontSize = 16;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          MyTableRowWidget(
            backgroundColor: themeData.colorScheme.primary,
            cells: [
              ...List.generate(titles.length, (index) {
                return MyTableCellModel(
                  flex: flexes[index],
                  child: getTableCellWidget(
                    titles[index],
                    textColor: textColor,
                    fontWeight: fontWeight,
                    size: fontSize,
                  ),
                );
              }),
            ],
          ),
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
    FontWeight? fontWeight = FontWeight.w600;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: MyTableRowWidget(
        cells: [
          MyTableCellModel(
            flex: flexes[0],
            child: getTableCellWidget((index + 1).toString(), fontWeight: fontWeight),
          ),
          MyTableCellModel(
            flex: flexes[1],
            child: getTableCellWidget(adminUserModel.id, fontWeight: fontWeight),
          ),
          MyTableCellModel(
            flex: flexes[2],
            child: getTableCellWidget(adminUserModel.name, fontWeight: fontWeight),
          ),
          MyTableCellModel(
            flex: flexes[3],
            child: getTableCellWidget(adminUserModel.role, fontWeight: fontWeight),
          ),
          MyTableCellModel(
            flex: flexes[4],
            child: getTableCellWidget(adminUserModel.username, fontWeight: fontWeight),
          ),
          MyTableCellModel(
            flex: flexes[5],
            child: getTableCellWidget(adminUserModel.isActive ? "Activated" : "Deactivated", fontWeight: fontWeight),
          ),
          MyTableCellModel(
            flex: flexes[6],
            child: getEditDeleUser(),
          ),
        ],
      ),
    );
  }

  Widget getTableCellWidget(String title, {Color? textColor, FontWeight? fontWeight, double? size}) {
    return Text(
      title,
      style: themeData.textTheme.caption?.copyWith(
        color: textColor,
        fontWeight: fontWeight,
        fontSize: size,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget getEditDeleUser() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        getIconButton(
          iconData: Icons.edit,
          onTap: () {

          },
        ),
        SizedBox(width: 5,),
        getIconButton(
          iconData: Icons.delete,
          onTap: () {

          },
          backgroundColor: Colors.red,
        ),
      ],
    );
  }

  Widget getIconButton({required IconData iconData, void Function()? onTap, Color? backgroundColor, Color? iconColor,}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: Spacing.all(6),
        decoration: BoxDecoration(
          color: backgroundColor ?? themeData.colorScheme.primary,
          borderRadius: const BorderRadius.all(Radius.circular(8),),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Icon(
            iconData,
            color: iconColor ?? themeData.colorScheme.onPrimary,
            size: 20,
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
