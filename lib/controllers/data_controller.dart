import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/new_document_data_model.dart';
import 'firestore_controller.dart';

class DataController {
  static DataController? _instance;

  factory DataController() {
    _instance ??= DataController._();
    return _instance!;
  }

  DataController._();

  Future<NewDocumentDataModel> getNewDocIdAndTimeStamp({bool isGetTimeStamp = true}) async {
    String docId = "";
    Timestamp? timestamp;

    await FirestoreController().firestore.collection("timestamp_collection").add({"temp_timestamp": FieldValue.serverTimestamp()}).then((DocumentReference<Map<String, dynamic>> reference) async {
      docId = reference.id;

      if(isGetTimeStamp) {
        DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await reference.get();
        timestamp = documentSnapshot.data()?['temp_timestamp'];
      }

      await reference.delete();
    })
    .catchError((e, s) {
      // reportErrorToCrashlytics(e, s, reason: "Error in DataController.getNewDocId()");
    });

    if(docId.isEmpty) {
      docId = Uuid().v1().replaceAll("-", "");
    }

    return NewDocumentDataModel(docid: docId, timestamp: timestamp ?? Timestamp.now());
  }
}
