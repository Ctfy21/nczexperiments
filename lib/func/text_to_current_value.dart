import 'package:nczexperiments/cubit/box/box_repository.dart';
import 'package:nczexperiments/cubit/current_value/current_value_repository.dart';
import 'package:nczexperiments/models/current_value.dart';

List<int> textToCurrentValue(String text) {
  int progress = 0;
  List<int> currentValuesPlants = [];
  List<String> arrayString = text.split(' ');
  for(var value in arrayString){
    if(value.contains(':')){
      final index = arrayString.indexOf(value);
      arrayString.removeAt(index);
      final tempVal = value.split(':');
      arrayString.insertAll(index, tempVal);
    }
  }
  for (var value in arrayString){
    if(value.isNotEmpty && value != '' && value.toLowerCase().contains('ящик')){
      progress = 1;
    }
    else if(progress == 1 && int.tryParse(value) != null && value != '' && value.isNotEmpty){
      currentValuesPlants.add(int.parse(value));
      progress = 2;
    }
    else if(progress == 2 && value.isNotEmpty && value != '' && value.toLowerCase().contains('начать')){
      progress = 3;
    }
    else if(progress == 3 && value.isNotEmpty && int.tryParse(value) != null){
      currentValuesPlants.add(int.parse(value));
      progress = 4;
    }
    else if(progress == 4 && value.isNotEmpty && value.toLowerCase().contains('дальше')){
      progress = 3;
    }
    else if(progress == 3 && value.isNotEmpty && value.toLowerCase().contains('конец')){
      progress = 0;
    }
  }
  return currentValuesPlants;
}

Future<String> saveCurrentValuesPlantValues(List<int> values, String field) async{
  final result = await FetchBoxRepository().fetchBox("https://protiraki.beget.app/api/box?search=${values[0]}");
  values.removeAt(0);
  final currentValues = await FetchCurrentValueRepository().fetchCurrentValuesByBoxId("https://protiraki.beget.app/api/currentvalues?boxid=${result.id}");
  if(currentValues.length != values.length){
    return "Ошибка, количество полей не совпадают!";
  }
  for(var i = 0; i < currentValues.length; i++){
    final json = currentValues[i].toJson();
    json[field] = values[i];
    try{
      FetchCurrentValueRepository().putCurrentValue("https://protiraki.beget.app/api/currentvaluesdetail/${currentValues[i].id.toString()}", CurrentValue.fromCurrentValue(json));
      
    }
    catch(e){
      return e.toString();
    }
}
  return 'Сохранено!';
}