import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {Future<void> sendRequest() async {
    final response = await http.post(
      Uri.parse('https://example.com/api/request'), // Thay bằng URL của bạn
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userId': 'user123', // ID của người dùng
        'message': 'User sent a request to admin.', // Thông điệp gửi
      }),
    );

    if (response.statusCode == 200) {
      // Xử lý phản hồi thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request sent to admin!')),
      );
    } else {
      // Xử lý lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send request.')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Detail'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: sendRequest, // Gọi hàm khi nhấn nút
          child: const Text('Send Request to Admin'),
        ),
      ),
    );
  }
}