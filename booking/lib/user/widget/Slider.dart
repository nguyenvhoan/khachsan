import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SliderPage extends StatelessWidget {
  final String title;
  final String description;
  final String image;

   SliderPage({required this.title, required this.description, required this.image});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      height: MediaQuery.of(context).size.height/2,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          
          const SizedBox(
            height: 60,
          ),
          Text(
            title,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
           const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80),
            child: Text(
              description,
              style:const TextStyle(
                height: 1.5,
                fontWeight: FontWeight.normal,
                fontSize: 14,
                letterSpacing: 0.7,
              ),
              textAlign: TextAlign.center,
            ),
          ),
         const SizedBox(
            height: 60,
          ),
        ],
      ),
    );
  }
}