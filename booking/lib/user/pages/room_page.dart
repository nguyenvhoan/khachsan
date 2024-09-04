import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RoomPage extends StatelessWidget {
   RoomPage({super.key});

  final FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return  Scaffold(
      backgroundColor: Colors.white,   
      appBar: AppBar(
          surfaceTintColor: Colors.white,
          foregroundColor: Colors.white,
          backgroundColor: Colors.white,
          title:const Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Chữ "Otelia" nằm ở góc trái
             Text(
                'Room',
                style: TextStyle(
                  fontFamily: 'Candal',
                  color: Color(0xff3CA0B6),
                  fontSize: 35,
                ),
              ),
              // Biểu tượng nằm ở góc phải
               
            ],
          ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          
          children: [
            
                StreamBuilder(
                  stream: db.collection('Room').snapshots(),
                 builder: (context, snapshot){  
                    if(snapshot.hasData){
                        return SingleChildScrollView(    
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            direction: Axis.vertical,
                            children: snapshot.data!.docs.map<Widget>((documentSnapshot) {
                              Map<String, dynamic> thisItem =
                                documentSnapshot.data() as Map<String, dynamic>;
                                
                                return Container(
                                   margin: EdgeInsets.all(30),
                                decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), 
                                    spreadRadius: 5,
                                    blurRadius: 7, 
                                    offset: Offset(0, 3), 
                                  ),
                                ],
                                
                              ),
                              
                              child: Container(
                               
                                child: Column(
                                  
                                  children: [
                                    Container(
                                      
                                        constraints: BoxConstraints(
                                        maxWidth: size.width / 1.25, // Sử dụng maxWidth thay vì width cố định
                                      ),
                                        height:size.height/9,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          image: thisItem['img'] != null
                                              ? DecorationImage(
                                                  image: NetworkImage(thisItem['img']),
                                                  fit: BoxFit.cover,
                                                )
                                              : null,
                                          color: Colors.transparent,
                                          
                                        ),
                                        child: thisItem['img'] == null
                                            ? const Icon(Icons.image,
                                                size: 50) // Thay đổi kích thước icon nếu cần
                                            : null,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(documentSnapshot['roomType'],
                                            textAlign: TextAlign.center,
                                            style:const TextStyle(
                                              fontFamily: 'Candal',
                                              fontSize: 15,
                                              color: Colors.black
                                            ),),
                                            
                                          ],
                                        ),
                                      ),
                                      Text(documentSnapshot['price'].toString() +"/ night",
                                      textAlign: TextAlign.center,
                                      style:const TextStyle(
                                        color: Color(0xff57A5EC),
                                      ),),
                                        const SizedBox(height: 10,),
                                      GestureDetector(
                                        child: Center(
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text('View More', textAlign:TextAlign.center,
                                            style: TextStyle(fontWeight:FontWeight.bold, color: Colors.white),
                                            ),
                                            height: 26,
                                            width: 127,
                                            decoration: BoxDecoration(
                                              color: Color(0xff1A4368),
                                              borderRadius: BorderRadius.circular(25)
                                              ),
                                          
                                            ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                            }).toList()
                             
                          ),
                        );
                    }
                    else
                    {
                     return Center(child: CircularProgressIndicator());
                    }
                    
                 }
                 
                 ),
                
          ]
          
        ),
      ),
    );
  }
}