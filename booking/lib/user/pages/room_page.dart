import 'package:booking/model/database_service.dart';
import 'package:booking/user/pages/detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RoomPage extends StatefulWidget {
   RoomPage({super.key, required this.account});
var account;
  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  DatabaseService  _databaseService  =DatabaseService();
  final FirebaseFirestore db = FirebaseFirestore.instance;
  List<String> services = [];
  @override
  void initState() {
    super.initState();
    fetchServices();
    
  }
Future<void> fetchServices() async {
    List<String> fetchedServices = await _databaseService.getService();
    setState(() {
      services = fetchedServices;
    });
    print(services);
  }
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
              
             Text(
                'Room',
                style: TextStyle(
                  fontFamily: 'Candal',
                  color: Color(0xff3CA0B6),
                  fontSize: 35,
                ),
              ),
              
               
            ],
          ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15), 
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                    stream: db.collection('Room').snapshots(),
                   builder: (context, snapshot){  
                      if(snapshot.hasData){
                          return SingleChildScrollView( 
                            scrollDirection:Axis.vertical,   
                            child: Column(
                              children: snapshot.data!.docs.map<Widget>((documentSnapshot) {
                                
                                Map<String, dynamic> thisItem = documentSnapshot.data() as Map<String, dynamic>;
                                  print('data              '+thisItem!['img']);
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
                                    mainAxisAlignment: MainAxisAlignment.start,                           
                                    children: [
                                      Container(                                      
                                          width : size.width / 1.3, 
                                        
                                          height:size.height/6,
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
                                                  size: 10)
                                              : null,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Row(
                                            mainAxisAlignment:MainAxisAlignment.center,
                                            children: [
                                              Text(documentSnapshot['roomType'],
                                              maxLines: 1,
                                              textAlign: TextAlign.center ,
                                              style:const TextStyle(
                                                fontFamily: 'Candal',
                                                fontSize: 18,
                                                color: Colors.black
                                              ),),
                                            ],
                                          ),
                                        ),
                                        
                                        
                                          const SizedBox(height: 10,),
              
                                         Padding(
                                              padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded( // Sử dụng Expanded để chiếm không gian
                                                    child: SingleChildScrollView(
                                                      scrollDirection: Axis.horizontal,
                                                      child: Row(
                                                        children: services.map((service) {
                                                          return Container(
                                                            margin: EdgeInsets.symmetric(horizontal: 5),
                                                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                                            decoration: BoxDecoration(
                                                              color: Colors.black,
                                                              borderRadius: BorderRadius.circular(20),
                                                            ),
                                                            child: Text(
                                                              service,
                                                              overflow: TextOverflow.ellipsis, // Đảm bảo chữ không bị tràn
                                                              style: TextStyle(color: Colors.white),
                                                            ),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ),
                                                  ),
                                                 
                                            ] 
                                             ),
                                          ),
                                          GestureDetector(
                                            onTap:  (){
                                              print('Số phòng :'+documentSnapshot.id);
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPage(codeRoom: documentSnapshot.id,account: widget.account,),));
                                            },
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
                                            SizedBox(height: 5,),
                                        Container(
                                          height: 1,
                                          width: size.width/1.6,
                                          color: Colors.grey
                                        ),
                                         Padding(
                                          padding: EdgeInsets.only( left: 20,right: 20),
                                           child: Row(          
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                                             children: [
                                              Row(
              
                                                children:[
                                                  Text(documentSnapshot['price'].toString() ,              
                                                style:const TextStyle(
                                                  color: Color(0xff57A5EC),
                                                  fontSize: 20,
                                                  fontFamily: 'Cantral'
                                                ),
                                                
                                                ),
                                                Text('/ night', style: TextStyle(color: Colors.grey,fontFamily: 'Cantral', fontSize: 20),)
              
                                                ] 
                                              ),
                                              Row( 
                                                crossAxisAlignment: CrossAxisAlignment.center   ,
                                                children: [
                                                  Image.asset('asset/images/icons/Star.png'),
                                                  Text('  4.8')
                                                ],
                                              )
                                             ]
                                           ),
                                         ),
                                          ] 
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
            ),

          ],
          
        ),
      ),
    );
  }
}