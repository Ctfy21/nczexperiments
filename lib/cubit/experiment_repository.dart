import 'dart:convert';

import 'package:nczexperiments/models/experiment.dart';
import 'package:http/http.dart' as http;

abstract class ExperimentsRepository{
  Future<List<Experiment>> fetchExperiments(String url);
}

class FetchExperimentsRepository implements ExperimentsRepository {

  @override
  Future<List<Experiment>> fetchExperiments(String url) async{
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200){
      final json = jsonDecode(response.body)["results"];
      List<dynamic> tempData = json.map((data) => Experiment.fromJson(data)).toList();
      List<Experiment> experiments = tempData.cast<Experiment>();
      return experiments;
    }
    else{
      throw NetworkException();
    }
  }
}

class NetworkException implements Exception {

}