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
        title: Text('welcome to [name]'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
                '[NAME]',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 65.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            SizedBox(height: 20.0),
            TextField(
              controller: emailController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'email',
                hintText: 'enter your email',
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: passwordController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'password',
                hintText: 'enter your password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                isLogin ?  signInWithEmailAndPassword() : createUserWithEmailAndPassword();
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
              isLogin ? 'login' : 'sign up',
                style: TextStyle(fontSize: 18.0, color: Colors.black),
                ),
              ),
              SizedBox(height: 5.0),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
                child: Text(
                  isLogin ? "don't have an account? sign up" : "already have an account? login",
                  style: TextStyle(color: Colors.black, decoration: TextDecoration.underline, fontSize: 14.0),
                  textAlign: TextAlign.center,
                ),
            ),
            SizedBox(height: 3.0),
              Text(
                errorMessage ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                ),
              ),

              SizedBox(height: 100.0),
          ],
        ),
      ),
      
    );

  }
}