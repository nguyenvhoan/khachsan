import 'package:booking/user/pages/payment_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class DiningTable extends StatefulWidget {
   DiningTable({super.key, required this.table, required this.account});
  Map<String,dynamic> table;
  var account;
  @override
  State<DiningTable> createState() => _DiningTableState();
}

class _DiningTableState extends State<DiningTable> {
  @override
  void initState() {
    super.initState();
    getUserById(widget.account);
        getBooking(widget.account);

          
  }
  Timestamp now = Timestamp.now();
  String dayStart='';
  String dayEnd='';
  int quantity=1; 
    final FirebaseFirestore db = FirebaseFirestore.instance;
  Map<String,dynamic>? user;
  List<dynamic> booking =[];
  Future<void> getBooking(String id) async {
    try {
      DocumentSnapshot documentSnapshot = await db.collection('user').doc(id).get();

      if (documentSnapshot.exists) {
        setState(() {
          user = documentSnapshot.data() as Map<String, dynamic>?; 
         !user?['lstBooking'].isEmpty ?booking=user!['lstBooking'] as List<dynamic>:booking=[];
        });
      } else {
        print('Tài liệu không tồn tại');
      }
    } catch (e) {
      print('Lỗi khi lấy dữ liệu: $e');
    }
  } 
  Future<void> _selectedStartDate() async{
    DateTime? picked=await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3)),
    );
    if (picked != null) {
      setState(() {
        dayStart = picked.toString().split(" ")[0];
      });
    }
  }
   Future<void> getUserById(String id) async {
    try {
      DocumentSnapshot documentSnapshot =
          await db.collection('user').doc(id).get();

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

  Future<void> _selectedEndDate() async{
    DateTime? picked=await showDatePicker(
      context: context,
      initialDate: dayStart==''? DateTime.now().add(const Duration(days: 1)):DateTime.parse(dayStart).add(const Duration(days: 1)),
      firstDate: dayStart==''? DateTime.now().add(const Duration(days: 1)):DateTime.parse(dayStart).add(const Duration(days: 1)),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        dayEnd = picked.toString().split(" ")[0];
      });
    }
  }
  int calculateDaysBetween(DateTime startDate, DateTime endDate) {
    return endDate.difference(startDate).inDays;
  }
  @override
  Widget build(BuildContext context) {
    DateTime? a;
    DateTime? b;
     if (dayStart!='' && dayEnd!='') {
      try {
        a = DateTime.parse(dayStart);
        b = DateTime.parse(dayEnd);
      } catch (e) {
        print("Error parsing date: $e");
      }
    }
    Size size = MediaQuery.sizeOf(context);
        int day = (a != null && b != null) ? calculateDaysBetween(a, b) : 0;
    print('---------------------------------------------------------------');
    print(widget.table);
    print('---------------------------------------------------------------');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed:(){ 
        Navigator.pop(context);}, icon: Image.asset('asset/images/icons/icon_back.png')),
        centerTitle: true,
        title:const Text('Dining table reservation form', textAlign: TextAlign.center,) ,
        
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                 color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), 
                        spreadRadius: 1,
                        blurRadius: 7, 
                        offset: const Offset(0, 5), 
                      ),
                    ],
                  ),
              margin: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    width: size.width/3,
                    height: size.height/6.5 ,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image:  widget.table['img']!=null
                      ?DecorationImage(
                        image: NetworkImage(widget.table['img']),
                        fit: BoxFit.cover
                        
                        )
                        :null,
                        color: Colors.transparent,
                    ),
                    child: widget.table['img']==null
                    ?const Icon(Icons.image, size: 50,)
                    :null,
                  ),
                  Padding(
                    padding:const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(children: [
                           Text('Table type : ', style:TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                        ]),
                         Text(widget.table['tabletype'], style:  const TextStyle(fontSize: 19, color: Color(0xff1A4368)),),
                       Row(children:[
                           const Text('Giá: ', style:TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Color(0xff57A5EC)),
                          ),
                         const SizedBox(height: 50,),
                          Text(widget.table['price'].toString(),style: const TextStyle(fontSize: 19),)
                          ] 
                          ),
                      ],
                    ), 
                    )
                ],
              ),
            ),
            Container(
                margin: const EdgeInsets.all(10),
               decoration:BoxDecoration(
                 color: Colors.white,
                   boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), 
                      spreadRadius: 3,
                       blurRadius: 7, 
                       offset: const Offset(0, 2), 
                      ),
                    ],
                   ),
                  height: 50,
                  child: TextFormField(
                    validator: (value){
                      if(value==null||value.isEmpty){
                        return 'Bắt buộc nhập';
                      }
                      return null;
                    },
                                  
                  // controller: cardNumberController,
                  decoration: const InputDecoration(
                  label:Text( 'Enter card number *', style:TextStyle(color: Color(0xffBEBCBC)),),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  focusedBorder:OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                 Container(
                margin: const EdgeInsets.all(10),
               decoration:BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                 color: const Color(0xffD9D9D9),
                   boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), 
                      spreadRadius: 3,
                       blurRadius: 7, 
                       offset: const Offset(0, 2), 
                      ),
                    ],
                   ),
                  height: 200,
                  child: Column(
                    children: [
                      Expanded(

                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Select date: '),
                              Container(
                          
                                width: 200,
                                height: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.white
                                  )
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(dayStart),
                                      GestureDetector(onTap: (){
                                        _selectedStartDate();
                          
                                      },
                                       child: const Icon(Icons.calendar_month))
                                    ],
                                  ),
                                ),
                              )
                             
                            ],
                          ),
                        ),
                      ),
                       Expanded(

                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Select end date: '),
                              Container(
                          
                                width: 200,
                                height: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.white
                                  )
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(dayEnd),
                                      GestureDetector(onTap: (){
                                        _selectedEndDate();
                          
                                      },
                                       child: const Icon(Icons.calendar_month))
                                    ],
                                  ),
                                ),
                              )
                             
                            ],
                          ),
                        ),
                      ),
                       Expanded(

                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Quantity: '),
                              Container(
                          
                                width: 200,
                                height: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.black
                                  )
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                         setState(() {
                                            quantity<=1?quantity=1:quantity--;
                                         });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10)
                                          ),
                                          child:const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                            child: Text('-',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold
                                            ),))),
                                      ),
                                      Text(quantity.toString(), textAlign: TextAlign.center,),
                                      GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            quantity<1?quantity=1:quantity++;
                                          });
                                          print(quantity);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10)
                                          ),
                                          child:const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                            child: Text('+',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold
                                            ),
                                            )
                                            )
                                            ),
                                      ),
                                      
                                    ],
                                  ),
                                ),
                              )
                             
                            ],
                          ),
                        ),
                      ),
                      
                    ],
                  ),
                  
                ),
                const Text('Total Payment',
                style: TextStyle(
                  fontFamily: 'Candal',
                  fontSize: 20,
                  color: Color(0xff57A5EC)
                ),),
                Container(
                margin: const EdgeInsets.all(10),
               decoration:BoxDecoration(
                 borderRadius: BorderRadius.circular(20),

                 color: const Color(0xffD9D9D9),
                   boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), 
                      spreadRadius: 3,
                       blurRadius: 7, 
                       offset: const Offset(0, 2), 
                      ),
                    ],
                   ),
                  child:Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Quantity:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            ),
                            Text(quantity.toString(),
                            style:const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total table:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),),
                            Text(
                                '${widget.table!['price']} đ',
                                style:const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),),
                          ],
                        ),
                        
                  
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Cost:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
                            Text('${widget.table!['price']*(day)*quantity} đ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                          ],
                        ),
                      ],
                    ),
                  ),
               ),
               GestureDetector(      
                        onTap: () {
                             String id = randomAlphaNumeric(10);

                            Map<String, dynamic> req =({
                                  'id':id,
                                  'idUser':widget.account,
                                  'nameUser':user!['name'],
                                  'emailUser':user!['email'],
                                  'img':widget.table['img'],
                                  // 'idTable':widget.table['Id'],
                                  'roomType':widget.table['tabletype'],
                                  'price':(widget.table['price']*(day)*quantity),
                                  'day':day  ,
                                  'start':dayStart,
                                  'end':dayEnd , 
                                  'time': now,     
                                  'phoneNumber':'',
                                  'numberTable':'null',
                                  'requestType':'table'
                                 });
                                 print(req);
                                 Navigator.push(context, MaterialPageRoute(builder: (context)=>PaymentPage(codeRoom: widget.table['Id'],account: widget.account, req: req, idVoucher: 'idVoucher', booking: booking,)));
                            
                          
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff1A4368), 
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
                 )
          ],
        ),
      ),
    );
  }
}
