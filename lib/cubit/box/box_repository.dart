import 'dart:convert';
import 'package:nczexperiments/models/box.dart';
import 'package:http/http.dart' as http;

abstract class BoxRepository{
  Future<Box> fetchBox(String url);
}

class FetchBoxRepository implements BoxRepository {

  @override
  Future<Box> fetchBox(String url) async{
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200){
      final json = jsonDecode(response.body)["results"];
      Box box = Box.fromJsonBox(json);
      return box;
    }
    else{
      throw NetworkException();
    }
  }


}

class NetworkException implements Exception {

}