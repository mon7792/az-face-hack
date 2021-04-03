import 'package:http/http.dart' as http;

class Utils {
  Future<http.Response> registerFace(dynamic faceBytes) async {
    var url = Uri.parse("https://az-face-hack.azurewebsites.net/verify");
    http.Response response = await http.post(
      url,
      body: faceBytes,
    );

    return response;
  }
}
