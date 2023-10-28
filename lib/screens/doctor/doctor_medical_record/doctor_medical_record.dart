import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:halyk_health/providers/doctor.dart';
import 'package:halyk_health/screens/doctor/doctor_medical_record/doctor_add_record.dart';
import 'package:provider/provider.dart';

class DoctorMedicalRecord extends StatelessWidget {
  const DoctorMedicalRecord({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var doctor = Provider.of<Doctor>(context);
    doctor.fetchMedicalRecord(context);
    return Column(children: [
      ElevatedButton(onPressed: () => Navigator.pushNamed(context, DoctorAddRecord.routeName), child: Text("Add a new medication")),
      Expanded(child: StreamBuilder(stream: doctor.records, builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if(streamSnapshot.connectionState == ConnectionState.waiting){
          return const CircularProgressIndicator();
        }
        return ListView.builder(itemBuilder: (ctx, index) {
          var data = streamSnapshot.data!.docs[index].data() as Map;
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
                        data['medication'],
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("Dosage: ${data['dosage']}"),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('Comment : ${data['comment']}'),
                  ],
                ),
              ),
            ),
          );
        },itemCount: streamSnapshot.data?.docs.length,);
      })),
    ],);
  }
}
