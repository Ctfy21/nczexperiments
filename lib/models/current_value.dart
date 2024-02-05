class CurrentValue{
  final int id;
  final DateTime timeCreate;
  final DateTime timeUpdate;
  final int allPlants;
  final int livePlants;
  final int? grownPlantsValue;
  final double livePlantsPercent;
  final int varietyId;
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

  factory CurrentValue.fromJsonCurrentValue(Map<String, Object?> json){
    return CurrentValue(
        id: json['id'] as int,
        timeCreate: DateTime.parse(json['time_create'].toString()),
        timeUpdate: DateTime.parse(json['time_update'].toString()),
        allPlants: json['all_plants'] as int,
        livePlants: json['live_plants'] as int,
        grownPlantsValue: json['grown_plants_value'] as int?,
        livePlantsPercent: json['live_plants_percent'] as double,
        varietyId: json['variety_id'] as int,
        boxId: json['box_id'] as int,
        experimentId: json['experiment_id'] as int,

        );
  }
}