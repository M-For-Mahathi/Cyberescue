import 'package:flutter/material.dart';
import 'screens/main_screen.dart'; // Import MainScreen from screens

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
      home: MainScreen(),
    );
  }
}
