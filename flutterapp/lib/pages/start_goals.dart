import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterapp/auth.dart';

int hexToInteger(String hex) => int.parse(hex, radix: 16);

extension StringColorExtensions on String {
  Color toColor() => Color(hexToInteger(this));
}

class StartGoals extends StatefulWidget {
  const StartGoals({super.key});

  @override
  State<StartGoals> createState() => _StartGoalsState();
}

class _StartGoalsState extends State<StartGoals> {
  @override
  Widget build(BuildContext context) {
    List options = [
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

    changeState(item) {
      setState(() {
        item['isActive'] = !item['isActive'];
      });
    }

    customBoxDecoration(isActive) {
      return BoxDecoration(
        color: isActive ? Color(0xff1763DD) : Colors.white,
        border: Border(
          left: BorderSide(color: Colors.black12, width: 1.0),
          bottom: BorderSide(color: Colors.black12, width: 1.0),
          top: BorderSide(color: Colors.black12, width: 1.0),
          right: BorderSide(color: Colors.black12, width: 1.0)),
          borderRadius: const BorderRadius.all(
          Radius.circular(5.0),
        ),
      );
    }

    return Scaffold (
      backgroundColor: Color(hexToInteger('FFF5F3ED')),

      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            SizedBox(height: 15),
            Text(
                'choose your nutritional goals to get started: ',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            SizedBox(height: 20.0),

            Wrap(
              spacing: 5.0,
              runSpacing: 5.0,
              children: options
                .map((option) => new Container(
                  margin: EdgeInsets.all(5),
                  decoration: customBoxDecoration(option['isActive']),
                    child: InkWell(
                      onTap: () {
                          changeState(option);
                      },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Text('${option['title']}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: option['isActive'] ? Colors.white : Colors.black87)
                      )
                    )
                  )
                )
                )
                .toList()
            ), 

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                //
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFA8C8D7), // A8C8D7 color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Colors.black.withOpacity(0.1), width: 3.0), // slight border
                ),
              ),
            child: Text(
              'continue',
                style: TextStyle(fontSize: 18.0, color: Colors.black),
                ),
              ),
                  
          ],
        ),
      ),

    );

    

  }
}