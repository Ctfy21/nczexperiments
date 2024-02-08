class Variety{
  final int id;
  final List<int>? currentValuesId;
  final String title;
  final

  const Variety({
    required this.id,
    required this.boxNumber
  });

  Map<String, Object?> toJson(){
    return <String, Object?> {
    'box_number': boxNumber,
    };
  }

  factory Variety.fromJsonBox(Map<String, Object?> json){
    return Variety(
        id: json['id'] as int,
        boxNumber: json['box_number'] as int,
        );
  }
}