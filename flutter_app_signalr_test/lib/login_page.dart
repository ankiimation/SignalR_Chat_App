import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_signalr_test/models/firebase_login_model.dart';
import 'package:http/http.dart' as http;

import 'list_users.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var usernameController = TextEditingController(text: "khoa1@gmail.com");
  var password = TextEditingController();

  Future<FirebaseLoginModel> login() async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCqxEKgBq_m0t7-BigpXrd4acZSRLbVijo";
    var result = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": usernameController.text,
          "password": "mysecretpassword",
          "returnSecureToken": "true"
        }));
    if (result.statusCode == 200) {
      return FirebaseLoginModel.fromJson(jsonDecode(result.body.toString()));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                    labelText: 'Username',
                    filled: true,
                    fillColor: Colors.black12,
                    border: InputBorder.none),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: password,
                decoration: InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    fillColor: Colors.black12,
                    border: InputBorder.none),
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                onPressed: () async {
                  var user = await login();
                  if (user != null) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => ListUsersPage(user)));
                  } else {
                    showDialog(
                        context: context,
                        child: SimpleDialog(
                          title: Text('Fail'),
                          contentPadding: EdgeInsets.all(20),
                        ));
                  }
                },
                child: Text('Login'),
              )
            ],
          ),
        ));
  }
}
