import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nczexperiments/cubit/experiment_cubit.dart';
import 'package:nczexperiments/cubit/experiment_repository.dart';
import 'package:nczexperiments/cubit/experiment_state.dart';

void main() {
  runApp(MaterialApp(
    title: "NCZ experiments",
    theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    initialRoute: '/',
    routes: {
      '/': (BuildContext context) => const MainScreen(),
      '/details': (BuildContext context) => const DetailScreen()
    },
  ));
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          Navigator.pushNamed(context, '/details');
                        },
                        child: const Text('Посмотреть данные'),
                      ),
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => print("222"),
                      child: Text("Внести данные")),
                  )
                ]
              ),
            )
          ],
        )
      );
  }
}


class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                if(state is ExperimentsInitial){
                  context.read<ExperimentsCubit>().getExperiments();
                  return const Center(child: CircularProgressIndicator()); 
                }
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
                      return ListTile(
                        title: Text(state.experiments[index].title),
                      );
                    },
                  );
                }                 
                else{
                  return const Center(child: Text("Неизвестная ошибка, пожалуйста напишите сообщение администратору."));
                }

              // if(state is ExperimentsInitial){
              //   return const Center(child: CircularProgressIndicator());                
              // }
              // if(state is ExperimentsLoading){
              //   return const Center(child: CircularProgressIndicator());
              // }
              // if(state is ExperimentsError){
              //   (errorMessage) => Center(child: Text(errorMessage));
              // }
              // if(state is ExperimentsSuccess){
              //   (experiments){
              //     ListView.builder(
              //       itemCount: experiments.length,
              //       itemBuilder: (context, index){
              //         return ListTile(
              //           title: Text(experiments[index].title),
              //         );
              //       },
              //     );
              //   };
              // }
              // else{
              //   return const Center(child: CircularProgressIndicator());
              // }
            },
          ),
        ),
      )
      );
  }
}