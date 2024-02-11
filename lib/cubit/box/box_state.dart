import 'package:nczexperiments/models/box.dart';

class BoxState {
  final Box? boxValue;
  final List<Box>? boxValues;

  const BoxState({this.boxValue, this.boxValues});

    BoxState copyWith({Box? newBoxValue, List<Box>? newBoxValues}) {
    return BoxState(
      boxValue: newBoxValue ?? boxValue,
      boxValues: newBoxValues ?? boxValues,
    );
  } 
}

class BoxInitial extends BoxState{
  const BoxInitial();
}

class BoxLoading extends BoxState{
  const BoxLoading();
}

class BoxSuccess extends BoxState{
  final Box box;
  const BoxSuccess(this.box);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BoxSuccess && other.box == box;
  }

  @override
  int get hashCode => box.hashCode;
}

class BoxError extends BoxState{
  final String message;
  const BoxError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BoxError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;

}


class BoxesLoading extends BoxState{
  const BoxesLoading();
}

class BoxesSuccess extends BoxState{
  final List<Box> boxes;
  BoxesSuccess(this.boxes){
    copyWith(newBoxValues: boxes);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BoxSuccess && other.boxValues == boxes;
  }

  @override
  int get hashCode => boxValues.hashCode;
}

class BoxesError extends BoxState{
  final String message;
  const BoxesError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BoxesError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;

}