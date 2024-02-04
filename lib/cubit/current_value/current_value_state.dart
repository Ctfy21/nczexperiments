import 'package:nczexperiments/models/current_value.dart';

abstract class CurrentValueState {
  const CurrentValueState();
}

class CurrentValueInitial extends CurrentValueState{
  const CurrentValueInitial();
}

class CurrentValueLoading extends CurrentValueState{
  const CurrentValueLoading();
}

class CurrentValueSuccess extends CurrentValueState{
  final CurrentValue currentValue;
  const CurrentValueSuccess(this.currentValue);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CurrentValueSuccess && other.currentValue == currentValue;
  }

  @override
  int get hashCode => currentValue.hashCode;
}

class CurrentValueError extends CurrentValueState{
  final String message;
  const CurrentValueError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CurrentValueError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;

}