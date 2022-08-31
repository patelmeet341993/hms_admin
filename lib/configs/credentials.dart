import 'package:firebase_core/firebase_core.dart';

import '../controllers/app_controller.dart';
import 'firebase_options_dev.dart' as firebase_dev;
import 'firebase_options_prod.dart' as firebase_prod;

//Firebase credentials
FirebaseOptions getFirebaseOptions({required bool isDev}) => isDev
    ? firebase_dev.DefaultFirebaseOptions.currentPlatform
    : firebase_prod.DefaultFirebaseOptions.currentPlatform;

const String PROJECT_ID_SPORTIWE_DEV = "sportiwe-dev";
const String PROJECT_ID_SPORTIWE = "sportiwe-4c13c";
String getProjectId() => AppController().isDev ? PROJECT_ID_SPORTIWE_DEV : PROJECT_ID_SPORTIWE;