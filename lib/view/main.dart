import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nczexperiments/cubit/current_value/current_value_state.dart';
import 'package:nczexperiments/cubit/variety/variety_cubit.dart';
import 'package:nczexperiments/cubit/variety/variety_repository.dart';
import 'package:nczexperiments/cubit/variety/variety_state.dart';
import 'package:nczexperiments/func/text_to_current_value.dart';
import 'package:nczexperiments/func/wav_to_text_stt.dart';
import 'package:nczexperiments/models/box.dart';
import 'package:nczexperiments/models/variety.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
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
        return const NewMainPage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'experiments',
          builder: (BuildContext context, GoRouterState state) {
            try{
              String urlVal = state.extra as String;
              return ChooseExperimentsScreen(url: urlVal);
            }
            catch(e){
              return ErrorScreen(message: e.toString());
            }
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
        GoRoute(
          path: 'selectbox',
          builder: (BuildContext context, GoRouterState state) {
            try {
              Experiment experiment = state.extra! as Experiment;
              return ChooseBoxScreen(experiment: experiment);
            } catch (e) {
              return ErrorScreen(message: e.toString());
            }
          },
        ),
        GoRoute(
          path: 'putvoicedata',
          builder: (BuildContext context, GoRouterState state) {
            try {
              List<dynamic> list = state.extra as List<dynamic>;
              return PutVoiceDataScreen(experiment: list[0], box: list[1]);
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
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Color.fromRGBO(63, 167, 39, 1),
          selectedLabelStyle: TextStyle(
              fontSize: 10,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(63, 167, 39, 1)
            ),
          unselectedLabelStyle: TextStyle(
              fontSize: 10,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(153, 162, 173, 1)
            ),
          unselectedItemColor: Color.fromRGBO(153, 162, 173, 1),
          selectedIconTheme: IconThemeData(size: 24),
          unselectedIconTheme: IconThemeData(size: 24),
        ),
        
        tabBarTheme: TabBarTheme(
          unselectedLabelColor: const Color.fromRGBO(129, 140, 153, 1),
          labelColor: const Color.fromRGBO(74, 74, 74, 1),
          labelStyle: Theme.of(context).textTheme.titleMedium,
          unselectedLabelStyle: Theme.of(context).textTheme.titleLarge,
          dividerColor: Colors.white,
          indicatorColor: const Color.fromRGBO(63, 167, 39, 1),
        ),
        iconTheme: const IconThemeData(
          color: Color.fromRGBO(63, 167, 39, 1)
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(0, 255, 255, 255),
          brightness: Brightness.light
        ),
        textTheme: TextTheme(
          displayLarge: GoogleFonts.openSans(
            textStyle: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(74, 74, 74, 1)
            )
          ),
          titleLarge: GoogleFonts.openSans( 
            textStyle: const TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400
            ),
          ),
          titleMedium: GoogleFonts.openSans(
            textStyle: const TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400
            ),
          ),
          titleSmall: GoogleFonts.openSans(
            textStyle: const TextStyle(
              fontSize: 10,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600
            ),
          ),
          bodyLarge: GoogleFonts.openSans(
            textStyle: const TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w800
            ), 
          ),
          bodyMedium: GoogleFonts.openSans(
            textStyle: const TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400
            ),
          ),
          bodySmall: GoogleFonts.openSans(
            textStyle: const TextStyle(
              fontSize: 10,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400
            ),
          )
        )
      ),
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
            // backgroundColor: Colors.deepPurpleAccent,
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
                          context.go('/experiments', extra: '/experimentvalues');
                        },
                        child: const Text('Посмотреть данные'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Center(
                      child: ElevatedButton(
                          onPressed: () {
                             context.go('/experiments', extra: '/selectBox');
                          }, child: const Text("Внести данные голосом")),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Center(
                      child: ElevatedButton(
                          onPressed: () {
                            context.go('/experiments', extra: '/createtemplatevalue');
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

class ChooseExperimentsScreen extends StatelessWidget {
  final String url;
  const ChooseExperimentsScreen({super.key, required this.url});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
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
                                context.go(url,
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
                                        columnSpacing: 17,
                                          columns: const [
                                            DataColumn(
                                                label: Center(child: Flexible(child: Text('Название')))),
                                            DataColumn(
                                                label: Center(child: Flexible(child: Text('Всего')))),
                                            DataColumn(
                                                label: Center(child: Flexible(child: Text('Живые')))),
                                            // DataColumn(label: Text('% живых'))
                                          ],
                                          rows: snapshot.data
                                                  ?.map((currentValue) =>
                                                      DataRow(cells: [
                                                        DataCell(Center(
                                                          child: Flexible(
                                                            child: Text(
                                                                currentValue
                                                                    .varietyId
                                                                    .title),
                                                          ),
                                                        )),
                                                        DataCell(Center(
                                                          child: Flexible(
                                                            child: Text(
                                                                currentValue
                                                                    .allPlants
                                                                    .toString()),
                                                          ),
                                                        )),
                                                        DataCell(Center(
                                                          child: Flexible(
                                                            child: Text(
                                                                currentValue
                                                                    .livePlants
                                                                    .toString()),
                                                          ),
                                                        )),
                                                        // DataCell(Text(currentValue
                                                        //     .livePlantsPercent
                                                        //     .toString())),
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
              title: const Text("NCZ Experiments"),
            ),
            body: Center(
              child: Text(message),
            )));
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
                      child: SingleChildScrollView(
                        reverse: true,
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                                primary: false,
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
                            ),
                          ],
                        ),
                      )
                      );
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


class ChooseBoxScreen extends StatelessWidget {
  final Experiment experiment;
  const ChooseBoxScreen({super.key, required this.experiment});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text("NCZ Experiments"),
          ),
          body: BlocProvider(
            create: (context) => BoxCubit(FetchBoxRepository()),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              child: BlocBuilder<BoxCubit, BoxState>(
                builder: (contextBox, stateBox) {
                  if (stateBox is BoxInitial) {
                    contextBox.read<BoxCubit>().getListBoxByExperimentId(experiment.id);
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (stateBox is BoxesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (stateBox is BoxesError) {
                    return Center(child: Text(stateBox.message));
                  }
                  if (stateBox is BoxesSuccess) {
                    return ListView.builder(
                      itemCount: stateBox.boxes.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Center(
                            child: ListTile(
                              title: Text(stateBox.boxes[index].boxNumber,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500)),
                              onTap: () {
                                context.go('/putVoiceData',
                                    extra: [experiment, stateBox.boxes[index]]);
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


class PutVoiceDataScreen extends StatefulWidget {
  final Experiment experiment;
  final Box box;
  const PutVoiceDataScreen({super.key, required this.experiment, required this.box});

  @override
  FavoriteWidgetState createState() => FavoriteWidgetState();
}

class FavoriteWidgetState extends State<PutVoiceDataScreen>{
  late AudioRecorder record;
  late String data;
  late bool isRecording;

  @override
  void initState() {
    record = AudioRecorder();
    data = '';
    isRecording = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text("NCZ Experiments"),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(data),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: isRecording ? MaterialStateProperty.all(Colors.red) : MaterialStateProperty.all(Colors.green),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0)
                    )
                  )
                ),
                onPressed:() async {
                  setState(() {
                    isRecording = !isRecording;
                  });
                  if(!isRecording){
                    final path = await record.stop();
                    final dataNew = await wavToText("https://protiraki.beget.app/api/uploadaudio", path!);
                    final resTemp = textToCurrentValue(dataNew);
                    await saveCurrentValuesPlantValues(resTemp, 'all_plants');
                    setState(() {
                      data = dataNew;
                    });
                  }
                  else{
                    if (await record.hasPermission()) {
                      Directory appTempDir = await getTemporaryDirectory();
                      await record.start(const RecordConfig(encoder: AudioEncoder.wav, noiseSuppress: true), path: '${appTempDir.path}/record.wav');
                    }
                  }
                },
                child: isRecording ? const Icon(Icons.mic_off) : const Icon(Icons.mic),
              )
            ],
          )
      )
    );
  }
}

class NewMainPage extends StatelessWidget {
  const NewMainPage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: const MainAppBar(),
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
              selectedLabelStyle: Theme.of(context).bottomNavigationBarTheme.selectedLabelStyle,
              unselectedLabelStyle: Theme.of(context).bottomNavigationBarTheme.unselectedLabelStyle,
              unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
              selectedIconTheme: Theme.of(context).bottomNavigationBarTheme.selectedIconTheme,
              unselectedIconTheme: Theme.of(context).bottomNavigationBarTheme.unselectedIconTheme,
              items:  [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.file_upload_rounded),
                  label: 'Ввод'
                ),
                BottomNavigationBarItem(
                  icon: ShaderMask(
                    shaderCallback: (bounds) => 
                    const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color.fromRGBO(153, 162, 173, 1), Color.fromRGBO(153, 162, 173, 0)]).createShader(bounds),
                    child: const CircleAvatar(backgroundColor: Color.fromRGBO(153, 162, 173, 1), child: Icon(Icons.mic, color: Colors.white,),),
                  ),
                  label: 'Запись'
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.edit_document, size: 24),
                  label: 'Эксперемент'
                ),
              ],
            ),
            body: const Padding(
              padding: EdgeInsets.all(12.0),
              child: TabBarView(
                children: [
                  ExperimentValuesNewScreen(experiment: ),
                  Text('2'),
                ],
              ),
            )
        ),
      )
    );
  }
}



class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      title: Text("Ввод данных", style: Theme.of(context).textTheme.displayLarge),
      centerTitle: true,
      leading: Icon(Icons.arrow_back_ios_new_rounded, color: Theme.of(context).iconTheme.color,),
      actions: [
        Icon(Icons.search, color: Theme.of(context).iconTheme.color)
      ],
      bottom: TabBar(
        unselectedLabelColor: Theme.of(context).tabBarTheme.unselectedLabelColor,
        unselectedLabelStyle: Theme.of(context).tabBarTheme.unselectedLabelStyle,
        labelStyle: Theme.of(context).tabBarTheme.labelStyle,
        labelColor: Theme.of(context).tabBarTheme.labelColor,
        indicatorColor: Theme.of(context).tabBarTheme.indicatorColor,
        
        tabs: const [
          Tab(child: Center(child: Text('Все растения')),),
          Tab(child: Center(child: Text('Живые растения')),),
        ],
      ),
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kTextTabBarHeight + kToolbarHeight);
}



class ExperimentValuesNewScreen extends StatelessWidget {
  final Experiment experiment;
  const ExperimentValuesNewScreen({super.key, required this.experiment});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
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
                                        columnSpacing: 17,
                                          columns: const [
                                            DataColumn(
                                                label: Center(child: Flexible(child: Text('Название')))),
                                            DataColumn(
                                                label: Center(child: Flexible(child: Text('Всего')))),
                                            DataColumn(
                                                label: Center(child: Flexible(child: Text('Живые')))),
                                            // DataColumn(label: Text('% живых'))
                                          ],
                                          rows: snapshot.data
                                                  ?.map((currentValue) =>
                                                      DataRow(cells: [
                                                        DataCell(Center(
                                                          child: Flexible(
                                                            child: Text(
                                                                currentValue
                                                                    .varietyId
                                                                    .title),
                                                          ),
                                                        )),
                                                        DataCell(Center(
                                                          child: Flexible(
                                                            child: Text(
                                                                currentValue
                                                                    .allPlants
                                                                    .toString()),
                                                          ),
                                                        )),
                                                        DataCell(Center(
                                                          child: Flexible(
                                                            child: Text(
                                                                currentValue
                                                                    .livePlants
                                                                    .toString()),
                                                          ),
                                                        )),
                                                        // DataCell(Text(currentValue
                                                        //     .livePlantsPercent
                                                        //     .toString())),
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
              ));
  }
}
