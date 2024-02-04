import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nczexperiments/cubit/current_value/current_value_repository.dart';
import 'package:nczexperiments/cubit/current_value/current_value_state.dart';
import 'package:nczexperiments/cubit/experiments/experiments_cubit.dart';
import 'package:nczexperiments/cubit/experiments/experiments_state.dart';

class CurrentValueCubit extends Cubit<CurrentValueState>{
  final CurrentValueRepository currentValueRepository;
  final ExperimentsCubit experimentsCubit;
  late final StreamSubscription experimentsSubscription;

  CurrentValueCubit({required this.currentValueRepository, required this.experimentsCubit}) : super(const CurrentValueInitial()){
    experimentsSubscription = experimentsCubit.stream.listen((ExperimentsState state) {
      if(state is ExperimentsSuccess){
        //Продолжение здесь!!!!!!
      }
    });
  }

  Future<void> getCurrentValue(int id) async{
    try{
      emit(const CurrentValueLoading());
      final currentValue = await currentValueRepository.fetchCurrentValue("https://protiraki.beget.app/api/currentvaluesdetail/${id.toString()}");
      emit(CurrentValueSuccess(currentValue));
    } 
    catch(e) {
      emit(CurrentValueError("Проблемы с ${e.toString()}"));
    }
  }

  @override
  Future<void> close(){
    experimentsSubscription.cancel();
    return super.close();
  }

}