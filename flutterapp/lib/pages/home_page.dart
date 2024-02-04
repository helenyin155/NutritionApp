import "package:flutter/material.dart";

int hexToInteger(String hex) => int.parse(hex, radix: 16);

extension StringColorExtensions on String {
  Color toColor() => Color(hexToInteger(this));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

void handleLogOut() {

}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(hexToInteger('FFF5F3ED')),
      appBar: AppBar(
        leading: Icon(
          Icons.account_circle,
          size: 40.0,
          color: Colors.black),
        title: Text("Logo Placeholder"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: handleLogOut,
              child: Icon(
                Icons.logout,
                size: 32.0,
              ),
            ),
          )
        ],
      ),
      body: Center()
    );
  }
}