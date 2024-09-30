
import 'dart:io';

import 'package:booking/user/test/repo/payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_zalopay_sdk/flutter_zalopay_sdk.dart';
import 'package:url_launcher/url_launcher.dart';





class Dashboard1 extends StatefulWidget {
  final String title;
  final String version;
  Dashboard1({required this.title,required this.version});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard1> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          // backgroundColor: Colors.transparent,
          leading: Center(
            child: Text(widget.version),
          ),
          title: Text(
            widget.title,
          ),
        ),
        body: SafeArea(
          child: HomeZaloPay(widget.title),
        ),
      ),
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
    );    
  }
}

class HomeZaloPay extends StatefulWidget {
  final String title;

  HomeZaloPay(this.title);

  @override
  _HomeZaloPayState createState() => _HomeZaloPayState();
}

class _HomeZaloPayState extends State<HomeZaloPay> {
  final textStyle = TextStyle(color: Colors.black54);
  
  String zpTransToken = "";
  String payResult = "";
  String payAmount = "10000";
  bool showResult = false;

  @override
  void initState() {
    super.initState();
  }



Widget _btnCreateOrder(String value) => Padding(
  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
  child: GestureDetector(
    onTap: () async {
          

      int amount = int.parse(value);
      if (amount < 1000 || amount > 1000000) {
        setState(() {
          zpTransToken = "Invalid Amount";
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              
            );
          },
        );

        var result = await createOrder(amount);
        if (result != null) {
          Navigator.pop(context);
          zpTransToken = result.zptranstoken!;
          print("zpTransToken $zpTransToken.");

          setState(() {
            zpTransToken = result.zptranstoken!;
            showResult = true;
          });
          setState(() {
            launchUrl(Uri.parse(result.orderurl.toString()), mode: LaunchMode.externalApplication);
            Navigator.pop(context);
          });

          // Mở URL kết quả

        }
      }
    },
    child: Container(
      height: 50.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.blue, // Thêm màu nền để dễ nhìn hơn
      ),
      child: Text(
        "Create Order",
        style: TextStyle(color: Colors.white, fontSize: 20.0),
      ),
    ),
  ),
);

  /// Build Button Pay
  Widget _btnPay(String zpToken) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: Visibility(
        visible: showResult,
        child: GestureDetector(
          onTap: () async {
            FlutterZaloPaySdk.payOrder(zpToken: zpToken).then((event) {
              setState(() {
                switch (event) {
                  case FlutterZaloPayStatus.cancelled:
                    payResult = "User Huỷ Thanh Toán";
                    break;
                  case FlutterZaloPayStatus.success:
                    payResult = "Thanh toán thành công";
                    break;
                  case FlutterZaloPayStatus.failed:
                    payResult = "Thanh toán thất bại";
                    break;
                  default:
                    payResult = "Thanh toán thất bại";
                    break;
                }
              });
            });
          },
          child: Container(
            
            width: double.infinity,
              height: 50.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.red,
                // color: AppColor.primaryColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text("Pay",
                  style: TextStyle(color: Colors.red, fontSize: 50.0))),
        ),
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _quickConfig,
          TextFormField(
            decoration: const InputDecoration(
              
              hintText: 'Amount',
              icon: Icon(Icons.attach_money),
            ),
            initialValue: payAmount,
            onChanged: (value) {
              setState(() {
                payAmount = value;
              });
            },
            keyboardType: TextInputType.number,
          ),
          _btnCreateOrder(payAmount),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Visibility(
              child: Text(
                "zptranstoken:",
                style: textStyle,
              ),
              visible: showResult,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              zpTransToken,
 
            ),
          ),
          _btnPay(zpTransToken),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Visibility(
                child: Text("Transaction status:", style: TextStyle(color: Colors.red)),
                visible: showResult),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              payResult,

            ),
          ),
        ],
      ),
    );
  }
}

/// Build Info App
Widget _quickConfig = Container(
  margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text("AppID: 2553"),
          ),
        ],
      ),
      // _btnQuickEdit,
    ],
  ),
);