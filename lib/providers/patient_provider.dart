import 'package:flutter/foundation.dart';

import '../models/patient_model.dart';

class PatientProvider extends ChangeNotifier {
  PatientModel? _currentPatient;
  List<PatientModel> _patientModels = [];

  PatientModel? getCurrentPatient() {
    if(_currentPatient != null) {
      return PatientModel.fromMap(_currentPatient!.toMap());
    }
    else {
      return null;
    }
  }

  void setCurrentPatient(PatientModel? patientModel, {bool isNotify = true}) {
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

  List<PatientModel> getPatientModels() {
    return _patientModels.map((e) => PatientModel.fromMap(e.toMap())).toList();
  }

  void setPatientModels(List<PatientModel> patientModels, {bool isNotify = true}) {
    _patientModels = patientModels.map((e) => PatientModel.fromMap(e.toMap())).toList();
    if(isNotify) {
      notifyListeners();
    }
  }

  int get patientsLength => _patientModels.length;

  void addPatientModel(PatientModel patientModel, {bool isNotify = true, int index = -1}) {
    if(index > -1 && index <= _patientModels.length) {
      _patientModels.insert(index, PatientModel.fromMap(patientModel.toMap()));
    }
    else {
      _patientModels.add(PatientModel.fromMap(patientModel.toMap()));
    }
    if(isNotify) {
      notifyListeners();
    }
  }
}