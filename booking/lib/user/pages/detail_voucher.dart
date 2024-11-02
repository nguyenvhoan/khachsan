import 'package:booking/user/pages/voucher_page.dart';
import 'package:booking/user/widget/navigation_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailVoucher extends StatefulWidget {
   DetailVoucher({super.key, required this.codeVoucher, required this.account});
  var codeVoucher, account;

  @override
  State<DetailVoucher> createState() => _DetailVoucherState();
}

class _DetailVoucherState extends State<DetailVoucher> {
    final FirebaseFirestore db = FirebaseFirestore.instance;
  Map<String, dynamic>? data; 
   @override
  void initState() {
    super.initState();
    getDataById(widget.codeVoucher); 
  }

  Future<void> getDataById(String id) async {
    try {
      DocumentSnapshot documentSnapshot = await db.collection('Discount').doc(id).get();

      if (documentSnapshot.exists) {
        setState(() {
          data = documentSnapshot.data() as Map<String, dynamic>?; 
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
    
    Size size =MediaQuery.sizeOf(context);
    String formatNumber(int number) {
    final formatter = NumberFormat('#,##0');
    return formatter.format(number);
  }

    return Scaffold(
      
      body:data!=null? SizedBox(
        width: double.infinity,
        height:   double.infinity ,
        child: Column(
          children:[ 
            Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: Stack(
              fit: StackFit.loose,
              children:[
                Container(
                  margin: const EdgeInsets.only(bottom: 50),
                height: 200,
                width: double.infinity,
                
                decoration:const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(100), // Bo tròn góc dưới trái
                    bottomRight: Radius.circular(100),
                  ),
                  color: Color(0xff1A4368),
                ),
              ),
             
              Positioned(
                top:100,
                left: 120  ,
                
                  child: Container(                                      
                          width: size.width / 2.5, 
                   height: size.width / 2.5,
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
                
                ),
                Positioned(
                    top: 20,
                    left: 10,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                      ),
                      child: IconButton(onPressed: (){
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=>VoucherPage(account: widget.account)));
                        Navigator.pop(context);
                      }, icon: const Icon(Icons.undo,
                      color: Colors.white,)
                      ),
                    ),
                    ),
               
                  
              ] 
              ),
            ),
             Center(
               child: Container(
                    
                    width: double.infinity,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 50,right: 50),
                          child: Text(data!['name'],
                          textAlign: TextAlign.center,
                           style:const TextStyle(
                            color: Color(0xff3CA0B6),
                            fontFamily: 'Candal',
                            fontSize: 25
                            ),
                            ),
                        ),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children:[
                             const Text('Discount:', style:TextStyle(
                            color: Colors.black,
                            fontFamily: 'Cabin',
                            fontSize: 30
                            ),
                            ),
                               Text('${formatNumber(data!['point'])}đ', style:const TextStyle(
                            color: Colors.red,
                            fontFamily: 'Cabin',
                            fontSize: 30
                            ),
                            textAlign: TextAlign.center,
                            ),
                            ]
                          ),
                          Container(
                            margin: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              boxShadow: [
                                    BoxShadow(
                                    color: Colors.black.withOpacity(0.1), 
                                    spreadRadius: 3,
                                    blurRadius: 7, 
                                    offset: const Offset(0, 2), 
                                  ),
                                ],
                              color: const Color.fromARGB(255, 242, 236, 236),
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child:  Column(
                                children: [
                                   Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text(data!['introduc'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black
                                    ),)
                                  ),
                                  Container(
               
                                  )
                                ],
                              ),
                            ),
                          ),
                          
                      ],
                    ),
                  ),
             ),
          
                
              
          ]
        ),
      ):const Center(
              child: CircularProgressIndicator(), // Hoặc bạn có thể thay thế bằng một widget khác thông báo lỗi
      )
    );

  }
}