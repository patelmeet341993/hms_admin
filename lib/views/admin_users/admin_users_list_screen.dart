import 'package:admin/configs/app_strings.dart';
import 'package:admin/configs/constants.dart';
import 'package:admin/controllers/admin_user_controller.dart';
import 'package:admin/models/admin_user_model.dart';
import 'package:admin/providers/admin_user_provider.dart';
import 'package:admin/utils/logger_service.dart';
import 'package:admin/utils/my_safe_state.dart';
import 'package:admin/utils/my_utils.dart';
import 'package:admin/views/common/components/common_dialog.dart';
import 'package:admin/views/common/components/loading_widget.dart';
import 'package:admin/views/common/components/modal_progress_hud.dart';
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

class _AdminUsersListScreenState extends State<AdminUsersListScreen> with AutomaticKeepAliveClientMixin, MySafeState {
  late ThemeData themeData;
  Future<List<AdminUserModel>>? futureGetData;

  bool isLoading = false;

  List<int> flexes = [1, 3, 3, 2];

  Future<void> deleteAdminUser(AdminUserModel adminUserModel) async {
    dynamic value = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CommonDialog(
          text: AppStrings.are_you_sure_want_to_delete_admin_user,
          rightOnTap: () {
            Navigator.pop(context, true);
          },
        );
      },
    );

    if(value == true) {
      isLoading = true;
      mySetState();

      bool isDeleted = await AdminUserController().deleteAdminUser(adminUserModel.id);
      Log().i("isDeleted:$isDeleted");

      isLoading = false;
      mySetState();
    }
  }

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
    super.pageBuild();

    themeData = Theme.of(context);
    return Consumer<AdminUserProvider>(
      builder: (BuildContext context, AdminUserProvider adminUserProvider, Widget? child) {
        return Container(
          child: ModalProgressHUD(
            inAsyncCall: isLoading,
            progressIndicator: const LoadingWidget(),
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
          ),
        );
      },
    );
  }

  Widget getMainBody(List<AdminUserModel> users) {
    flexes = [1, 2, 3, 2, 2, 1, 2];
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
      margin: const EdgeInsets.symmetric(vertical: 5),
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
            child: getEditDeleteUser(adminUserModel),
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

  Widget getEditDeleteUser(AdminUserModel adminUserModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        getIconButton(
          iconData: Icons.edit,
          onTap: () async {
            await AdminUserController().createAdminUserWithUsernameAndPassword(context: context, userModel: AdminUserModel(
              id: MyUtils.getUniqueIdFromUuid(),
              name: "Meet",
              role: AdminUserType.laboratory,
              isActive: true,
              username: "Meet341993${MyUtils.getUniqueIdFromUuid()}",
              password: "123456789",
            ));
            futureGetData = AdminUserController().getAdminUsers();
            mySetState();
          },
        ),
        const SizedBox(width: 5,),
        getIconButton(
          iconData: Icons.delete,
          onTap: () async {
            deleteAdminUser(adminUserModel);
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
