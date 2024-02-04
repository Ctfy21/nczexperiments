import 'dart:convert';

// import 'package:nczexperiments/cubit/current_value/current_value_cubit.dart';
// import 'package:nczexperiments/models/current_value.dart';
import 'package:nczexperiments/models/experiment.dart';
import 'package:http/http.dart' as http;

abstract class ExperimentsRepository{
  Future<List<Experiment>> fetchExperiments(String url);
  // Future<List<CurrentValue>> fetchCurrentValuesFromExperiment(Experiment experiment);
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