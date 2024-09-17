import 'package:booking/controller/constraints.dart';
import 'package:booking/model/database_service.dart';
import 'package:booking/ui/ui_option.dart';
import 'package:booking/user/pages/intro_page.dart';
import 'package:booking/user/pages/transaction_detail.dart';
import 'package:booking/user/widget/navigation_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PaymentPage extends StatefulWidget {
   PaymentPage({super.key, required this.codeRoom, this.account, required this.req});
var codeRoom,account;
Map<String,dynamic> req;
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  DatabaseService _databaseService=DatabaseService();
  bool status=false;
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            if(status==true){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>TransactionDetail(req: widget.req,)));
            }
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => UsePaypal(
                  sandboxMode: true,
                  clientId: "${Constraints.clientId}",
                  secretKey: "${Constraints.secretKey}",
                  returnURL: "${Constraints.returnURL}",
                  cancelURL: "${Constraints.cancelURL}",
                  
                  transactions:  [
                    {
                      "amount": {
                        "total": (widget.req['price']/24000).toStringAsFixed(2),
                        "currency": "USD",
                        "details": {
                          "subtotal": (widget.req['price']/24000).toStringAsFixed(2),
                          "shipping": '0',
                          "shipping_discount": 0
                        }
                      },
                      "description": "The payment transaction description.",
                      "item_list": {
                        "items": [
                          {
                            "name":widget.req['roomType'],
                            "quantity": 1,
                            "price": (widget.req['price']/24000).toStringAsFixed(2),
                            "currency": "USD"
                          }
                        ],
                       
                      }
                    }
                  ],
                  note: "Contact us for any questions on your order.",
                  onSuccess: (Map params) async {
                    print("onSuccess: $params");
                    status=true;
                    Fluttertoast.showToast(
                    msg: "Thanh toán thành công",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                    
                );
                _databaseService.createReq(widget.req);
                
                    
                  },
                  onError: (error) {
                    print("onError: $error");
                    status=false;
                    Fluttertoast.showToast(
                    msg: "Thanh toán thất bại",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
                  },
                  onCancel: (params) {
                    print('Cancelled: $params');
                    status=false;
                    Fluttertoast.showToast(
                    msg: "Hủy thanh toán",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
                
                  },
                ),
              ),
            );
          },
          
          child: const Text("Make Payment"),
        ),
      ),
    );
  }
}