import 'package:flutter/material.dart';
import 'package:flutter_app_signalr_chat/main.dart';
import 'package:signalr_core/signalr_core.dart';

class ChatPage extends StatefulWidget {
  final HubConnection connection;
  final String partnerConnectionId;

  ChatPage(this.connection, this.partnerConnectionId);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List message = [];
  final controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.connection.on('ReceiveMessage', (arguments) {
      print('MESSAGE: $arguments');
      if (arguments is List && arguments.length == 2) {
        if (this.mounted)
          setState(() {
            message.addAll(arguments);
          });
      }
    });
    widget.connection.on('PartnerConnection', (arguments) {
      if (arguments is List &&
          arguments.length == 1 &&
          arguments.first.toString() == 'disconnected') {
        hasPartner = false;
        if (this.mounted) {
          Navigator.pop(context);
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.connection.invoke('DisconnectFrom');
    print('ON DISPOSE');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text('${widget.partnerConnectionId}'),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () async {
                Navigator.pop(context);
              })
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
                child: ListView(
              children: message
                  .map((e) => Container(
                        padding: EdgeInsets.all(10),
                        child: Text(e.toString()),
                      ))
                  .toList(),
            )),
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: controller,
                )),
                IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      if (widget.connection.state ==
                          HubConnectionState.connected) {
                        widget.connection.invoke('SendMessage', args: [
                          widget.partnerConnectionId,
                          controller.text
                        ]);
                      }
                    })
              ],
            )
          ],
        ),
      ),
    );
  }
}
