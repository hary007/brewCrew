import 'package:brew_crew/models/my_user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({Key? key}) : super(key: key);

  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formkey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  String _currentName = "";
  String _currentSugars = "";
  int _currentStrength = 100;

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<MyUser?>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: _user!.uid).individualSnaps,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData? data_of_user = snapshot.data;
            return Container(
              padding: EdgeInsets.all(8),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    Text(
                      "Update Your Settings",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      initialValue: _currentName == ""
                          ? data_of_user!.name
                          : _currentName,
                      decoration: textInputDecoration.copyWith(
                        hintText: "Name",
                      ),
                      validator: (val) {
                        return val!.isEmpty ? "Please enter a name" : null;
                      },
                      onChanged: (val) {
                        setState(() {
                          _currentName = val;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //dropdown
                    DropdownButtonFormField(
                      value: _currentSugars == ""
                          ? data_of_user!.sugars
                          : _currentSugars,
                      decoration: textInputDecoration,
                      items: sugars.map((sugar) {
                        return DropdownMenuItem(
                          value: sugar,
                          child: Text("$sugar sugars"),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _currentSugars = val as String;
                        });
                      },
                    ),
                    //slider
                    Slider(
                      value: (_currentStrength).toDouble(),
                      onChanged: (val) {
                        setState(() {
                          _currentStrength = val.round();
                        });
                      },
                      min: 100,
                      max: 900,
                      divisions: 8,
                      activeColor: Colors.brown[_currentStrength],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.pink,
                        ),
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            DatabaseService(uid: _user.uid).updateUserData(
                                _currentSugars == ""
                                    ? data_of_user!.sugars
                                    : _currentSugars,
                                _currentName == ""
                                    ? data_of_user!.name
                                    : _currentName,
                                _currentStrength);
                            Navigator.pop(context);
                          }
                          // print(_currentName);
                          // print(_currentSugars);
                          // print(_currentStrength);
                        },
                        child: Text(
                          "Update",
                          style: TextStyle(color: Colors.white),
                        ))
                  ],
                ),
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
