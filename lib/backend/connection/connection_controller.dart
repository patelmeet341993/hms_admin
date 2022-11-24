import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../configs/app_strings.dart';
import '../../utils/my_toast.dart';
import '../navigation/navigation_controller.dart';
import 'connection_provider.dart';

class ConnectionController {
  static ConnectionController? _instance;

  factory ConnectionController() {
    return _instance ?? ConnectionController._();
  }

  ConnectionController._();

  bool checkConnection({bool isShowErrorSnakbar = true, BuildContext? context}) {
    ConnectionProvider connectionProvider = Provider.of<ConnectionProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);

    if(!connectionProvider.isInternet && isShowErrorSnakbar && context != null) {
      MyToast.showError(context: context, msg: AppStrings.no_internet,);
    }

    return connectionProvider.isInternet;
  }
}