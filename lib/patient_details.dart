import 'package:flutter/material.dart';
import 'patient.dart';

class PatientDetailsPage extends StatelessWidget {
  final Patient patient;

  const PatientDetailsPage({Key? key, required this.patient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: Text('Name'),
              subtitle: Text(patient.name),
            ),
            ListTile(
              title: Text('Custom ID'),
              subtitle: Text(patient.customId),
            ),
            ListTile(
              title: Text('Father\'s Name'),
              subtitle: Text(patient.fatherName),
            ),
            ListTile(
              title: Text('Mother\'s Name'),
              subtitle: Text(patient.motherName),
            ),
            ListTile(
              title: Text('Date of Birth'),
              subtitle: Text(patient.dob),
            ),
            ListTile(
              title: Text('Gender'),
              subtitle: Text(patient.gender),
            ),
            ListTile(
              title: Text('Marital Status'),
              subtitle: Text(patient.maritalStatus),
            ),
            ListTile(
              title: Text('Children Status'),
              subtitle: Text(patient.childrenStatus),
            ),
            ListTile(
              title: Text('Phone'),
              subtitle: Text(patient.phone),
            ),
            ListTile(
              title: Text('Emergency Phone'),
              subtitle: Text(patient.emergencyPhone),
            ),
            ListTile(
              title: Text('Email'),
              subtitle: Text(patient.email),
            ),
            ListTile(
              title: Text('Room Number'),
              subtitle: Text(patient.roomNumber),
            ),
            ListTile(
              title: Text('Bed Type'),
              subtitle: Text(patient.bedType),
            ),
            ListTile(
              title: Text('Medical History'),
              subtitle: Text(patient.medicalHistory),
            ),
            ListTile(
              title: Text('Reason for Visit'),
              subtitle: Text(patient.reasonForVisit),
            ),
            ListTile(
              title: Text('Symptoms'),
              subtitle: Text(patient.symptoms),
            ),
            ListTile(
              title: Text('Vital Signs'),
              subtitle: Text(patient.vitalSigns),
            ),
            ListTile(
              title: Text('Diagnostic Tests'),
              subtitle: Text(patient.diagnosticTests),
            ),
            ListTile(
              title: Text('Treatment Plan'),
              subtitle: Text(patient.treatmentPlan),
            ),
            ListTile(
              title: Text('Insurance Status'),
              subtitle: Text(patient.insuranceStatus),
            ),
            ListTile(
              title: Text('Insurance Policy'),
              subtitle: Text(patient.insurancePolicy),
            ),
            ListTile(
              title: Text('Insurer Name'),
              subtitle: Text(patient.insurerName),
            ),
            ListTile(
              title: Text('Doctor Name'),
              subtitle: Text(patient.doctorName),
            ),
            ListTile(
              title: Text('Prescribed Pills'),
              subtitle: Text(patient.pills),
            ),
            ListTile(
              title: Text('Admission Date'),
              subtitle: Text(patient.admissionDate),
            ),
            ListTile(
              title: Text('Discharge Date'),
              subtitle: Text(patient.dischargeDate),
            ),
            ListTile(
              title: Text('Lifestyle Choices'),
              subtitle: Text(patient.lifestyleChoices),
            ),
            ListTile(
              title: Text('Additional Comments'),
              subtitle: Text(patient.additionalComments),
            ),
          ],
        ),
      ),
    );
  }
}
