import 'package:nczexperiments/models/variety.dart';

class CurrentValue{
  final int? id;
  final DateTime? timeCreate;
  final DateTime? timeUpdate;
  final int? sequenceBoxNumber;
  final int? allPlants;
  final int? livePlants;
  final int? grownPlantsValue;
  final double? livePlantsPercent;
  final Variety varietyId;
  final int boxId;
  final int experimentId;

  const CurrentValue({
    required this.id,
    required this.timeCreate,
    required this.timeUpdate,
    required this.sequenceBoxNumber,
    required this.allPlants,
    required this.livePlants,
    required this.grownPlantsValue,
    required this.livePlantsPercent,
    required this.varietyId,
    required this.boxId,
    required this.experimentId,
  });

  Map<String, Object?> toJsonEmptyCurrentValue(){
    return <String, Object?> {
      'sequence_box_number': sequenceBoxNumber.toString(),
      'variety_id': varietyId.id.toString(),
      'box_id': boxId.toString(),
      'experiment_id' : experimentId.toString()
    };
  }

  Map<String, Object?> toJson(){
    return <String, Object?> {
      'id': id,
      'time_create': timeCreate!.toIso8601String(),
      'time_update': timeUpdate!.toIso8601String(),
      'all_plants': allPlants,
      'live_plants': livePlants,
      'grown_plants_value': grownPlantsValue,
      'variety_id': varietyId,
      'box_id': boxId,
      'experiment_id' : experimentId
    };
  }

  Map<String, Object?> toJsonPut(){
    return <String, Object?> {
      'id': id,
      'time_create': timeCreate!.toIso8601String(),
      'time_update': timeUpdate!.toIso8601String(),
      'all_plants': allPlants,
      'live_plants': livePlants,
      'grown_plants_value': grownPlantsValue,
      'variety_id': varietyId.id,
      'box_id': boxId,
      'experiment_id' : experimentId
    };
  }


  // factory CurrentValue.fromJsonCurrentValue(List<dynamic> json){
  //   return CurrentValue(
  //       id: json[0]['id'] as int,
  //       timeCreate: DateTime.parse(json[0]['time_create'].toString()),
  //       timeUpdate: DateTime.parse(json[0]['time_update'].toString()),
  //       allPlants: json[0]['all_plants'] as int,
  //       livePlants: json[0]['live_plants'] as int,
  //       grownPlantsValue: json[0]['grown_plants_value'] as int?,
  //       livePlantsPercent: json[0]['live_plants_percent'] as double,
  //       varietyId: json[0]['variety_id'] as Variety,
  //       boxId: json[0]['box_id'] as int,
  //       experimentId: json[0]['experiment_id'] as int,
  //       );
  // }

  factory CurrentValue.fromJsonCurrentValue(Map<String, Object?> json){
    return CurrentValue(
        id: json['id'] as int,
        timeCreate: DateTime.tryParse(json['time_create'].toString()),
        timeUpdate: DateTime.tryParse(json['time_update'].toString()),
        sequenceBoxNumber: json['sequence_box_number'] as int? ?? 0,
        allPlants: json['all_plants'] as int? ?? 0,
        livePlants: json['live_plants'] as int? ?? 0,
        grownPlantsValue: json['grown_plants_value'] as int? ?? 0,
        livePlantsPercent: json['live_plants_percent'] as double? ?? 0,
        varietyId: Variety.fromJsonBox((json['variety_id'] as Map<String, Object?>)),
        boxId: json['box_id'] as int,
        experimentId: json['experiment_id'] as int,
        );
  }

  factory CurrentValue.fromCurrentValue(Map<String, Object?> json){
    return CurrentValue(
        id: json['id'] as int,
        timeCreate: DateTime.tryParse(json['time_create'].toString()),
        timeUpdate: DateTime.tryParse(json['time_update'].toString()),
        sequenceBoxNumber: json['sequence_box_number'] as int? ?? 0,
        allPlants: json['all_plants'] as int? ?? 0,
        livePlants: json['live_plants'] as int? ?? 0,
        grownPlantsValue: json['grown_plants_value'] as int? ?? 0,
        livePlantsPercent: json['live_plants_percent'] as double? ?? 0,
        varietyId: json['variety_id'] as Variety,
        boxId: json['box_id'] as int,
        experimentId: json['experiment_id'] as int,
        );
  }

}