import 'package:http/http.dart' as http;

class Utils {
  Future<http.Response> registerFace(dynamic faceBytes) async {
    var url = Uri.parse(
        "https://az-hack-face.cognitiveservices.azure.com/face/v1.0/detect");
    http.Response response = await http.post(
      url,
      headers: {
        "Content-Type": "application/octet-stream",
        "Ocp-Apim-Subscription-Key": "ef82d2be98d04d18b437fb64bbc1949f"
      },
      body: faceBytes,
    );

    return response;
  }
}
// var data = """
//     {
//       'url':
//           'https://upload.wikimedia.org/wikipedia/commons/thumb/9/94/Robert_Downey_Jr_2014_Comic_Con_%28cropped%29.jpg/423px-Robert_Downey_Jr_2014_Comic_Con_%28cropped%29.jpg'
//     }
//     """;
