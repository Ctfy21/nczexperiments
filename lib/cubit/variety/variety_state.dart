import 'package:nczexperiments/models/variety.dart';

class VarietyState {
  final Variety? varietyValue;
  final List<Variety>? varietyValues;

  const VarietyState({this.varietyValue, this.varietyValues});

    VarietyState copyWith({Variety? newVarietyValue, List<Variety>? newVarietyValues}) {
    return VarietyState(
      varietyValue: newVarietyValue ?? varietyValue,
      varietyValues: newVarietyValues ?? varietyValues,
    );
  } 
}