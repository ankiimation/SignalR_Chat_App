import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_signalr_chat/chat_screen.dart';
import 'package:signalr_core/signalr_core.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

bool hasPartner = false;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Set<String> currentFreeConnections = {};
  HubConnection connection;

  initConnection() async {
    await connection?.stop();
    connection = HubConnectionBuilder()
        .withUrl(
            'http://10.0.2.2:54334/chatHub',
            HttpConnectionOptions(
              logging: (level, message) => print(message),
            ))
        .build();

    connection.on('CurrentConnections', (arguments) {
      print('Connections: $arguments');
      if (arguments.isNotEmpty && arguments.first is List) {
        currentFreeConnections = (arguments.first as List)
            .where((e) => e != connection.connectionId)
            .map((e) => e.toString())
            .toSet();
        if (!hasPartner && currentFreeConnections.isNotEmpty) {
          var randomList = currentFreeConnections.toList()..shuffle();
          var random = randomList.first;
          connection.invoke('ConnectTo', args: [random]);
        }
      }
    });
    connection.on('MyPartner', (arguments) async {
      if (arguments is List && arguments.isNotEmpty) {
        print('Partner: ${arguments.first}');
        if (!hasPartner) {
          hasPartner = true;
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ChatPage(connection, arguments.first)));
          hasPartner = false;
        }
      }
    });
    await connection.start();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
