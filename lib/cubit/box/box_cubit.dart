import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nczexperiments/cubit/box/box_repository.dart';
import 'package:nczexperiments/cubit/box/box_state.dart';

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

}