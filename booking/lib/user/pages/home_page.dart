import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
   HomePage({super.key});
final FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return  Scaffold(
      appBar: AppBar
        (
          title:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Chữ "Otelia" nằm ở góc trái
              Text(
                'Otelia',
                style: TextStyle(
                  fontFamily: 'Candal',
                  color: Color(0xff3CA0B6),
                  fontSize: 35,
                ),
              ),
              // Biểu tượng nằm ở góc phải
              IconButton(
                onPressed: () {},
                icon: Image.asset('asset/images/icons/tb.png'),
              ),
            ],
          ),
      ),
      body: Column(
        
        children: [
            Container(
              margin: EdgeInsets.all(15),
              child: Center(
                child: Image.asset('asset/images/icons/background.png',
                fit: BoxFit.cover,),
              )
              ),
              Container(
                margin: EdgeInsets.all(15),
                child:const Row
                (
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Row(
                    children: [
                      Text('Popular ',
                      style: TextStyle(
                        fontFamily: 'Candal',
                        fontSize: 20,
                        color: Color(0xff57A5EC),
                      ),
                      ),
                      Text('Room',
                      style: TextStyle(
                        fontFamily: 'Candal',
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      ),
                    ],
                  ),
                  Text('See All', style: TextStyle(color: Color(0xff57A5EC), fontSize: 15),)
                  ] 
                ),
              ),
              StreamBuilder(
                stream: db.collection('Room').snapshots(),
               builder: (context, snapshot){
                QuerySnapshot querySnapshot = snapshot.data!;
                
                
                  if(snapshot.hasData){
                      return SingleChildScrollView(
                        child: Wrap(
                          children: snapshot.data!.docs.map<Widget>((documentSnapshot) {
                            Map<String, dynamic> thisItem =
                              documentSnapshot.data() as Map<String, dynamic>;
                              print(thisItem);
                              return Container(
                                margin: EdgeInsets.only(right: 10),
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
                            width: size.width/2.3,
                            height:size.height/3.5,
                            child: Container(
                              margin:   EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    
                                      width: size.width/3,
                                      height:size.width/4,
                                      decoration: BoxDecoration(
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
                                        
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(documentSnapshot['roomType'],
                                          style: TextStyle(
                                            fontFamily: 'Candal',
                                            fontSize: 15,
                                            color: Colors.black
                                          ),),
                                          Row(
                                            children: [
                                              Image.asset('asset/images/icons/Star.png'),
                                              Text('  4.8')
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Text(documentSnapshot['price'].toString() +"/ night",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: Color(0xff57A5EC),
                                    ),),
                                    SizedBox(height: 10,),
                                    GestureDetector(
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
                                ],
                              ),
                            ),
                          );
                          }).toList()
                           
                        ),
                      );
                  }
                  return Container();
               }
               
               ),
              
        ]
        
      ),
    );
  }
}