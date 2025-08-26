import 'package:booking/user/pages/transaction_detail.dart';
import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';

class UiOption {
  static void showAlertDialog(String message, BuildContext ctx, {String title = ' '}) {
    // Kiểm tra nếu context vẫn còn hợp lệ
    if (!ctx.mounted) return;

    showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
  static showDialogSuccessPayment(Map<String,dynamic> req, String account){
    OneContext().showDialog(builder: (ctx)
    {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          
        ),
        actions: [
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 10,bottom: 10),
              child: Text('Thanh toán thành công đi đến trang bill',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black
              ),),
            ),
          ),
          ElevatedButton(onPressed: (){
            Navigator.of(ctx).pop();
          }, child: TextButton(
            onPressed: (){
              Navigator.push(ctx, MaterialPageRoute(builder: (ctx)=>TransactionDetail(account: account,id: req['id'],)));
            },
            child: Center(child: const Text('ok', style: TextStyle(color: Colors.black),))))
        ],
      );
    });
  }
}