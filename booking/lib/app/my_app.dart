import 'package:booking/Management/Dashboard.dart';
import 'package:booking/app/adminManager.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Dashboard(),
    );
  }
}