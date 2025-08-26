import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:sprintf/sprintf.dart';
import 'config.dart';

/// Định dạng số tiền
String formatNumber(double value) {
  final f = NumberFormat("#,###", "vi_VN");
  return f.format(value);
}

/// Định dạng ngày giờ
String formatDateTime(DateTime dateTime, String layout) {
  return DateFormat(layout).format(dateTime).toString();
}

/// Tạo mã giao dịch duy nhất
int transIdDefault = 1;
String getAppTransId() {
  if (transIdDefault >= 100000) {
    transIdDefault = 1;
  }
  transIdDefault += 1;
  var timeString = formatDateTime(DateTime.now(), "yyMMdd_hhmmss");
  return sprintf("%s%06d", [timeString, transIdDefault]);
}

/// Lấy mã ngân hàng
String getBankCode() => "zalopayapp";

/// Mô tả giao dịch
String getDescription(String appTransId) =>
    "Merchant Demo thanh toán cho đơn hàng #$appTransId";

/// Tạo chữ ký (HMAC SHA256)
String getMacCreateOrder(String data) {
  var hmac = Hmac(sha256, utf8.encode(ZaloPayConfig.key1));
  return hmac.convert(utf8.encode(data)).toString();
}