import 'package:flutter/material.dart';
import 'package:flutter_app_signalr_chat/bloc/chat_user_bloc/bloc.dart';
import 'package:flutter_app_signalr_chat/bloc/chat_user_bloc/event.dart';
import 'package:flutter_app_signalr_chat/bloc/chat_user_bloc/model.dart';
import 'package:flutter_app_signalr_chat/bloc/chat_user_bloc/satate.dart';
import 'package:flutter_app_signalr_chat/bloc/chat_user_bloc/service.dart';
import 'package:flutter_app_signalr_chat/constants/constant_variables.dart';
import 'package:flutter_app_signalr_chat/models/firebase_user.dart';
import 'package:flutter_app_signalr_chat/pages/account_setting_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signalr_core/signalr_core.dart';

import 'chat_page.dart';

class HomePage extends StatefulWidget {
  final FirebaseUser firebaseUser;

  HomePage(this.firebaseUser);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ChatUserBloc chatUserBloc = ChatUserBloc();
  Set<String> currentFreeConnections = {};
  HubConnection connection;
  bool isStopped = false;

  initConnection() async {
    await connection?.stop();
    connection = HubConnectionBuilder()
        .withUrl(
            CHAT_HUB_URL,
            HttpConnectionOptions(
                logging: (level, message) => print(message),
                accessTokenFactory: () async {
                  return widget.firebaseUser.idToken;
                }))
        .build();

    connection.on("AddToRoom", (arguments) async {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ChatPage(connection,
                  arguments.map<String>((e) => e.toString()).toList())));
    });
    connection.onclose((exception) {
      if (this.mounted)
        setState(() {
          isStopped = true;
        });
    });
    await startConnection();
  }

  startConnection() async {
    if (connection != null) {
      await connection.start();
      await ChatUsersService.updateConnectionId(ChatUserModel(
          email: widget.firebaseUser.email,
          connectionId: connection.connectionId));
      chatUserBloc.add(GetChatUser(connection.connectionId));
      setState(() {
        isStopped = false;
      });
    }
    return;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initConnection();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    chatUserBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top + 10,
          ),
          buildChatUser(),
          isStopped
              ? Expanded(
                  child: Center(
                      child: InkWell(
                    onTap: () {
                      startConnection();
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Image.asset('assets/images/search.png'),
                        ),
                        Container(
                            margin: EdgeInsets.all(10),
                            child: Text(
                              'Chạm để tìm kiếm 1 đối thủ',
                              style: TextStyle(
                                  color: BLUE,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                  )),
                )
              : Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset('assets/images/searching.gif'),
                      ),
                      Container(
                          margin: EdgeInsets.all(10),
                          child: Text(
                            'Đang tìm cho bạn 1 đối thủ mạnh',
                            style: TextStyle(
                                color: BLUE,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget buildChatUser() {
    return Container(
      padding: EdgeInsets.all(20),
      child: BlocBuilder(
        cubit: chatUserBloc,
        builder: (context, state) {
          if (state is ChatUserLoaded) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: BLUE,
                      backgroundImage: state.model.avatar != null
                          ? NetworkImage(state.model.avatar)
                          : null,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Xin chào:',
                      style: TextStyle(color: ORANGE),
                    ),
                    Text(
                      '${state.model.nickname ?? '<Bạn đang ẩn danh>'}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          color: BLUE,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                    icon: Icon(
                      Icons.settings,
                      color: BLUE,
                    ),
                    onPressed: () async {
                      await connection?.stop();
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AccountSettingPage(state.model)));
                      chatUserBloc.add(GetChatUser(state.model.connectionId));
                    })
              ],
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
