class Experiment{
  final int id;
  final List<int> currentValues;
  final String title;
  final int maxRecurrence;
  final int maxRegime;
  final int maxBoxVariety;
  final String startTime;

  const Experiment({
    required this.id,
    required this.currentValues,
    required this.title,
    required this.maxRecurrence,
    required this.maxRegime,
    required this.maxBoxVariety,
    required this.startTime,
  });

  Map<String, Object?> toJson(){
    return <String, Object?> {
    'current_values': currentValues,
    'title': title,
    'max_recurrence': maxRecurrence,
    'max_regime': maxRegime,
    'max_box_variety': maxBoxVariety,
    'start_time': startTime
    };
  }

  factory Experiment.fromJson(Map<String, Object?> json){
    return Experiment(
        id: json['id'] as int,
        currentValues: (json['current_values'] as List).map((e) => e as int).toList(),
        title: json['title'] as String,
        maxRecurrence: json['max_recurrence'] as int,
        maxRegime: json['max_regime'] as int,
        maxBoxVariety: json['max_box_variety'] as int,
        startTime: json['start_time'] as String
        );
  }
}