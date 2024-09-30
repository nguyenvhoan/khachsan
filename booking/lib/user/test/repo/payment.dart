import 'dart:io';

import 'package:booking/user/test/models/create_order_response.dart';
import 'package:booking/user/test/utils/endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:booking/user/test/utils/util.dart' as utils;
import 'package:sprintf/sprintf.dart';
import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:url_launcher/url_launcher.dart';


class ZaloPayConfig {
  static const String appId = "2554";
  static const String key1 = "sdngKKJmqEMzvh5QQcdD2A9XBSKUNaYn";
  static const String key2 = "";

  static const String appUser = "zalopaydemo";
  static int transIdDefault = 1;
}

Future<CreateOrderResponse?> createOrder(int price) async {
  var header = new Map<String, String>();
  header["Content-Type"] = "application/x-www-form-urlencoded";

  var body = new Map<String, String>();
  body["app_id"] = ZaloPayConfig.appId;
  body["app_user"] = ZaloPayConfig.appUser;
  body["app_time"] = DateTime.now().millisecondsSinceEpoch.toString();
  body["amount"] = price.toStringAsFixed(0);
  body["app_trans_id"] = utils.getAppTransId();
  body["embed_data"] = "{}";
  body["item"] = "[]";
  body["bank_code"] = utils.getBankCode();
  body["description"] = utils.getDescription(body["app_trans_id"]!);

  var dataGetMac = sprintf("%s|%s|%s|%s|%s|%s|%s", [
    body["app_id"],
    body["app_trans_id"],
    body["app_user"],
    body["amount"],
    body["app_time"],
    body["embed_data"],
    body["item"]
  ]);
  body["mac"] = utils.getMacCreateOrder(dataGetMac);
  print("mac: ${body["mac"]}");

  http.Response response = await http.post(
  Uri.parse(Endpoints.createOrderUrl), // Convert string URL to Uri
  headers: header,
  body: body,
);

  print("body_request: $body");
  if (response.statusCode != 200) {
    return null;
  }

  var data = jsonDecode(response.body);
  await launchPaymentUrl(data['order_url']);
  print("data_response: $data}");

  return CreateOrderResponse.fromJson(data);
}
Future<void> launchPaymentUrl(String url) async {
  try {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
      throw 'Could not launch $url';
    }
  } catch (e) {
    print('Error launching URL: $e');
  }
}

  Future<http.Response> postCallback(HttpRequest request) async {
    final Map<String, dynamic> result = {};
    
    try {
      // Read the request body
      String content = await utf8.decodeStream(request);
      final Map<String, dynamic> cbdata = json.decode(content);

      final String dataStr = cbdata['data'];
      final String reqMac = cbdata['mac'];

      final String mac = computeHmac(dataStr);

      print("mac = $mac");

      // Validate callback (from ZaloPay server)
      if (reqMac != mac) {
        // Invalid callback
        result['return_code'] = -1;
        result['return_message'] = "mac not equal";
      } else {
        // Payment succeeded
        final Map<String, dynamic> dataJson = json.decode(dataStr);
        print("update order's status = success where app_trans_id = ${dataJson['app_trans_id']}");
        
        result['return_code'] = 1;
        result['return_message'] = "success";
      }
    } catch (e) {
      result['return_code'] = 0; // ZaloPay server will callback again (up to 3 times)
      result['return_message'] = e.toString();
    }

    // Notify the result to ZaloPay server
    return http.Response(json.encode(result), HttpStatus.ok);
  }

  String computeHmac(String dataStr) {
    final key = utf8.encode(ZaloPayConfig.key2);
    final bytes = utf8.encode(dataStr);
    final hmacSha256 = Hmac(sha256, key);
    final digest = hmacSha256.convert(bytes);
    return digest.toString();
  }

