import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> showRoomSelectionDialog(
    BuildContext context, String roomType, String requestId) async {
  final CollectionReference _roomCollection =
      FirebaseFirestore.instance.collection('Room');

  // Lấy danh sách các phòng thuộc loại phòng đã cho
  QuerySnapshot roomSnapshot =
      await _roomCollection.where('roomType', isEqualTo: roomType).get();

  List<String> roomList =
      roomSnapshot.docs.map((doc) => doc['number'] as String).toList();

  // Kiểm tra xem danh sách có trống hay không
  if (roomList.isEmpty) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No Rooms Available'),
          content: Text('No rooms available for the selected room type.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
            ),
          ],
        );
      },
    );
    return; // Dừng hàm nếu không có phòng
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Select Room for Order'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: roomList.map((room) {
              return ListTile(
                title: Text(room),
                onTap: () {
                  // Xử lý chọn phòng
                  Navigator.of(context).pop(); // Đóng dialog
                  updateRequestWithRoom(
                      requestId, room); // Cập nhật yêu cầu với số phòng
                },
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(); // Đóng dialog
            },
          ),
        ],
      );
    },
  );
}

Future<void> updateRequestWithRoom(String id, String roomNumber) async {
  final CollectionReference _requestCollection =
      FirebaseFirestore.instance.collection('Request');

  // In ra ID để kiểm tra
  print('Updating request with ID: $id and room number: $roomNumber');

  try {
    await _requestCollection.doc(id).update({
      'roomNumber': roomNumber, // Thêm trường mới roomNumber vào tài liệu
    });
    print('Updated successfully with id: $id');
  } catch (e) {
    print('Failed to update request: $e');
  }

  // Cập nhật trạng thái phòng thành 'full'
  await updateRoomStatus(roomNumber); // Gọi hàm cập nhật trạng thái
}

// Hàm cập nhật trạng thái của phòng
Future<void> updateRoomStatus(String roomNumber) async {
  final CollectionReference _roomCollection =
      FirebaseFirestore.instance.collection('Room');

  // Tìm tài liệu có 'number' tương ứng với roomNumber
  QuerySnapshot roomSnapshot =
      await _roomCollection.where('number', isEqualTo: roomNumber).get();

  if (roomSnapshot.docs.isNotEmpty) {
    String roomId = roomSnapshot.docs.first.id; // Lấy document ID

    // Cập nhật trạng thái phòng thành 'full'
    await _roomCollection.doc(roomId).update({
      'status': 'full',
    });
  } else {
    print('Room not found');
  }
}
