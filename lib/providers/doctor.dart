import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth.dart';

class Doctor with ChangeNotifier {
  Stream<QuerySnapshot<Map<String, dynamic>>>? appointments;
  Stream<QuerySnapshot<Map<String, dynamic>>>? records;

  Future<void> fetchAppointments(BuildContext context) async {
    appointments = FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).currentUser?.phoneNumber)
        .collection('appointments')
        .snapshots();
  }

  Future<void> fetchMedicalRecord(BuildContext context) async {
    records = FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).currentUser?.phoneNumber)
        .collection('medicalRecord')
        .snapshots();
  }

  Future<void> setMedicalRecord(BuildContext context, String medication,
      String dosage, String comment) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).currentUser?.phoneNumber)
        .collection('medicalRecord')
        .add({'medication': medication, 'dosage': dosage, 'comment': comment});
  }
}
