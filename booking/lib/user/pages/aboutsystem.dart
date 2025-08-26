import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AboutApp extends StatefulWidget {
  const AboutApp({super.key});

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset('asset/images/icons/icon_back.png'),
        ),
        title: const Text(
          'About Us',
          style: TextStyle(
            fontFamily: 'Candal',
            color: Color(0xff51A7BF),
            fontSize: 32,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children:[ Container(
            margin: EdgeInsets.only(top: 10),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20)
            ),
            width: 310,
            height: 201,
            child: AnotherCarousel(
              boxFit: BoxFit.cover,
              showIndicator: false,
              images: [
                AssetImage("asset/images/icons/intro.gif", 
               ),
              ],
            )
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text('Welcome to Paradise Hotel', style: TextStyle(
              color: Color(0xff51A7BF),
              fontSize: 22,
              fontFamily: 'Candal'
            ),),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text('Nestled in the heart of the city, Paradise Hotel offers a perfect blend of luxury and comfort. Our elegantly designed rooms provide breathtaking views and modern amenities to ensure a relaxing stay for every guest. With a commitment to exceptional service, our friendly staff is dedicated to making your visit memorable. Enjoy our on-site restaurant, featuring a diverse menu of local and international cuisine, or unwind at our rooftop bar with stunning sunset views. Whether you’re here for business or leisure, Paradise Hotel is your home away from home, where every detail is crafted for your enjoyment.',
            style: TextStyle(color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 17),textAlign: TextAlign.center,),
          )
          ]
        ),
      ),
    );
  }
}