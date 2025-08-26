import 'package:booking/user/pages/TestZlp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OptionPayment extends StatelessWidget {
   OptionPayment({super.key,required this.codeRoom, this.account, required this.req,  required this.booking, required this.voucher});
  var codeRoom, account;
  var voucher;
  var booking;
   Map<String, dynamic> req;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 1000,),
          GestureDetector(
            onTap: (){
              Navigator.push(
              context,
              // MaterialPageRoute(
              //   builder: (context) => ZaloPayQRPage(
              //     amount: 100000, // Số tiền cần thanh toán
              //     appId: "2554", // App ID của bạn
              //     key1: "sdngKKJmqEMzvh5QQcdD2A9XBSKUNaYn", // Key1 của bạn
              //     key2: "", // Key2 của bạn
              //   ),
              // ),
              MaterialPageRoute(builder: (context)=>HomeZaloPay(req: req))
            );
            },
            child: Text('data'),
          )
        ],
      ),
    );
  }
}