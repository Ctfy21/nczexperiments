import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nczexperiments/cubit/variety/variety_repository.dart';
import 'package:nczexperiments/cubit/variety/variety_state.dart';

class VarietyCubit extends Cubit<VarietyState>{
  final VarietyRepository _varietyRepository;

  VarietyCubit(this._varietyRepository) : super(const VarietyInitial());
  
  Future<void> getSearchVarieties(String searchTitle) async{
    try{
      emit(const VarietyLoading());
      final searchVarieties = await _varietyRepository.getVarieties("https://protiraki.beget.app/api/variety?search=$searchTitle");
      emit(VarietySuccess(searchVarieties));
    } 
    catch(e) {
      emit(throw Exception());
    }
  }

  Future<void> getAllVarieties() async{
    try{
      emit(const VarietyLoading());
      final varieties = await _varietyRepository.getVarieties("https://protiraki.beget.app/api/variety");
      emit(VarietySuccess(varieties));
    } 
    catch(e) {
      emit(throw Exception());
    }
  }


}