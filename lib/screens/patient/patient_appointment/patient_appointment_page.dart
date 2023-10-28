import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:halyk_health/models/appointment.dart';
import 'package:halyk_health/screens/patient/patient_appointment/patient_add_appointment.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../providers/patient.dart';

class PatientAppointmentPage extends StatelessWidget {
  const PatientAppointmentPage({Key? key}) : super(key: key);

  static const routeName='/patient-appointment-page';

  @override
  Widget build(BuildContext context) {
    var patient = Provider.of<Patient>(context);
    patient.fetchAppointments(context);
    return Column(children: [
      ElevatedButton(onPressed: () => Navigator.pushNamed(context, PatientAddAppointment.routeName), child: Text("Add a new appointment")),
      Expanded(child: StreamBuilder(stream: patient.appointments, builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if(streamSnapshot.connectionState == ConnectionState.waiting){
          return const CircularProgressIndicator();
        }
        return ListView.builder(itemBuilder: (ctx, index) {
          var data = Appointment.fromMap(streamSnapshot.data!.docs[index].data()
          as Map<String, dynamic>);
          if(DateUtils.isSameDay(data.date, DateTime.now()) || data.date.isAfter(DateTime.now())) {
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
                      Text("Date: ${DateFormat('dd-MM-yyyy').format(
                          data.date)}"),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('Address : ${data.address}'),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('Doctor: ${data.doctorName}'),
                    ],
                  ),
                ),
              ),
            );
          }
          return null;
        },itemCount: streamSnapshot.data?.docs.length,);
      })),
    ],);
  }
}
