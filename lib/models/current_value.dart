import 'package:nczexperiments/models/variety.dart';

class CurrentValue{
  final int id;
  final DateTime timeCreate;
  final DateTime timeUpdate;
  final int allPlants;
  final int livePlants;
  final int? grownPlantsValue;
  final double livePlantsPercent;
  final Variety varietyId;
  final int boxId;
  final int experimentId;

  const CurrentValue({
    required this.id,
    required this.timeCreate,
    required this.timeUpdate,
    required this.allPlants,
    required this.livePlants,
    required this.grownPlantsValue,
    required this.livePlantsPercent,
    required this.varietyId,
    required this.boxId,
    required this.experimentId,
  });

  Map<String, Object?> toJsonCurrentValue(){
    return <String, Object?> {
      'time_create': timeCreate,
      'time_update': timeUpdate,
      'all_plants': allPlants,
      'live_plants': livePlants,
      'grown_plants_value': grownPlantsValue,
      'live_plants_percent': livePlantsPercent,
      'variety_id': varietyId,
      'box_id': boxId,
      'experiment_id' : experimentId

    };
  }

  factory CurrentValue.fromJsonCurrentValue(List<dynamic> json){
    return CurrentValue(
        id: json[0]['id'] as int,
        timeCreate: DateTime.parse(json[0]['time_create'].toString()),
        timeUpdate: DateTime.parse(json[0]['time_update'].toString()),
        allPlants: json[0]['all_plants'] as int,
        livePlants: json[0]['live_plants'] as int,
        grownPlantsValue: json[0]['grown_plants_value'] as int?,
        livePlantsPercent: json[0]['live_plants_percent'] as double,
        varietyId: json[0]['variety_id'] as Variety,
        boxId: json[0]['box_id'] as int,
        experimentId: json[0]['experiment_id'] as int,
        );
  }
}