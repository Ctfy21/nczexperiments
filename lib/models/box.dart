class Box{
  final int id;
  final int boxNumber;

  const Box({
    required this.id,
    required this.boxNumber
  });

  Map<String, Object?> toJson(){
    return <String, Object?> {
    'box_number': boxNumber,
    };
  }

  factory Box.fromJsonBox(Map<String, Object?> json){
    return Box(
        id: json['id'] as int,
        boxNumber: json['box_number'] as int,
        );
  }
}