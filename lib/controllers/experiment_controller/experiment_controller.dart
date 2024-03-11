import 'package:get/get.dart';
import 'package:nczexperiments/cubit/experiments/experiments_repository.dart';
import 'package:nczexperiments/models/experiment.dart';

class ExperimentContoller extends GetxController{
  late Experiment experiment;
  late List<Experiment> allExperiments;

  final repository = FetchExperimentsRepository();

  void getAllExperiments(String url) {
    repository.fetchExperiments(url)
}