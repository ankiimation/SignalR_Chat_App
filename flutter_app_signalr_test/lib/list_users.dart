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
  bool searching = false;

  Future<List<ChatUserModel>> getUsers() async {
    final response = await http.get(
        'https://ankiisignalrtest.azurewebsites.net/api/apihome',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${widget.loginModel.idToken}',
        });
    if (response.statusCode == 200) {
      var listJson = jsonDecode(response.body.toString());
      var listUsers =
          (listJson as List).map((e) => ChatUserModel.fromJson(e)).toList();
      chatModels = listUsers;
    } else {
      chatModels = [];
    }
    return chatModels;
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
          // IconButton(
          //     icon: Icon(Icons.refresh),
          //     onPressed: () {
          //       getUsers();
          //     }),
          // IconButton(
          //     icon: Icon(Icons.search),
          //     onPressed: () async {
          //       var users = await getUsers();
          //       if (users.length > 0) {
          //         users.shuffle();
          //         await Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (_) => ClientChatPage(
          //                       loginModel: widget.loginModel,
          //                       chatUserModel: users[0],
          //                     )));
          //       } else {
          //         await Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (_) => HostChatPage(widget.loginModel)));
          //       }
          //     })
        ],
      ),
      body: Center(
        child: searching
            ? CircularProgressIndicator()
            : MaterialButton(
                color: Colors.blue,
                shape: CircleBorder(),
                padding: EdgeInsets.all(20),
                child: Icon(
                  Icons.search,
                  size: 100,
                  color: Colors.white,
                ),
                onPressed: () async {
                  setState(() {
                    searching = true;
                  });
                  var users = await getUsers();
                  if (users.length > 0) {
                    users.shuffle();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ClientChatPage(
                                  loginModel: widget.loginModel,
                                  chatUserModel: users[0],
                                )));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => HostChatPage(widget.loginModel)));
                  }
                  setState(() {
                    searching = false;
                  });
                },
              ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     await Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //             builder: (_) => HostChatPage(widget.loginModel)));
      //   },
      //   child: Icon(Icons.message),
      // ),
    );
  }
}
