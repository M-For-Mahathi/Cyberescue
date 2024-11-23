import 'package:flutter/material.dart';
import 'screens/sign_up_screen.dart'; // Import the SignUpScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CyberEscue',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SignUpScreen(), // Set SignUpScreen as the home screen
    );
  }
}
