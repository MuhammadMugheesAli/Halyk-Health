import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/user.dart';
import '../../../providers/auth.dart';
import '../../../providers/patient.dart';

class PatientAddAppointment extends StatefulWidget {
  const PatientAddAppointment({Key? key}) : super(key: key);

  static const routeName = '/patient-add-appointment';

  @override
  State<PatientAddAppointment> createState() => _PatientAddAppointmentState();
}

class _PatientAddAppointmentState extends State<PatientAddAppointment> {
  final _formKey = GlobalKey<FormState>();

  var firstNameController = TextEditingController();

  var secondNameController = TextEditingController();

  var addressController = TextEditingController();

  var iinController = TextEditingController();
  DateTime? selectedDate;
  User? selectedDoctor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                  ),
                  const Text(
                    'Appointment',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
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
                    height: 30,
                  ),
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      label: Text("Address"),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Enter a valid address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 30,
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
                  DropdownButton(
                    hint: const Text('Select a doctor'),
                    items: Provider.of<Patient>(context, listen: false)
                        .allDoctors
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text("${e.firstName} ${e.secondName}"),
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedDoctor = val;
                      });
                    },
                    value: selectedDoctor,
                    isExpanded: true,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  OutlinedButton(
                      onPressed: () async {
                        var datePicker = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            currentDate: selectedDate,
                            initialDate: DateTime.now(),
                            lastDate: DateTime(2100));
                        setState(() {
                          selectedDate = datePicker;
                        });
                      },
                      child: Text(selectedDate != null
                          ? DateFormat('dd-MM-yyyy')
                              .format(selectedDate!)
                              .toString()
                          : 'Select a date')),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                          onPressed: () async {
                            var currentUser =
                                Provider.of<Auth>(context, listen: false)
                                    .currentUser;
                            if (_formKey.currentState!.validate()) {
                              if (selectedDoctor != null &&
                                  selectedDate != null) {
                                var data = {
                                  'firstName': firstNameController.text,
                                  'secondName': secondNameController.text,
                                  'address': addressController.text,
                                  'iinNumber': iinController.text,
                                  'doctorNumber': selectedDoctor?.phoneNumber,
                                  'doctorName':
                                      "${selectedDoctor!.firstName} ${selectedDoctor?.secondName}",
                                  'date': selectedDate,
                                  'patientNumber': currentUser?.phoneNumber,
                                  'patientName':
                                      "${currentUser!.firstName} ${currentUser.secondName}",
                                };
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(currentUser.phoneNumber)
                                    .collection('appointments')
                                    .add(data)
                                    .then((value) => FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(selectedDoctor?.phoneNumber)
                                        .collection('appointments')
                                        .doc(value.id)
                                        .set(data));
                                Navigator.of(context).pop();
                              } else if (selectedDoctor == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Select a doctor from the dropdown')));
                              } else if (selectedDate == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Select a date')));
                              }
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
