import 'package:flutter/material.dart';
import 'package:halyk_health/screens/patient/patient_diseases/patient_diseases.dart';
import 'package:halyk_health/screens/patient/patient_diseases/patient_diseases_helplines.dart';

class PatientDiseasesPage extends StatefulWidget {
  const PatientDiseasesPage({Key? key}) : super(key: key);

  static const routeName = '/patient-diseases-page';

  @override
  State<PatientDiseasesPage> createState() => _PatientDiseasesPageState();
}

class _PatientDiseasesPageState extends State<PatientDiseasesPage> {
  var pageNumber = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: pageNumber,
          onTap: (index) => setState(() => pageNumber = index),
          items: [
            BottomNavigationBarItem(
              icon: Container(),
              label: 'Diseases',
            ),
            BottomNavigationBarItem(icon: Container(), label: 'Helplines'),
          ]),
      body: getPage(pageNumber),
    );
  }

  Widget getPage(int index) {
    if (index == 0) {
      return const PatientDiseases();
    }
    return const PatientDiseasesHelplines();
  }
}
