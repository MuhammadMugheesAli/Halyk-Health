import 'package:flutter/material.dart';
import 'package:halyk_health/providers/patient.dart';
import 'package:halyk_health/screens/patient/patient_medical_card/patient_add_medical_card.dart';
import 'package:provider/provider.dart';

class PatientMedicalPage extends StatefulWidget {
  const PatientMedicalPage({Key? key}) : super(key: key);

  static const routeName = '/patient-medical-page';

  @override
  State<PatientMedicalPage> createState() => _PatientMedicalPageState();
}

class _PatientMedicalPageState extends State<PatientMedicalPage> {
  var isLoading = true;

  @override
  Widget build(BuildContext context) {
    var patient = Provider.of<Patient>(context);
    patient
        .fetchMedicalCard(context)
        .whenComplete(() => setState(() => isLoading = false));
    var data = patient.card;
    return isLoading
        ? CircularProgressIndicator()
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: data == null
                ? Align(
                    alignment: Alignment.topCenter,
                    child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(
                            context, PatientAddMedicalCard.routeName),
                        child: const Text("Add Medical Record")))
                : Column(
                    children: [
                      SizedBox(
                        width: double.maxFinite,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                      '${data['firstName']} ${data['secondName']}',
                                      style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text('IIN Number: ${data['iinNumber']}'),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                    'Past Condition: ${data['pastCondition']}'),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                    'Surgical Procedure: ${data['surgicalProcedure']}'),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text('Allergies: ${data['allergies']}'),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                    'Family History: ${data['familyHistory']}'),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text('Medication: ${data['medication']}'),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text('Dosage: ${data['dosage']}'),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                    'Prescribing Physician: ${data['iinNumber']}'),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          );
  }
}
