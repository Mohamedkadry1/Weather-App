import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:weather_app/view/page/home_page.dart';
import 'package:weather_app/view/splashPage/splash_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      home: SplashScreen(),
    );
  }
}
