import 'package:booking/model/database_service.dart';
import 'package:booking/user/pages/booking_page.dart';
import 'package:booking/user/pages/intro_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class BookingPage extends StatefulWidget {
  BookingPage({super.key, required this.codeRoom, required this.account});
  final String codeRoom; 
  var account;
  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  TextEditingController cardNumberController =TextEditingController();
  TextEditingController cardholderController =TextEditingController();
  TextEditingController phoneNumberController =TextEditingController();
  TextEditingController dayController =TextEditingController();
  TextEditingController cccdController =TextEditingController();
  
  final FirebaseFirestore db = FirebaseFirestore.instance;
  Map<String, dynamic>? data; 
  Map<String, dynamic>? user; 
  List<dynamic> services = [];
   DatabaseService _databaseService = DatabaseService();
  
  @override
  void initState() {
    super.initState();
    getDataById(widget.codeRoom); 
    getUserById(widget.account);
  }

  Future<void> getDataById(String id) async {
    try {
      DocumentSnapshot documentSnapshot = await db.collection('Room').doc(id).get();

      if (documentSnapshot.exists) {
        setState(() {
          data = documentSnapshot.data() as Map<String, dynamic>?; 
          services = data?['services'] ?? []; // Lấy dịch vụ
        });
      } else {
        print('Tài liệu không tồn tại');
      }
    } catch (e) {
      print('Lỗi khi lấy dữ liệu: $e');
    }
  }
  Future<void> getUserById(String id) async {
    try {
      DocumentSnapshot documentSnapshot = await db.collection('user').doc(id).get();

      if (documentSnapshot.exists) {
        setState(() {
          user = documentSnapshot.data() as Map<String, dynamic>?; 
          
        });
      } else {
        print('Tài liệu không tồn tại');
      }
    } catch (e) {
      print('Lỗi khi lấy dữ liệu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Options', textAlign: TextAlign.center),
      ),
      body: data != null 
          ? Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(left: 25, right: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(                                      
                          width: double.infinity,
                          height: size.height / 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: data?['img'] != null
                              ? DecorationImage(
                                  image: NetworkImage(data!['img']),
                                  fit: BoxFit.cover,
                                )
                              : null,
                            color: Colors.transparent,
                          ),
                          child: data?['img'] == null
                            ? const Icon(Icons.image, size: 10)
                            : null,
                        ),
                        Center(
                          child: Text(
                            data?['roomType'] ?? '',
                            style: TextStyle(fontFamily: 'Candal', fontSize: 25),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        
                        
                        Form(
                          child: Column(
                            children: [
                              Container(
                                
                                decoration:BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                  BoxShadow(
                                  color: Colors.black.withOpacity(0.1), 
                                  spreadRadius: 3,
                                  blurRadius: 7, 
                                  offset: Offset(0, 2), 
                                ),
                              ],
                                ),
                                height: 50,
                                child: TextFormField(
                                  controller: cardNumberController,
                                  decoration: const InputDecoration(
                                  label:Text( 'Enter card number *', style:TextStyle(color: Color(0xffBEBCBC)),),
                                    
                                  focusedBorder:const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                ),
                                ),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                
                                decoration:BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                  BoxShadow(
                                  color: Colors.black.withOpacity(0.1), 
                                  spreadRadius: 3,
                                  blurRadius: 7, 
                                  offset: Offset(0, 2), 
                                ),
                              ],
                                ),
                                height: 50,
                                child: TextFormField(
                                  controller: cardholderController,
                                  decoration: const InputDecoration(
                                  label:Text( 'Card holder *', style:TextStyle(color: Color(0xffBEBCBC)),),
                                    
                                  focusedBorder:const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                ),
                                ),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                
                                decoration:BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                  BoxShadow(
                                  color: Colors.black.withOpacity(0.1), 
                                  spreadRadius: 3,
                                  blurRadius: 7, 
                                  offset: Offset(0, 2), 
                                ),
                              ],
                                ),
                                height: 50,
                                child: TextFormField(
                                    controller: phoneNumberController,
                                  decoration: const InputDecoration(
                                  label:Text( 'Phone number *', style:TextStyle(color: Color(0xffBEBCBC)),),
                                    
                                  focusedBorder:const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                ),
                                ),
                              ),
                               SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 150,
                                decoration:BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                  BoxShadow(
                                  color: Colors.black.withOpacity(0.1), 
                                  spreadRadius: 3,
                                  blurRadius: 7, 
                                  offset: Offset(0, 2), 
                                ),
                              ],
                                ),
                                height: 50,
                                child: TextFormField(
                                  controller: dayController,
                                  decoration: const InputDecoration(
                                  label:Text( 'MM/YY *', style:TextStyle(color: Color(0xffBEBCBC)),),
                                    
                                  focusedBorder:const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                ),
                                ),
                              ),
                              Container(
                                width:150,
                                decoration:BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                  BoxShadow(
                                  color: Colors.black.withOpacity(0.1), 
                                  spreadRadius: 3,
                                  blurRadius: 7, 
                                  offset: Offset(0, 2), 
                                ),
                              ],
                                ),
                                
                                height: 50,
                                child: TextFormField(
                                  controller: cccdController,
                                  decoration: const InputDecoration(
                                  label:Text( 'CCCD *', style:TextStyle(color: Color(0xffBEBCBC)),),
                                    
                                  focusedBorder:const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                ),
                                ),
                              ),
                                ],
                              ),
                              SizedBox(height: 10,),
                              Text('Price and summary', textAlign: TextAlign.start,),
                              SizedBox(height: 10,),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xffD9D9D9),
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                width:double.infinity,
                                child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Total Discounts:'),
                                          Text(data!['price'].toString()+' đ'),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Total Room Price:'),
                                          Text(data!['price'].toString()+' đ'),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Quantity:'),
                                          Text(data!['price'].toString()+' đ'),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Total Cost:', style: TextStyle(fontWeight: FontWeight.bold),),
                                          Text(data!['price'].toString()+' đ', style: TextStyle(fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                     
                                    ],
                                    
                                  ),
                                ),
                              ),
                              SizedBox(height: 10,),
                               GestureDetector(
                               
                              onTap: () {
                                String id = randomAlphaNumeric(10);
                                 Map<String, dynamic> req =({
                                  'id':id,
                                  'idUser':widget.account,
                                  'nameUser':user!['name'],
                                  'emailUser':user!['email'],
                                  'img':data!['img'],
                                  'idRoom':data!['Id'],
                                  'service':services,
                                  'roomType':data!['roomType'],
                                  'price':data!['price'],
                                  'cardNumber':cardNumberController.text  ,
                                  'cardHolder':cardholderController.text,
                                  'phoneNumber':phoneNumberController.text,
                                  'day':dayController.text  ,
                                  'cccd':cccdController.text  ,       
                                 });
                                 _databaseService.createReq(req);
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (context) => Landing())
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xff1A4368), 
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                                  child: Text(
                                    'Compplete payment',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                
              ],
            )
          : Center(
              child: CircularProgressIndicator(), // Hoặc bạn có thể thay thế bằng một widget khác thông báo lỗi
            ),
    );
  }
}