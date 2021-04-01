import 'package:faceapp/camera.dart';
import 'package:flutter/material.dart';

import 'package:faceapp/utils/post.dart';
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
      // home: Home(camera: widget.camera),
      home: Scaffold(
        body: CaptureImage(
          camera: widget.camera,
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  final CameraDescription camera;
  const Home({Key key, @required this.camera}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static String _api = "https://api.github.com/users/mon7792";
  String _result = "E";
  @override
  Widget build(BuildContext context) {
    final CaptureImage cameraWidget = CaptureImage(
      camera: widget.camera,
    );
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
                child: cameraWidget,
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

  void displayImagePath(CaptureImage ct) async {}

  // sendButtonPressed takes the image and post it to the az-face call.
  void sendButtonPressed() async {
    ByteData data = await getFileData('images/rdj-face.jpeg');
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

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

  Future<ByteData> getFileData(String path) async {
    return await rootBundle.load(path);
  }
}
