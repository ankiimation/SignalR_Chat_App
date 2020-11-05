import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_app_signalr_chat/bloc/chat_user_bloc/model.dart';
import 'package:flutter_app_signalr_chat/constants/constant_variables.dart';
import 'package:flutter_app_signalr_chat/models/firebase_user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatUsersService {
  static String currentToken;

  static Future<ChatUserModel> updateInfo(
    ChatUserModel user,
  ) async {
    var response = await http
        .post(CHAT_USER_API, body: jsonEncode(user.toJson()), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $currentToken',
    });
    print(response);
    if (response.statusCode == 200) {
      return user;
    } else if (response.statusCode == 401) {
      await _loginAgain();
      return updateInfo(user);
    } else {
      return null;
    }
  }

  static Future<ChatUserModel> updateConnectionId(
    ChatUserModel user,
  ) async {
    var response = await http.post(CHAT_USER_API + "/connectionid",
        body: jsonEncode(user.toJson()),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $currentToken',
        });
    print(response);
    if (response.statusCode == 200) {
      return user;
    } else if (response.statusCode == 401) {
      await _loginAgain();
      return updateConnectionId(user);
    } else {
      return null;
    }
  }

  static Future<ChatUserModel> getChatUserViaConnectionId(
    String connectionId,
  ) async {
    var response = await http.get(CHAT_USER_API + "/$connectionId", headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $currentToken',
    });
    if (response.statusCode == 200) {
      return ChatUserModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      await _loginAgain();
      return getChatUserViaConnectionId(connectionId);
    } else {
      return null;
    }
  }

  static Future<FirebaseUser> _loginAgain() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var email = sharedPreferences.getString('username');
    var password = sharedPreferences.getString('password');
    if (email != null && password != null) {
      final url =
          "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCqxEKgBq_m0t7-BigpXrd4acZSRLbVijo";
      var result = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "email": email,
            "password": password,
            "returnSecureToken": "true"
          }));
      if (result.statusCode == 200) {
        var rs = FirebaseUser.fromJson(jsonDecode(result.body.toString()));
        currentToken = rs.idToken;
        return rs;
      }
    }
    return null;
  }
}
