import 'package:flutter/material.dart';
import 'package:halyk_health/providers/auth.dart';
import 'package:halyk_health/screens/doctor/doctor_appointment_page.dart';
import 'package:halyk_health/screens/doctor/doctor_medical_record/doctor_medical_record.dart';
import 'package:halyk_health/screens/signing_page.dart';
import 'package:provider/provider.dart';

class DoctorHomePage extends StatefulWidget {
  const DoctorHomePage({Key? key}) : super(key: key);

  static const routeName = '/doctor-home-page';

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  Widget currentPage = const DoctorAppointmentPage();

  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<Auth>(context).currentUser;
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
          child: Column(children: [
        UserAccountsDrawerHeader(
            accountName:
                Text("${currentUser?.firstName} ${currentUser?.secondName}"),
            accountEmail: Text(currentUser?.phoneNumber ?? '')),
        ListTile(
          title: const Text("Appointments"),
          onTap: () {
            if (currentPage.runtimeType != DoctorAppointmentPage) {
              setState(() => currentPage = const DoctorAppointmentPage());
            }
            Navigator.pop(context);
          },
          selected: currentPage.runtimeType == DoctorAppointmentPage,
        ),
        ListTile(
          title: const Text("Medical Record"),
          onTap: () {
            if (currentPage.runtimeType != DoctorMedicalRecord) {
              setState(() => currentPage = const DoctorMedicalRecord());
            }
            Navigator.pop(context);
          },
          selected: currentPage.runtimeType == DoctorMedicalRecord,
        ),
        const Spacer(),
        ListTile(
          title: const Text("Logout"),
          onTap: () async {
            try {
              await Provider.of<Auth>(context, listen: false).logout();
              Navigator.pushNamedAndRemoveUntil(
                  context, SigningPage.routeName, (route) => false);
            } catch (e) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(e.toString())));
            }
          },
        ),
      ])),
      body: currentPage,
    );
  }
}
