import 'package:flutter/material.dart';
import 'package:halyk_health/providers/patient.dart';
import 'package:provider/provider.dart';

class PatientAddMedicalCard extends StatelessWidget {
  PatientAddMedicalCard({Key? key}) : super(key: key);

  static const routeName = '/patient-add-medical-card';
  final _formKey = GlobalKey<FormState>();

  var firstNameController = TextEditingController();
  var secondNameController = TextEditingController();
  var iinController = TextEditingController();
  var pastConditionController = TextEditingController();
  var surgicalProcedureController = TextEditingController();
  var allergiesController = TextEditingController();
  var familyHistoryController = TextEditingController();
  var medicationController = TextEditingController();
  var dosageController = TextEditingController();
  var prescribingPhysicianController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                    ),
                    const Text(
                      'Medical Card',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.42,
                            child: TextFormField(
                              controller: firstNameController,
                              keyboardType: TextInputType.name,
                              textCapitalization: TextCapitalization.words,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Enter a valid name';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                label: Text('First Name'),
                              ),
                            )),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.42,
                            child: TextFormField(
                              controller: secondNameController,
                              keyboardType: TextInputType.name,
                              textCapitalization: TextCapitalization.words,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Enter a valid name';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  label: Text('Second Name')),
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      controller: iinController,
                      decoration:
                          const InputDecoration(label: Text("IIN Number")),
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        if (val == null || val.isEmpty || val.length != 12) {
                          return 'Enter your 12 digit IIN Number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      controller: pastConditionController,
                      decoration: const InputDecoration(
                        label: Text("Past Condition"),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      controller: surgicalProcedureController,
                      decoration: const InputDecoration(
                        label: Text("Surgical Procedure"),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      controller: allergiesController,
                      decoration: const InputDecoration(
                        label: Text("Allergies"),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      controller: familyHistoryController,
                      decoration: const InputDecoration(
                        label: Text("Family History"),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      controller: medicationController,
                      decoration: const InputDecoration(
                        label: Text("Medication"),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      controller: prescribingPhysicianController,
                      decoration: const InputDecoration(
                        label: Text("Prescribing Physician"),
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                        width: double.maxFinite,
                        child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await Provider.of<Patient>(context,
                                        listen: false)
                                    .setMedicalRecord(
                                        context,
                                        firstNameController.text,
                                        secondNameController.text,
                                        iinController.text,
                                        pastConditionController.text,
                                        surgicalProcedureController.text,
                                        allergiesController.text,
                                        familyHistoryController.text,
                                        medicationController.text,
                                        dosageController.text,
                                        prescribingPhysicianController.text);
                                var patient = Provider.of<Patient>(context,
                                    listen: false);
                                patient.fetchMedicalCard(context);
                                Navigator.pop(context);
                              }
                            },
                            child: const Text("Add"))),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
