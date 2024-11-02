import 'package:booking/Management/RoomType/image_picker_util.dart';
import 'package:booking/Management/Room/roomform.dart';
import 'package:booking/Management/Room/roomtype_delete_dialog.dart';
import 'package:booking/Management/Room/roomtype_edit_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class RoomtypeScreen extends StatefulWidget {
  const RoomtypeScreen({super.key});

  @override
  State<RoomtypeScreen> createState() => _RoomtypeScreenState();
}

class _RoomtypeScreenState extends State<RoomtypeScreen> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final CollectionReference _item =
      FirebaseFirestore.instance.collection('Room');

  final CollectionReference _roomTypes =
      FirebaseFirestore.instance.collection('RoomType');

  Stream<QuerySnapshot>? _stream;
  String imageUrl = '';
  String? _selectedRoomType;

  List<String> _roomTypeOptions = [];

  @override
  void initState() {
    super.initState();
    _stream = FirebaseFirestore.instance.collection('Room').snapshots();
    _loadRoomTypes();
  }

  Future<void> _loadRoomTypes() async {
    try {
      QuerySnapshot snapshot = await _roomTypes.get();
      List<String> roomTypes =
          snapshot.docs.map((doc) => doc['number'] as String).toList();
      setState(() {
        _roomTypeOptions = roomTypes;
      });
    } catch (e) {
      print('Error loading room types: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load room types.')));
    }
  }

  Future<void> _create() async {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Roomform(
          numberController: _numberController,
          floorController: _floorController,
          selectedRoomType: _selectedRoomType,
          roomTypeOptions: _roomTypeOptions,
          onRoomTypeChanged: (String? newValue) {
            setState(() {
              _selectedRoomType = newValue;
            });
          },
          onPickImage: () async {
            String tempDocumentId = randomAlphaNumeric(10);
            String? url = await pickAndUploadImage(tempDocumentId);
            if (url != null) {
              setState(() {
                imageUrl = url;
              });
            }
          },
          onSubmit: () async {
            if (imageUrl.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please pick an image')));
              return;
            }
            final String number = _numberController.text;
            final String floor = _floorController.text;
            final String roomType = _selectedRoomType ?? 'Unknown';

            await _item.add({
              "id": randomAlphaNumeric(10),
              "number": number,
              "floor": floor,
              "status": "empty",
              "roomType": roomType,
              "img": imageUrl,
            });
            _numberController.clear();
            _floorController.clear();
            _selectedRoomType = null;

            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A2A40),
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
            documents.sort((a, b) {
              String numberA = a['number'] ?? '';
              String numberB = b['number'] ?? '';
              return numberA.compareTo(numberB); // So sánh theo thứ tự số
            });
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
                                    text: "Number: ",
                                    style: TextStyle(
                                      fontFamily:
                                          'Courier', // Thay đổi font chữ
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 31, 144, 243),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${thisItem['number']}",
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
                                    text: "RoomType: ",
                                    style: TextStyle(
                                      fontFamily:
                                          'Courier', // Thay đổi font chữ
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 31, 144, 243),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${thisItem['roomType']}",
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
                                    text: "Floor: ",
                                    style: TextStyle(
                                      fontFamily:
                                          'Courier', // Thay đổi font chữ
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 31, 144, 243),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${thisItem['floor']}",
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
                                    text: "Status: ",
                                    style: TextStyle(
                                      fontFamily:
                                          'Courier', // Thay đổi font chữ
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 31, 144, 243),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${thisItem['status']}",
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

                      // Column(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     IconButton(
                      //       icon: const Icon(
                      //         Icons.edit,
                      //         color: Color.fromARGB(255, 23, 127, 230),
                      //       ),
                      //       onPressed: () => showEditDialog(
                      //         context,
                      //         document.id,
                      //         thisItem,
                      //     _numberController,

                      //       _floorController,
                      //         imageUrl,
                      //         () async {
                      //           String tempDocumentId = randomAlphaNumeric(10);
                      //           String? url =
                      //               await pickAndUploadImage(tempDocumentId);
                      //           if (url != null) {
                      //             setState(() {
                      //               imageUrl = url;
                      //             });
                      //           }
                      //         },
                      //         (List<String> values) {
                      //           setState(() {
                      //             _selectedServices = values;
                      //           });
                      //         }, // Pass the onServicesChanged function
                      //       ),
                      //     ),
                      //     IconButton(
                      //       icon: const Icon(
                      //         Icons.delete,
                      //         color: Color.fromARGB(255, 230, 23, 23),
                      //       ),
                      //       onPressed: () => showDeleteConfirmationDialog(
                      //         context,
                      //         document.id,
                      //         () async {
                      //           await _roomTypes
                      //               .doc(document.id)
                      //               .delete(); // Handle the deletion
                      //         },
                      //       ),
                      //     ),
                      //   ],
                      // ),
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
