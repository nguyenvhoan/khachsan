import 'package:booking/model/database_service.dart';
import 'package:booking/user/pages/detail_voucher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class VoucherPage extends StatefulWidget {
   VoucherPage({super.key , required this.account});
var account;
  @override
  State<VoucherPage> createState() => _VoucherPageState();
}

class _VoucherPageState extends State<VoucherPage> {
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
    return Scaffold(
    backgroundColor: Colors.white,
      appBar: AppBar(
          surfaceTintColor: Colors.white,
          foregroundColor: Colors.white,
          backgroundColor: Colors.white,
          title:const Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             Text(
                'Voucher',
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
                    stream: db.collection('Discount').snapshots(),
                   builder: (context, snapshot){  
                      if(snapshot.hasData){
                          return SingleChildScrollView( 
                            scrollDirection:Axis.vertical,   
                            child: Column(
                              children: snapshot.data!.docs.map<Widget>((documentSnapshot) {
                                
                                Map<String, dynamic> thisItem = documentSnapshot.data() as Map<String, dynamic>;
                                  print('data              '+thisItem!['img']);
                                  return Container(
                                    
                                     margin: EdgeInsets.only(right:30,left:30,bottom:10, top:10),
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
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,                           
                                      children: [
                                        Container(                                      
                                            width : size.width / 2.8, 
                                          
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
                                          Expanded(
                                            child: Column(
                                              children:[
                                                 
                                                 Text(documentSnapshot['name'],
                                                style:const TextStyle(
                                                  fontFamily: 'Candal',
                                                  color: Color(0xff57A5EC),
                                                  fontSize: 15,
                                                  
                                                ),overflow: TextOverflow.ellipsis,
                                                maxLines: 2,softWrap: true,
                                                ),
                                                 SizedBox(height: 5,),
                                              
                                              
                                                 Text(documentSnapshot['introduc'],
                                                style:const TextStyle(
                                                  fontWeight: FontWeight.bold,  
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  
                                                ),overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                softWrap: true,
                                                ),
                                                SizedBox(height: 5,),
                                                GestureDetector(
                                                  onTap: (){
                                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailVoucher(codeVoucher: documentSnapshot.id, account: widget.account,)));
                                                  },
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
                                              
                                            
                                              ]
                                            ),
                                          )
                                              ] 
                                          ),
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