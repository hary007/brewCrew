import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function? toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool loading = false;
  // text field states
  String email = "";
  String password = "";
  String error_message = "";

  final _formkey = GlobalKey<FormState>();
  AuthService _helper = AuthService();

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              title: Text(
                "New to Brew Crew? Sign up!",
                style: TextStyle(fontSize: 18),
              ),
              centerTitle: false,
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              actions: [
                TextButton.icon(
                  onPressed: () => widget.toggleView!(),
                  icon: Icon(Icons.person),
                  label: Text("Sign in"),
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
                        return val!.isEmpty ? "Please enter an email" : null;
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
                            ? "Enter a stronger password"
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
                          dynamic result = await _helper
                              .signUpWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() {
                              error_message = "Please enter a valid email";
                              loading = false;
                            });
                          }
                        }
                      },
                      child: Text(
                        "Register",
                        style: TextStyle(),
                      ),
                    ),
                    SizedBox(
                      height: 10,
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
