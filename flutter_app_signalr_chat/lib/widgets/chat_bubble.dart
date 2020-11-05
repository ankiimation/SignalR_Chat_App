import 'package:flutter/material.dart';
import 'package:flutter_app_signalr_chat/constants/constant_variables.dart';
import 'package:flutter_app_signalr_chat/models/message_model.dart';

class ChatBubble extends StatefulWidget {
  final ChatMessageModel chatMessageModel;
  final bool fromMe;

  ChatBubble(this.chatMessageModel, {this.fromMe = false});

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    final borderRadius = 10.0;
    var e = widget.chatMessageModel;
    var fromMe = widget.fromMe;
    return Container(
      margin: EdgeInsets.only(left: !fromMe ? 10 : 0, right: fromMe ? 10 : 0),
      alignment: widget.fromMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: widget.fromMe ? BLUE : MESSAGE_BACKGROUND_COLOR,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(fromMe ? 0 : borderRadius),
              bottomRight: Radius.circular(borderRadius),
              topLeft: Radius.circular(!fromMe ? 0 : borderRadius),
              bottomLeft: Radius.circular(borderRadius),
            )),
        child: Column(
          crossAxisAlignment:
              widget.fromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Text(
            //   e.dateTime,
            //   style: TextStyle(
            //     fontSize: 12,
            //     fontStyle: FontStyle.italic,
            //     color: fromMe ? WHITE : GREEN,
            //   ),
            // ),
            Text(
              e.message,
              style: TextStyle(
                  fontSize: 18,
                  color: fromMe ? WHITE : BLUE,
                  letterSpacing: 1.1),
            ),
          ],
        ),
      ),
    );
  }
}
