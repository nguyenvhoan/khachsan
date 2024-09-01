import 'package:flutter/material.dart';


class Adminmanager extends StatelessWidget {
   Adminmanager({super.key});
// final FirebaseFirestore db = FirebaseFirestore.instance;
// DatabaseService databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      // drawer: Navbar(),
      body: GestureDetector(
        onTap: () async {
          // final FirebaseFirestore db = FirebaseFirestore.instance;

  // Tham chiếu tới collection 'room'
  // final CollectionReference users = db.collection('room');

  // // Lấy dữ liệu từ tài liệu 'room A01'
  // final DocumentSnapshot snapshot = await users.doc('room A01').get();

  // Kiểm tra xem tài liệu có tồn tại không
  // if (snapshot.exists) {
  //   // In dữ liệu ra console
  //   print(snapshot.data());
  // } else {
  //   print('Tài liệu không tồn tại.');
  // }
        },
        child: Container(
          child: Text('Text')
          ),
      ) 
    );
  }
}