import 'dart:io';

import 'package:faceapp/utils/post.dart';
import 'package:flutter/material.dart';

class ProcessImage extends StatefulWidget {
  final String imagePath;
  const ProcessImage({Key key, this.imagePath}) : super(key: key);
  @override
  _ProcessImageState createState() => _ProcessImageState();
}

class _ProcessImageState extends State<ProcessImage> {
  @override
  void initState() {
    sendButtonPressed(widget.imagePath);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Process Image'),
      ),
      body: Image.file(File(widget.imagePath)),
    );
  }
}

void sendButtonPressed(String filePath) async {
  var data = File(filePath);
  List<int> bytes = data.readAsBytesSync();

  var result = await Utils().registerFace(bytes);
  if (result.statusCode == 200) {
    print(result.body.toString());
  } else {
    print("ERORR");
    print(result.statusCode);
    print(result.body);
  }
  print("button Pressed");
  // var url = Uri.parse(_api);
  // // var response = await http.get(url);
  // // String _processLogin = "no user";

  // // if (response.statusCode == 200) {
  // //   var obj = jsonDecode(response.body.toString());
  // //   _processLogin = obj["login"];
  // // } else {
  // //   _processLogin = "no user.";
  // // }

  // // setState(() {
  // //   _result = _processLogin;
  // // });

  // showAlert(context);
}
