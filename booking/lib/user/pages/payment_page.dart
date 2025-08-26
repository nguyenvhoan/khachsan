import 'package:booking/controller/constraints.dart';
import 'package:booking/model/database_service.dart';
import 'package:booking/ui/ui_option.dart';
import 'package:booking/user/pages/TestZlp.dart';
import 'package:booking/user/pages/transaction_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:one_context/one_context.dart';
const String transactionDetailUrl = '/transaction_detail';

class PaymentPage extends StatefulWidget {
  PaymentPage({super.key, required this.codeRoom, this.account, required this.req,  required this.booking, required this.voucher});
  var codeRoom, account;
  var voucher;
  var booking;
  Map<String, dynamic> req;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}


class _PaymentPageState extends State<PaymentPage> {
  final DatabaseService _databaseService = DatabaseService();
Map<String,dynamic>? user;
  void _handlePaymentSuccess() {
    print("Navigating to TransactionDetail...");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => TransactionDetail(account: widget.account,id: widget.req['id'],)),
    ).then((_) {
      print("Navigated to TransactionDetail");
    });
  }
  
  
  final FirebaseFirestore db = FirebaseFirestore.instance;
  
  @override
  Widget build(BuildContext context) {
    print('--------------------------------------------');
    print('Đang thanh toán với id tài khoản :${widget.account}');
    print('Booking : ${widget.booking}');
    print('--------------------------------------------');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[ 
        
           GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => UsePaypal(
                    sandboxMode: true,
                    clientId: Constraints.clientId,
                    secretKey: Constraints.secretKey,
                    returnURL: transactionDetailUrl,
                    cancelURL: Constraints.cancelURL,
                    transactions: [
                      {
                        "amount": {
                          "total": (widget.req['price'] / 24000).toStringAsFixed(2),
                          "currency": "USD",
                          "details": {
                            "subtotal": (widget.req['price'] / 24000).toStringAsFixed(2),
                            "shipping": '0',
                            "shipping_discount": 0
                          }
                        },
                        "description": "The payment transaction description.",
                        "item_list": {
                          "items": [
                            {
                              "name": widget.req['roomType'],
                              "quantity": 1,
                              "price": (widget.req['price'] / 24000).toStringAsFixed(2),
                              "currency": "USD"
                            }
                          ],
                        }
                      }
                    ],
                    note: "Contact us for any questions on your order.",
                    onSuccess: (Map params) async {
                      print("onSuccess: $params");
        
                      Fluttertoast.showToast(
                        msg: "Thanh toán thành công",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
        
                      // Cập nhật dữ liệu
                      await _databaseService.createReq(widget.req);
                      await _databaseService.createBookingHis(widget.booking, widget.account, widget.req);
                      await _databaseService.updateScore(widget.account, widget.req['price']);
                      await _databaseService.deleteDiscount(widget.account, widget.voucher);  
        
                    UiOption.showDialogSuccessPayment(widget.req, widget.account);
                    },
                    onError: (error) {
                      print("onError: $error");
                      Fluttertoast.showToast(
                        msg: "Thanh toán thất bại",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    },
                    onCancel: (params) {
                      print('Cancelled: $params');
                      Fluttertoast.showToast(
                        msg: "Hủy thanh toán",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    },
                  ),
                ),
              );
            },
            
              child: Container(
                  child: Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[200],
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
                      child: Row(
                        children:[
                        Padding(
                          padding: EdgeInsets.only(left: 15, right: 10),
                          child: Text(
                            textAlign: TextAlign.center,"Make Payment with Paypal", style: TextStyle(
                            fontFamily: 'Candal',
                            fontSize: 18,
                            color: Colors.black
                          ),),
                        ),
                        Image.asset('asset/images/icons/paypal.png')
                      ] ),
                    ),
                  ),
                
              ),
            
          ),
        SizedBox(height: 20,),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeZaloPay(req: widget.req),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[200],
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                
                '  Make Payment with ZaloPay', style: TextStyle(
                fontFamily: 'Candal',
                
                fontSize: 18,
                color: Colors.black
              ),),
            ),
          ),
        )
        ]
      ),
    );
  }
}