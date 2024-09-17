import 'package:booking/user/widget/navigation_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionDetail extends StatefulWidget {
   TransactionDetail({super.key, required this.req});
Map<String,dynamic> req;
  @override
  State<TransactionDetail> createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {
  @override
  Widget build(BuildContext context) {
    String formatNumber(int number) {
    final formatter = NumberFormat('#,##0');
    return formatter.format(number);
  }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed:(){
          Navigator.push(context,MaterialPageRoute(builder: (context)=>NavigationMenu(account: widget.req['idUser'])));
        }, icon: Icon(Icons.home)),
        title: const Text('   Transaction Details', textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Candal',
          color: Color(0xff3CA0B6)
        ),),
      ),
      body: Container(
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
                margin: EdgeInsets.all(30),
                width: double.infinity,
                
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  children:[ Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                       border: Border.all(
                        color: Color(0xff57A5EC), // Màu viền
                        width: 1, // Độ dày của viền
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 30),
                      child:  Column(
                        children: [
                          Text('Book a hotel room',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20
                          ),),
                          Text('200.000VND', 
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20
                          ),)
                        ],
                      ),
                    ),
                    
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20,right: 20,left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                    const Text('Status',
                    style: TextStyle(fontSize: 20, color: Colors.grey),),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xff94E19B),
                    
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
                    padding: EdgeInsets.only(top: 20,right: 20,left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                     Text('Transaction Code',
                    style: TextStyle(fontSize: 20, color: Colors.grey),),
                     Text(widget.req['id'],style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),)
          
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
                margin: EdgeInsets.only(left: 30, bottom: 10),
                child: const Text('Room information',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),),
              ),
              Container(
                margin: EdgeInsets.only(right: 30,left: 30,bottom: 30),
                width: double.infinity,
                
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  children:
                  [ 
                   Padding(
                    padding: EdgeInsets.only(top: 20,right: 20,left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                     const Text('Room Type',
                    style: TextStyle(fontSize: 20, color: Colors.grey),),
                     Text(widget.req['roomType'],style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),)
          
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
                margin: EdgeInsets.only(left: 30, bottom: 10),
                child: const Text('Customer infomation',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),),
              ),
              Container(
                margin: EdgeInsets.only(right: 30,left: 30,bottom: 30),
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
                    padding: EdgeInsets.only(top: 20,right: 20,left: 20),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                     Text(widget.req['nameUser'],
                    style:const TextStyle(fontSize: 20, color: Colors.black),),
          
                    ],
                     ),
                  ),
                   Padding(
                    padding: EdgeInsets.only(top: 20,right: 20,left: 20),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                     const Text('Phone Number',
                    style: TextStyle(fontSize: 20, color: Colors.grey),),
                     Text(widget.req['phoneNumber'],style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),)
          
                    ],
                     ),
                  ),
                   Padding(
                    padding: EdgeInsets.only(top: 20,right: 20,left: 20, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                     const Text('Email',
                    style: TextStyle(fontSize: 20, color: Colors.grey),),
                     Text(widget.req['emailUser'],style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),)
          
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