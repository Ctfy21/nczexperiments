import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nczexperiments/models/experiment.dart';

class ExperimentCubit extends Cubit<Experiment>{
  ExperimentCubit() : super(Experiment(title: "error", maxRecurrence: 0, maxRegime: 0, maxBoxVariety: 0, startTime: DateTime.now()));

}