import 'package:booking/model/database_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
DatabaseService  _databaseService =DatabaseService();
bool checkDay(DateTime a, DateTime target){
  if(a.day==target.day&&a.month==target.month&&a.year==target.year){
    return true;
  }
  else return false;
}

bool? getSTT(Map<String, dynamic> room, Map<String, dynamic> req) {
  if (!room['user'].isEmpty) {
    for(int i =0; i<room['user'].length;i++){

    
DateTime userStart = DateTime.parse(room['user'][i]['start']);
DateTime userEnd = DateTime.parse(room['user'][i]['end']);
DateTime reqStart = DateTime.parse(req['start']);
DateTime reqEnd = DateTime.parse(req['end']);
    if(reqEnd.isBefore(userEnd)&&reqEnd.isBefore(userStart))
      return false;
    else if (reqStart.isAfter(userEnd)&&reqStart.isAfter(userStart))
      return false;
    else if (reqStart.isBefore(userStart)&&reqEnd.isBefore(userEnd)&&reqEnd.isAfter(userStart))
      return true; 
    else if (reqStart.isBefore(userStart)&&reqEnd.isAtSameMomentAs(userEnd)&&reqEnd.isAfter(userStart))
      return true;
    else if (reqStart.isAtSameMomentAs(userStart)&&reqEnd.isAtSameMomentAs(userEnd))
      return true;   
    else if (reqStart.isAfter(userStart)&&reqEnd.isAtSameMomentAs(userEnd)&&reqStart.isBefore(userEnd))
      return true;   
    else if (reqStart.isAfter(userStart)&&reqEnd.isAfter(userEnd)&&reqEnd.isAfter(userStart))
      return true;
    else if (reqStart.isBefore(userStart)&&reqEnd.isAfter(userEnd))
      return true;  
    else return false;
    }
    
}
else return false;
}



String datetodate(String date){
  DateTime dateTime = DateTime.parse(date);
  
  // Định dạng lại thành chuỗi mới
  String formattedDate = '${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}';
  return formattedDate;
}
Future<void> showRoomSelectionDialog(
    BuildContext context, Map<String,dynamic> req) async {
  final CollectionReference _roomCollection =
      FirebaseFirestore.instance.collection('Room');

  // Lấy danh sách các phòng thuộc loại phòng đã cho
  QuerySnapshot roomSnapshot =
      await _roomCollection.where('roomType', isEqualTo: req['roomType']).get();
  List<Map<String, dynamic>> roomList = roomSnapshot.docs.map((doc) {
  List<dynamic> users = doc['user'] ?? []; // Đảm bảo user là List
  print('user: ${doc['user']}');
  // Chỉ trả về thông tin phòng nếu users không rỗng
  if (users.isEmpty) {
   return{
    'id': doc['id'] as String,
    'number': doc['number'] as String,
    'status': doc['status'] as String,
    'user':doc['user'] as List<dynamic>,
   };
  }
  
  return {
    'id': doc['id'] as String,
    'number': doc['number'] as String,
    'status': doc['status'] as String,
    'user':doc['user'] as List<dynamic>,

  };
}).where((room) => room != null).cast<Map<String, dynamic>>().toList();
changeStatusRoomEndDate();
String doc=roomSnapshot.docs.first.id;
// print('-------------------------------------------------');

// print('Room List :${roomList}');
// print('-------------------------------------------------');

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
                    print(room['user'].isEmpty);
                    print(room['user']!=null);
                    
                    
                    room['user'].isNotEmpty&&room['user']!=null?targetDate= DateTime.parse(room['user'].first['start']):print('hh');
                    print(targetDate);
                    room['user'].isEmpty?print('${room['number']}\n'+'Trống'):
                    print('${room['number']}\n'+
                    'start:${datetodate(room['user'].first['start'])}\n'
                    +'end:${datetodate(room['user'].first['end'])
                    }');
                    var earliestUser;
                    if(!room['user'].isEmpty){
                        earliestUser = room['user'].reduce((a, b) {
                      DateTime startA = DateTime.parse(a['start']);
                      DateTime startB = DateTime.parse(b['start']);
                      return startA.isBefore(startB) ? a : b;
                      
                    });
                    
                    }

                return Container(
                  width: 150, 
                  height: 100, 
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: getSTT(room, req)!?Colors.blue:Colors.white,
                    border: Border.all(     
                      width: 1, 
                      color: Colors.grey
                    )
                  ),
                  child: ListTile(
                    title: Center(child: Text(
                    
                    room['user'].isEmpty?'${room['number']}\n'+'Trống':
                    '${room['number']}\n'+
                    'start:${datetodate(earliestUser['start'])}\n'
                    +'end:${datetodate(earliestUser['end'])
                    }',
                    
                    
                    
                    style: TextStyle(
                        fontSize: 16
                    ),)), 
                    onTap: () {
                      print(roomSnapshot.docs[index].id);
                      // Xử lý chọn phòng
                      if(!getSTT(room, req)!){
                        print('success');
                        print(req);
                        print(room);
                          Navigator.of(context).pop(); 
                        req['numberRoom']=room['number'];
                        print(req['numberRoom']);
                      createBill(req);
                      print('success create bill');
                      Map<String,dynamic> user =({
                        'idUser':req['idUser'],   
                        'nameUser':req['nameUser'],
                        'start':req['start'],
                        'end':req['end'],
                        'phone':req['phoneNumber'],
                        'email':req['emailUser'],
                        'idRoom':room['id'],

                      });
                      room['user'].isEmpty||room['user']==null?updateUserToRoom([], roomSnapshot.docs[index].id,user):
                      updateUserToRoom(room['user'], roomSnapshot.docs[index].id,user );
                      _databaseService.deleteReq('request '+req['id']); 
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
Future<void> updateUserToRoom(List<dynamic> user, String doc,  Map<String,dynamic> a) async {
  final CollectionReference _roomCollection =
      FirebaseFirestore.instance.collection('Room');
      user.add(a);
 
  try {
    print(a['idRoom']);
    QuerySnapshot roomSnapshot = await _roomCollection
        .where('id', isEqualTo: a['idRoom'])
        .get();
        
    if (roomSnapshot.docs.isNotEmpty) {
      await _roomCollection.doc(doc).update({
        'status':'servicing'    
      });  
      await _roomCollection.doc(doc).update({
        'user':user
      });  
      
    } else {
      print('No room found with idRoom: ${a['idRoom']}');
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
// print('Room List :${roomList}');
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
