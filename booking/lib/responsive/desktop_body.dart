import 'package:booking/responsive/mobileapp_body.dart';
import 'package:booking/responsive/responsive_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyDesktopBody extends StatelessWidget {
  const MyDesktopBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(mobileBody: MyMobileAppBody(), desktopApp: MyDesktopBody()),
    );
  }
}