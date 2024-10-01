import 'package:booking/model/database_service.dart';
import 'package:booking/user/pages/dining_table.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TablePage extends StatefulWidget {
   TablePage({super.key, required this.account});
  var account;

  @override
  State<TablePage> createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  @override
  Widget build(BuildContext context) {
    DatabaseService  _databaseService  =DatabaseService();
  final FirebaseFirestore db = FirebaseFirestore.instance;
  Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:const Text('    Types of dining tables', textAlign: TextAlign.center,) 
      ),
      body: 
       Expanded(
        child: StreamBuilder(
          stream: db.collection('TableType').snapshots(),
          builder: (context, snapshot){
            if(snapshot.hasData){
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: snapshot.data!.docs.map<Widget>((documentSnapshot){
                   Map<String, dynamic> thisItem =
                                documentSnapshot.data() as Map<String, dynamic>;
                     return  Container(
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
                      child: GestureDetector(
                        onTap: (){
                                Navigator.push(context,
                                MaterialPageRoute(builder: (context)=>DiningTable(table: thisItem,account: widget.account,)));
                              },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              
                                 Container(
                                          margin: EdgeInsets.only(right: 10),
                                            width: size.width/3,
                                            height:size.height/7,
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
                                padding:const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Row(children: [
                                      Text('Table type : ', style:TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                                    ]),
                                    Text(documentSnapshot['tabletype'], style:  TextStyle(fontSize: 19, color: Color(0xff1A4368)),),
                                    Row(children:[
                                     const Text('Giá: ', style:TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Color(0xff57A5EC)),
                                      ),
                                      SizedBox(height: 50,),
                                      Text(documentSnapshot['price'].toString(),style: TextStyle(fontSize: 19),)
                                    ] 
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                }
                ).toList(),
              )
            );
            }
            else{
              return Center(child: CircularProgressIndicator(),);
            }
          }),
      )
        
      
    );
  }
}