import 'package:booking/Management/RoomType/RoomForm.dart';
import 'package:booking/Management/RoomType/room_delete_dialog.dart';
import 'package:booking/Management/RoomType/room_edit_dialog.dart';
import 'package:booking/Management/role/widgets/FormCreateRole.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';

class CreateRole extends StatefulWidget {
  const CreateRole({Key? key}) : super(key: key);

  @override
  State<CreateRole> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<CreateRole> {
  final TextEditingController nameRole = TextEditingController();
  
  final CollectionReference _item =
      FirebaseFirestore.instance.collection('role');


 

  @override
  void initState() {
    super.initState();

    
  }

 

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Formcreaterole(
          nameRole: nameRole,
          onSubmit: () async {
            
            final String _nameRole = nameRole.text;
          

            await _item.add({
              'name':_nameRole
            });
            nameRole.clear();
            
            
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A2A40),
      body: StreamBuilder<QuerySnapshot>(
        stream: _item.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text('Some error occurred: ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            QuerySnapshot querySnapshot = snapshot.data!;
            List<QueryDocumentSnapshot> documents = querySnapshot.docs;

            
            
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
                                    text: "Name Role: ",
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
                            // const SizedBox(height: 5),
                            // RichText(
                            //   text: TextSpan(
                            //     children: [
                            //       const TextSpan(
                            //         text: "Price: ",
                            //         style: TextStyle(
                            //           fontFamily:
                            //               'Courier', // Thay đổi font chữ
                            //           fontSize: 14,
                            //           fontWeight: FontWeight.bold,
                            //           color: Color.fromARGB(255, 31, 144, 243),
                            //         ),
                            //       ),
                            //       TextSpan(
                            //         text: "${thisItem['price']} VND/Night",
                            //         style: const TextStyle(
                            //           fontFamily:
                            //               'Courier', // Thay đổi font chữ
                            //           fontSize: 14,
                            //           color:
                            //               Colors.white, // Màu chữ của giá trị
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // const SizedBox(height: 5),
                            // Text(
                            //   "Services: ${thisItem['services'] != null ? (thisItem['services'] as List).join(', ') : 'None'}",
                            //   style: const TextStyle(
                            //     fontFamily: 'Courier',
                            //     fontSize: 14,
                            //     fontStyle: FontStyle.italic,
                            //     color: Colors.grey, // Thay đổi màu chữ
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      // Phần chứa các biểu tượng chỉnh sửa và xóa
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Color.fromARGB(255, 23, 127, 230),
                            ),
                            onPressed: (){},
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Color.fromARGB(255, 230, 23, 23),
                            ),
                            onPressed:  (){},
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _create(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
