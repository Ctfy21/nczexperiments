import 'package:nczexperiments/models/current_value.dart';

class CurrentValueState {
  final CurrentValue? currentValue;
  final List<CurrentValue>? currentValues;

  const CurrentValueState({this.currentValue, this.currentValues});

    CurrentValueState copyWith({CurrentValue? newCurrentValue, List<CurrentValue>? newCurrentValues}) {
    return CurrentValueState(
      currentValue: newCurrentValue ?? currentValue,
      currentValues: newCurrentValues ?? currentValues,
    );
  } 
}

// CurrentValueManager

class CurrentValueInitial extends CurrentValueState{
  const CurrentValueInitial();
}

class CurrentValueLoading extends CurrentValueState{
  const CurrentValueLoading();
}

class CurrentValueSuccess extends CurrentValueState{
  // ignore: annotate_overrides, overridden_fields
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

// CurrentValuesStateManager

class CurrentValuesInitial extends CurrentValueState{
  const CurrentValuesInitial();
}

class CurrentValuesLoading extends CurrentValueState{
  // ignore: annotate_overrides, overridden_fields
  final List<CurrentValue> currentValues;
  CurrentValuesLoading(this.currentValues){
    copyWith(newCurrentValues: currentValues);
  }
}


class CurrentValuesSuccess extends CurrentValueState{
  // ignore: annotate_overrides, overridden_fields
  final List<CurrentValue> currentValues;
  const CurrentValuesSuccess(this.currentValues);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CurrentValuesSuccess && other.currentValues == currentValues;
  }

  @override
  int get hashCode => currentValues.hashCode;
}

class CurrentValuesError extends CurrentValueState{
  final String message;
  const CurrentValuesError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CurrentValuesError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;

}