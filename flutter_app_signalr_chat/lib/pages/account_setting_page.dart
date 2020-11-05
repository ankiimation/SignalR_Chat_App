import 'package:flutter/material.dart';
import 'package:flutter_app_signalr_chat/bloc/chat_user_bloc/bloc.dart';
import 'package:flutter_app_signalr_chat/bloc/chat_user_bloc/event.dart';
import 'package:flutter_app_signalr_chat/bloc/chat_user_bloc/model.dart';
import 'package:flutter_app_signalr_chat/bloc/chat_user_bloc/service.dart';
import 'package:flutter_app_signalr_chat/constants/constant_variables.dart';

class AccountSettingPage extends StatefulWidget {
  final ChatUserModel chatUserModel;

  AccountSettingPage(this.chatUserModel);

  @override
  _AccountSettingPageState createState() => _AccountSettingPageState();
}

class _AccountSettingPageState extends State<AccountSettingPage> {
  TextEditingController nameTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameTextController.text = widget.chatUserModel.nickname;
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
        backgroundColor: BLUE,
        title: Text("Cài đặt tài khoản"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.25,
              backgroundImage: widget.chatUserModel.avatar != null
                  ? NetworkImage(widget.chatUserModel.avatar)
                  : null,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                decoration: BoxDecoration(color: Colors.black12),
                child: TextFormField(
                  maxLength: (50),
                  controller: nameTextController,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(border: InputBorder.none),
                ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          widget.chatUserModel.nickname =
              nameTextController.text.isEmpty ? null : nameTextController.text;

          await ChatUsersService.updateInfo(widget.chatUserModel);
          Navigator.pop(context);
        },
        label: Text('Lưu'),
        icon: Icon(Icons.save),
        backgroundColor: BLUE,
      ),
    );
  }
}
