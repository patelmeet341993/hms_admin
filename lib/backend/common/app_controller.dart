import 'package:hms_models/utils/shared_pref_manager.dart';

//To Store Some Important App related Variables
class AppController {
  static AppController? _instance;

  factory AppController() {
    _instance ??= AppController._();
    return _instance!;
  }

  AppController._();

  late bool isDev;
  late bool isLightTheme;

  Future getThemeMode() async {
    bool? isLight = await SharedPrefManager().getBool("isLight");

    if(isLight == null) await SharedPrefManager().setBool("isLight", true);

    isLightTheme = isLight ?? true;
  }

  //region HospitalId
  static String _hospitalId = "Hospital_1";

  String get hospitalId => _hospitalId;

  set hospitalId(String id) => _hospitalId = id;
  //endregion
}