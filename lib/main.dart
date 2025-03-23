// lib/main.dart
import 'package:flutter/material.dart';
import 'package:sportapp/views/subnet_41_view.dart';
import 'package:sportapp/views/subnet_8_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Miner Web',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true,
        ),
        home: const ScreenApp());
  }
}

class ScreenApp extends StatelessWidget {
  const ScreenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Miner Web'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
              child: ElevatedButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Subnet8View(),
                ),
              );
            },
            child: const Text('Subnet 8'),
          )),
          const SizedBox(height: 10),
          Center(
              child: ElevatedButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Subnet41View(),
                ),
              );
            },
            child: const Text('Subnet 41'),
          ))
        ],
      ),
    );
  }
}
