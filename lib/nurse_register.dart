import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NurseRegistrationPage extends StatefulWidget {
  @override
  _NurseRegistrationPageState createState() => _NurseRegistrationPageState();
}

class _NurseRegistrationPageState extends State<NurseRegistrationPage> {
  String apiUrl = 'http://your-flask-api-url/register_nurse'; // Update with your Flask API URL

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nurse Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField('First Name', firstNameController),
              _buildTextField('Last Name', lastNameController),
              _buildTextField('Email', emailController),
              _buildTextField('Phone Number', phoneNumberController),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _registerNurse,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  void _registerNurse() async {
    if (_formKey.currentState!.validate()) {
      // Form data to be sent to the Flask API
      Map<String, dynamic> formData = {
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'email': emailController.text,
        'phoneNumber': phoneNumberController.text,
      };

      // Convert data to JSON
      String jsonData = jsonEncode(formData);

      try {
        // Send POST request to Flask API endpoint
        http.Response response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonData,
        );

        if (response.statusCode == 201) {
          // Nurse registration successful
          Map<String, dynamic> responseBody = jsonDecode(response.body);

          // Extract the generated nurse ID from the response
          String nurseId = responseBody['id'];

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Nurse registered successfully with ID: $nurseId'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          // Show error message for registration failure
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to register nurse'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        // Error with HTTP request
        print('Error: $e');
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to connect to server'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
