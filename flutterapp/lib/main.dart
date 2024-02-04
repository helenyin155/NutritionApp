// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'pages/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            color: Colors.black
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey), // Change the color of the focused border
          ),
        ),
      ),
      home: LoginPage(),
    );
  }
}
