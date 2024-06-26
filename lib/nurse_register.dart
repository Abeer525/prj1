import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NurseRegistrationPage extends StatefulWidget {
  @override
  _NurseRegistrationPageState createState() => _NurseRegistrationPageState();
}

class _NurseRegistrationPageState extends State<NurseRegistrationPage> {
  String apiUrl = 'http://192.168.1.3:5000/register_nurse';

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController dobController = TextEditingController(); // Controller for Date of Birth
  String selectedNursingType = 'Registered Nurse (RN)';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? emailErrorMessage;

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
              _buildFullNameField(),
              _buildEmailField(),
              _buildPhoneNumberField(),
              _buildDateOfBirthField(), // New Date of Birth field
              _buildNursingTypeDropdown(),
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
                onPressed: _registerNurse,
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

  Widget _buildDateOfBirthField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: dobController,
        decoration: InputDecoration(
          labelText: 'Date of Birth (DD-MM-YYYY)',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your date of birth';
          }
          // Additional validation logic for date format or age eligibility can be added here
          return null;
        },
      ),
    );
  }

  Widget _buildNursingTypeDropdown() {
    List<String> nursingTypes = [
      'Registered Nurse (RN)',
      'Licensed Practical Nurse (LPN)',
      'Nurse Practitioner (NP)',
      'Certified Nurse Midwife (CNM)',
      'Clinical Nurse Specialist (CNS)',
      'Critical Care Nurse',
      'Emergency Room (ER) Nurse',
      'Operating Room (OR) Nurse',
      'Pediatric Nurse',
      'Psychiatric-Mental Health Nurse',
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField(
        value: selectedNursingType,
        decoration: InputDecoration(
          labelText: 'Nursing Type',
          border: OutlineInputBorder(),
        ),
        items: nursingTypes.map((type) {
          return DropdownMenuItem(
            value: type,
            child: Text(type),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedNursingType = value.toString();
          });
        },
      ),
    );
  }

  void _registerNurse() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> formData = {
        'fullName': fullNameController.text,
        'email': emailController.text,
        'phoneNumber': phoneNumberController.text,
        'dateOfBirth': dobController.text, // Include Date of Birth in the form data
        'nursingType': selectedNursingType,
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
          String nurseId = responseBody['id'];

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Nurse registered successfully with ID: $nurseId'),
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
              content: Text('Failed to register nurse'),
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
