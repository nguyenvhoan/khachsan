import 'package:flutter/material.dart';

class Intro extends StatelessWidget {
  const Intro({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
        border: Border.all(
                color: Colors.grey, 
                width: 2,
              ),
              color: Colors.white,
              borderRadius:const BorderRadius.only(
                topLeft: Radius.circular(30), 
                topRight: Radius.circular(30), 
              ),
            ),
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.center,
        
          children: [
            const SizedBox(height: 70,),
            const Text("Find your perfect stay in just a few tap! Book hotels effortlessly with our app.",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight:FontWeight.bold),),
            const SizedBox(height:30,),
            GestureDetector(
              child: Container(
                alignment: Alignment.center,
                child: Text('Get Started', textAlign:TextAlign.center,
                style: TextStyle(fontWeight:FontWeight.bold, color: Colors.white),
                ),
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  color: Color(0xff1A4368),
                  borderRadius: BorderRadius.circular(25)
                  ),
              
                ),
            ),
            const SizedBox(height:30,),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?", textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),),
                  Text("Sign in", style: TextStyle(
                    color: Color(0xff57A5EC),
                  ),),

                ],
              )
            

          ],
        ),
      ),
    );
  }
}