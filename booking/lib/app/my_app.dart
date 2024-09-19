import 'package:booking/Management/Dashboard.dart';
import 'package:booking/user/pages/Test.dart';
import 'package:booking/user/pages/intro_page.dart';


import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OneNotification(
      builder: (_, __) =>MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Landing(),
        theme: ThemeData(
          primaryColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white
          ),
          scaffoldBackgroundColor: Colors.white
        ),
        builder: OneContext().builder,navigatorKey: OneContext().key,
      )

      // backgroundColor: Color(0xff3CA0B6), // Màu nền của AppBar
      // foregroundColor: Colors.white, // Màu chữ trong AppBar

      
    );
  }
}
