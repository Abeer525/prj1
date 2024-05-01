import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PatientInfoPage extends StatefulWidget {
  @override
  _PatientInfoPageState createState() => _PatientInfoPageState();
}

class _PatientInfoPageState extends State<PatientInfoPage> {
  String apiUrl = 'http://192.168.1.3:5000/api/patients'; // Update with your API URL

  TextEditingController nameController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController motherNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  String? selectedGender;
  TextEditingController maritalStatusController = TextEditingController();
  TextEditingController childrenStatusController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emergencyPhoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController medicalHistoryController = TextEditingController();
  TextEditingController reasonForVisitController = TextEditingController();
  TextEditingController symptomsController = TextEditingController();
  TextEditingController vitalSignsController = TextEditingController();
  TextEditingController diagnosticTestsController = TextEditingController();
  TextEditingController treatmentPlanController = TextEditingController();
  TextEditingController insuranceStatusController = TextEditingController();
  TextEditingController insurancePolicyController = TextEditingController();
  TextEditingController admissionDateController = TextEditingController();
  TextEditingController dischargeDateController = TextEditingController();
  TextEditingController insurerNameController = TextEditingController();
  TextEditingController doctorNameController = TextEditingController();
  TextEditingController additionalCommentsController = TextEditingController();
  TextEditingController roomNumberController = TextEditingController(); // New room number controller

  List<PillInfo> pillsList = [];
  bool pillsFound = false;
  List<String> selectedLifestyles = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hospital Admission Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSectionTitle('Personal Information'),
                _buildTextField('Full Name', nameController, validator: _validateRequired),
                _buildTextField('Father\'s Name', fatherNameController, validator: _validateRequired),
                _buildTextField('Mother\'s Name', motherNameController, validator: _validateRequired),
                _buildDateField('Date of Birth', dobController),
                _buildGenderSelection(),
                _buildMaritalStatusSelection(),
                if (maritalStatusController.text == 'Married') ...[
                  _buildChildrenStatusSelection(),
                ],
                _buildTextField('Phone Number', phoneController, validator: _validateRequired),
                _buildTextField('Emergency Phone Number', emergencyPhoneController, validator: _validateRequired),
                _buildTextField('Email', emailController, validator: _validateEmail),
                _buildTextFieldWithBedSelection('Room Number', roomNumberController, validator: _validateRequired), // Updated room number field
                _buildSectionTitle('Medical Details'),
                _buildTextField('Medical History', medicalHistoryController),
                _buildTextField('Reason for Visit', reasonForVisitController),
                _buildTextField('Symptoms', symptomsController),
                _buildTextField('Vital Signs', vitalSignsController),
                _buildTextField('Diagnostic Tests', diagnosticTestsController),
                _buildTextField('Treatment Plan', treatmentPlanController),
                _buildSectionTitle('Insurance Information'),
                _buildInsuranceStatusSelection(),
                if (insuranceStatusController.text == 'Found') ...[
                  _buildTextField('Insurance Policy Number', insurancePolicyController),
                  _buildTextField('Insurer\'s Name', insurerNameController),
                  _buildTextField('Doctor\'s Name', doctorNameController),
                ],
                _buildSectionTitle('Pills Information'),
                _buildPillsStatus(),
                if (pillsFound) ...[
                  _buildPillsList(),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _addNewPill,
                    child: Text('Add New Pill'),
                  ),
                ],
                _buildSectionTitle('Lifestyle Choices'),
                _buildLifestyleChoices(),
                _buildSectionTitle('Additional Comments'),
                _buildAdditionalCommentsField(),
                _buildAdmissionDateField(),
                _buildDischargeDateField(),
                SizedBox(height: 24.0),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildTextFieldWithBedSelection(String label, TextEditingController controller, {String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(),
            ),
            validator: validator,
          ),
          SizedBox(height: 12.0), // Add space between text field and radio buttons
          Text(
            'Select Bed:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Radio<String>(
                value: 'Bed One',
                groupValue: controller.text,
                onChanged: (value) {
                  setState(() {
                    controller.text = value!;
                  });
                },
              ),
              Text('Bed One'),
              Radio<String>(
                value: 'Bed Two',
                groupValue: controller.text,
                onChanged: (value) {
                  setState(() {
                    controller.text = value!;
                  });
                },
              ),
              Text('Bed Two'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text('Gender', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Row(
          children: [
            Radio<String>(
              value: 'Male',
              groupValue: selectedGender,
              onChanged: (value) {
                setState(() {
                  selectedGender = value;
                });
              },
            ),
            Text('Male'),
            Radio<String>(
              value: 'Female',
              groupValue: selectedGender,
              onChanged: (value) {
                setState(() {
                  selectedGender = value;
                });
              },
            ),
            Text('Female'),
          ],
        ),
      ],
    );
  }

  Widget _buildMaritalStatusSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Marital Status',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          children: [
            Radio<String>(
              value: 'Single',
              groupValue: maritalStatusController.text,
              onChanged: (value) {
                setState(() {
                  maritalStatusController.text = value!;
                });
              },
            ),
            Text('Single'),
            Radio<String>(
              value: 'Married',
              groupValue: maritalStatusController.text,
              onChanged: (value) {
                setState(() {
                  maritalStatusController.text = value!;
                  if (value == 'Married') {
                    setState(() {
                      pillsFound = true;
                    });
                  } else {
                    setState(() {
                      pillsFound = false;
                    });
                  }
                });
              },
            ),
            Text('Married'),
          ],
        ),
      ],
    );
  }

  Widget _buildChildrenStatusSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Children',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          children: [
            Radio<String>(
              value: 'Yes',
              groupValue: childrenStatusController.text,
              onChanged: (value) {
                setState(() {
                  childrenStatusController.text = value!;
                });
              },
            ),
            Text('Yes'),
            Radio<String>(
              value: 'No',
              groupValue: childrenStatusController.text,
              onChanged: (value) {
                setState(() {
                  childrenStatusController.text = value!;
                });
              },
            ),
            Text('No'),
          ],
        ),
      ],
    );
  }

  Widget _buildInsuranceStatusSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Insurance Status',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          children: [
            Radio<String>(
              value: 'Found',
              groupValue: insuranceStatusController.text,
              onChanged: (value) {
                setState(() {
                  insuranceStatusController.text = value!;
                  if (value == 'Found') {
                    setState(() {
                      pillsFound = true;
                    });
                  } else {
                    setState(() {
                      pillsFound = false;
                    });
                  }
                });
              },
            ),
            Text('Found'),
            Radio<String>(
              value: 'Not Found',
              groupValue: insuranceStatusController.text,
              onChanged: (value) {
                setState(() {
                  insuranceStatusController.text = value!;
                  if (value == 'Found') {
                    setState(() {
                      pillsFound = true;
                    });
                  } else {
                    setState(() {
                      pillsFound = false;
                    });
                  }
                });
              },
            ),
            Text('Not Found'),
          ],
        ),
      ],
    );
  }

  Widget _buildPillsStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Pills',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          children: [
            Radio<bool>(
              value: true,
              groupValue: pillsFound,
              onChanged: (value) {
                setState(() {
                  pillsFound = value!;
                });
              },
            ),
            Text('Pills Found'),
            SizedBox(width: 16.0),
            Radio<bool>(
              value: false,
              groupValue: pillsFound,
              onChanged: (value) {
                setState(() {
                  pillsFound = value!;
                });
              },
            ),
            Text('Pills Not Found'),
          ],
        ),
      ],
    );
  }

  Widget _buildLifestyleChoices() {
    List<String> lifestyleChoices = [
      'Play Sports',
      'Smoking',
      'Eating Healthy Food',
      'Take Drugs',
      'Drink Alcohol',
      // Add more lifestyle choices here
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lifestyleChoices.map((choice) {
        return CheckboxListTile(
          title: Text(choice),
          value: selectedLifestyles.contains(choice),
          onChanged: (value) {
            setState(() {
              if (value != null && value) {
                selectedLifestyles.add(choice);
              } else {
                selectedLifestyles.remove(choice);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildPillsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < pillsList.length; i++) ...[
          _buildSectionTitle('Pill ${i + 1}'),
          _buildTextField('Pills Number', pillsList[i].pillsNumberController),
          _buildTextField('Pills Name', pillsList[i].pillsNameController),
          _buildDosageInfo(i),
        ],
      ],
    );
  }

  Widget _buildDosageInfo(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Dosage Information',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildTextField('Quantity', pillsList[index].quantityController),
        _buildFrequencySelection(index),
        _buildFoodTimingSelection(index),
        _buildTextField('Duration Taken', pillsList[index].durationController),
      ],
    );
  }

  Widget _buildFrequencySelection(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Frequency',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          children: [
            Radio<String>(
              value: 'Daily',
              groupValue: pillsList[index].frequency,
              onChanged: (value) {
                setState(() {
                  pillsList[index].frequency = value!;
                });
              },
            ),
            Text('Daily'),
            Radio<String>(
              value: 'Weekly',
              groupValue: pillsList[index].frequency,
              onChanged: (value) {
                setState(() {
                  pillsList[index].frequency = value!;
                });
              },
            ),
            Text('Weekly'),
          ],
        ),
      ],
    );
  }

  Widget _buildFoodTimingSelection(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Timing (Before/After Food)',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          children: [
            Radio<String>(
              value: 'Before Food',
              groupValue: pillsList[index].foodTiming,
              onChanged: (value) {
                setState(() {
                  pillsList[index].foodTiming = value!;
                });
              },
            ),
            Text('Before Food'),
            Radio<String>(
              value: 'After Food',
              groupValue: pillsList[index].foodTiming,
              onChanged: (value) {
                setState(() {
                  pillsList[index].foodTiming = value!;
                });
              },
            ),
            Text('After Food'),
          ],
        ),
      ],
    );
  }

  Widget _buildAdditionalCommentsField() {
    return _buildTextField('Additional Comments', additionalCommentsController);
  }

  Widget _buildAdmissionDateField() {
    return _buildDateField('Admission Date', admissionDateController);
  }

  Widget _buildDischargeDateField() {
    return _buildDateField('Discharge Date', dischargeDateController);
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                setState(() {
                  controller.text = formattedDate;
                });
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _submitForm,
      child: Text('Save'),
    );
  }

  String? _validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Invalid email address';
    }
    return null;
  }

  void _addNewPill() {
    setState(() {
      pillsList.add(PillInfo());
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Form is valid, send data to API
      Map<String, dynamic> formData = {
        'name': nameController.text,
        'fatherName': fatherNameController.text,
        'motherName': motherNameController.text,
        'dob': dobController.text,
        'gender': selectedGender,
        'maritalStatus': maritalStatusController.text,
        'childrenStatus': childrenStatusController.text,
        'phone': phoneController.text,
        'emergencyPhone': emergencyPhoneController.text,
        'email': emailController.text,
        'medicalHistory': medicalHistoryController.text,
        'reasonForVisit': reasonForVisitController.text,
        'symptoms': symptomsController.text,
        'vitalSigns': vitalSignsController.text,
        'diagnosticTests': diagnosticTestsController.text,
        'treatmentPlan': treatmentPlanController.text,
        'insuranceStatus': insuranceStatusController.text,
        'insurancePolicy': insurancePolicyController.text,
        'admissionDate': admissionDateController.text,
        'dischargeDate': dischargeDateController.text,
        'insurerName': insurerNameController.text,
        'doctorName': doctorNameController.text,
        'additionalComments': additionalCommentsController.text,
        'roomNumber': roomNumberController.text,
        // Include other fields here
      };

      // Convert data to JSON
      String jsonData = jsonEncode(formData);

      try {
        // Send POST request
        http.Response response = await http.post(Uri.parse(apiUrl),
            headers: {'Content-Type': 'application/json'}, body: jsonData);

        if (response.statusCode == 201) {
          // Successful response from the server
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Patient record saved successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          // Error in response
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to save patient record'),
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

class PillInfo {
  TextEditingController pillsNumberController = TextEditingController();
  TextEditingController pillsNameController = TextEditingController();
  String frequency = 'Daily';
  String foodTiming = 'Before Food';
  TextEditingController quantityController = TextEditingController();
  TextEditingController durationController = TextEditingController();
}
