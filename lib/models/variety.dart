class Variety{
  final int id;
  final List<int>? currentValuesId;
  final String title;
  final int sequenceNumber;
  final bool isTemplated;
  final double relativeTemplatePercent;
  final int score;
  final String additionalInfo;


  const Variety({
    required this.id,
    required this.currentValuesId,
    required this.title,
    required this.sequenceNumber,
    required this.isTemplated,
    required this.relativeTemplatePercent,
    required this.score,
    required this.additionalInfo,
  });

  Map<String, Object?> toJson(){
    return <String, Object?> {
    'id': id,
    'current_values_id': currentValuesId,
    'title': title,
    'sequence_number': sequenceNumber,
    'is_templated': isTemplated,
    'relative_template_percent': relativeTemplatePercent,
    'score': score,
    'additional_info': additionalInfo,
    };
  }

  factory Variety.fromJsonBox(Map<String, Object?> json){
    return Variety(
        id: json['id'] as int, 
        currentValuesId: (json['current_values'] as List).map((e) => e as int).toList(),
        title: json['title'] as String,
        sequenceNumber: json['sequence_number'] as int,
        isTemplated: json['is_templated'] as bool,
        relativeTemplatePercent: json['relative_template_percent'] as double,
        score: json['score'] as int,
        additionalInfo: json['additional_info'] as String
        );
  }
}