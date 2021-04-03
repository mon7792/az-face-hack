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
  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    sendButtonPressed(widget.imagePath, context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Process Image'),
      ),
      body: Image.file(File(widget.imagePath)),
    );
  }
}

void sendButtonPressed(String filePath, BuildContext context) async {
  var data = File(filePath);
  List<int> bytes = data.readAsBytesSync();

  String respResult = "in progress";
  var result = await Utils().registerFace(bytes);
  if (result.statusCode == 200) {
    respResult = result.body.toString();
    print(respResult);
  } else {
    print("ERORR");
    print(result.statusCode);
    print(result.body);
  }
  print("button Pressed");
  showAlert(context, respResult);
}

// showAlert will display the result on sending the request.
showAlert(BuildContext context, String result) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text(result),
      );
    },
  );
}
