import 'package:flutter/material.dart';

class IntroAdmin extends StatefulWidget {
  const IntroAdmin({super.key});

  @override
  State<IntroAdmin> createState() => _IntroState();
}

class _IntroState extends State<IntroAdmin> {
  @override
  Widget build(BuildContext context) {
    Size size =MediaQuery.sizeOf(context);
    return Scaffold(
      
      body: Container(
        decoration:const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 0, 0, 0), // Màu bắt đầu
                Color.fromARGB(255, 33, 0, 27), // Màu kết thúc
              ],
              begin: Alignment.topCenter, // Điểm bắt đầu
              end: Alignment.bottomCenter, // Điểm kết thúc
            ),
          ),
        child: Center(
          child: 
        Column(children:[
         Padding(
          padding: EdgeInsets.only(top: 40, bottom: 40),
           child: Text('Welcome!!!!!!!!!!!!!!!!!!!!!!!', style: TextStyle(
            fontFamily: 'Candal',
            color: Colors.white,
            fontSize: 22
           ),),
         ),
         Image.asset('asset/images/icons/welcome2.gif')
         ]),
        ),
      ),
    );
  }
}