class Box{
  final int id;
  final String boxNumber;
  final List<int>? currentValues;

  const Box({
    required this.id,
    required this.boxNumber,
    required this.currentValues
  });

  Map<String, Object?> toJson(){
    return <String, Object?> {
    'box_number': boxNumber,
    'current_values': currentValues,
    };
  }

  factory Box.fromJsonBox(List<dynamic> json){
    return Box(
        id: json[0]['id'] as int,
        boxNumber: json[0]['box_number'],
        currentValues: (json[0]['current_values'] as List).map((e) => e as int).toList(),
        );
  }
}