import 'package:flutter/material.dart';
import 'package:heart_rate/pages/home.dart';
import 'package:heart_rate/pages/profile.dart';
import 'package:heart_rate/pages/settings.dart';
import 'package:heart_rate/pages/heartSensor.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/home',
    routes: {
      '/home': (context) => Home(),
      '/profile': (context) => Profile(),
      '/settings': (context) => Settings(),
      '/heart': (context) => HomePage(),
    }
));
