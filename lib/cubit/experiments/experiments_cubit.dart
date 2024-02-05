import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nczexperiments/cubit/experiments/experiments_repository.dart';
import 'package:nczexperiments/cubit/experiments/experiments_state.dart';

class ExperimentsCubit extends Cubit<ExperimentsState>{
  final ExperimentsRepository _experimentsRepository;

  ExperimentsCubit(this._experimentsRepository) : super(const ExperimentsInitial()){
    getExperiments();
  }
  
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