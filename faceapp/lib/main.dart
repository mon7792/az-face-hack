import 'package:flutter/material.dart';

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
          title: new Text("RESULT"),
        );
      },
    );
  }

  // sendButtonPressed takes the image and post it to the az-face call.
  void sendButtonPressed() async {
    print("SEND THE DATA TO AZURE");
    // var url = Uri.parse(_api + _controller.text);
    // var response = await http.get(url);
    // // TODO: WORK on THE RESPONSE BODY
    // if (response.statusCode == 200) {
    //   setState(() {
    //     _result = response.body.toString();
    //   });
    // } else {
    //   setState(() {
    //     _result = "no user.";
    //   });
    // }

    showAlert(context);
  }
}
