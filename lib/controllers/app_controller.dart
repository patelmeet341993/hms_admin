//To Store Some Important App related Variables
import '../utils/shared_pref_manager.dart';

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
}