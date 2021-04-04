import 'package:faceapp/camera.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:camera/camera.dart';

Future<void> main() async {
  // initialize plugin service.
  WidgetsFlutterBinding.ensureInitialized();

  // obtain the list of available camera.
  final cameras = await availableCameras();

  // select the front camera.
  CameraDescription cm;

  for (int i = 0; i < cameras.length; i++) {
    var cam = cameras[i].lensDirection;
    if (cam == CameraLensDirection.front) {
      cm = cameras[i];
    }
  }

  final CameraDescription selCam = cm;
  var myApp = MyApp(camera: selCam);

  runApp(myApp);
}

class MyApp extends StatefulWidget {
  final CameraDescription camera;
  const MyApp({Key key, @required this.camera}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: CaptureImage(
          camera: widget.camera,
        ),
      ),
    );
  }
}
