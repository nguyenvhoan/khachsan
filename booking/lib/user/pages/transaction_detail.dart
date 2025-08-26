import 'package:booking/model/database_service.dart';
import 'package:booking/user/widget/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class TransactionDetail extends StatefulWidget {
   TransactionDetail({super.key,  required this.id, required this.account});

String id;
String account;
  @override
  State<TransactionDetail> createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {
  Map<String,dynamic>? req;
  DatabaseService _databaseService= DatabaseService();
  @override
  void initState() {
    super.initState();
    
    fetch();
  }
  Future<void> fetch() async{
  Map<String, dynamic>? a = await _databaseService.getBookingById(widget.account,widget.id);
  setState(() {
    req =a;
  });
}
  @override
  Widget build(BuildContext context) {
    String formatNumber(int number) {
    final formatter = NumberFormat('#,##0');
    return formatter.format(number);
  }NumberFormat numberFormat = NumberFormat('#,##0', 'vi_VN');
    return 
    Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed:(){
          Navigator.push(context,MaterialPageRoute(builder: (context)=>NavigationMenu(account: widget.account)));
        }, icon: const Icon(Icons.home)),
        title: const Text('   Transaction Details', textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Candal',
          color: Color(0xff3CA0B6)
        ),),
      ),
      body: req==null 
      ? const Center(
              child: CircularProgressIndicator(),
            )
      : Container(
        width: double.infinity,
        height: double.infinity,
        decoration:const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xffFFFFFF), // Màu bắt đầu
                Color(0xff999999), // Màu kết thúc
              ],
              begin: Alignment.topCenter, // Điểm bắt đầu
              end: Alignment.bottomCenter, // Điểm kết thúc
            ),
          ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(30),
                width: double.infinity,
                
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  children:[ Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                       border: Border.all(
                        color: const Color(0xff57A5EC), // Màu viền
                        width: 1, // Độ dày của viền
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 30),
                      child:  Column(
                        children: [
                          const Text('Book a hotel room',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20
                          ),),
                          Text(numberFormat.format(req!['price'] ) +'VND', 
                          style:const TextStyle(
                            color: Colors.black,
                            fontSize: 20
                          ),)
                        ],
                      ),
                    ),
                    
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20,right: 20,left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                    const Text('Status',
                    style: TextStyle(fontSize: 20, color: Colors.grey),),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xff94E19B),
                    
                      ),
                      child:const Padding(
                        padding: EdgeInsets.only(left: 10,right: 10),
                        child: Text('Success', style: TextStyle(fontSize: 18),
                        )
                        ),
                    )
                    ],
                     ),
                  ),
                  
                  const Padding(
                    padding: EdgeInsets.only(top: 20,right: 20,left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                     Text('Time',
                    style: TextStyle(fontSize: 20, color: Colors.grey),),
                    Text('32342342',style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),)
                    ],
                     ),
                  ),
                  
                   Padding(
                    padding: const EdgeInsets.only(top: 20,right: 20,left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                     const Text('Transaction Code',
                    style: TextStyle(fontSize: 20, color: Colors.grey),),
                     Text(req!['id'],style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),)
          
                    ],
                     ),
                  ),
                  
                  const Padding(
                    padding: EdgeInsets.only(top: 20,right: 20,left: 20, bottom:20 ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                     Text('Account/Card',
                    style: TextStyle(fontSize: 20, color: Colors.grey),),
                    Text('Paypal',style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),)
                   
                    ],
                     ),
                  ),
                  
                  ]
                ),
                
              ),
              Container(
                margin: const EdgeInsets.only(left: 30, bottom: 30),
                child: const Text('Room information',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),),
              ),
              Container(
                margin: const EdgeInsets.only(right: 30,left: 30,bottom: 30),
                width: double.infinity,
                
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  children:
                  [ 
                   Padding(
                    padding: const EdgeInsets.only(top: 20,right: 20,left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                     const Text('Room Type',
                    style: TextStyle(fontSize: 20, color: Colors.grey),),
                     Text(req!['roomType'],style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),)
          
                    ],
                     ),
                  ),
                   const Padding(
                    padding: EdgeInsets.only(top: 20,right: 20,left: 20, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                     Text('Quantity',
                    style: TextStyle(fontSize: 20, color: Colors.grey),),
                     Text('1',style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),)
          
                    ],
                     ),
                  ),
                  
                  
                   
                    ],
                     ),
                  ),
                  Container(
                margin: const EdgeInsets.only(left: 30, bottom: 30),
                child: const Text('Customer infomation',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),),
              ),
              Container(
                margin: const EdgeInsets.only(right: 30,left: 30,bottom: 30),
                width: double.infinity,
                
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                  [ 
                     Padding(
                    padding: const EdgeInsets.only(top: 20,right: 20,left: 20),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                     Text(req!['nameUser'],
                    style:const TextStyle(fontSize: 20, color: Colors.black),),
          
                    ],
                     ),
                  ),
                   Padding(
                    padding: const EdgeInsets.only(top: 20,right: 20,left: 20),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                     const Text('Phone Number',
                    style: TextStyle(fontSize: 20, color: Colors.grey),),
                     Text(req!['phoneNumber'],style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),)
          
                    ],
                     ),
                  ),
                   Padding(
                    padding: const EdgeInsets.only(top: 20,right: 20,left: 20, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                     const Text('Email',
                    style: TextStyle(fontSize: 20, color: Colors.grey),),
                     Text(req!['emailUser'],style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),)
          
                    ],
                     ),
                  ),
                  
                  
                  
                   
                    ],
                     ),
                  ),
                  
                  ]
                ),
        ),
              
            ),
            
          
        
      
    );
  }
}