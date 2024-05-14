import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'patient.dart';
import 'patient_details.dart';
import 'nurse_profile.dart';
import 'package:provider/provider.dart';
import 'SearchProvider.dart';

class NurseHomePage extends StatefulWidget {
  final String fullName;
  final String nurseId;

  const NurseHomePage({
    Key? key,
    required this.fullName,
    required this.nurseId,
  }) : super(key: key);

  @override
  _NurseHomePageState createState() => _NurseHomePageState();
}

class _NurseHomePageState extends State<NurseHomePage> {
  late Future<List<Patient>> _futurePatients;

  @override
  void initState() {
    super.initState();
    _futurePatients = fetchPatients();
  }

  Future<List<Patient>> fetchPatients() async {
    final url = Uri.parse('http://192.168.1.10:5000/api/patients');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        List<Patient> patients = jsonResponse.map((data) => Patient.fromJson(data)).toList();

        // Set the patients in SearchProvider
        Provider.of<SearchProvider>(context, listen: false).setPatients(patients);

        return patients;
      } else {
        throw Exception('Failed to load patients - ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${widget.fullName}'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    nurseId: widget.nurseId,
                  ),
                ),
              );
            },
            icon: Icon(Icons.person),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                searchProvider.filterPatients(value);
              },
              decoration: InputDecoration(
                hintText: 'Search Patients...',
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<SearchProvider>(
              builder: (context, searchProvider, _) {
                List<Patient> filteredPatients = searchProvider.filteredPatients;

                if (filteredPatients.isEmpty) {
                  return Center(child: Text('No patients found'));
                }

                return ListView.builder(
                  itemCount: filteredPatients.length,
                  itemBuilder: (context, index) {
                    final patient = filteredPatients[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: patient.gender.toLowerCase() == 'male'
                            ? Colors.blue
                            : Colors.pink,
                        child: Icon(
                          patient.gender.toLowerCase() == 'male'
                              ? Icons.person
                              : Icons.person_outline,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(patient.name),
                      subtitle: Text('Room: ${patient.roomNumber}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PatientDetailsPage(patient: patient),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
