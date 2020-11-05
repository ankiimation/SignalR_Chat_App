import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_signalr_chat/bloc/chat_user_bloc/service.dart';
import 'package:flutter_app_signalr_chat/constants/constant_variables.dart';
import 'package:flutter_app_signalr_chat/models/firebase_user.dart';
import 'package:flutter_app_signalr_chat/pages/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool remember = true;
  bool loading = false;
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();

  Future<FirebaseUser> login() async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCqxEKgBq_m0t7-BigpXrd4acZSRLbVijo";
    var result = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": usernameController.text,
          "password": passwordController.text,
          "returnSecureToken": "true"
        }));
    if (result.statusCode == 200) {
      return FirebaseUser.fromJson(jsonDecode(result.body.toString()));
    }
    return null;
  }

  Future<bool> signUp() async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCqxEKgBq_m0t7-BigpXrd4acZSRLbVijo";
    var result = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": usernameController.text,
          "password": passwordController.text,
          "returnSecureToken": "true"
        }));
    if (result.statusCode == 200) {
      return true;
    }
    return false;
  }

  getUsernamePassword() async {
    SharedPreferences ref = await SharedPreferences.getInstance();
    var username = ref.getString('username');
    var password = ref.getString('password');
    var getRemember = ref.getBool('remember');
    if (username != null &&
        password != null &&
        getRemember != null &&
        getRemember) {
      setState(() {
        usernameController.text = username;
        passwordController.text = password;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsernamePassword();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: BLUE,
        body: Container(
          padding: EdgeInsets.all(20),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ĐĂNG NHẬP',
                    style: TextStyle(
                        color: WHITE,
                        fontSize: 30,
                        wordSpacing: 1.2,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: MESSAGE_BACKGROUND_COLOR,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: BLUE),
                          contentPadding: EdgeInsets.all(10),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: MESSAGE_BACKGROUND_COLOR,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: 'Mật khẩu',
                          labelStyle: TextStyle(color: BLUE),
                          contentPadding: EdgeInsets.all(10),
                          border: InputBorder.none),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: remember,
                        onChanged: (value) {
                          setState(() {
                            remember = value;
                          });
                        },
                        checkColor: BLUE,
                        activeColor: WHITE,
                      ),
                      Text(
                        'Ghi nhớ',
                        style: TextStyle(color: WHITE),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  loading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : MaterialButton(
                          onPressed: () async {
                            setState(() {
                              loading = true;
                            });
                            var user = await login();
                            if (user != null) {
                              SharedPreferences ref =
                                  await SharedPreferences.getInstance();

                              ref.setString(
                                  'username', usernameController.text);
                              ref.setString(
                                  'password', passwordController.text);
                              if (remember) {
                                ref.setBool('remember', true);
                              } else {
                                ref.remove('remember');
                              }
                              ChatUsersService.currentToken = user.idToken;
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => HomePage(user)));
                            } else {
                              bool register = await signUp();
                              if (register) {
                                var user = await login();
                                if (user != null) {
                                  SharedPreferences ref =
                                      await SharedPreferences.getInstance();

                                  ref.setString(
                                      'username', usernameController.text);
                                  ref.setString(
                                      'password', passwordController.text);
                                  if (remember) {
                                    ref.setBool('remember', true);
                                  } else {
                                    ref.remove('remember');
                                  }
                                  ChatUsersService.currentToken = user.idToken;
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => HomePage(user)));
                                }
                              } else {
                                showDialog(
                                    context: context,
                                    child: SimpleDialog(
                                      children: [Text('Đăng nhập thất bại!')],
                                      contentPadding: EdgeInsets.all(20),
                                    ));
                              }
                            }
                            setState(() {
                              loading = false;
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.all(15),
                              alignment: Alignment.center,
                              child: Text(
                                'Tham gia',
                                style: TextStyle(color: BLUE, fontSize: 20),
                              )),
                          color: WHITE,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        )
                ],
              ),
            ),
          ),
        ));
  }
}
