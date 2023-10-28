import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:halyk_health/screens/doctor/doctor_home_page.dart';
import 'package:halyk_health/screens/otp_verification.dart';
import 'package:halyk_health/screens/patient/patient_home_page.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class RegistrationPage extends StatefulWidget {
  RegistrationPage({Key? key}) : super(key: key);

  static const routeName = '/registration';

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  var _showPassword = false;

  var firstNameController = TextEditingController();
  var secondNameController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var clinicNameController = TextEditingController();
  var iinController = TextEditingController();

  
  // Change +92 to +7
  @override
  void dispose() {
    firstNameController.dispose();
    secondNameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    clinicNameController.dispose();
    iinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _role = ModalRoute
        .of(context)
        ?.settings
        .arguments as String;
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
                        .height * 0.2,
                  ),
                  const Text(
                    'Register',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.42,
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
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.42,
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
                            decoration:
                            const InputDecoration(label: Text('Second Name')),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
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
                          keyboardType: TextInputType.number,
                          controller: phoneController,
                          validator: (val) {
                            if (val == null ||
                                val.length != 10 || int.tryParse(val) == null) {
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
                  _role == 'doctor'
                      ? TextFormField(
                    controller: clinicNameController,
                    decoration: const InputDecoration(
                      label: Text("Name of the clinic"),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Enter a valid name';
                      }
                      return null;
                    },
                  )
                      : TextFormField(
                    controller: iinController,
                    decoration:
                    InputDecoration(label: Text("IIN Number")),
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val == null ||
                          val.isEmpty ||
                          val.length != 12) {
                        return 'Enter your 12 digit IIN Number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
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
                    controller: passwordController,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              var data={
                                'firstName': firstNameController.text,
                                'secondName': secondNameController.text,
                                'phoneNumber': '+7${phoneController.text}',
                                'password':passwordController.text,
                                'role': _role,
                                'clinicName':_role == 'doctor' ? clinicNameController.text : null,
                                'iinNumber':_role == 'patient' ? iinController.text : null,
                              };
                              var auth=FirebaseAuth.instance;
                              await auth.verifyPhoneNumber(
                                phoneNumber: '+7${phoneController.text}',
                                verificationCompleted: (PhoneAuthCredential credential) async {
                                  try {
                                    await Provider.of<Auth>(
                                        context, listen: false).register(
                                        data, credential);
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                        _role == 'doctor'
                                            ? DoctorHomePage.routeName
                                            : PatientHomePage.routeName, (
                                        _) => false);
                                    var db = FirebaseFirestore.instance;
                                    db.collection('users').doc(
                                        '+7${phoneController.text}').set(data);
                                  } catch(e){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                                  }
                                },
                                verificationFailed: (FirebaseAuthException e) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? e.code)));
                                },
                                codeSent: (String verificationId, int? resendToken) async {
                                  try {
                                    if(await Provider.of<Auth>(context,listen:false).checkIfUserExists('+7${phoneController.text}')) {
                                      Navigator.pushNamed(
                                          context,
                                          OtpVerificationPage.routeName,
                                          arguments: {
                                            'role': _role,
                                            'mode': 'Register',
                                            'verificationId': verificationId,
                                            'data': data
                                          });
                                    } else {
                                      throw Exception('User already exists');
                                    }
                                  } catch(e){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                                  }
                                },
                                codeAutoRetrievalTimeout: (String verificationId) {},
                              );
                            }
                          },
                          child: const Text("Register"))),
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
