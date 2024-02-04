import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterapp/auth.dart';

int hexToInteger(String hex) => int.parse(hex, radix: 16);

extension StringColorExtensions on String {
  Color toColor() => Color(hexToInteger(this));
}

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  String? errorMessage = '';
  bool isLogin = true;

  final User? user = Auth().currentUser;

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController(); 

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(hexToInteger('FFF5F3ED')),
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: emailController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Username',
                hintText: 'Enter your username',
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: passwordController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Passwords must be at least 8 characters',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                createUserWithEmailAndPassword();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFA8C8D7), // A8C8D7 color
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Colors.black.withOpacity(0.1), width: 3.0), // slight border
                ),
              ),
            child: Text(
              'Login',
                style: TextStyle(fontSize: 18.0, color: Colors.black),
                ),
              ),
          ],
        ),
      ),
      
    );

  }
}