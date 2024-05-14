import 'package:flutter/material.dart';
import 'patient.dart'; // Import your Patient class

class SearchProvider extends ChangeNotifier {
  List<Patient> _patients = []; // List of all patients
  List<Patient> _filteredPatients = []; // List of filtered patients based on search query
  String _query = ''; // Current search query

  List<Patient> get filteredPatients => _filteredPatients;

  // Set the list of all patients
  void setPatients(List<Patient> patients) {
    _patients = patients;
    filterPatients(_query); // Apply current filter
  }

  // Apply filter based on the search query
  void filterPatients(String query) {
    _query = query.toLowerCase();
    if (_query.isEmpty) {
      _filteredPatients = List.from(_patients); // Show all patients if query is empty
    } else {
      _filteredPatients = _patients.where((patient) {
        return patient.name.toLowerCase().contains(_query); // Filter by patient name
      }).toList();
    }
    notifyListeners(); // Notify listeners to update UI
  }
}
