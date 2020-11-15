import 'package:flutter/material.dart';
import 'package:heart_rate/pages/heartSensor.dart';
import 'package:heart_rate/pages/home.dart';
import 'package:heart_rate/pages/profile.dart';

class Menu extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Menu> {

  int _currentIndex = 0;
  final tabs = [
    Home(),
    HeartSensor(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        iconSize: 20,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Scan',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
            backgroundColor: Colors.blue,
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}