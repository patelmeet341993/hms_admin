/*
* File : App Theme Notifier (Listener)
* Version : 1.0.0
* */

import 'dart:io';

import 'package:admin/configs/constants.dart';
import 'package:flutter/material.dart';
import 'package:hms_models/utils/shared_pref_manager.dart';

class AppThemeProvider extends ChangeNotifier {

  static bool kIsWeb = kIsWeb;
  static bool kIsWindow = Platform.isWindows;
  static bool kIsLinux = Platform.isLinux;
  static bool kIsMac = Platform.isMacOS;

  static bool kIsFullScreen = kIsLinux || kIsWeb || kIsWindow || kIsMac;

  int _themeMode = 1;

  AppThemeProvider() {
    init();
  }

  init() async {
    int? data =  await SharedPrefManager().getInt(SharePrefrenceKeys.appThemeMode);
    if(data==null) {
      _themeMode = 1;
    }
    else {
      _themeMode = data;
    }
    notifyListeners();
  }

  int get themeMode => _themeMode;

  Future<void> updateTheme(int themeMode) async {
    _themeMode = themeMode;
    notifyListeners();

    SharedPrefManager().setInt("themeMode", themeMode);
  }
}