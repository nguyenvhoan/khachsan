import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:booking/user/test/utils/config.dart';
import 'package:booking/user/test/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../test/repo/payment.dart';

class HomeZaloPay extends StatefulWidget {
  final Map<String, dynamic> req;

  const HomeZaloPay({Key? key, required this.req}) : super(key: key);

  @override
  State<HomeZaloPay> createState() => _HomeZaloPayState();
}

class _HomeZaloPayState extends State<HomeZaloPay> {
  String zpTransToken = "";
  String payResult = "";
  late String payAmount;
  bool showResult = false;

  @override
  void initState() {
    super.initState();
    payAmount = widget.req['price'].toString();
  }

  Future<void> _createOrder() async {
    int amount = int.parse(payAmount);
    if (amount < 1000 || amount > 1000000) {
      setState(() {
        zpTransToken = "Invalid Amount";
      });
      return;
    }

    var result = await createOrder(amount);
    if (result != null && result.orderUrl != null) {
      setState(() {
        zpTransToken = result.zpTransToken ?? "";
        showResult = true;
      });

      // Mở URL thanh toán
      await launchUrl(
        Uri.parse(result.orderUrl!),
        mode: LaunchMode.externalApplication,
      );
    } else {
      setState(() {
        zpTransToken = "Failed to create order";
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thanh toán ZaloPay")),
      body: Column(
        children: [
          TextFormField(
            initialValue: payAmount,
            decoration: const InputDecoration(
              labelText: "Số tiền",
              icon: Icon(Icons.attach_money),
            ),
            onChanged: (value) {
              setState(() {
                payAmount = value;
              });
            },
          ),
          ElevatedButton(
            onPressed: _createOrder,
            child: const Text("Tạo đơn hàng"),
          ),
           ElevatedButton(
          onPressed: () async {
            if (zpTransToken.isNotEmpty) {
              // Gọi hàm kiểm tra trạng thái giao dịch
              await checkTransactionStatus(zpTransToken);
            } else {
              setState(() {
                payResult = "Không tìm thấy zp_trans_token để kiểm tra trạng thái.";
              });
            }
          },
          child: const Text("Kiểm tra trạng thái giao dịch"),
        ),
        if (showResult)
          Column(
            children: [
              Text("Mã giao dịch: $zpTransToken"),
              Text("Trạng thái: $payResult"),
            ],
          ),
        ],
      ),
    );
  }
}