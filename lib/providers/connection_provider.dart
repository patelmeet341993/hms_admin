import 'dart:async';
import 'dart:io';

import 'package:admin/utils/logger_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../utils/my_print.dart';

class ConnectionProvider extends ChangeNotifier {
  bool isInternet = true;
  StreamSubscription<ConnectivityResult>? subscription;

  ConnectionProvider() {
    Log().d("ConnectionProvider constructor called");
    if(kIsWeb) {
      isInternet = true;
    }
    else {
      isInternet = Platform.isIOS;
    }
    try {
      Connectivity().checkConnectivity().then((ConnectivityResult result) {
        Log().d("Connectivity Result:$result");
        isInternet = result == ConnectivityResult.none ? false : true;

        Log().d("Connection Subscription Started");
        subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
          Log().d("Connectivity Result:$result");
          isInternet = result == ConnectivityResult.none ? false : true;
          notifyListeners();
        });
      });
    }
    catch (e, s) {
      MyPrint.printOnConsole("Error in Connectivity Subscription:$e");
      MyPrint.printOnConsole(s);
    }
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
    subscription = null;
  }
}