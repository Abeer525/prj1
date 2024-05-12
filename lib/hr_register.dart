import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HRRegistrationPage extends StatefulWidget {
  @override
  _HRRegistrationPageState createState() => _HRRegistrationPageState();
}

class _HRRegistrationPageState extends State<HRRegistrationPage> {
  String apiUrl = 'http://192.168.1.5:5000/register_hr';

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  String selectedDepartment = 'Human Resources';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? emailErrorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HR Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildFullNameField(),
              _buildEmailField(),
              _buildPhoneNumberField(),
              _buildDepartmentDropdown(),
              SizedBox(height: 20.0),
              if (emailErrorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    emailErrorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ElevatedButton(
                onPressed: _registerHR,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFullNameField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Full Name',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your full name';
          }
          return null;
        },
        controller: fullNameController,
      ),
    );
  }

  Widget _buildEmailField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: emailController,
        decoration: InputDecoration(
          labelText: 'Email',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email';
          }
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'Please enter a valid email address';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: phoneNumberController,
        decoration: InputDecoration(
          labelText: 'Phone Number',
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your phone number';
          }
          if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
            return 'Please enter only numeric characters';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDepartmentDropdown() {
    List<String> departments = [
      'Human Resources',
      'Recruitment',
      'Employee Relations',
      'Benefits Administration',
      'Training and Development',
      // Add more HR departments here
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField(
        value: selectedDepartment,
        decoration: InputDecoration(
          labelText: 'Department',
          border: OutlineInputBorder(),
        ),
        items: departments.map((department) {
          return DropdownMenuItem(
            value: department,
            child: Text(department),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedDepartment = value.toString();
          });
        },
      ),
    );
  }

  void _registerHR() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> formData = {
        'fullName': fullNameController.text,
        'email': emailController.text,
        'phoneNumber': phoneNumberController.text,
        'department': selectedDepartment,
      };

      String jsonData = jsonEncode(formData);

      try {
        http.Response response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonData,
        );

        if (response.statusCode == 201) {
          Map<String, dynamic> responseBody = jsonDecode(response.body);
          String hrId = responseBody['id'];
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('HR registered successfully with ID: $hrId'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (response.statusCode == 400) {
          setState(() {
            emailErrorMessage = 'This email is already registered. Please use a different email.';
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to register HR'),
              backgroundColor: Colors.black,
            ),
          );
        }
      } catch (e) {
        print('Error: $e');
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
