
import 'package:booking/user/widget/navigation_menu.dart';

import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NavigationMenu(),
      // home: NavigationMenu(),
      theme: ThemeData(
        primaryColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white, // Màu nền của AppBar
           // Màu chữ trong AppBar
        ),
        scaffoldBackgroundColor: Colors.white, // Màu nền cho toàn bộ Scaffold
      ),
    );
  }
}
