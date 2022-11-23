import 'package:flutter/foundation.dart';

import '../../models/patient_model.dart';

class PatientProvider extends ChangeNotifier {
  //region Current patient
  PatientModel? _currentPatient;

  PatientModel? getCurrentPatient() {
    if(_currentPatient != null) {
      return PatientModel.fromMap(_currentPatient!.toMap());
    }
    else {
      return null;
    }
  }

  void setCurrentPatient({PatientModel? patientModel, bool isNotify = true}) {
    if(patientModel != null) {
      _currentPatient = PatientModel.fromMap(patientModel.toMap());
    }
    else {
      _currentPatient = null;
    }
    if(isNotify) {
      notifyListeners();
    }
  }
  //endregion

  //region Patient Models
  //region Patient Ids List
  final List<String> _patientIds = <String>[];

  int get patientsLength => _patientIds.length;

  List<String> getPatientIdsList() {
    return _patientIds;
  }

  void setPatientIdsList({required List<String> patientIdsList, bool isClear = true, bool isNotify = true}) {
    if(isClear) _patientIds.clear();
    _patientIds.addAll(patientIdsList);
    if(isNotify) {
      notifyListeners();
    }
  }

  void addPatientIdInIdsList({required String patientId, bool isNotify = true}) {
    if(patientId.isEmpty) return;

    setPatientIdsList(patientIdsList: (_patientIds..add(patientId)).toSet().toList(), isNotify: isNotify);
  }
  //endregion

  //region Patient Models Map
  final Map<String, PatientModel> _patientModelsMap = <String, PatientModel>{};

  Map<String, PatientModel> getPatientModelsMap() {
    return _patientModelsMap;
  }

  void setPatientModelsMap({required Map<String, PatientModel> patientModelsMap, bool isClear = true, bool isNotify = true}) {
    if(isClear) _patientModelsMap.clear();
    _patientModelsMap.addAll(patientModelsMap);
    if(isNotify) {
      notifyListeners();
    }
  }

  void updatePatientsData({required String patientId, required PatientModel patientModel, bool isNotify = true}) {
    if(patientId.isEmpty) return;

    PatientModel? model = _patientModelsMap[patientId];
    if(model != null) {
      model.updateFromMap(patientModel.toMap());
    }
    else {
      _patientModelsMap[patientId] = patientModel;
    }
    if(isNotify) {
      notifyListeners();
    }
  }
  //endregion

  void addPatientModelsInList({required List<PatientModel> patientModels, bool isNotify = true}) {
    for (PatientModel patientModel in patientModels) {
      addPatientIdInIdsList(patientId: patientModel.id, isNotify: false);
      updatePatientsData(patientId: patientModel.id, patientModel: patientModel, isNotify: false);
    }
    if(isNotify) {
      notifyListeners();
    }
  }

  List<PatientModel> getPatientModelsList() {
    List<PatientModel> patients = <PatientModel>[];

    Map<String, PatientModel> map = getPatientModelsMap();
    for (String element in getPatientIdsList()) {
      PatientModel? model = map[element];
      if(model != null) {
        patients.add(model);
      }
    }

    return patients;
  }
  //endregion
}