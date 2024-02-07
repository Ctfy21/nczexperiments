import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nczexperiments/cubit/experiment_boxes/experiment_boxes_repository.dart';
import 'package:nczexperiments/cubit/experiment_boxes/experiment_boxes_state.dart';

class ExperimentBoxesCubit extends Cubit<ExperimentBoxesState>{
  final ExperimentBoxesRepository _boxesRepository;

  ExperimentBoxesCubit(this._boxesRepository) : super(ExperimentBoxesState(values: []));
  
  Future<void> getBoxesIds(int experimentId) async{
    try{
      emit(ExperimentBoxesInitial(values: []));
      emit(ExperimentBoxesLoading(values: []));
      final result = await _boxesRepository.fetchExperimentBoxes("http://protiraki.beget.app/api/currentvaluesboxesids?experimentid=${experimentId.toString()}");
      emit(ExperimentBoxesSuccess(values: result));
    }
    catch(e){
      emit(ExperimentBoxesError(values: [],message: "Проблемы с ${e.toString()}"));
    }
  }
}