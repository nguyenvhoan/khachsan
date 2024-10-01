import 'package:booking/model/database_service.dart';
import 'package:booking/user/pages/detail_voucher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



class BookingHistory extends StatefulWidget {
   BookingHistory({super.key , required this.account, required this.type});
var account, type;

  @override
  State<BookingHistory> createState() => _BookingHistoryState();
}

class _BookingHistoryState extends State<BookingHistory> {
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
  String formatDate(DateTime dateTime) {
  return DateFormat('EEEE, dd/MM').format(dateTime);
}

  @override
  Widget build(BuildContext context) {
    print('-----------------------------------------------------------------------');
    print('type booking :${widget.type}');
    print('-----------------------------------------------------------------------');
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
    backgroundColor: Colors.white,
      appBar: AppBar(
          
          centerTitle: true,
          leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);},
             child: Image.asset( 'asset/images/icons/icon_back.png')),
          title:const Text(
                'Booking History',
                style: TextStyle(
                  fontFamily: 'Candal',
                  color: Color(0xff3CA0B6),
                  fontSize: 32  ,
                ),
              ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15), 
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                    stream: db.collection('Request').where('idUser', isEqualTo: widget.account, ).where('requestType', isEqualTo: widget.type).snapshots(),
                   builder: (context, snapshot){  
                      if(snapshot.hasData){
                          return SingleChildScrollView( 
                            scrollDirection:Axis.vertical,   
                            child: Column(
                              children: snapshot.data!.docs.map<Widget>((documentSnapshot) {
                                
                                Map<String, dynamic> thisItem = documentSnapshot.data() as Map<String, dynamic>;
                                  print('data              '+thisItem!['img']);
                                  Timestamp timestamp = documentSnapshot['time'];
                                  DateTime dateTime = timestamp.toDate(); 
                                  String formattedDate = formatDate(dateTime);
                                  print('data              '+formattedDate);
                                  return Container(
                                    
                                     margin: EdgeInsets.only(right:10,left:10,bottom:10, top:10),
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
                                    padding: EdgeInsets.only(left: 10, right: 10, ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,                           
                                      children: [
                                        Container(      
                                          margin: EdgeInsets.only(top: 10,bottom: 10),                                
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
                                            child: Padding(
                                            padding: EdgeInsets.only(left: 10),

                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children:[
                                                     Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                     Text(
                                                    formattedDate,
                                                   style:const TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xffBEBCBC)
                                                    ),
                                                   ),
                                                  GestureDetector(
                                                    child: Icon(Icons.menu),
                                                  )
                                                    ],
                                                    ),
                                                   
                                                   const Text('Successful booking payment',
                                                   textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff57A5EC),
                                                    fontSize: 19,
                                                    
                                                  ),overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,softWrap: true,
                                                  ),
                                                   SizedBox(height: 5,),
                                                  Text('Room type: ${documentSnapshot['roomType']}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10
                                              
                                                  ),
                                                  ),
                                                  SizedBox(height: 5,),
                                                  const Text('Quantity: 1',
                                                  style:  TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10
                                              
                                                  ),
                                                  ),
                                                  SizedBox(height: 5,),
                                                  const Text('Click to see more!',
                                                  style:  TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10
                                              
                                                  ),
                                                  ),
                                                  
                                                
                                                   
                                                  
                                                
                                              
                                                ]
                                              ),
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