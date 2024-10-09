import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> showRoomSelectionDialog(
    BuildContext context, Map<String,dynamic> req) async {
  final CollectionReference _roomCollection =
      FirebaseFirestore.instance.collection('Room');

  // Lấy danh sách các phòng thuộc loại phòng đã cho
  QuerySnapshot roomSnapshot =
      await _roomCollection.where('roomType', isEqualTo: req['roomType']).get();
  List<Map<String, dynamic>> roomList = roomSnapshot.docs.map((doc) {
    doc['user']==null ? 
    print('null'):
    print(doc['user'].toString());
  return {
    'id':doc['id'] as String,
    'number': doc['number'] as String,  
    'status': doc['status'] as String,
    'user':doc['user'] as Map<String,dynamic>

    
     
  };
  

}).toList();
changeStatusRoomEndDate();
String doc=roomSnapshot.docs.first.id;
      print('-------------------------------------------------');

print('Room List :${roomList}');
print('-------------------------------------------------');

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
      content: Container(
        child: SingleChildScrollView( 
          child: Center(
            child: Wrap(
              spacing: 8.0, 
              runSpacing: 8.0,
              children: roomList.asMap().entries.map((entry) {
                int index = entry.key; // Lấy chỉ số của phòng
                
               var room = entry.value; 
               print('id : ${room}');
               Map<String,dynamic> user ;
                  DateTime targetDate = DateTime(2024, 10, 8);
                   
                    DateTime today = DateTime.now();
                    print(room['user']);
                    room['user'].isNotEmpty?targetDate= DateTime.parse(room['user']['start']):print('hh');
                    print(targetDate);
                return Container(
                  width: 100, 
                  height: 100, 
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: (today.year == targetDate.year &&
                            today.month == targetDate.month &&
                             today.day == targetDate.day)?
                             Colors.blue : Colors.white,
                    border: Border.all(
                      width: 1, 
                      color: Colors.grey
                    )
                  ),
                  child: ListTile(
                    title: Center(child: Text(room['number'],
                    style: TextStyle(

                    ),)), 
                    onTap: () {
                      print(roomSnapshot.docs[index].id);
                      // Xử lý chọn phòng
                      if(room['status']!='servicing'){
                        Navigator.of(context).pop(); 
                        req['roomNumber']=room['number'];
                      createBill(req);
                      Map<String,dynamic> user =({
                        'idUser':req['idUser'],
                        'nameUser':req['nameUser'],
                        'start':req['start'],
                        'end':req['end'],
                        'phone':req['phoneUser'],
                        'email':req['emailUser'],
                        'idRoom':room['id'],

                      });
                      updateUserToRoom(user, roomSnapshot.docs[index].id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Arranged successfull')),
                      );
                      } 
                      else 
                      {
                        showDialog(
                          context: context,
                           builder: (context)=>
                           AlertDialog(
                          title: const Text('Announcement'),
                          content: const Text('This room not empty'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            
                          ],
                        )
                           );
                                         
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
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
Future<void> changeStatusRoomEndDate()async {
  final CollectionReference _roomCollection =
      FirebaseFirestore.instance.collection('Room');
       QuerySnapshot roomSnapshot = await _roomCollection.get();
        
  
  }

Future<void> createBill(Map<String,dynamic> req) async {
  final CollectionReference _roomCollection =
      FirebaseFirestore.instance.collection('Bill');
      try{
        _roomCollection.doc('bill '+req['id']).set(req);
      }
      catch(e){
        print('fail create bill ${e}');
      }
}
Future<void> updateUserToRoom(Map<String, dynamic> user, String doc) async {
  final CollectionReference _roomCollection =
      FirebaseFirestore.instance.collection('Room');

  
 
  try {
    print(user['idRoom']);
    QuerySnapshot roomSnapshot = await _roomCollection
        .where('id', isEqualTo: user['idRoom'])
        .get();
        
    if (roomSnapshot.docs.isNotEmpty) {
      await _roomCollection.doc(doc).update({
        'status':'servicing'    
      });  
      await _roomCollection.doc(doc).update({
        'user':user
      });  
      
    } else {
      print('No room found with idRoom: ${user['idRoom']}');
    }
  } catch (e) {
    print('Fail to update room: ${e}');
  }
}
Future<void> showTableDialog(
    BuildContext context, String roomType, String requestId) async {
  final CollectionReference _roomCollection =
      FirebaseFirestore.instance.collection('Table');

  // Lấy danh sách các phòng thuộc loại phòng đã cho
  QuerySnapshot roomSnapshot =
      await _roomCollection.where('tableType', isEqualTo: roomType).get();

  List<String> roomList =
      roomSnapshot.docs.map((doc) => doc['number'] as String).toList();
      print('-------------------------------------------------');
print('Room List :${roomList}');
print('-------------------------------------------------');       

  // Kiểm tra xem danh sách có trống hay không
  if (roomList.isEmpty) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No table Available'),
          content: Text('No table available for the selected room type.'),
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
      'status': 'servicing',
    });
  } else {
    print('Room not found');
  }
}
