import 'package:nczexperiments/models/experiment.dart';

abstract class ExperimentsState {
  const ExperimentsState();
}

class ExperimentsInitial extends ExperimentsState{
  const ExperimentsInitial();

  
}

class ExperimentsLoading extends ExperimentsState{
  const ExperimentsLoading();
}

class ExperimentsSuccess extends ExperimentsState{
  final List<Experiment> experiments;
  const ExperimentsSuccess(this.experiments);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExperimentsSuccess && other.experiments == experiments;
  }

  @override
  int get hashCode => experiments.hashCode;
}

class ExperimentsError extends ExperimentsState{
  final String message;
  const ExperimentsError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExperimentsError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;

}