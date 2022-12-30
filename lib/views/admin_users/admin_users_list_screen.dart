import 'package:admin/backend/admin_user/admin_user_controller.dart';
import 'package:admin/backend/admin_user/admin_user_provider.dart';
import 'package:admin/configs/app_strings.dart';
import 'package:admin/configs/constants.dart';
import 'package:admin/views/admin_users/components/add_edit_admin_user_dialog.dart';
import 'package:admin/views/common/components/common_dialog.dart';
import 'package:admin/views/common/components/header_widget.dart';
import 'package:admin/views/common/components/loading_widget.dart';
import 'package:admin/views/common/components/modal_progress_hud.dart';
import 'package:admin/views/common/components/my_table/my_table_cell_model.dart';
import 'package:admin/views/common/components/my_table/my_table_row_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hms_models/hms_models.dart';

import '../../backend/common/app_controller.dart';

class AdminUsersListScreen extends StatefulWidget {
  final String title;
  const AdminUsersListScreen({Key? key, this.title = "Admin Users"}) : super(key: key);

  @override
  State<AdminUsersListScreen> createState() => _AdminUsersListScreenState();
}

class _AdminUsersListScreenState extends State<AdminUsersListScreen> with AutomaticKeepAliveClientMixin, MySafeState {
  late ThemeData themeData;
  late AdminUserProvider adminUserProvider;
  late AdminUserController adminUserController;
  Future<List<AdminUserModel>>? futureGetData;

  bool isLoading = false;

  List<int> flexes = [1, 3, 3, 2];

  List<String> selectedUsersList = [];

  Future<void> deleteAdminUser(List<String> adminUserIds) async {
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

      bool isDeleted = await adminUserController.deleteAdminUsers(adminUserIds);
      MyPrint.printOnConsole("isDeleted:$isDeleted");

      isLoading = false;
      mySetState();
    }
  }

  Future<void> enableDisableUser(AdminUserModel adminUserModel, bool newValue) async {
    if(adminUserModel.isActive != newValue) {
      adminUserModel.isActive = newValue;
      adminUserProvider.updateUserData(userid: adminUserModel.id, adminUserModel: adminUserModel);

      bool isUpdated = await adminUserController.enableDisableAdminUser(adminUserModel.id, newValue);

      if(!isUpdated) {
        adminUserModel.isActive = !newValue;
        adminUserProvider.updateUserData(userid: adminUserModel.id, adminUserModel: adminUserModel);
      }
    }
  }

  Future<void> showAddEditAdminUserDialog({AdminUserModel? adminUserModel}) async {
    dynamic value = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddEditAdminUserDialog(adminUserModel: adminUserModel,);
      },
      barrierDismissible: false,
    );

    if(value is AdminUserModel) {
      bool isSuccessful;

      isLoading = true;
      mySetState();

      if(adminUserModel != null) {
        AdminUserModel newAdminUserModel = AdminUserModel(
          id: adminUserModel.id,
          name: value.name,
          username: value.username,
          password: value.password,
          description: value.description,
          role: value.role,
          isActive: value.isActive,
          createdTime: adminUserModel.createdTime,
          scannerData: adminUserModel.scannerData,
          imageUrl: adminUserModel.imageUrl,
          hospitalId: adminUserModel.hospitalId.isNotEmpty ? adminUserModel.hospitalId : AppController().hospitalId,
        );
        isSuccessful = await adminUserController.updateAdminUserProfileDataAndUpdateInListInProvider(context: context, adminUserModel: newAdminUserModel);
      }
      else {
        isSuccessful = await adminUserController.addAdminUserInFirestoreAndUpdateInProvider(
          context: context,
          adminUserModel: AdminUserModel(
            name: value.name,
            username: value.username,
            password: value.password,
            description: value.description,
            role: value.role,
            isActive: value.isActive,
          ),
        );
      }

      MyPrint.printOnConsole("isSuccessful:$isSuccessful");

      isLoading = false;
      mySetState();
    }
  }

  @override
  void initState() {
    super.initState();
    adminUserProvider = Provider.of<AdminUserProvider>(context, listen: false);
    adminUserController = AdminUserController(adminUserProvider: adminUserProvider);
    if(adminUserProvider.adminUsersLength <= 0) {
      futureGetData = adminUserController.getAdminUsers(isNotify: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    super.pageBuild();

    themeData = Theme.of(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: adminUserProvider),
      ],
      child: Consumer<AdminUserProvider>(
        builder: (BuildContext context, AdminUserProvider adminUserProvider, Widget? child) {
          return ModalProgressHUD(
            inAsyncCall: isLoading,
            progressIndicator: const LoadingWidget(),
            child: Scaffold(
           //   appBar: getAppBar(),
              body: Column(
                children: [
                  HeaderWidget(title: 'Admin Users'),
                  Expanded(
                    child: SizedBox(
                      height: double.maxFinite,
                      width: double.maxFinite,
                      child: futureGetData != null ? FutureBuilder<List<AdminUserModel>>(
                        future: futureGetData,
                        builder: (BuildContext context, AsyncSnapshot<List<AdminUserModel>> snapshot) {
                          if(snapshot.connectionState == ConnectionState.done) {
                            return getMainBody(adminUserProvider);
                          }
                          else {
                            return const LoadingWidget();
                          }
                        },
                      ) : getMainBody(adminUserProvider),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  AppBar getAppBar() {
    return AppBar(
      title: Text(widget.title),
      centerTitle: false,
      elevation: 0,
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              getIconButton(iconData: Icons.refresh, onTap: () {
                futureGetData = adminUserController.getAdminUsers(isNotify: true);
              }),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              getIconButton(iconData: Icons.add, onTap: () {
                showAddEditAdminUserDialog();
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget getMainBody(AdminUserProvider adminUserProvider) {
    flexes = [1, 2, 2, 1, 2, 2, 2, 2];
    List<String> titles = ["Sr No.", "Id", "Name", "Role", "Username", "Created On", "Active", "Edit"];

    Color textColor = themeData.colorScheme.onPrimary;
    FontWeight fontWeight = FontWeight.w800;
    double fontSize = 16;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          MyTableRowWidget(
            backgroundColor: themeData.colorScheme.primary,
            cells: [
              /*MyTableCellModel(
                  flex: flexes[0],
                  child: getCheckBoxWidget(
                    isSelected: adminUserProvider.adminUsersLength > 0 && selectedUsersList.length == adminUserProvider.adminUsersLength,
                    activeColor: themeData.colorScheme.onPrimary,
                    checkColor: themeData.colorScheme.primary,
                    unselectedColor: themeData.colorScheme.onPrimary,
                    onChanged: (bool? value) {
                      selectedUsersList.clear();
                      if(value ?? false) {
                        selectedUsersList.addAll(adminUserProvider.adminUsers.map((e) => e.id));
                      }
                      mySetState();
                    }
                  ),
                ),*/
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
          Expanded(child: getAdminUsersListView(adminUserProvider))
        ],
      ),
    );
  }

  Widget getAdminUsersListView(AdminUserProvider adminUserProvider) {
    List<String> users = adminUserProvider.adminUsersIds;

    if(users.isEmpty) {
      return const Center(
        child: Text(AppStrings.no_users),
      );
    }

    return ListView.builder(
      itemCount: users.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if((index == 0 && adminUserProvider.adminUsersLength == 0) || (index == adminUserProvider.adminUsersLength)) {
          if(adminUserProvider.getIsUsersLoading) {
          // if(true) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: themeData.colorScheme.primary,
                    size: 40,
                  ),
                ),
              ],
            );
          }
          else {
            return const SizedBox();
          }
        }

        if(adminUserProvider.getHasMoreUsers && index > (adminUserProvider.adminUsersLength - AppConstants.adminUsersRefreshIndexForPagination)) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            adminUserController.getAdminUsers(isRefresh: false, isFromCache: false, isNotify: false);
          });
        }

        String userId = users[index];
        AdminUserModel? adminUserModel = adminUserProvider.adminUserModelsMap[userId];

        if(adminUserModel != null) {
          return getAdminUserWidget(adminUserModel, index);
        }
        else {
          return const SizedBox();
        }
      },
    );
  }

  Widget getAdminUserWidget(AdminUserModel adminUserModel, int index) {
    FontWeight? fontWeight = FontWeight.w600;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: MyTableRowWidget(
        cells: [
          /*MyTableCellModel(
            flex: flexes[0],
            child: getCheckBoxWidget(
              isSelected: selectedUsersList.contains(adminUserModel.id),
              onChanged: (bool? value) {
                if(value ?? false) {
                  selectedUsersList.add(adminUserModel.id);
                }
                else {
                  selectedUsersList.remove(adminUserModel.id);
                }
                mySetState();
              }
            ),
          ),*/
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
            child: getTableCellWidget(adminUserModel.createdTime != null ? DatePresentation.ddMMyyyyFormatter(adminUserModel.createdTime!.millisecondsSinceEpoch.toString()) : "Not Available", fontWeight: fontWeight),
          ),
          MyTableCellModel(
            flex: flexes[6],
            child: getSwitch(value: adminUserModel.isActive, onChanged: (bool? value) {
              enableDisableUser(adminUserModel, value ?? false);
            }),
          ),
          MyTableCellModel(
            flex: flexes[7],
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

  Widget getCheckBoxWidget({bool isSelected = false, void Function(bool?)? onChanged, Color? activeColor, Color? checkColor, Color? unselectedColor}) {
    return Theme(
      data: themeData.copyWith(
        unselectedWidgetColor: unselectedColor,
      ),
      child: Checkbox(
        value: isSelected, onChanged: onChanged,
        activeColor: activeColor,
        checkColor: checkColor,
      ),
    );
  }

  Widget getEditDeleteUser(AdminUserModel adminUserModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        getIconButton(
          iconData: Icons.edit,
          onTap: () async {
            showAddEditAdminUserDialog(adminUserModel: adminUserModel);

            /*isLoading = true;
            mySetState();

            AdminUserModel adminUserModel = AdminUserModel(
              id: MyUtils.getUniqueIdFromUuid(),
              name: "Meet",
              role: AdminUserType.laboratory,
              isActive: true,
              username: "Meet341993${MyUtils.getUniqueIdFromUuid()}",
              password: "123456789",
            );
            await adminUserController.addAdminUserInFirestoreAndUpdateInProvider(context: context, adminUserModel: adminUserModel);

            isLoading = false;
            mySetState();*/
          },
        ),
        const SizedBox(width: 5,),
        getIconButton(
          iconData: Icons.delete,
          onTap: () async {
            deleteAdminUser(selectedUsersList.isNotEmpty ? selectedUsersList : [adminUserModel.id]);
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

  Widget getSwitch({required bool value, void Function(bool?)? onChanged}) {
    return CupertinoSwitch(
      value: value, onChanged: onChanged,
      activeColor: themeData.colorScheme.primary,
    );
  }

  @override
  bool get wantKeepAlive => false;
}
