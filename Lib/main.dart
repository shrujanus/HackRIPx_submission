import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import './screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    Object() = const Color.fromRGBO(16, 79, 85, 1);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => const MainPage(),
      },
      title: 'Augma',
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          displayLarge: TextStyle(
            fontSize: 52,
            fontWeight: FontWeight.bold,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.blue,
          //TODO mess with RGB
          background: const Color.fromRGBO(1, 32, 15, 1),
          onPrimary: const Color.fromRGBO(158, 197, 171, 1),
          secondary: const Color.fromRGBO(50, 116, 109, 1),
        ),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}
