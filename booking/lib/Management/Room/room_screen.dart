import 'package:booking/Management/Room/RoomForm.dart';
import 'package:booking/Management/Room/room_delete_dialog.dart';
import 'package:booking/Management/Room/room_edit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
import 'image_picker_util.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({Key? key}) : super(key: key);

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _introduceController = TextEditingController();
  final CollectionReference _item =
      FirebaseFirestore.instance.collection('Room');
  final CollectionReference _roomTypes =
      FirebaseFirestore.instance.collection('RoomType');
  final CollectionReference _service =
      FirebaseFirestore.instance.collection('Service');
  Stream<QuerySnapshot>? _stream;
  String imageUrl = '';
  String? _selectedRoomType;
  List<String> _selectedServices = [];
  List<String> _roomTypeOptions = [];
  List<String> _serviceOptions = [];

  @override
  void initState() {
    super.initState();
    _stream = FirebaseFirestore.instance.collection('Room').snapshots();
    _loadRoomTypes();
    _loadServices();
  }

  Future<void> _loadRoomTypes() async {
    try {
      QuerySnapshot snapshot = await _roomTypes.get();
      List<String> roomTypes =
          snapshot.docs.map((doc) => doc['roomtype'] as String).toList();
      setState(() {
        _roomTypeOptions = roomTypes;
      });
    } catch (e) {
      print('Error loading room types: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load room types.')));
    }
  }

  Future<void> _loadServices() async {
    try {
      QuerySnapshot snapshot = await _service.get();
      List<String> services =
          snapshot.docs.map((doc) => doc['service'] as String).toList();
      setState(() {
        _serviceOptions = services;
      });
    } catch (e) {
      print('Error loading services: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load services.')));
    }
  }

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return RoomForm(
          numberController: _numberController,
          priceController: _priceController,
          introduceController: _introduceController,
          selectedRoomType: _selectedRoomType,
          roomTypeOptions: _roomTypeOptions,
          selectedServices: _selectedServices,
          serviceOptions: _serviceOptions,
          onRoomTypeChanged: (String? newValue) {
            setState(() {
              _selectedRoomType = newValue;
            });
          },
          onServicesChanged: (List<String> values) {
            setState(() {
              _selectedServices = values;
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
            final int price = int.tryParse(_priceController.text) ?? 0;
            final String introduce = _introduceController.text;
            final String roomType = _selectedRoomType ?? 'Unknown';
            final List<String> services =
                _selectedServices.isNotEmpty ? _selectedServices : ['Unknown'];

            await _item.add({
              "Id": randomAlphaNumeric(10),
              "number": number,
              "price": price,
              "intro": introduce,
              "status": "empty",
              "img": imageUrl,
              "roomType": roomType,
              "services": services,
            });
            _numberController.clear();
            _priceController.clear();
            _introduceController.clear();
            _selectedRoomType = null;
            _selectedServices = [];
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
        stream: _stream,
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
                                    text: "Room Number: ",
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
                                    text: "Price: ",
                                    style: TextStyle(
                                      fontFamily:
                                          'Courier', // Thay đổi font chữ
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 31, 144, 243),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${thisItem['price']} VND/Night",
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
                                    text: "Room Type: ",
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
                            Text(
                              "Services: ${thisItem['services'] != null ? (thisItem['services'] as List).join(', ') : 'None'}",
                              style: const TextStyle(
                                fontFamily: 'Courier',
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey, // Thay đổi màu chữ
                              ),
                            ),
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
                            onPressed: () => showEditDialog(
                              context,
                              document.id,
                              thisItem,
                              _numberController, // Pass the controllers
                              _priceController,
                              _introduceController,
                              imageUrl, // Pass the current image URL
                              () async {
                                // Pass the image picker callback
                                String tempDocumentId = randomAlphaNumeric(10);
                                String? url =
                                    await pickAndUploadImage(tempDocumentId);
                                if (url != null) {
                                  setState(() {
                                    imageUrl = url;
                                  });
                                }
                              },
                            ),
                          ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _create(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
