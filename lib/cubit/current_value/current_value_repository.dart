import 'dart:convert';
import 'package:nczexperiments/models/current_value.dart';
import 'package:http/http.dart' as http;

abstract class CurrentValueRepository{
  Future<CurrentValue> fetchCurrentValue(String url);
  Future<List<CurrentValue>> fetchCurrentValuesByBoxId(String url);
  Future<String> postEmptyCurrentValue(String url, CurrentValue currentValue);
}

class FetchCurrentValueRepository implements CurrentValueRepository {

  @override
  Future<CurrentValue> fetchCurrentValue(String url) async{
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    String body = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200){
      final json = jsonDecode(body);
      CurrentValue currentValue = CurrentValue.fromJsonCurrentValue(json);
      
      return currentValue;
    }
    else{
      throw NetworkException();
    }
  }


  @override
  Future<List<CurrentValue>> fetchCurrentValuesByBoxId(String url) async{
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    String body = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200){
      List<dynamic> json = jsonDecode(body);
      List<CurrentValue> values = [];
      for(var element in json){
      values.add(CurrentValue.fromJsonCurrentValue(element));
      }      
      return values;
    }
    else{
      throw NetworkException();
    }
  }

  @override
  Future<String> postEmptyCurrentValue(String url, CurrentValue currentValue) async{
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: currentValue.toJsonEmptyCurrentValue());
    if(response.statusCode <= 300){
      return "Данные успешно отправлены!";
    }
    else{
      throw NetworkException();
    }
  }

}

class NetworkException implements Exception {

}