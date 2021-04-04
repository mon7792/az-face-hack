import 'package:camera/camera.dart';
import 'package:faceapp/process_image.dart';
import 'package:flutter/material.dart';

class CaptureImage extends StatefulWidget {
  final CameraDescription camera;

  const CaptureImage({Key key, @required this.camera}) : super(key: key);
  @override
  _CaptureImageState createState() => _CaptureImageState();
}

class _CaptureImageState extends State<CaptureImage> {
  CameraController _cameraController;
  Future<void> _initializeControllerFuture;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<String> captureImagePath() async {
    XFile image;
    try {
      await _initializeControllerFuture;
      image = await _cameraController.takePicture();
    } catch (e) {
      print(e);
    }
    return image?.path;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        // Camera.
        FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_cameraController);
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
        // Input button.
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            controller: _controller,
          ),
        ),
        // sumbit button.
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: MaterialButton(
            shape: CircleBorder(),
            color: Colors.red,
            padding: EdgeInsets.all(20),
            onPressed: () async {
              XFile image;
              try {
                await _initializeControllerFuture;
                image = await _cameraController.takePicture();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProcessImage(
                      // Pass the automatically generated path to
                      // the DisplayPictureScreen widget.
                      imagePath: image?.path,
                      profName: _controller.text,
                    ),
                  ),
                );
              } catch (e) {
                print(e);
              }
              print(image?.path);
            },
            child: Icon(Icons.send, size: 50),
          ),
        ),
      ],
    );
  }
}
