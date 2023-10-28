import 'package:flutter/material.dart';
import 'package:halyk_health/providers/doctor.dart';
import 'package:provider/provider.dart';

class DoctorAddRecord extends StatelessWidget {
  DoctorAddRecord({Key? key}) : super(key: key);

  static const routeName = '/doctor-add-record';

  final _formKey = GlobalKey<FormState>();

  var medicationController = TextEditingController();

  var dosageController = TextEditingController();

  var commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
            BoxConstraints(maxHeight: MediaQuery
                .of(context)
                .size
                .height),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.15,
                  ),
                  const Text(
                    'Medication',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.05,
                  ),
                  TextFormField(
                    controller: medicationController,
                    textCapitalization: TextCapitalization.words,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Enter a valid name';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      label: Text('Medication'),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: dosageController,
                    decoration: const InputDecoration(
                      label: Text("Dosage"),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Enter a valid amount';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: commentController,
                    decoration:
                    const InputDecoration(label: Text("Comment of the doctor")),
                    keyboardType: TextInputType.text,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Enter a comment';
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
                              Provider.of<Doctor>(context, listen: false)
                                  .setMedicalRecord(
                                  context, medicationController.text,
                                  dosageController.text, commentController.text);
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text("Make"))),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
