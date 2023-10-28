import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:halyk_health/screens/patient/patient_home_page.dart';
import 'package:halyk_health/screens/signing_page.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import 'doctor/doctor_home_page.dart';

class OtpVerificationPage extends StatelessWidget {
  const OtpVerificationPage({Key? key}) : super(key: key);

  static const routeName = '/otp-verification-page';

  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)!.settings.arguments! as Map;
    var mode = arguments['mode'] as String;
    var role = arguments['role'] as String;
    var data = arguments['data'] as Map<String, dynamic>;
    var otpController = TextEditingController();
    var authProvider = Provider.of<Auth>(context, listen: false);
    var verificationId = arguments['verificationId'];
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            const Text(
              'OTP Verification',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Enter a 6 digit otp sent to the entered number',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'OTP'),
              keyboardType: TextInputType.number,
              controller: otpController,
            ),
            const SizedBox(
              height: 25,
            ),
            SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                    onPressed: () async {
                      if (mode == 'Register') {
                        try {
                          await authProvider.register(
                              data,
                              PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: otpController.text));
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              role == 'doctor'
                                  ? DoctorHomePage.routeName
                                  : PatientHomePage.routeName,
                              (_) => false);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())));
                          // showDialog<void>(
                          //   context: context,
                          //   barrierDismissible: false,
                          //   builder: (BuildContext dialogContext) {
                          //     return AlertDialog(
                          //       title: const Text(
                          //           'An Error occured, Try Again'),
                          //       content: Text(e.toString()),
                          //       actions: <Widget>[
                          //         TextButton(
                          //           child: const Text('Ok'),
                          //           onPressed: () {
                          //             Navigator.of(dialogContext)
                          //                 .pop();
                          //             Navigator.of(context)
                          //                 .pushNamedAndRemoveUntil(
                          //                 SigningPage.routeName, (
                          //                 _) => false);
                          //           },
                          //         ),
                          //       ],
                          //     );
                          //   },
                          // );
                        }
                      } else {
                        try {
                          await Provider.of<Auth>(context,listen: false).login(data['phoneNumber'], data['password'], role, PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otpController.text));
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              role == 'doctor'
                                  ? DoctorHomePage.routeName
                                  : PatientHomePage.routeName,
                              (_) => false);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())));
                          // showDialog<void>(
                          //   context: context,
                          //   barrierDismissible: false,
                          //   builder: (BuildContext dialogContext) {
                          //     return AlertDialog(
                          //       title: const Text(
                          //           'An Error occured, Try Again'),
                          //       content: Text(e.toString()),
                          //       actions: <Widget>[
                          //         TextButton(
                          //           child: const Text('Ok'),
                          //           onPressed: () {
                          //             Navigator.of(dialogContext)
                          //                 .pop();
                          //             Navigator.of(context)
                          //                 .pushNamedAndRemoveUntil(
                          //                 SigningPage.routeName, (
                          //                 _) => false);
                          //           },
                          //         ),
                          //       ],
                          //     );
                          //   },
                          // );
                        }
                      }
                    },
                    child: Text(mode))),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
