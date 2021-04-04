import 'dart:io';

import 'package:faceapp/utils/post.dart';
import 'package:flutter/material.dart';

class ProcessImage extends StatefulWidget {
  final String imagePath;
  final String profName;
  const ProcessImage({Key key, this.imagePath, this.profName})
      : super(key: key);
  @override
  _ProcessImageState createState() => _ProcessImageState();
}

class _ProcessImageState extends State<ProcessImage> {
  @override
  Widget build(BuildContext context) {
    sendButtonPressed(widget.imagePath, widget.profName, context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Process Image'),
      ),
      body: Image.file(File(widget.imagePath)),
    );
  }
}

void sendButtonPressed(
    String filePath, String profName, BuildContext context) async {
  var data = File(filePath);
  List<int> bytes = data.readAsBytesSync();

  String respResult = "in progress";
  String result = await Utils().registerFace(bytes, profName);

  if (result == "True") {
    respResult = "Your Attendance has been logged";
  } else {
    respResult = "System couldn't verify your entry. please retry !";
  }
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
