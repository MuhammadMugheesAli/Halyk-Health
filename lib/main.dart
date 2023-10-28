import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:halyk_health/firebase_options.dart';
import 'package:halyk_health/providers/auth.dart';
import 'package:halyk_health/providers/doctor.dart';
import 'package:halyk_health/providers/patient.dart';
import 'package:halyk_health/screens/doctor/doctor_home_page.dart';
import 'package:halyk_health/screens/doctor/doctor_medical_record/doctor_add_record.dart';
import 'package:halyk_health/screens/login.dart';
import 'package:halyk_health/screens/otp_verification.dart';
import 'package:halyk_health/screens/patient/patient_appointment/patient_add_appointment.dart';
import 'package:halyk_health/screens/patient/patient_appointment/patient_add_appointment.dart';
import 'package:halyk_health/screens/patient/patient_appointment/patient_appointment_page.dart';
import 'package:halyk_health/screens/patient/patient_clinic_page.dart';
import 'package:halyk_health/screens/patient/patient_clinic_page.dart';
import 'package:halyk_health/screens/patient/patient_diseases/patient_diseases_page.dart';
import 'package:halyk_health/screens/patient/patient_education_page.dart';
import 'package:halyk_health/screens/patient/patient_medical_card/patient_add_medical_card.dart';
import 'package:halyk_health/screens/patient/patient_medical_card/patient_medical_page.dart';
import 'package:halyk_health/screens/patient/patient_sympytoms_page.dart';
import 'package:halyk_health/screens/registration.dart';
import 'package:halyk_health/screens/signing_page.dart';
import 'package:provider/provider.dart';

import 'screens/patient/patient_home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider(create: (_) => Auth(),),
        ListenableProvider(create: (_) => Patient(),),
        ListenableProvider(create: (_) => Doctor(),),
      ],
      builder: (context,child) {
        return MaterialApp(
        title: 'Halyk Health',
        theme: ThemeData(
          useMaterial3: true,
        ),
        routes: {
          LoginPage.routeName: (context) => const LoginPage(),
          RegistrationPage.routeName: (context) => RegistrationPage(),
          DoctorHomePage.routeName: (context) => const DoctorHomePage(),
          SigningPage.routeName: (context) => const SigningPage(),
          PatientHomePage.routeName: (context) => const PatientHomePage(),
          OtpVerificationPage.routeName: (context) => const OtpVerificationPage(),
          PatientClinicPage.routeName: (context) => const PatientClinicPage(),
          PatientAddAppointment.routeName: (context) => const PatientAddAppointment(),
          DoctorAddRecord.routeName: (context) => DoctorAddRecord(),
          PatientAddMedicalCard.routeName: (context) => PatientAddMedicalCard(),
          // PatientSymptomsPage.routeName: (context) => const PatientSymptomsPage(),
          // PatientDiseasesPage.routeName: (context) => const PatientDiseasesPage(),
          // PatientMedicalPage.routeName: (context) => const PatientMedicalPage(),
          // PatientAppointmentPage.routeName: (context) => const PatientAppointmentPage(),
          // PatientEducationPage.routeName: (context) => const PatientEducationPage(),
        },
        home: Provider.of<Auth>(context).loggedIn ?  getHomePage(context) : const SigningPage(),
      );
      },
    );
  }

  Widget getHomePage(BuildContext context){
    if(Provider.of<Auth>(context).currentUser!.role == 'doctor'){
      return const DoctorHomePage();
    } else {
      return const PatientHomePage();
    }
  }
}
