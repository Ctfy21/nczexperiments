import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nczexperiments/cubit/experiment_repository.dart';
import 'package:nczexperiments/cubit/experiment_state.dart';

class ExperimentsCubit extends Cubit<ExperimentsState>{
  final ExperimentsRepository _experimentsRepository;

  ExperimentsCubit(this._experimentsRepository) : super(const ExperimentsInitial());

  Future<void> getExperiments() async{
    try{
      emit(const ExperimentsLoading());
      final experiments = await _experimentsRepository.fetchExperiments("https://protiraki.beget.app/api/experiment");
      emit(ExperimentsSuccess(experiments));
    } 
    catch(e) {
      emit(ExperimentsError("Проблемы с ${e.toString()}"));
    }
  }

}