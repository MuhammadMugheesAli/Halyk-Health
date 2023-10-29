import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:halyk_health/providers/doctor.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/appointment.dart';

class DoctorAppointmentPage extends StatelessWidget {
  const DoctorAppointmentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var doctor = Provider.of<Doctor>(context);
    doctor.fetchAppointments(context);
    return StreamBuilder(
        stream: doctor.appointments,
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          return ListView.builder(
            itemBuilder: (ctx, index) {
              var data = Appointment.fromMap(streamSnapshot.data!.docs[index]
                  .data() as Map<String, dynamic>);
              if (DateUtils.isSameDay(data.date, DateTime.now()) ||
                  data.date.isAfter(DateTime.now())) {
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
                              data.firstName + data.secondName,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                              "Date: ${DateFormat('dd-MM-yyyy').format(data.date)}"),
                          const SizedBox(
                            height: 10,
                          ),
                          Text('Address : ${data.address}'),
                          const SizedBox(
                            height: 10,
                          ),
                          Text('Patient Number: ${data.patientNumber}'),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return null;
            },
            itemCount: streamSnapshot.data?.docs.length,
          );
        });
  }
}
