import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'SearchProvider.dart'; // Import your SearchProvider class
import 'nurse_profile.dart'; // Import the ProfilePage widget file
import 'home_nurse.dart'; // Import the NurseHomePage widget file
import 'package:flutter/material.dart';
import 'patient_data.dart';
import 'nurse_register.dart';
import 'hr_register.dart';
import 'login.dart';
import 'SearchProvider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SearchProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedicalAlert',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
        fontFamily: 'Roboto',
      ),
      home: MedicalAlertPage(),
    );
  }
}

class MedicalAlertPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.local_hospital_outlined,
                color: Colors.blue,
              ),
              SizedBox(width: 8),
              Text(
                'MedicalAlert',
                style: TextStyle(color: Colors.black, fontSize: 24),
              ),
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Image.asset(
                    'assets/clip-doctor-and-patient 1.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const Center(
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Stay informed with instant nurse notification for timely patients',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 0.0),
              const Center(
                child: Text(
                  'care',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 100.0),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to NurseHomePage with specific nurse details
                      Navigator.push(
                        context,
                        MaterialPageRoute(

                          builder:
                              (context) =>    NurseLoginPage()),
                          //  (context) =>  NurseHomePage(fullName: 'abeer', nurseId: "NS322374"),
                          //  (context) => RegisterPage()),
                          //  (context) => PatientInfoPage ()),
                          //  (context) => NurseRegistrationPage ()),
                          //  (context) => HRRegistrationPage()),
                          //  (context) =>   ProfilePage(nurseId:'NS322374')),
                          //  (context) =>   NurseHomePageState()),


                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 100.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
            ]),
          ),
        ],
      ),
    );
  }
}
