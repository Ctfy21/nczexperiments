class Experiment{
  final String title;
  final int maxRecurrence;
  final int maxRegime;
  final int maxBoxVariety;
  final DateTime startTime;

  const Experiment({
    required this.title,
    required this.maxRecurrence,
    required this.maxRegime,
    required this.maxBoxVariety,
    required this.startTime,
  });

  Map<String, Object?> toDataBase(){
    return <String, Object?> {
    'title': title,
    'max_recurrence': maxRecurrence,
    'max_regime': maxRegime,
    'max_box_variety': maxBoxVariety,
    'start_time': startTime
    };
  }

  Experiment.fromDataBase(Map<String, Object?> data)
      : title = data['title'] as String,
        maxRecurrence = data['max_recurrence'] as int,
        maxRegime = data['max_regime'] as int,
        maxBoxVariety = data['max_box_variety'] as int,
        startTime = data['start_time'] as DateTime;
}