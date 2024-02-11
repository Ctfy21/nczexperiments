import 'dart:convert';
import 'package:nczexperiments/models/box.dart';
import 'package:http/http.dart' as http;

abstract class BoxRepository{
  Future<Box> fetchBox(String url);
  Future<List<Box>> fetchListBox(String url);
}

class FetchBoxRepository implements BoxRepository {

  @override
  Future<Box> fetchBox(String url) async{
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200){
      final json = jsonDecode(response.body);
      Box box = Box.fromJsonBox(json);
      return box;
    }
    else{
      throw NetworkException();
    }
  }

  @override
  Future<List<Box>> fetchListBox(String url) async{
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200){
      List<dynamic> json = jsonDecode(response.body);
      List<Box> boxes = [];
      for(var element in json){
        boxes.add(Box.fromJsonBox(element));
      }
      return boxes;
    }
    else{
      throw NetworkException();
    }
  }


}

class NetworkException implements Exception {

}