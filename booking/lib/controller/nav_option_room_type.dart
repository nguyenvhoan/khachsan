import 'package:booking/model/room_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class NavOptionRoomType {
  final CollectionReference _item =
      FirebaseFirestore.instance.collection('RoomType');
  final RoomTypeModel _roomType = RoomTypeModel();
  Future<void> create(
      BuildContext context, TextEditingController roomTypeController) async {
    // Sử dụng showModalBottomSheet thay cho showBottomSheet
    showModalBottomSheet(
        context: context,
        isScrollControlled: true, // Điều chỉnh kích thước Modal theo nội dung
        builder: (BuildContext ctx) {
          return Padding(
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
                  child: Text('Create Room Type'),
                ),
                TextField(
                  controller: roomTypeController,
                  decoration: const InputDecoration(
                      labelText: 'Type', hintText: 'Junior Suite'),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: ElevatedButton(
                      onPressed: () async {
                        String id = randomAlphaNumeric(10);
                        final String type = roomTypeController.text;

                        if (type.isNotEmpty) {
                          await _item.add({
                            "roomtype": type,
                            "id": id,
                          });
                          roomTypeController.clear();
                          Navigator.of(context)
                              .pop(); // Đóng Modal Bottom Sheet
                        } else {
                          // Hiển thị SnackBar nếu loại phòng trống
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Room type cannot be left blank'),
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
          );
        });
  }

  Future<void> editType(String id, BuildContext context,
          TextEditingController roomTypetController) =>
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
                  controller: roomTypetController,
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await _roomType.updateType(id, roomTypetController.text);
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
