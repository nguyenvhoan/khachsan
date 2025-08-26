import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sprintf/sprintf.dart';
import '../utils/util.dart';
import '../utils/config.dart';

class CreateOrderResponse {
  final String? zpTransToken;
  final String? orderUrl;
  final int? returnCode;
  final String? returnMessage;

  CreateOrderResponse({
    this.zpTransToken,
    this.orderUrl,
    this.returnCode,
    this.returnMessage,
  });

  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) {
    return CreateOrderResponse(
      zpTransToken: json['zp_trans_token'],
      orderUrl: json['order_url'],
      returnCode: json['return_code'],
      returnMessage: json['return_message'],
    );
  }
}

Future<CreateOrderResponse?> createOrder(int price) async {
  try {
    // Header cho request
    var header = {"Content-Type": "application/x-www-form-urlencoded"};

    // Body của request
    var body = {
      "app_id": ZaloPayConfig.appId,
      "app_user": ZaloPayConfig.appUser,
      "app_time": DateTime.now().millisecondsSinceEpoch.toString(),
      "amount": price.toString(),
      "app_trans_id": getAppTransId(),
      "embed_data": "{}",
      "item": "[]",
      "bank_code": getBankCode(),
      "description": getDescription(getAppTransId()),
    };

    // Tạo chữ ký (mac)
    var dataToSign = sprintf("%s|%s|%s|%s|%s|%s|%s", [
      body["app_id"],
      body["app_trans_id"],
      body["app_user"],
      body["amount"],
      body["app_time"],
      body["embed_data"],
      body["item"]
    ]);
    body["mac"] = getMacCreateOrder(dataToSign);

    print("Payload: $body");

    // Gửi request đến API ZaloPay
    final response = await http.post(
      Uri.parse(ZaloPayConfig.createOrderUrl),
      headers: header,
      body: body,
    );

    // Xử lý phản hồi từ API
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print("Response: $data");

      // Kiểm tra mã trả về từ API
      if (data['return_code'] == 1) {
        return CreateOrderResponse.fromJson(data);
      } else {
        print("Error: ${data['return_message']}");
        return null;
      }
    } else {
      print("HTTP Error: ${response.statusCode}");
      print("Response Body: ${response.body}");
      return null;
    }
  } catch (e) {
    print("Exception: $e");
    return null;
  }
}
Future<void> checkTransactionStatus(String appTransId) async {
  try {
    // Header cho request
    var header = {"Content-Type": "application/json"};

    // Body của request
    var body = {
      "app_id": ZaloPayConfig.appId,
      "app_trans_id": appTransId,
      "mac": getMacCreateOrder("${ZaloPayConfig.appId}|$appTransId|${ZaloPayConfig.key1}"),
    };

    print("Payload for status check: $body");

    // Gửi request đến API ZaloPay
    final response = await http.post(
      Uri.parse("https://sb-openapi.zalopay.vn/v2/query"),
      headers: header,
      body: jsonEncode(body),
    );

    // Xử lý phản hồi từ API
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print("Transaction status response: $data");

      if (data['return_code'] == 1) {
        // Giao dịch thành công
        print("Giao dịch thành công: ${data['return_message']}");
      } else {
        // Giao dịch thất bại hoặc đang chờ xử lý
        print("Giao dịch thất bại hoặc đang chờ xử lý: ${data['return_message']}");
      }
    } else {
      print("HTTP Error: ${response.statusCode}");
      print("Response Body: ${response.body}");
    }
  } catch (e) {
    print("Exception while checking transaction status: $e");
  }
}