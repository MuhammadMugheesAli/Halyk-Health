import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:halyk_health/providers/patient.dart';
import 'package:provider/provider.dart';

import '../../models/clinic.dart';

class PatientClinicPage extends StatefulWidget {
  const PatientClinicPage({Key? key}) : super(key: key);

  static const routeName = '/patient-clinic-page';

  @override
  State<PatientClinicPage> createState() => _PatientClinicPageState();
}

class _PatientClinicPageState extends State<PatientClinicPage> {
  var filter = 'all';

  @override
  Widget build(BuildContext context) {
    var patient = Provider.of<Patient>(context);
    patient.fetchClinicsList();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              'Filters:',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              width: 10,
            ),
            DropdownButton(
              items: const [
                DropdownMenuItem(
                  value: 'all',
                  child: Text("All"),
                ),
                DropdownMenuItem(
                  value: 'paid',
                  child: Text("Paid"),
                ),
                DropdownMenuItem(
                  value: 'free',
                  child: Text("Free"),
                ),
              ],
              onChanged: (val) => setState(() => filter = val!),
              value: filter,
            ),
          ],
        ),
        Expanded(
          child: StreamBuilder(
              stream: filter == 'paid'
                  ? patient.paidClinics
                  : filter == 'free'
                      ? patient.freeClinics
                      : patient.clinics,
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                return ListView.builder(
                    itemBuilder: (ctx, index) {
                      var data = Clinic.fromMap(streamSnapshot.data!.docs[index]
                          .data() as Map<String, dynamic>);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    data.name,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text('Address : ${data.address}'),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(data.paid ? "Paid" : "Free"),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text('Contact Numbers:'),
                                SizedBox(
                                  height: (data.numbers.length * 35).toDouble(),
                                  child: ListView(
                                    children: data.numbers
                                        .map((e) => Text(e))
                                        .toList(),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Working Hours: ${data.workingHours}'),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: streamSnapshot.data?.docs.length);
              }),
        ),
      ],
    );
  }
}
