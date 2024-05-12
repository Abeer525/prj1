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
  late Future<String> _futureEmail;

  @override
  void initState() {
    super.initState();
    _futureEmail = fetchEmail();
  }

  Future<String> fetchEmail() async {
    final url = Uri.parse('http://192.168.1.2:5000/api/nurse/email/${widget.nurseId}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse['email'];
      } else {
        throw Exception('Failed to load nurse email - ${response.statusCode}');
      }
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
        child: FutureBuilder<String>(
          future: _futureEmail,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            return Text('Nurse Email: ${snapshot.data}');
          },
        ),
      ),
    );
  }
}
