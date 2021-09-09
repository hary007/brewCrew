import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/loading.dart';

import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';

class SignIn extends StatefulWidget {
  final Function? toggleView;
  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthService _helper = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;

  // text field states

  String email = "";
  String password = "";
  String error_message = "";

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              title: Text(
                "Sign in to Brew Crew",
                style: TextStyle(fontSize: 18),
              ),
              centerTitle: false,
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              actions: [
                TextButton.icon(
                  onPressed: () => widget.toggleView!(),
                  icon: Icon(Icons.person),
                  label: Text(
                    "Register",
                    style: TextStyle(fontSize: 12),
                  ),
                )
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 50),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: "Email"),
                      validator: (val) {
                        return val!.isEmpty
                            ? "Please enter a valid email"
                            : null;
                      },
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: "Password"),
                      validator: (val) {
                        return val!.length < 6
                            ? "Please enter a stronger password"
                            : null;
                      },
                      obscureText: true,
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.pink[400],
                        elevation: 10,
                      ),
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });
                          dynamic result = _helper.signInWithEmailAndPassword(
                              email, password);
                          if (result == null) {
                            setState(() {
                              loading = false;
                              error_message = "The credentials do not match";
                            });
                          }
                        }
                      },
                      child: Text(
                        "Sign in",
                        style: TextStyle(),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      error_message,
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              ),
            ));
  }
}
