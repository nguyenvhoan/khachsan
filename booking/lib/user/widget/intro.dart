import 'package:booking/ui/button_confirm_landing.dart';
import 'package:booking/user/widget/signIn.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Intro extends StatelessWidget {
  const Intro({super.key, required this.onGetStarted});
  final VoidCallback  onGetStarted;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        alignment: Alignment.center,
         height:MediaQuery.of(context).size.height / 1.8 ,
        decoration:const BoxDecoration(
            
              color: Colors.white   ,
              borderRadius:BorderRadius.only(
                topLeft: Radius.circular(30), 
                topRight: Radius.circular(30), 
              ),
            ),
        child: Container(
          alignment: Alignment.center,
          
          child: Column(
            crossAxisAlignment:CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: const Text("''Find your perfect stay in just a few tap! Book hotels effortlessly with our app.''",
                textAlign: TextAlign.center,
                
                style: TextStyle(fontWeight:FontWeight.bold,
                fontSize: 20),),
              ),
              const SizedBox(height:100,),
              ButtonConfirmLanding(onGetStarted: onGetStarted,textTitle: 'Get Started'),
              const SizedBox(height:40,),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ", textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),
                    ),
                    Text(" Sign in", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff57A5EC),
                      fontSize: 18
                    ),),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}