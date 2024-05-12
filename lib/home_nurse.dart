import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'patient.dart';
import 'patient_details.dart';
import 'nurse_profile.dart';

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
    final url = Uri.parse('http://192.168.1.2:5000/api/patients');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((data) => Patient.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load patients - ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder<List<Patient>>(
        future: _futurePatients,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No patients found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final patient = snapshot.data![index];
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
    );
  }
}
