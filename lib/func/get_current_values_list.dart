import 'package:nczexperiments/cubit/current_value/current_value_repository.dart';
import 'package:nczexperiments/models/current_value.dart';

FetchCurrentValueRepository repository = FetchCurrentValueRepository();

Future<List<CurrentValue>> getCurrentValuesFromBoxId(int boxId) async{
  final values = await repository.fetchCurrentValuesByBoxId("https://protiraki.beget.app/api/currentvalues?boxid=${boxId.toString()}");
  return values;
}