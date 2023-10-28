import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:halyk_health/screens/patient/patient_appointment/patient_add_appointment.dart';
import 'package:halyk_health/screens/patient/patient_appointment/patient_appointment_page.dart';
import 'package:halyk_health/screens/patient/patient_appointment/patient_appointment_page.dart';
import 'package:halyk_health/screens/patient/patient_appointment/patient_appointment_page.dart';
import 'package:halyk_health/screens/patient/patient_clinic_page.dart';
import 'package:halyk_health/screens/patient/patient_diseases/patient_diseases_page.dart';
import 'package:halyk_health/screens/patient/patient_diseases/patient_diseases_page.dart';
import 'package:halyk_health/screens/patient/patient_diseases/patient_diseases_page.dart';
import 'package:halyk_health/screens/patient/patient_education_page.dart';
import 'package:halyk_health/screens/patient/patient_education_page.dart';
import 'package:halyk_health/screens/patient/patient_education_page.dart';
import 'package:halyk_health/screens/patient/patient_medical_card/patient_medical_page.dart';
import 'package:halyk_health/screens/patient/patient_medical_card/patient_medical_page.dart';
import 'package:halyk_health/screens/patient/patient_medical_card/patient_medical_page.dart';
import 'package:halyk_health/screens/patient/patient_sympytoms_page.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import '../../providers/patient.dart';
import '../signing_page.dart';

class PatientHomePage extends StatefulWidget {
  const PatientHomePage({Key? key}) : super(key: key);

  static const routeName = '/patient-home-page';

  @override
  State<PatientHomePage> createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage> {
  Widget currentPage=const PatientClinicPage();

  @override
  void initState() {
    Provider.of<Patient>(context,listen: false).fetchAllDoctors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<Auth>(context).currentUser;
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
                accountName:
                    Text("${currentUser?.firstName} ${currentUser?.secondName}"),
                accountEmail: Text(currentUser?.phoneNumber ?? '')),
            ListTile(
              title: const Text("Clinic"),
              onTap: () {
                if(currentPage.runtimeType != PatientClinicPage){
                  setState(() => currentPage=const PatientClinicPage());
                  Navigator.pop(context);
                }
              },
              selected: currentPage.runtimeType == PatientClinicPage,
            ),
            ListTile(
              title: const Text("Symptoms"),
              onTap: () {
                if(currentPage.runtimeType != PatientSymptomsPage){
                  setState(() => currentPage= const PatientSymptomsPage());
                  Navigator.pop(context);
                }
              },
              selected: currentPage.runtimeType == PatientSymptomsPage,
            ),
            ListTile(
              title: const Text("Diseases"),
              onTap: () {
                if(currentPage.runtimeType != PatientDiseasesPage){
                  setState(() => currentPage=const PatientDiseasesPage());
                  Navigator.pop(context);
                }
              },
              selected: currentPage.runtimeType == PatientDiseasesPage,
            ),
            ListTile(
              title: const Text("Medical Card"),
              onTap: () {
                if(currentPage.runtimeType != PatientMedicalPage){
                  setState(() => currentPage=const PatientMedicalPage());
                  Navigator.pop(context);
                }
              },
              selected: currentPage.runtimeType == PatientMedicalPage,
            ),
            ListTile(
              title: const Text("Appointment"),
              onTap: () {
                if(currentPage.runtimeType != PatientAppointmentPage){
                  setState(() => currentPage=const PatientAppointmentPage());
                  Navigator.pop(context);
                }
              },
              selected: currentPage.runtimeType == PatientAppointmentPage,
            ),
            ListTile(
              title: const Text("Education"),
              onTap: () {
                if(currentPage.runtimeType != PatientEducationPage){
                  setState(() => currentPage= PatientEducationPage());
                  Navigator.pop(context);
                }
              },
              selected: currentPage.runtimeType == PatientEducationPage,
            ),
            const Spacer(),
            ListTile(
              title: const Text("Logout"),
              onTap: () async {
                try {
                  await Provider.of<Auth>(context,listen:false).logout();
                  Navigator.pushNamedAndRemoveUntil(context, SigningPage.routeName, (route) => false);
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
            ),
          ],
        ),
      ),
      body: currentPage,
    );
  }
}
