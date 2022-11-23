import 'package:cloud_firestore/cloud_firestore.dart';

import '../../configs/typedefs.dart';

/*class FirestoreController {
  static FirestoreController? _instance;

  factory FirestoreController() {
    _instance ??= FirestoreController._();
    return _instance!;
  }

  FirestoreController._();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
}*/

class FirestoreController {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static MyFirestoreCollectionReference collectionReference({required String collectionName, String? documentId}) {
    return firestore.collection(collectionName);
  }

  static MyFirestoreDocumentReference documentReference({required String collectionName, String? documentId}) {
    return firestore.collection(collectionName).doc(documentId);
  }
}