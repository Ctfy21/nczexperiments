import 'dart:convert';
import 'package:nczexperiments/models/current_value.dart';
import 'package:http/http.dart' as http;

abstract class CurrentValueRepository{
  Future<CurrentValue> fetchCurrentValue(String url);
}

class FetchCurrentValueRepository implements CurrentValueRepository {

  @override
  Future<CurrentValue> fetchCurrentValue(String url) async{
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200){
      final json = jsonDecode(response.body);
      CurrentValue currentValue = CurrentValue.fromJsonCurrentValue(json);
      return currentValue;
    }
    else{
      throw NetworkException();
    }
  }
}

class NetworkException implements Exception {

}