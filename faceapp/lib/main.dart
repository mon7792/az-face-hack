import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static String _api = "https://api.github.com/users/mon7792";
  String _result = "E";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FACES'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image(
                  image: AssetImage('images/rdj-face.jpeg'),
                  height: 400.0,
                  width: 300.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: MaterialButton(
                  shape: CircleBorder(),
                  color: Colors.red,
                  padding: EdgeInsets.all(20),
                  onPressed: sendButtonPressed,
                  child: Icon(Icons.send, size: 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // showAlert will display the result on sending the request.
  showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(_result),
        );
      },
    );
  }

  // sendButtonPressed takes the image and post it to the az-face call.
  void sendButtonPressed() async {
    var url = Uri.parse(_api);
    var response = await http.get(url);
    String _processLogin = "no user";

    if (response.statusCode == 200) {
      var obj = jsonDecode(response.body.toString());
      _processLogin = obj["login"];
    } else {
      _processLogin = "no user.";
    }

    setState(() {
      _result = _processLogin;
    });

    showAlert(context);
  }
}
