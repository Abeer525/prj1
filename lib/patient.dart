class Patient {
  final String customId;
  final String name;
  final String fatherName;
  final String motherName;
  final String dob;
  final String gender;
  final String maritalStatus;
  final String childrenStatus;
  final String phone;
  final String emergencyPhone;
  final String email;
  final String roomNumber;
  final String bedType;
  final String medicalHistory;
  final String reasonForVisit;
  final String symptoms;
  final String vitalSigns;
  final String diagnosticTests;
  final String treatmentPlan;
  final String insuranceStatus;
  final String insurancePolicy;
  final String insurerName;
  final String doctorName;
  final String pills;
  final String admissionDate;
  final String dischargeDate;
  final String lifestyleChoices;
  final String additionalComments;

  Patient({
    required this.customId,
    required this.name,
    required this.fatherName,
    required this.motherName,
    required this.dob,
    required this.gender,
    required this.maritalStatus,
    required this.childrenStatus,
    required this.phone,
    required this.emergencyPhone,
    required this.email,
    required this.roomNumber,
    required this.bedType,
    required this.medicalHistory,
    required this.reasonForVisit,
    required this.symptoms,
    required this.vitalSigns,
    required this.diagnosticTests,
    required this.treatmentPlan,
    required this.insuranceStatus,
    required this.insurancePolicy,
    required this.insurerName,
    required this.doctorName,
    required this.pills,
    required this.admissionDate,
    required this.dischargeDate,
    required this.lifestyleChoices,
    required this.additionalComments,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      customId: json['customId'] ?? '',
      name: json['name'] ?? 'Unknown',
      fatherName: json['fatherName'] ?? '',
      motherName: json['motherName'] ?? '',
      dob: json['dob'] ?? '',
      gender: json['gender'] ?? 'Unknown',
      maritalStatus: json['maritalStatus'] ?? '',
      childrenStatus: json['childrenStatus'] ?? '',
      phone: json['phone'] ?? '',
      emergencyPhone: json['emergencyPhone'] ?? '',
      email: json['email'] ?? '',
      roomNumber: json['roomNumber'] ?? '',
      bedType: json['bedType'] ?? '',
      medicalHistory: json['medicalHistory'] ?? '',
      reasonForVisit: json['reasonForVisit'] ?? '',
      symptoms: json['symptoms'] ?? '',
      vitalSigns: json['vitalSigns'] ?? '',
      diagnosticTests: json['diagnosticTests'] ?? '',
      treatmentPlan: json['treatmentPlan'] ?? '',
      insuranceStatus: json['insuranceStatus'] ?? '',
      insurancePolicy: json['insurancePolicy'] ?? '',
      insurerName: json['insurerName'] ?? '',
      doctorName: json['doctorName'] ?? '',
      pills: json['pills'] ?? '',
      admissionDate: json['admissionDate'] ?? '',
      dischargeDate: json['dischargeDate'] ?? '',
      lifestyleChoices: json['lifestyleChoices'] ?? '',
      additionalComments: json['additionalComments'] ?? '',
    );
  }
}
