import 'package:flutter/material.dart';
import 'package:weather_app/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // late String theme = "dark";
  // void changeTheme() {
  //   if (theme == 'dark') {
  //     theme = 'dark';
  //   } else {
  //     theme = 'light';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}
