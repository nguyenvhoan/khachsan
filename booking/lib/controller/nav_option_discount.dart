import 'package:booking/model/discount_model.dart';
import 'package:booking/model/room_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class NavOptionDiscount {
  final CollectionReference _item =
      FirebaseFirestore.instance.collection('Discount');
  final DiscountModel _discountModel = DiscountModel();
  Future<void> create(
    BuildContext context,
    TextEditingController _nameController,
    TextEditingController _introduController,
    TextEditingController _pointController,
  ) async {
    //BottomSheet (một phần giao diện người dùng có thể trượt từ dưới cùng của màn hình).
    showBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return GestureDetector(
            onTap: () {
              // Đóng BottomSheet khi người dùng chạm vào phía ngoài nội dung
              Navigator.of(ctx).pop();
            },
            child: Padding(
              padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text('Create Discount'),
                  ),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                        labelText: 'Name', hintText: 'Ngyn'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _introduController,
                    decoration: const InputDecoration(
                        labelText: 'Introduc', hintText: 'Ngyn'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _pointController,
                    decoration: const InputDecoration(
                        labelText: 'Point', hintText: '1000'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: ElevatedButton(
                        onPressed: () async {
                          String id = randomAlphaNumeric(10);
                          final String name = _nameController.text;
                          final String introduc = _introduController.text;
                          final String pointText =
                              _pointController.text; // Khai báo biến pointText
                          final int? point = int.tryParse(pointText);

                          if (point != null && name.isNotEmpty) {
                            await _item.add({
                              "name": name,
                              "id": id,
                              "introduc": introduc,
                              "point": point
                            });
                            _nameController.clear();
                            _introduController.clear();
                            _pointController.clear();
                            Navigator.of(context)
                                .pop(); // Đóng Modal Bottom Sheet
                          } else {
                            // Hiển thị SnackBar
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Name không được để trống'),
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                duration:
                                    Duration(seconds: 2), // Thời gian hiển thị
                              ),
                            );
                          }
                        },
                        child: const Text('Create')),
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> editType(
          String id,
          BuildContext context,
          TextEditingController _nameController,
          TextEditingController _introController,
          TextEditingController _pointController) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.cancel),
                ),
                const SizedBox(height: 10),
                const Row(
                  children: [
                    Text(
                      'Edit',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Detail',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'NameDiscount',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _introController,
                  decoration: const InputDecoration(
                    labelText: 'Intro',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _pointController,
                  decoration: const InputDecoration(
                    labelText: 'Point',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await _discountModel.updateDiscount(id, _nameController.text,
                    _introController.text, _pointController.text as int);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
}
