import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'screens/home_screen.dart';
import 'screens/personal_info_screen.dart';
import 'screens/comfort_chatbot.dart';

void main() {
  runApp(CyberEscueApp());
}

class CyberEscueApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyberescue',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false, // Optional: removes debug banner
      home: MainScreen(), // 👈 This is now the first screen on launch
    );
  }
}
