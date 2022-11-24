import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hms_models/configs/constants.dart';
import 'package:hms_models/models/common/new_document_data_model.dart';
import 'package:uuid/uuid.dart';

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

    await FirebaseNodes.timestampCollectionReference.add({"temp_timestamp": FieldValue.serverTimestamp()}).then((DocumentReference<Map<String, dynamic>> reference) async {
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

    return NewDocumentDataModel(docId: docId, timestamp: timestamp ?? Timestamp.now());
  }

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getDocsWithIdsFromFirestoreCollection(Query query, List<String> docIds) async {
    //Check If input List is Not Null
    if (docIds.isNotEmpty) {
      //Create A New List Of DocumentSnapshots
      List<DocumentSnapshot<Map<String, dynamic>>> newDocs = [];

      //Total Input Documents Count
      int docIdsCount = docIds.length;

      //Limit Accepted By FireStore in WhereIn Query
      int maxLimit = 10;

      //No Of Count we are gonna fire whereIn query on FireStore
      int iterationCount = (docIdsCount / maxLimit).ceil();
      //MyPrint.printOnConsole("IterationCount:"+iterationCount.toString());

      //Min and Max Index to create subList from main input List
      int low = 0, hi = maxLimit;

      //While Loop Count
      int count = 0;

      while (count < iterationCount) {
        //If hi index > Total Input Documents Count ,
        // then make hi index equal to Total Input Documents Count
        if (hi > docIdsCount) {
          hi = docIdsCount;
        }

        //Create SubList From Main Input List
        List<String> docs = docIds.sublist(low, hi);

        //Fire WhereIn query on firestore collection with sublist of documentId
        await query
            .where(FieldPath.documentId, whereIn: docs)
            .get()
            .then((QuerySnapshot querySnapshot) {
              //Get DocumentSnapshots from QuerySnapshot
              List<DocumentSnapshot<Map<String, dynamic>>> docs = List.castFrom(querySnapshot.docs);

              //For Each Document check whether data is empty or not
              //If not then add that DocumentSnapshot to list of newDocumentSnapshot
              docs.forEach((documentSnapshot) {
                if (documentSnapshot.data()!.isNotEmpty) {
                  //MyPrint.printOnConsole("${documentSnapshot.documentID} Exist");
                  //MyPrint.printOnConsole("Data:  ${documentsnapshot.data()}");
                  newDocs.add(documentSnapshot);
                }
                else {
                  //MyPrint.printOnConsole("${documentSnapshot.documentID} Not Exist");
                }
              });
            });
        //--------------Fire Query Ends---------------------------------------------------

        //Icreament low And Hi index by MaxLimit to move to next sublist from main list
        low += maxLimit;
        hi += maxLimit;

        //Increament While loop counter to move further
        count++;
      }

      return newDocs;
    }
    else {
      return [];
    }
  }
}
