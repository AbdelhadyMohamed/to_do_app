import 'package:flutter/material.dart';
import 'package:to_do_app/screens/login/login.dart';

import '../../shared/network/firebase/firebase_manager.dart';

class SignUp extends StatelessWidget {
  static const routName = "Signup";
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(18),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                final bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value);
                if (!emailValid) {
                  return "please enter valid email";
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Confirm Email'),
              validator: (value) {
                if (value != emailController.text) {
                  return 'email does not match';
                }
              },
            ),
            TextFormField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
              },
            ),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              validator: (value) {
                if (value != passwordController.text) {
                  return 'password does not match';
                }
              },
            ),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
              },
            ),
            TextFormField(
              controller: ageController,
              decoration: const InputDecoration(labelText: 'age'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your age';
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  FirebaseManager.createAccount(
                      nameController.text,
                      int.parse(ageController.text),
                      emailController.text,
                      passwordController.text, () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginScreen.routeName, (route) => false);
                    // Navigator.pushAndRemoveUntil(context, LoginScreen.routeName,(route) => false);
                  }, (errorMessage) {
                    return showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("error"),
                            content: Text(
                              errorMessage.toString(),
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("okay"),
                              )
                            ],
                          );
                        });
                  });
                }
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
