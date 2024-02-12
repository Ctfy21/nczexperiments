import 'package:flutter/material.dart';
import 'package:nczexperiments/cubit/current_value/current_value_state.dart';
import 'package:nczexperiments/cubit/variety/variety_cubit.dart';
import 'package:nczexperiments/cubit/variety/variety_repository.dart';
import 'package:nczexperiments/cubit/variety/variety_state.dart';
import 'package:nczexperiments/models/variety.dart';
import 'package:searchfield/searchfield.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nczexperiments/cubit/box/box_cubit.dart';
import 'package:nczexperiments/cubit/box/box_repository.dart';
import 'package:nczexperiments/cubit/box/box_state.dart';
import 'package:nczexperiments/cubit/current_value/current_value_cubit.dart';
import 'package:nczexperiments/cubit/current_value/current_value_repository.dart';
import 'package:nczexperiments/cubit/experiments/experiments_cubit.dart';
import 'package:nczexperiments/cubit/experiments/experiments_repository.dart';
import 'package:nczexperiments/cubit/experiments/experiments_state.dart';
import 'package:nczexperiments/func/get_current_values_list.dart';
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
          path: 'experimentsCreateTemplate',
          builder: (BuildContext context, GoRouterState state) {
            return const ExperimentsCreateTemplateScreen();
          },
        ),
        GoRoute(
          path: 'experimentvalues',
          builder: (BuildContext context, GoRouterState state) {
            try {
              Experiment experiment = state.extra! as Experiment;
              return ExperimentValuesScreen(experiment: experiment);
            } catch (e) {
              return ErrorScreen(message: e.toString());
            }
          },
        ),
        GoRoute(
          path: 'createtemplatevalue',
          builder: (BuildContext context, GoRouterState state) {
            try {
              Experiment experiment = state.extra! as Experiment;
              return CreateTemplateValueScreen(experiment: experiment);
            } catch (e) {
              return ErrorScreen(message: e.toString());
            }
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
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
                    children: [
                      Center(child: Icon(Icons.holiday_village, size: 200.0))
                    ]),
              ),
              Expanded(
                flex: 1,
                child: Column(children: [
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
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Center(
                      child: ElevatedButton(
                          onPressed: () {}, child: const Text("Внести данные")),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Center(
                      child: ElevatedButton(
                          onPressed: () {
                            context.go('/experimentsCreateTemplate');
                          },
                          child: const Text("Внести шаблонные данные")),
                    ),
                  )
                ]),
              )
            ],
          )),
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
                  if (state is ExperimentsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is ExperimentsError) {
                    return Center(child: Text(state.message));
                  }
                  if (state is ExperimentsSuccess) {
                    return ListView.builder(
                      itemCount: state.experiments.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Center(
                            child: ListTile(
                              title: Text(state.experiments[index].title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500)),
                              subtitle: Text(
                                  'Время начала эксперимента - ${state.experiments[index].startTime.day}.${state.experiments[index].startTime.month}.${state.experiments[index].startTime.year}'),
                              onTap: () {
                                context.go('/experimentvalues',
                                    extra: state.experiments[index]);
                              },
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                        child: Text(
                            "Неизвестная ошибка, пожалуйста напишите сообщение администратору."));
                  }
                },
              ),
            ),
          )),
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
                BlocProvider(
                    create: (context) => BoxCubit(FetchBoxRepository())),
                BlocProvider(
                    create: (context) =>
                        CurrentValueCubit(FetchCurrentValueRepository())),
              ],
              child: BlocBuilder<BoxCubit, BoxState>(
                builder: (contextBoxes, stateBoxes) {
                  if (stateBoxes is BoxInitial) {
                    contextBoxes
                        .read<BoxCubit>()
                        .getListBoxByExperimentId(experiment.id);
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (stateBoxes is BoxesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (stateBoxes is BoxesError) {
                    return Center(child: Text(stateBoxes.message));
                  }
                  if (stateBoxes is BoxesSuccess) {
                    return ListView.builder(
                      itemCount: stateBoxes.boxes.length,
                      itemBuilder: (contextList, indexBox) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(50, 10, 50, 0),
                          child: Card(
                            child: Column(
                              children: [
                                Text(
                                  '№${stateBoxes.boxes[indexBox].boxNumber}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                FutureBuilder(
                                  future: getCurrentValuesFromBoxId(
                                      stateBoxes.boxes[indexBox].id),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return DataTable(
                                          columns: const [
                                            DataColumn(label: Text('Название')),
                                            DataColumn(
                                                label: Text('Всего раст.')),
                                            DataColumn(
                                                label: Text('Живые раст.')),
                                            DataColumn(label: Text('% живых'))
                                          ],
                                          rows: snapshot.data
                                                  ?.map((currentValue) =>
                                                      DataRow(cells: [
                                                        DataCell(Text(
                                                            currentValue
                                                                .varietyId
                                                                .title)),
                                                        DataCell(Text(
                                                            currentValue
                                                                .allPlants
                                                                .toString())),
                                                        DataCell(Text(
                                                            currentValue
                                                                .livePlants
                                                                .toString())),
                                                        DataCell(Text(currentValue
                                                            .livePlantsPercent
                                                            .toString())),
                                                      ]))
                                                  .toList() ??
                                              []);
                                    } else {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text("ExperimentBoxes: Error"));
                  }
                },
              ))),
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
            )));
  }
}

class ExperimentsCreateTemplateScreen extends StatelessWidget {
  const ExperimentsCreateTemplateScreen({super.key});

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
                  if (state is ExperimentsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is ExperimentsError) {
                    return Center(child: Text(state.message));
                  }
                  if (state is ExperimentsSuccess) {
                    return ListView.builder(
                      itemCount: state.experiments.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Center(
                            child: ListTile(
                              title: Text(state.experiments[index].title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500)),
                              subtitle: Text(
                                  'Время начала эксперимента - ${state.experiments[index].startTime.day}.${state.experiments[index].startTime.month}.${state.experiments[index].startTime.year}'),
                              onTap: () {
                                context.go('/createtemplatevalue',
                                    extra: state.experiments[index]);
                              },
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                        child: Text(
                            "Неизвестная ошибка, пожалуйста напишите сообщение администратору."));
                  }
                },
              ),
            ),
          )),
    );
  }
}

class CreateTemplateValueScreen extends StatelessWidget {
  final Experiment experiment;
  CreateTemplateValueScreen({super.key, required this.experiment});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String boxNumber = '';
    List<String> varietyTitles = List<String>.filled(experiment.maxBoxVariety, '');

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text("NCZ Experiments"),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => VarietyCubit(FetchVarietyRepository()),
          ),
          BlocProvider(
            create: (context) => BoxCubit(FetchBoxRepository()),
          ),
          BlocProvider(
            create: (context) => CurrentValueCubit(FetchCurrentValueRepository()),
          ),
        ],
        child: Builder(
          builder: (context) {
            return BlocBuilder<VarietyCubit, VarietyState>(
              builder: (contextVariety, stateVariety) {
                if (stateVariety is VarietyInitial) {
                  contextVariety.read<VarietyCubit>().getAllVarieties();
                  return const Center(child: CircularProgressIndicator());
                }
                if (stateVariety is VarietyLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (stateVariety is VarietySuccess) {
                  return Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: TextFormField(
                              onSaved: (newValue) => boxNumber = newValue!,
                              decoration: const InputDecoration(
                              icon: Icon(Icons.check_box_outline_blank_outlined),
                              hintText: 'Введите номер ящика'),
                              validator: (value) {
                                if (value!.isEmpty || value == '') {
                                  return 'Пустой ввод!';
                                }
                                return null;
                              },
                            ),
                          ),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: experiment.maxBoxVariety,
                              itemBuilder: (contextList, index) {
                                return Row(
                                  children: [
                                    Text("№${index + 1}"),
                                    const VerticalDivider(),
                                    Expanded(
                                      child: SearchField<Variety>(
                                      suggestions: stateVariety.values.map((e) =>
                                        SearchFieldListItem<Variety>(e.title,
                                            item: e,
                                            child: Padding(
                                              padding:const EdgeInsets.all(8.0),
                                              child: Text(e.title))
                                            )).toList(),
                                      validator: (value) {
                                        if (value!.isEmpty || value == '') {
                                          return 'Пустой ввод!';
                                        }
                                        return null;
                                      },         
                                      onSaved: (value) => varietyTitles[index] = value!,                 
                                    )),
                                  ],
                                );
                              },
                            ),
                          ),
                          BlocBuilder<CurrentValueCubit, CurrentValueState>(
                            builder: (contextCurrentValue, stateCurrentValue) {
                              if(stateCurrentValue is CurrentValueLoading){
                                return ElevatedButton(
                                onPressed: () {},
                                child: const Center(child: CircularProgressIndicator()),
                              );
                              }
                              if(stateCurrentValue is CurrentValuePostSuccess){
                                return Column(
                                  children: [
                                    const Text('Успешно'),
                                    const SizedBox(height: 20,),
                                    ElevatedButton(
                                    onPressed: () {
                                      context.go('/');
                                    },
                                    child: const Text('Домой'))
                                  ],
                                );
                              }
                              else{
                                return ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      final boxProvider = BlocProvider.of<BoxCubit>(context);
                                      await boxProvider.addBox(boxNumber);
                                      int boxId = 0;
                                      boxId = boxProvider.state.boxValue!.id;
                                      for(var value in varietyTitles){
                                        // ignore: use_build_context_synchronously
                                        contextCurrentValue.read<CurrentValueCubit>().postEmptyCurrentValue(boxId, stateVariety.values.firstWhere((element) => element.title == value), varietyTitles.indexOf(value) + 1, experiment.id);
                                      }
                                      // ignore: use_build_context_synchronously
                                      contextCurrentValue.read<CurrentValueCubit>().currentValuePostSuccess();
                                    }
                                  },
                                  child: const Text('Отправить'),
                                );
                              }
                            },
                          )
                        ],
                      ));
                } else {
                  return const Text('Variety: error');
                }
              },
            );
          }
        ),
      ),
    ));
  }
}
