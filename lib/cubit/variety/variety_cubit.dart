import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nczexperiments/cubit/variety/variety_repository.dart';
import 'package:nczexperiments/cubit/variety/variety_state.dart';

class VarietyCubit extends Cubit<VarietyState>{
  final VarietyRepository _varietyRepository;

  VarietyCubit(this._varietyRepository) : super(const VarietyState());
  
  Future<void> getSearchVarieties(String searchTitle) async{
    try{
      final searchVarieties = await _varietyRepository.searchVarieties("https://protiraki.beget.app/api/variety?search=$searchTitle");
      emit(const VarietyState().copyWith(newVarietyValues: searchVarieties));
    } 
    catch(e) {
      emit(throw Exception());
    }
  }
}