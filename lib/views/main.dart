import 'package:flutter/material.dart';

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
                        onPressed: () => Navigator.pushNamed(context, '/details'),
                        child: Text('Посмотреть данные'),
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
      body: const Text('Test')
      );
  }
}