import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nczexperiments/cubit/box/box_repository.dart';
import 'package:nczexperiments/cubit/box/box_state.dart';
import 'package:nczexperiments/models/box.dart';

class BoxCubit extends Cubit<BoxState>{
  final BoxRepository boxRepository;

  BoxCubit(this.boxRepository) : super(const BoxInitial());
  
  Future<void> getBox(int id) async{
    try{
      emit(const BoxLoading());
      final box = await boxRepository.fetchBox("https://protiraki.beget.app/api/boxdetail/${id.toString()}");
      emit(BoxSuccess(box));
    } 
    catch(e) {
      emit(BoxError("Проблемы с ${e.toString()}"));
    }
  }

  Future<void> getListBoxByExperimentId(int id) async{
    try{
      emit(const BoxesLoading());
      List<Box> boxes = await boxRepository.fetchListBox("https://protiraki.beget.app/api/currentvaluesboxesids?experimentid=${id.toString()}");
      emit(BoxesSuccess(boxes));
    } 
    catch(e) {
      emit(BoxesError("Проблемы с ${e.toString()}"));
    }
  }

  Future<void> getBoxByTitle(String boxNumber) async{
    try{
      emit(const BoxLoading());
      final box = await boxRepository.fetchBox("https://protiraki.beget.app/api/box?search=$boxNumber");
      state.copyWith(newBoxValue: box);
      emit(BoxSuccess(box));
    } 
    catch(e) {
      emit(BoxError("Проблемы с ${e.toString()}"));
    }
  }

  Future<void> addBox(String boxNumber) async{
    try{
      final box = await boxRepository.addBox("https://protiraki.beget.app/api/box", Box(id: 0, boxNumber: boxNumber, currentValues: null));
      emit(state.copyWith(newBoxValue: box));
    } 
    catch(e) {
      emit(BoxError("Проблемы с ${e.toString()}"));
    }
  }

}