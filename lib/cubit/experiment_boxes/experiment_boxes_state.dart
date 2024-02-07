class ExperimentBoxesState{
  List<int>? values;
  ExperimentBoxesState({required this.values});

    ExperimentBoxesState copyWith({List<int>? newValues}) {
    return ExperimentBoxesState(
      values: newValues ?? values,
    );
  } 
  
}

class ExperimentBoxesInitial extends ExperimentBoxesState{
  ExperimentBoxesInitial({required super.values});
}

class ExperimentBoxesLoading extends ExperimentBoxesState{
  ExperimentBoxesLoading({required super.values});
}

class ExperimentBoxesSuccess extends ExperimentBoxesState{
  ExperimentBoxesSuccess({required super.values});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExperimentBoxesSuccess && other.values == values;
  }

  @override
  int get hashCode => values.hashCode;
}

class ExperimentBoxesError extends ExperimentBoxesState{
  final String message;
  ExperimentBoxesError({required super.values, required this.message});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExperimentBoxesError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;

}