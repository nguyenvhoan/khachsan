import 'package:booking/user/pages/table_page.dart';
import 'package:flutter/material.dart';

class RestaurantPage extends StatelessWidget {
  const RestaurantPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height:   double.infinity ,
        child: Stack(
          fit: StackFit.loose,
          children: [
            Container(
              child: Image.asset('asset/images/icons/restaurant.png'),
            ),
            Positioned(
             top: 300,
            child: Container(
               decoration:const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50), // Bo tròn góc trên bên trái
                    topRight: Radius.circular(50), // Bo tròn góc trên bên phải
                  ),
                ),
              height: MediaQuery.sizeOf(context).height/1.8,
              width:  MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    '‘Welcome to Otelia’',
                  style: TextStyle(
                    fontFamily:   'Candal',
                    color: Color(0xff3CA0B6),
                    fontSize: 23,
                  ),
                  ),
                  const Text(
                    'Where high food meets cozy atmosphere!',
                    maxLines: 2,
                    textAlign:  TextAlign.center,
                  style: TextStyle(
                    fontFamily:   'Candal',
                    color: Color(0xff1A4368),
                    fontSize: 23,
                    
                    
                  ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(58, 143, 145, 130),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Padding(
                      padding:const  EdgeInsets.all(10),
                      child: Column(
                        children:[ 
                         const Text("At Otelia, indulge in exquisite dishes made from the freshest, locally sourced ingredients. Our talented chefs combine traditional techniques with modern flair, creating a menu that delights the senses. Experience exceptional dining in a luxurious and cozy setting, perfect for any occasion. Let us make your meal unforgettable.",
                        maxLines: 8,
                        textAlign: TextAlign.center,
                        style:  TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 20,),
                        const Text("You can adjust the name or any details to better fit your restaurant's style!",
                        maxLines: 8,
                        textAlign: TextAlign.center,
                        style:  TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10,),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>TablePage()));
                          },
                          child: Container( 
                            
                            width: 250,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xff1A4368),
                              borderRadius: BorderRadius.circular(30)
                            ),
                            child:const Center(
                              child: Text('Book a table now', textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 21),),
                            ),
                          ),
                        )
                        ]
                      ),
                    )
                  )
                ],
              ),
            )
            )
          ],
        ),
      ),
    );
  }
}