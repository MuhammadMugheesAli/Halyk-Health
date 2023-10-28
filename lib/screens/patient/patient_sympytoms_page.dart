import 'package:flutter/material.dart';

class PatientSymptomsPage extends StatefulWidget {
  const PatientSymptomsPage({Key? key}) : super(key: key);

  static const routeName='/patient-symptoms-page';

  @override
  State<PatientSymptomsPage> createState() => _PatientSymptomsPageState();
}

class _PatientSymptomsPageState extends State<PatientSymptomsPage> {

  String patientAreaOfPain = '';
  String selectedDoctor = 'General Practitioner';

  Map<String, String> doctorMapping = {
    'head': 'Neurologist',
    'chest': 'Cardiologist',
    'abdomen': 'Gastroenterologist',
    'leg': 'Orthopedic Surgeon',
    'eye' : 'Ophthalmologist'
  };

  void recommendDoctor() {
    setState(() {
      selectedDoctor = doctorMapping[patientAreaOfPain.toLowerCase().replaceAll(' ', '')] ?? 'General Practitioner';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Enter the area of your body that hurts:'),
            TextField(
              onChanged: (text) {
                patientAreaOfPain = text;
              },
            ),
            SizedBox(height: 10,),
            SizedBox(width: double.maxFinite,
              child: ElevatedButton(
                onPressed: recommendDoctor,
                child: Text('Recommend Doctor'),
              ),
            ),
            Text(
              'Recommended Doctor: $selectedDoctor',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
