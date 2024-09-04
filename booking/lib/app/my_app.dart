import 'package:booking/Management/Dashboard.dart';
import 'package:booking/app/adminManager.dart';
import 'package:booking/user/pages/home_page.dart';
import 'package:booking/user/pages/intro_page.dart';
import 'package:booking/user/widget/intro.dart';
import 'package:booking/user/widget/navigation_menu.dart';
import 'package:booking/user/widget/signIn.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NavigationMenu(),
      theme: ThemeData(
        primaryColor: Colors.white, 
        appBarTheme:const AppBarTheme(
          backgroundColor: Color(0xff3CA0B6), // Màu nền của AppBar
          foregroundColor: Colors.white, // Màu chữ trong AppBar
        ),
        scaffoldBackgroundColor: Colors.white, // Màu nền cho toàn bộ Scaffold
      ),
    );
  }
}