import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app_signalr_test/chat_page.dart';
import 'package:flutter_app_signalr_test/host_chat_page.dart';
import 'package:flutter_app_signalr_test/models/firebase_login_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'models/chat_model.dart';

class ListUsersPage extends StatefulWidget {
  final FirebaseLoginModel loginModel;

  ListUsersPage(this.loginModel);

  @override
  _ListUsersPageState createState() => _ListUsersPageState();
}

class _ListUsersPageState extends State<ListUsersPage> {
  List<ChatUserModel> chatModels = [];
  StreamController chatUsersStreamController = BehaviorSubject();

  getUsers() async {
    final response =
        await http.get('https://ankiisignalrtest.azurewebsites.net/api/apihome', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${widget.loginModel.idToken}',
    });
    if (response.statusCode == 200) {
      var listJson = jsonDecode(response.body.toString());
      var listUsers =
          (listJson as List).map((e) => ChatUserModel.fromJson(e)).toList();
      setState(() {
        chatModels = listUsers;
      });
    } else {
      setState(() {
        chatModels = [];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsers();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    chatUsersStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Xin chao: ${widget.loginModel.email}',
          style: TextStyle(fontSize: 10),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                getUsers();
              })
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: chatModels
              .map((e) => InkWell(
                    onTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ClientChatPage(
                                    loginModel: widget.loginModel,
                                    chatUserModel: e,
                                  )));
                      getUsers();
                    },
                    child: Card(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Text(e.email),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => HostChatPage(widget.loginModel)));
        },
        child: Icon(Icons.message),
      ),
    );
  }
}
