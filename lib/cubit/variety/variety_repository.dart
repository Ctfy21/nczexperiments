import 'dart:convert';

import 'package:nczexperiments/models/variety.dart';
import 'package:http/http.dart' as http;

abstract class VarietyRepository{
  Future<List<Variety>> searchVarieties(String url);
}

class FetchVarietyRepository implements VarietyRepository {
  @override
  Future<List<Variety>> searchVarieties(String url) async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if(response.statusCode == 200){
      List<dynamic> json = jsonDecode(response.body);
      List<Variety> searchVarieties = [];
      for(var value in json){
        searchVarieties.add(Variety.fromJsonBox(value));
      }
    return searchVarieties;
    }
    else{
      throw NetworkException();
    }
  }

}

class NetworkException implements Exception {

}