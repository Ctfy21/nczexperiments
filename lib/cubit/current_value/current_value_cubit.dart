import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nczexperiments/cubit/current_value/current_value_repository.dart';
import 'package:nczexperiments/cubit/current_value/current_value_state.dart';
import 'package:nczexperiments/models/current_value.dart';
import 'package:nczexperiments/models/experiment.dart';

class CurrentValueCubit extends Cubit<CurrentValueState>{
  final CurrentValueRepository currentValueRepository;

  CurrentValueCubit(this.currentValueRepository) : super(const CurrentValueInitial());

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

  Future<void> getCurrentValuesFromExperiment(Experiment experiment) async{
    emit(const CurrentValuesInitial());
    try{
      List<CurrentValue> currentValues = [];
      emit(const CurrentValuesLoading());
      for(var id in experiment.currentValues){
        currentValues.add(await currentValueRepository.fetchCurrentValue("https://protiraki.beget.app/api/currentvaluesdetail/${id.toString()}"));
      }
      emit(CurrentValuesSuccess(currentValues));
    }
    catch(e){
      emit(CurrentValueError("Проблемы с ${e.toString()}"));
    }
  }

  void setCurrentValue(CurrentValue currentValue){  
    emit(state.copyWith(newCurrentValue: currentValue));
  }

  void addCurrentValue(CurrentValue newCurrentValue) {
    final currentValues = List<CurrentValue>.from(state.currentValues ?? []);
    currentValues.add(newCurrentValue);
    emit(state.copyWith(newCurrentValues: currentValues));
  }

}