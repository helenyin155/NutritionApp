import 'package:flutter/material.dart';

void main() {
  runApp(TabBarApp());
}

class TabBarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TabBar Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TabBarDemo(),
    );
  }
}

class TabBarDemo extends StatefulWidget {
  @override
  _TabBarDemoState createState() => _TabBarDemoState();
}

class _TabBarDemoState extends State<TabBarDemo> {
  final List<Tab> tabs = <Tab>[
    Tab(text: 'Tab 1'),
    Tab(text: 'Tab 2'),
    Tab(text: 'Tab 3'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('TabBar Demo'),
          bottom: TabBar(
            tabs: tabs,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 2.0, color: Colors.blue),
            ),
          ),
        ),
        body: TabBarView(
          children: tabs.map((Tab tab) {
            return Center(
              child: Text(
                'Content for ${tab.text}',
                style: TextStyle(fontSize: 20.0),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
