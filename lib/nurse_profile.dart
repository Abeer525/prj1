import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  final String nurseId;

  const ProfilePage({Key? key, required this.nurseId}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>> _futureNurseDetails;

  @override
  void initState() {
    super.initState();
    _futureNurseDetails = fetchNurseDetails();
  }

  Future<Map<String, dynamic>> fetchNurseDetails() async {
    final baseUrl = 'http://192.168.1.2:5000/api/nurse';
    final List<Future<http.Response>> requests = [
      http.get(Uri.parse('$baseUrl/email/${widget.nurseId}')),
      http.get(Uri.parse('$baseUrl/fullname/${widget.nurseId}')),
      http.get(Uri.parse('$baseUrl/phonenumber/${widget.nurseId}')),
      http.get(Uri.parse('$baseUrl/dateofbirth/${widget.nurseId}')),
    ];

    try {
      final responses = await Future.wait(requests);

      // Parse responses
      Map<String, dynamic> nurseDetails = {};

      for (var response in responses) {
        if (response.statusCode == 200) {
          Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          nurseDetails.addAll(jsonResponse);
        } else {
          throw Exception('Failed to load nurse details - ${response.statusCode}');
        }
      }

      return nurseDetails;
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nurse Profile'),
      ),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _futureNurseDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            Map<String, dynamic>? nurseDetails = snapshot.data;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Nurse Email: ${nurseDetails?["email"]}'),
                Text('Full Name: ${nurseDetails?["fullName"]}'),
                Text('Phone Number: ${nurseDetails?["phoneNumber"]}'),
                Text('Date of Birth: ${nurseDetails?["dateOfBirth"]}'),
              ],
            );
          },
        ),
      ),
    );
  }
}
