import 'package:http/http.dart' as http;

class Utils {
  Future<String> registerFace(dynamic faceBytes, String profName) async {
    var url = Uri.parse(
        "https://az-face-cust-hack.azurewebsites.net/reconcile_profile/");

    var request = new http.MultipartRequest("POST", url);
    request.fields['profile_name'] = profName;
    request.files.add(new http.MultipartFile.fromBytes('file', faceBytes,
        filename: "prof.name"));

    var response = await request.send();

    if (response.statusCode == 200) print("Uploaded!");

    var rsp = await response.stream.bytesToString();
    return rsp;
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
