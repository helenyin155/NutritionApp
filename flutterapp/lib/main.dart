// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutterapp/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterapp/pages/start_goals.dart';
import 'package:flutterapp/pages/nutrient_page.dart';
import 'package:flutterapp/pages/testing.dart';
import 'pages/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
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
      // home: LoginPage(),
      // home: StartGoals(),
      home: NutrientPage(),
      // home: Iphone13144Widget(),
      // home: HomePage(),
      routes: {
        'homepage': (context) => HomePage(),
      }
    );
  }
}
