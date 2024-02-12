import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nczexperiments/cubit/current_value/current_value_repository.dart';
import 'package:nczexperiments/cubit/current_value/current_value_state.dart';
import 'package:nczexperiments/models/current_value.dart';
import 'package:nczexperiments/models/experiment.dart';
import 'package:nczexperiments/models/variety.dart';

class CurrentValueCubit extends Cubit<CurrentValueState>{
  final CurrentValueRepository currentValueRepository;

  CurrentValueCubit(this.currentValueRepository) : super(const CurrentValuesInitial());

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
      for(var id in experiment.currentValues){
        addCurrentValue(await currentValueRepository.fetchCurrentValue("http://protiraki.beget.app/api/currentvaluesdetail/${id.toString()}"));
      }
      sortCurrentValuesBoxID(state.currentValues!);
      emit(CurrentValuesSuccess(state.currentValues ?? []));
    }
    catch(e){
      emit(CurrentValuesError("Проблемы с ${e.toString()}"));
    }
  }

  Future<void> getCurrentValuesFromBoxId(int boxId) async{
    emit(const CurrentValuesInitial());
    try{
      final list = await currentValueRepository.fetchCurrentValuesByBoxId("https://protiraki.beget.app/api/currentvalues?boxid=${boxId.toString()}");
      emit(CurrentValuesLoading(list));
      sortCurrentValuesBoxID(state.currentValues!);
      emit(CurrentValuesSuccess(state.currentValues ?? []));
    }
    catch(e){
      emit(CurrentValuesError("Проблемы с ${e.toString()}"));
    }
  }

  Future<void> postEmptyCurrentValue(int boxId, Variety variety, int sequenceBoxNumber, int experimentId) async{
    emit(const CurrentValueInitial());
    CurrentValue emptyValue = CurrentValue(id: null, timeCreate: null, timeUpdate: null, sequenceBoxNumber: sequenceBoxNumber, allPlants: null, livePlants: null, grownPlantsValue: null, livePlantsPercent: null, varietyId: variety, boxId: boxId, experimentId: experimentId);
    try{
      emit(const CurrentValueLoading());
      await currentValueRepository.postEmptyCurrentValue("https://protiraki.beget.app/api/currentvalues", emptyValue);
    }
    catch(e){
      emit(CurrentValuesError("Проблемы с ${e.toString()}"));
    }
  }

  Future<void> currentValuePostSuccess() async{
    emit(const CurrentValuePostSuccess('Загрузка завершена!'));
  }

  Future<void> returnInitialState() async{
    emit(const CurrentValuesInitial());
  }

  void setCurrentValue(CurrentValue currentValue){  
    emit(state.copyWith(newCurrentValue: currentValue));
  }


  void addCurrentValue(CurrentValue newCurrentValue) {
    final currentValues = List<CurrentValue>.from(state.currentValues ?? []);
    currentValues.add(newCurrentValue);
    emit(CurrentValuesLoading(currentValues));
  }

  void sortCurrentValuesBoxID(List<CurrentValue> list){
    list.sort((a, b) => a.boxId.compareTo(b.boxId));
    emit(CurrentValuesLoading(list));
  }

}