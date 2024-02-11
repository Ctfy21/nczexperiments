import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nczexperiments/cubit/box/box_cubit.dart';
import 'package:nczexperiments/cubit/box/box_repository.dart';
import 'package:nczexperiments/cubit/box/box_state.dart';
import 'package:nczexperiments/cubit/current_value/current_value_cubit.dart';
import 'package:nczexperiments/cubit/current_value/current_value_repository.dart';
import 'package:nczexperiments/cubit/current_value/current_value_state.dart';
import 'package:nczexperiments/cubit/experiments/experiments_cubit.dart';
import 'package:nczexperiments/cubit/experiments/experiments_repository.dart';
import 'package:nczexperiments/cubit/experiments/experiments_state.dart';
import 'package:nczexperiments/models/experiment.dart';

void main() => runApp(const MyApp());

// SafeArea(
//     child: MaterialApp(
//       title: "NCZ experiments",
//       theme: ThemeData(
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//           useMaterial3: true,
//         ),
//       initialRoute: '/',
//       routes: {
//         '/': (BuildContext context) => const MainScreen(),
//         '/experiments': (BuildContext context) => const ExperimentsScreen(),
//         '/experimentvalues': (BuildContext context) => const ExperimentValuesScreen()
//       },
//     ),
//   )

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const MainScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'experiments',
          builder: (BuildContext context, GoRouterState state) {
            return const ExperimentsScreen();
          },
        ),
        GoRoute(
          path: 'experimentvalues',
          builder: (BuildContext context, GoRouterState state) {
            try{
              Experiment experiment = state.extra! as Experiment;
              return ExperimentValuesScreen(experiment: experiment);
            }
            catch (e){
              return ErrorScreen(message:e.toString());
            }

          },
        ),  
      ],
    ),
  ],
);

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurpleAccent,
            title: const Text("NCZ Experiments"),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            verticalDirection: VerticalDirection.down,
            children: [
              const Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Center(
                    child: Icon(Icons.holiday_village, size: 200.0)
                  )]
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            context.go('/experiments');
                          },
                          child: const Text('Посмотреть данные'),
                        ),
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text("Внести данные")),
                    )
                  ]
                ),
              )
            ],
          )
        ),
    );
  }
}






class ExperimentsScreen extends StatelessWidget {
  const ExperimentsScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          title: const Text("NCZ Experiments"),
        ),
        body: BlocProvider(
          create: (context) => ExperimentsCubit(FetchExperimentsRepository()),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            alignment: Alignment.center,
            child: BlocBuilder<ExperimentsCubit, ExperimentsState>(
              builder: (context, state) {          
                  if(state is ExperimentsLoading){
                    return const Center(child: CircularProgressIndicator());
                  }
                  if(state is ExperimentsError){
                    return Center(child: Text(state.message));
                  }
                  if(state is ExperimentsSuccess){
                    return ListView.builder(
                      itemCount: state.experiments.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Center(
                            child: ListTile(
                              title: Text(state.experiments[index].title, style: const TextStyle(fontWeight:  FontWeight.w500)),
                              subtitle: Text('Время начала эксперимента - ${state.experiments[index].startTime.day}.${state.experiments[index].startTime.month}.${state.experiments[index].startTime.year}'),
                              onTap: () {
                                context.go('/experimentvalues', extra: state.experiments[index]);                         
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }                 
                  else{
                    return const Center(child: Text("Неизвестная ошибка, пожалуйста напишите сообщение администратору."));
                  }
              },
            ),
          ),
        )
      ),
    );
  }
}





class ExperimentValuesScreen extends StatelessWidget {

  final Experiment experiment;
  const ExperimentValuesScreen({super.key, required this.experiment});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          title: const Text("NCZ Experiments"),
        ),
        body: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => BoxCubit(FetchBoxRepository())),
            BlocProvider(create: (context) => CurrentValueCubit(FetchCurrentValueRepository())),
          ],
          child: BlocBuilder<BoxCubit, BoxState>(
            builder: (contextBoxes, stateBoxes) {
              if(stateBoxes is BoxInitial){
                contextBoxes.read<BoxCubit>().getListBoxByExperimentId(experiment.id);
                return const Center(child: CircularProgressIndicator());
              }
              if(stateBoxes is BoxesLoading){
                return const Center(child: CircularProgressIndicator());
              }
              if(stateBoxes is BoxesError){
                return Center(child: Text(stateBoxes.message));
              }
              if(stateBoxes is BoxesSuccess){
                return ListView.builder(
                  itemCount: stateBoxes.boxes.length,
                  itemBuilder: (contextList, index) {
                    return Card(
                      child: Column(
                        children: [
                          Text(stateBoxes.boxes[index].boxNumber),
                          BlocBuilder<CurrentValueCubit, CurrentValueState>(
                            builder: (contextCurrentValue, stateCurrentValue) {
                              if(stateCurrentValue is CurrentValuesInitial){
                                contextCurrentValue.read<CurrentValueCubit>().getCurrentValuesFromBoxId(stateBoxes.boxes[index].id);
                                return const Center(child: CircularProgressIndicator());
                              }
                              if(stateCurrentValue is CurrentValuesLoading){
                                return const Center(child: CircularProgressIndicator());
                              }
                              if(stateCurrentValue is CurrentValuesError){
                                return Center(child: Text(stateCurrentValue.message));
                              }
                              if(stateCurrentValue is CurrentValuesSuccess){
                                return ListView.builder(
                                  itemCount: stateCurrentValue.currentValues.length,
                                  itemBuilder: (context, index) {
                                    return Row(children: [
                                      Text(stateCurrentValue.currentValues[index].varietyId.title),
                                      Text(stateCurrentValue.currentValues[index].allPlants.toString()),
                                      Text(stateCurrentValue.currentValues[index].livePlants.toString()),
                                      Text(stateCurrentValue.currentValues[index].livePlantsPercent.toString()),
                                    ],);
                                  },
                                );
                              }
                              else{
                                return const Center(child: Text("CurrentValue: error"));
                              }
                            },
                          )
                        ],
                      ),
                    );
                  },
                );
              }
              else{
                return const Center(child: Text("ExperimentBoxes: Error"));
              }
            },
          )
        )
      ),
    );
  }
}

class ErrorScreen extends StatelessWidget {

  final String message;
  const ErrorScreen({super.key, required this.message});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          title: const Text("NCZ Experiments"),
        ),
        body: Center(
          child: Text(message),
        )
      )
    );
  }
    
}

// DataTable dataTableCurrentValues(CurrentValue currentValue){
//   return DataTable(columns: currentValuesDataColumn(), rows: currentValuesDataRows(currentValue));
// }

// List<DataColumn> currentValuesDataColumn(){
//   return [
//     const DataColumn(label: Text("Сорт")),
//     const DataColumn(label: Text("Всего растений")),
//     const DataColumn(label: Text("Живые растения")),
//     const DataColumn(label: Text("% живых")),
//   ];
// }

// List<DataRow> currentValuesDataRows(CurrentValue currentValue){
// }