import 'package:nczexperiments/models/box.dart';

abstract class BoxState {
  const BoxState();
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