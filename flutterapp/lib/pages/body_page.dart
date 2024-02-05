import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

int hexToInteger(String hex) => int.parse(hex, radix: 16);

extension StringColorExtensions on String {
  Color toColor() => Color(hexToInteger(this));
}

class TestAPI extends StatefulWidget {
  const TestAPI({super.key});

  @override
  State<TestAPI> createState() => _TestAPIState();
}

class _TestAPIState extends State<TestAPI> {
  Future<String> fetchTest() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:5000/test'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("There was an error fetching data.");
    }
  }

  Future<http.Response> postTest(String text) {
    return http.post(
      Uri.parse('http://127.0.0.1:5000/test-post'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': text,
      }),
    );
  }

  final apiPostController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Center(
          child: TextButton(
            child: Text("Test GET"),
            onPressed: () async {
              String temp = await fetchTest();
              print(temp);
            },
          ),
        ),
        Center(
            child: Column(
          children: [
            TextButton(
              child: Text("Test POST"),
              onPressed: () {
                postTest(apiPostController.text);
              },
            ),
            TextField(
              controller: apiPostController,
              decoration: InputDecoration(border: OutlineInputBorder()),
            )
          ],
        )),
      ],
    ));
  }
}

class BodyHome extends StatefulWidget {
  const BodyHome({super.key});

  @override
  State<BodyHome> createState() => _BodyHomeState();
}

class _BodyHomeState extends State<BodyHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(hexToInteger('FFF5F3ED')), body: TestAPI());
  }
}
