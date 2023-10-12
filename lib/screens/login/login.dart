import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/layout/home_layout.dart';
import 'package:to_do_app/screens/signup/signup.dart';
import 'package:to_do_app/shared/network/firebase/firebase_manager.dart';

import '../../providers/my_provider.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = "Login";
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MyProvider>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("To DO App"),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Log in",
              ),
              Tab(
                text: "Sign Up",
              ),
            ],
          ),
        ),
        body: TabBarView(children: [
          Padding(
            padding: EdgeInsets.all(18),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: validateEmail,
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: validatePassword,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        FirebaseManager.login(
                            emailController.text, passwordController.text, () {
                          provider.initUser();
                          Navigator.pushNamedAndRemoveUntil(
                              context, HomeLayout.routeName, (route) => false);
                        }, (e) {
                          return showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("error"),
                                  content: Text(
                                    e,
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
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          SignUp()
        ]),
      ),
    );
  }

  String? validatePassword(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else {
      return null;
    }
  }

  String? validateEmail(value) {
    {
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
    }
  }
}
