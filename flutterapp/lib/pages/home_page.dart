import "package:flutter/material.dart";
import "package:flutterapp/pages/body_page.dart";
import "package:flutterapp/pages/camera_page.dart";
import "package:flutterapp/pages/profile_page.dart";
import "package:flutterapp/pages/tracker_page.dart";

int hexToInteger(String hex) => int.parse(hex, radix: 16);

extension StringColorExtensions on String {
  Color toColor() => Color(hexToInteger(this));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageList = [
    BodyHome(),
    TrackerPage(),
    CameraPage(),
    ProfilePage(),
  ];

  void handleLogOut() {}

  int _selectedIndex = 0;

  void _handleNavigation(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(hexToInteger('FFF5F3ED')),
      appBar: AppBar(
        leading: Icon(Icons.account_circle, size: 40.0, color: Colors.black),
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
      body: Center(child: _pageList[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _handleNavigation,
        iconSize: 32.0,
        fixedColor: Colors.black,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Tracker'),
          BottomNavigationBarItem(icon: Icon(Icons.document_scanner), label: 'Camera'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
