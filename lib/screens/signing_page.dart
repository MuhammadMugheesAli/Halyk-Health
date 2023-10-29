import 'package:flutter/material.dart';
import 'package:halyk_health/screens/login.dart';
import 'package:halyk_health/screens/registration.dart';

class SigningPage extends StatefulWidget {
  const SigningPage({Key? key}) : super(key: key);

  @override
  State<SigningPage> createState() => _SigningPageState();

  static const routeName = '/signing-page';
}

class _SigningPageState extends State<SigningPage> {
  String? role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              const Text(
                'Welcome',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              SizedBox(
                width: double.maxFinite,
                child: DropdownButton(
                    value: role,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        value: 'doctor',
                        child: Text('Doctor'),
                      ),
                      DropdownMenuItem(
                        value: 'patient',
                        child: Text('Patient'),
                      ),
                    ],
                    onChanged: (val) => setState(() => role = val)),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                      onPressed: role != null
                          ? () {
                              Navigator.pushNamed(context, LoginPage.routeName,
                                  arguments: role);
                            }
                          : null,
                      child: const Text('Login'))),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                      onPressed: role != null
                          ? () {
                              Navigator.pushNamed(
                                  context, RegistrationPage.routeName,
                                  arguments: role);
                            }
                          : null,
                      child: const Text('Register'))),
            ],
          ),
        ),
      ),
    );
  }
}
