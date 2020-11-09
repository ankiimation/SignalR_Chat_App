import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_signalr_chat/bloc/chat_user_bloc/bloc.dart';
import 'package:flutter_app_signalr_chat/bloc/chat_user_bloc/event.dart';
import 'package:flutter_app_signalr_chat/bloc/chat_user_bloc/satate.dart';
import 'package:flutter_app_signalr_chat/constants/constant_variables.dart';
import 'package:flutter_app_signalr_chat/main.dart';
import 'package:flutter_app_signalr_chat/models/message_model.dart';
import 'package:flutter_app_signalr_chat/widgets/chat_bubble.dart';
import 'package:flutter_app_signalr_chat/widgets/no_glow_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signalr_core/signalr_core.dart';

class ChatPage extends StatefulWidget {
  final HubConnection connection;
  final List<String> members;

  ChatPage(this.connection, this.members);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatUserBloc chatUserBloc = ChatUserBloc();
  List<ChatMessageModel> message = [];
  final textController = TextEditingController();
  final scrollController = ScrollController();

  getPartnerChatUserInfo() {
    var partnerId = widget.members.firstWhere(
        (element) => element != widget.connection.connectionId,
        orElse: () => null);
    if (partnerId != null) chatUserBloc.add(GetChatUser(partnerId));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPartnerChatUserInfo();
    widget.connection.on('ReceiveMessage', (arguments) {
      print('MESSAGE: $arguments');
      if (arguments is List && arguments.isNotEmpty) {
        if (this.mounted)
          setState(() {
            message.add(ChatMessageModel.fromJson(jsonDecode(arguments.first)));
            scrollController.jumpTo(0.0);

            getPartnerChatUserInfo();
          });
      }
    });
    widget.connection.on('LeaveFromRoom', (arguments) {
      if (mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    });
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
      appBar: AppBar(
        backgroundColor: BLUE,
        actions: [
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () async {
                showDialog(
                    context: context,
                    child: Dialog(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: WHITE,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FlatButton(
                                onPressed: () {
                                  widget.connection.invoke('RemoveFromRoom',
                                      args: [widget.connection.connectionId]);
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.refresh,
                                      color: BLUE,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Text(
                                      'Thoát và tìm người mới',
                                      style:
                                          TextStyle(color: BLUE, fontSize: 20),
                                    )),
                                  ],
                                )),
                            FlatButton(
                                onPressed: () {
                                  widget.connection.invoke('RemoveFromRoom',
                                      args: [widget.connection.connectionId]);
                                  widget.connection.stop();
                                  Navigator.popUntil(
                                      context, (route) => route.isFirst);
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      color: BLUE,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Text(
                                      'Thoát',
                                      style:
                                          TextStyle(color: BLUE, fontSize: 20),
                                    )),
                                  ],
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Đóng',
                                  style: TextStyle(
                                      color: BLUE,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ))
                          ],
                        ),
                      ),
                    ));
              })
        ],
        automaticallyImplyLeading: false,
        title: Container(
          child: BlocBuilder(
            cubit: chatUserBloc,
            builder: (context, state) {
              if (state is ChatUserLoaded) {
                return Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: WHITE,
                      backgroundImage: state.model.avatar != null
                          ? NetworkImage(state.model.avatar)
                          : null,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Text('${state.model.nickname ?? '<Ẩn danh>'}')),
                  ],
                );
              } else {
                return Text('<Ẩn danh>');
              }
            },
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 70),
            child: NoGlowList(
              child: ListView(
                  controller: scrollController,
                  reverse: true,
                  children: [
                    ...message
                        .map((e) => Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: ChatBubble(
                                e,
                                fromMe:
                                    e.from == widget.connection.connectionId,
                              ),
                            ))
                        .toList()
                        .reversed
                        .toList(),
                  ]),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(color: WHITE, boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 5)
                ]),
                height: 70,
                alignment: Alignment.center,
                child: buildInput()),
          )
        ],
      ),
    );
  }

  Widget buildInput() {
    return Row(
      children: [
        Expanded(
            child: Container(
          decoration: BoxDecoration(
              color: MESSAGE_BACKGROUND_COLOR,
              borderRadius: BorderRadius.circular(5)),
          child: TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            controller: textController,
            decoration: InputDecoration(
                border: InputBorder.none, contentPadding: EdgeInsets.all(10)),
          ),
        )),
        InkWell(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              alignment: Alignment.center,
              child: Icon(
                Icons.send,
                color: BLUE,
              ),
            ),
            onTap: () {
              if (widget.connection.state == HubConnectionState.connected &&
                  textController.text.isNotEmpty) {
                widget.connection
                    .invoke('SendMessage', args: [textController.text]);
                setState(() {
                  textController.text = '';
                });
              }
            }),
      ],
    );
  }
}
