import 'package:flutter/material.dart';

class ButtonConfirmLanding extends StatelessWidget {
   ButtonConfirmLanding({super.key, required this.onGetStarted, required this.textTitle});
  final VoidCallback onGetStarted;
  String textTitle;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: 
        onGetStarted,
      
      child: Container(
        alignment: Alignment.center,
        height: 55,
        width: 250,
        decoration: BoxDecoration(
          color: const Color(0xff1A4368),
          borderRadius: BorderRadius.circular(25),
        ),
        child: const Text(
          'Get Started',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}