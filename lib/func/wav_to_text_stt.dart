import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

Future<String> wavToText(String uri, String filePath) async{
  final url = Uri.parse(uri);
  var request = http.MultipartRequest("POST", url);
  request.files.add(
    await http.MultipartFile.fromPath('file', filePath, contentType: MediaType('multipart', 'form-data'))
  );
  final responseStreamed = await request.send();
  if(responseStreamed.statusCode == 200){
      var response = await http.Response.fromStream(responseStreamed);
      String body = utf8.decode(response.bodyBytes);
      final json = jsonDecode(body);
      return json["result"] as String;
    }
  else{
    return 'Ошибка!';
  }
}