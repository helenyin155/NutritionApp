import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterapp/auth.dart';

int hexToInteger(String hex) => int.parse(hex, radix: 16);

extension StringColorExtensions on String {
  Color toColor() => Color(hexToInteger(this));
}

class NutrientPage extends StatefulWidget {
  const NutrientPage({super.key});

  @override
  State<NutrientPage> createState() => _NutrientPageState();
}

class _NutrientPageState extends State<NutrientPage> {
  @override
  Widget build(BuildContext context) {

    List nutrients = [
      {'title': 'weight loss', 'isActive': false},
      {'title': 'weight gain', 'isActive': false},
      {'title': 'low cholesterol', 'isActive': false},
      {'title': 'low sugar', 'isActive': false},
      {'title': 'diabetic', 'isActive': false},
      {'title': 'vegan', 'isActive': false},
      {'title': 'keto', 'isActive': false},
      {'title': 'paleo', 'isActive': false},
      {'title': 'low carb', 'isActive': false},
      {'title': 'increase protein', 'isActive': false},
      {'title': 'gluten free', 'isActive': false},
      {'title': 'more nutrients', 'isActive': false},
      {'title': 'more iron', 'isActive': false},
      {'title': 'maintain weight', 'isActive': false},
      {'title': 'balanced diet', 'isActive': false},
    ];

    return Scaffold (
      backgroundColor: Color(hexToInteger('FFF5F3ED')),

      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            Center(
              child: Image.asset('lib/images/graphic1.jpg', width: 200,
                                        height: 100,),
            ),

            SizedBox(height: 20),

            Container(
                decoration: BoxDecoration(
                  borderRadius : BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                boxShadow : [BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                    offset: Offset(4,4),
                    blurRadius: 4
                )],  
              ),
            ),
          ],
        ),
      ),
    );

    

  }
}