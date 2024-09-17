import 'package:booking/model/database_service.dart';
import 'package:booking/user/pages/booking_page.dart';
import 'package:booking/user/pages/intro_page.dart';
import 'package:booking/user/pages/payment_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class BookingPage extends StatefulWidget {
  BookingPage({super.key, required this.codeRoom, required this.account});
  final String codeRoom; 
  final String account; 
  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  TextEditingController cardNumberController =TextEditingController();
  TextEditingController cardholderController =TextEditingController();
  TextEditingController phoneNumberController =TextEditingController();
  TextEditingController dayRentController =TextEditingController();
  TextEditingController dayEndController =TextEditingController();
  final _formkey = GlobalKey<FormState>();
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
  Future<void> _selectedStartDate() async{
    DateTime? _picked=await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if(_picked!=null){
      setState(() {
        dayRentController.text=_picked.toString().split(" ")[0];
        
      });
    }
  }
  Future<void> _selectedEndDate() async{
    DateTime? _picked=await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now().add(Duration(days: 1)),
      lastDate: DateTime(2100),
    );
    if(_picked!=null){
      setState(() {
        
        dayEndController.text=_picked.toString().split(" ")[0];
      });
    }
  }
  int calculateDaysBetween(DateTime startDate, DateTime endDate) {
  
  return endDate.difference(startDate).inDays;
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
    DateTime? a;
DateTime? b;

if (dayRentController.text.isNotEmpty && dayEndController.text.isNotEmpty) {
  try {
    a = DateTime.parse(dayRentController.text);
    b = DateTime.parse(dayEndController.text);
  } catch (e) {
    print("Error parsing date: $e");
  }
}
    int day = (a != null && b != null) ? calculateDaysBetween(a, b) : 0;
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
                          key:  _formkey,
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
                                  validator: (value){
                                    if(value==null||value.isEmpty){
                                      return 'Bắt buộc nhập';
                                    }
                                  },
                                  
                                  controller: cardNumberController,
                                  decoration: const InputDecoration(
                                  label:Text( 'Enter card number *', style:TextStyle(color: Color(0xffBEBCBC)),),
                                    floatingLabelBehavior: FloatingLabelBehavior.never,
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
                                  validator: (value){
                                    if(value==null||value.isEmpty){
                                      return 'Bắt buộc nhập';
                                    }
                                  },
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
                                  validator: (value){
                                    if(value==null||value.isEmpty){
                                      return 'Bắt buộc nhập';
                                    }
                                  },
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
                                  onTap: (){
                                    _selectedStartDate();
                                  },
                                  validator: (value){
                                    if(value==null||value.isEmpty){
                                      return 'Bắt buộc nhập';
                                    }
                                  },
                                  readOnly:   true,
                                  controller: dayRentController,
                                  decoration: const InputDecoration(
                                  label:Text( 'Start *', style:TextStyle(color: Color(0xffBEBCBC)),),
                                    
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
                                  onTap:  (){
                                    _selectedEndDate();
                                  },
                                  validator: (value){
                                    if(value==null||value.isEmpty){
                                      return 'Bắt buộc nhập';
                                    }
                                  },
                                  readOnly: true,
                                  controller: dayEndController,
                                  decoration: const InputDecoration(
                                  label:Text( 'End *', style:TextStyle(color: Color(0xffBEBCBC)),),
                                    
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
                                          Text('Quantity day:'),
                                          Text(day.toString()+' Day'),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Total Cost:', style: TextStyle(fontWeight: FontWeight.bold),),
                                          Text((data!['price']*day).toString()+' đ', style: TextStyle(fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                     
                                    ],
                                    
                                  ),
                                ),
                              ),
                              SizedBox(height: 10,),
                               GestureDetector(
                              
                              onTap: () {
                                setState(() {
                                  if(_formkey.currentState!.validate()){   
                                  
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
                                  'price':data!['price']*day,
                                  'cardNumber':cardNumberController.text  ,
                                  'cardHolder':cardholderController.text,
                                  'phoneNumber':phoneNumberController.text,
                                  'day':day  ,
                                  'start':dayRentController.text,
                                  'end':dayEndController.text  ,       
                                 });
                                
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (context) => PaymentPage(codeRoom: widget.codeRoom,account: widget.account,req: req,))
                                );
                                }
                                
                                }); 
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