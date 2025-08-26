import 'package:booking/Management/RoomType/RoomForm.dart';
import 'package:booking/Management/RoomType/image_picker_util.dart';
import 'package:booking/Management/RoomType/room_delete_dialog.dart';
import 'package:booking/Management/RoomType/room_edit_dialog.dart';
import 'package:booking/Management/role/widgets/FormCreateAccountAdmin.dart';
import 'package:booking/Management/role/widgets/formEditAccountAdmin.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';

class Customer extends StatefulWidget {
  const Customer({Key? key}) : super(key: key);

  @override
  State<Customer> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<Customer> {
  
  final CollectionReference _item =
      FirebaseFirestore.instance.collection('user');

  final CollectionReference _service =
      FirebaseFirestore.instance.collection('role');
  Stream<QuerySnapshot>? _stream;
  String imageUrl = '';
  String? _selectedRole;
  List<String> _selectedServices = [];
  List<String> _roleOptions = [];
  String img='';

  @override
  void initState() {
    super.initState();
    _stream = FirebaseFirestore.instance.collection('user').snapshots();

  }



  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A2A40),
      body: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text('Some error occurred: ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            QuerySnapshot querySnapshot = snapshot.data!;
            List<QueryDocumentSnapshot> documents = querySnapshot.docs;

            // Sắp xếp các tài liệu theo số phòng
            
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (BuildContext context, int index) {
                QueryDocumentSnapshot document = documents[index];
                Map<String, dynamic> thisItem =
                    document.data() as Map<String, dynamic>;

                return Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(
                      top: 20, left: 10, right: 10, bottom: 5),
                  decoration: BoxDecoration(
                    color: Colors.transparent, // Background color of the item
                    border: Border.all(
                      color: const Color.fromARGB(
                          255, 83, 214, 250), // Border color
                      // Border width
                    ),
                    borderRadius: BorderRadius.circular(8), // Border radius
                  ),
                  child: Row(
                    children: [
                      // Phần chứa hình ảnh
                      Container(
                        width: 100, // Thay đổi kích thước nếu cần
                        height: 100, // Thay đổi kích thước nếu cần

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: thisItem['img'] != null
                              ? DecorationImage(
                                  image: NetworkImage(thisItem['img']),
                                  fit: BoxFit.cover,
                                )
                              : null,
                          color: Colors.transparent,
                        ),
                        child: thisItem['img'] == null
                            ? const Icon(Icons.image,
                                size: 50) // Thay đổi kích thước icon nếu cần
                            : null,
                      ),
                      const SizedBox(width: 10),
                      // Phần chứa thông tin chi tiết
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "FullName: ",
                                    style: TextStyle(
                                      fontFamily:
                                          'Courier', // Thay đổi font chữ
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 31, 144, 243),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${thisItem['name']}",
                                    style: const TextStyle(
                                      fontFamily:
                                          'Courier', // Thay đổi font chữ
                                      fontSize: 14,
                                      color:
                                          Colors.white, // Màu chữ của giá trị
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "Email: ",
                                    style: TextStyle(
                                      fontFamily:
                                          'Courier', // Thay đổi font chữ
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 31, 144, 243),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${thisItem['email']} ",
                                    style: const TextStyle(
                                      fontFamily:
                                          'Courier', // Thay đổi font chữ
                                      fontSize: 14,
                                      color:
                                          Colors.white, // Màu chữ của giá trị
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "Score: ",
                                    style: TextStyle(
                                      fontFamily:
                                          'Courier', // Thay đổi font chữ
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 31, 144, 243),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${thisItem['score']} ",
                                    style: const TextStyle(
                                      fontFamily:
                                          'Courier', // Thay đổi font chữ
                                      fontSize: 14,
                                      color:
                                          Colors.white, // Màu chữ của giá trị
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "Address: ",
                                    style: TextStyle(
                                      fontFamily:
                                          'Courier', // Thay đổi font chữ
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 31, 144, 243),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${thisItem['address']} ",
                                    style: const TextStyle(
                                      fontFamily:
                                          'Courier', // Thay đổi font chữ
                                      fontSize: 14,
                                      color:
                                          Colors.white, // Màu chữ của giá trị
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "BirthDay: ",
                                    style: TextStyle(
                                      fontFamily:
                                          'Courier', // Thay đổi font chữ
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 31, 144, 243),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${thisItem['day']} ",
                                    style: const TextStyle(
                                      fontFamily:
                                          'Courier', // Thay đổi font chữ
                                      fontSize: 14,
                                      color:
                                          Colors.white, // Màu chữ của giá trị
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "Password: ",
                                    style: TextStyle(
                                      fontFamily:
                                          'Courier', // Thay đổi font chữ
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 31, 144, 243),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${thisItem['password']} ",
                                    style: const TextStyle(
                                      fontFamily:
                                          'Courier', // Thay đổi font chữ
                                      fontSize: 14,
                                      color:
                                          Colors.white, // Màu chữ của giá trị
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                          ],
                        ),
                      ),
                     
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                         
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Color.fromARGB(255, 230, 23, 23),
                            ),
                            onPressed: () => showDeleteConfirmationDialog(
                              context,
                              document.id,
                              () async {
                                await _item
                                    .doc(document.id)
                                    .delete(); // Handle the deletion
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      
    );
  }
}
