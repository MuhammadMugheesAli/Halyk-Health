import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:halyk_health/providers/auth.dart';
import 'package:halyk_health/screens/otp_verification.dart';
import 'package:halyk_health/screens/patient/patient_home_page.dart';
import 'package:provider/provider.dart';

import 'doctor/doctor_home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const routeName = '/login-page';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  var _showPassword = false;

  var phoneNumberController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  void dispose() {
    phoneNumberController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var role=ModalRoute
        .of(context)
        ?.settings
        .arguments as String;
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
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  const Text(
                    'Login',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Phone Number",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      )),
                  Row(
                    children: [
                      const Text(
                        '+7',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: phoneNumberController,
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (val == null ||
                                val.length != 10 ||
                                int.tryParse(val) == null) {
                              return 'Enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                        label: const Text("Password"),
                        suffixIcon: IconButton(
                          icon: Icon(_showPassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () =>
                              setState(() => _showPassword = !_showPassword),
                        )),
                    validator: (val) {
                      if (val == null || val.isEmpty || val.length <= 5) {
                        return "Enter a password greater than 5 characters";
                      }
                      return null;
                    },
                    obscureText: !_showPassword,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                              //   Provider.of<Auth>(context,listen: false).checkIfUserExists('+7${phoneNumberController
                              //       .text}', passwordController.text, ModalRoute
                              //       .of(context)
                              //       ?.settings
                              //       .arguments as String);
                              // var otp =
                              //     Provider.of<Auth>(context, listen: false)
                              //         .sendOtp();
                              // print(otp);
                                await Provider.of<Auth>(context,listen: false).checkLoginCredentials('+7${phoneNumberController.text}', passwordController.text, role);
                                var auth=FirebaseAuth.instance;
                                await auth.verifyPhoneNumber(
                                  phoneNumber: '+7${phoneNumberController.text}',
                                  verificationCompleted: (PhoneAuthCredential credential) async {
                                    Provider.of<Auth>(context,listen: false).login('+7${phoneNumberController.text}', passwordController.text, role, credential);
                                    Navigator.of(context).pushNamedAndRemoveUntil(
                                        role == 'doctor'
                                            ? DoctorHomePage.routeName
                                            : PatientHomePage.routeName, (
                                        _) => false);
                                  },
                                  verificationFailed: (FirebaseAuthException e) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? e.code)));
                                  },
                                  codeSent: (String verificationId, int? resendToken) {
                                    Navigator.pushNamed(
                                        context, OtpVerificationPage.routeName,
                                        arguments: {
                                          'mode': 'Login',
                                          'role': role,
                                          'verificationId':verificationId,
                                          'data': {
                                            "phoneNumber": '+7${phoneNumberController
                                                .text}',
                                            'password': passwordController.text,
                                            'role': role,
                                          }
                                        });
                                  },
                                  codeAutoRetrievalTimeout: (String verificationId) {},
                                );
                              } catch(e){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                              }
                            }
                          },
                          child: const Text("Login"))),
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
