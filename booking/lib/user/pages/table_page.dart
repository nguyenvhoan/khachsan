import 'package:booking/model/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TablePage extends StatelessWidget {
  const TablePage({super.key});

  @override
  Widget build(BuildContext context) {
    DatabaseService  _databaseService  =DatabaseService();
  final FirebaseFirestore db = FirebaseFirestore.instance;
    return Scaffold(
      appBar: AppBar(
        title:const Text('    Types of dining tables', textAlign: TextAlign.center,) 
      ),
      body: Expanded(
        child: StreamBuilder(
          stream: db.collection('Restaurant').snapshots(),
          builder: (context, snapshot){
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: snapshot.data!.docs.map<Widget>((documentSnapshot){
                  
                    return Container(
                      margin:EdgeInsets.all(15),
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2), 
                                    spreadRadius: 1,
                                    blurRadius: 7, 
                                    offset: Offset(0, 5), 
                                  ),
                                ],
                      ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Image.asset('asset/images/icons/table.png'),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    Text('Số bàn: ', style:TextStyle(fontSize: 19, fontWeight: FontWeight.bold),),
                                    Text(documentSnapshot['id'],style: TextStyle(fontSize: 19),)
                                  ]),
                                  Text('Bàn dành cho '+documentSnapshot['quant'].toString()+' người', style:  TextStyle(fontSize: 19, color: Color(0xff1A4368)),),
                                  Row(children:[
                                    Text('Giá: ', style:TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Color(0xff57A5EC)),
                                    ),
                                    Text(documentSnapshot['price'].toString(),style: TextStyle(fontSize: 19),)
                                  ] 
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                }
                ).toList(),
              )
            );
          }),
      )
        
      
    );
  }
}