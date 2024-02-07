import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class ExperimentBoxesRepository{
  Future<List<int>> fetchExperimentBoxes(String url);
}

class FetchExperimentBoxesRepository implements ExperimentBoxesRepository {

  @override
  Future<List<int>> fetchExperimentBoxes(String url) async{
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200){
      final json = jsonDecode(response.body);
      List<int> experimentBoxes = json as List<int>;
      return experimentBoxes;
    }
    else{
      throw NetworkException();
    }
  }
}

class NetworkException implements Exception {

}