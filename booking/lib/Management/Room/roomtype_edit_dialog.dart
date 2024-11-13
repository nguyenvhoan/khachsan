import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> showEditDialog(
    BuildContext context,
    String id,
    Map<String, dynamic> thisItem,
    TextEditingController roomTypeController,
    TextEditingController priceController,
    TextEditingController introduceController,
    String imageUrl,
    Function onPickImage,
    void Function(List<String>) onServicesChanged) async {
  // Đặt giá trị ban đầu cho các TextEditingController
  roomTypeController.text = thisItem['roomtype'] ?? ''; // Loại phòng
  priceController.text = thisItem['price']?.toString() ?? ''; // Giá tiền
  introduceController.text = thisItem['intro']?.toString() ?? '';
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Edit Room'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Hiển thị hình ảnh hiện có hoặc mặc định
              GestureDetector(
                onTap: () => onPickImage(), // Sử dụng hàm được truyền vào
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: imageUrl.isNotEmpty
                      ? NetworkImage(imageUrl)
                      : thisItem['img'] != null
                          ? NetworkImage(thisItem['img'])
                          : null,
                  child: thisItem['img'] == null && imageUrl.isEmpty
                      ? const Icon(Icons.image)
                      : null,
                ),
              ),
              // Các TextField để chỉnh sửa loại phòng và giá
              TextField(
                controller: roomTypeController,
                decoration: const InputDecoration(labelText: 'Room Type'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: introduceController,
                decoration: const InputDecoration(labelText: 'Intro'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Save'),
            onPressed: () async {
              // Lưu thay đổi
              if (roomTypeController.text.isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection('RoomType')
                    .doc(id)
                    .update({
                  'roomtype': roomTypeController.text,
                  'intro': introduceController.text,
                  'price': int.tryParse(priceController.text) ?? 0,
                  'img': imageUrl.isNotEmpty ? imageUrl : thisItem['img'],
                });
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
}

