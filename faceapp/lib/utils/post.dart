import 'package:http/http.dart' as http;

class Utils {
  Future<http.Response> registerFace(dynamic faceBytes) async {
    var url = Uri.parse("https://az-face-hack.azurewebsites.net/verify");
    http.Response response = await http.post(
      url,
      body: faceBytes,
    );

    return response;

    // var request = new http.MultipartRequest("POST", url);
    // request.fields['uuid'] = 'nweiz@google.com';
    // request.files.add(new http.MultipartFile.fromBytes('file', faceBytes));
    // var response = await request.send();

    // response.
    // // request.send().then((response) {
    // //   if (response.statusCode == 200) print("Uploaded!");
    // // });

    // return response;
  }
}

// http.Response response = await http.post(
//   url,
//   headers: ,
//   body: faceBytes,
// );

// var request = http.MultipartRequest('POST', url);
// request.files.add(http.MultipartFile('file', faceBytes, faceBytes));

// var response = await request.send();

// class Utils {
//   Future<http.Response> registerFace(dynamic faceBytes) async {
//     var url = Uri.parse("https://az-face-hack.azurewebsites.net/verify");

//     Map<String, String> header = {
//       "Content-Type": "multipart/form-data",
//     };

//     http.Response response =
//         await http.post(url, headers: header, body: faceBytes);

//     return response;
//   }
// }
