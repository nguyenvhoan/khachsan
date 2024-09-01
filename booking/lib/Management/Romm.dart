import 'dart:io';

import 'package:appthoitiet/model/room_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart'; // Import multi_select_flutter

class Room extends StatefulWidget {
  const Room({super.key});

  @override
  State<Room> createState() => _RoomState();
}

class _RoomState extends State<Room> {
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
  List<String> _selectedServices = []; // List to store selected services
  List<String> _roomTypeOptions = []; // List to store room types
  List<String> _serviceOptions = []; // List to store services

  @override
  void initState() {
    super.initState();
    _stream = FirebaseFirestore.instance.collection('Room').snapshots();
    _loadRoomTypes(); // Load room types when initializing
    _loadServices(); // Load services when initializing
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
        const SnackBar(content: Text('Failed to load room types.')),
      );
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
        const SnackBar(content: Text('Failed to load services.')),
      );
    }
  }

  Future<void> pickAndUploadImage(String documentId) async {
    final ImagePicker picker = ImagePicker();
    final XFile? picture = await picker.pickImage(source: ImageSource.gallery);

    if (picture != null) {
      bool? confirm = await _showConfirmDialog();
      if (confirm == true) {
        String downloadUrl;
        try {
          if (kIsWeb) {
            Uint8List imageData = await picture.readAsBytes();
            Reference reference =
                FirebaseStorage.instance.ref().child('img/${picture.name}');
            await reference.putData(imageData);
            downloadUrl = await reference.getDownloadURL();
          } else {
            File imageFile = File(picture.path);
            Reference reference = FirebaseStorage.instance
                .ref()
                .child('img/${DateTime.now().microsecondsSinceEpoch}');
            await reference.putFile(imageFile);
            downloadUrl = await reference.getDownloadURL();
          }

          setState(() {
            imageUrl = downloadUrl;
          });

          await _item.doc(documentId).update({"img": imageUrl});
        } catch (e) {
          print('Error uploading image: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload image.')),
          );
        }
      } else {
        print('User cancelled the image upload.');
      }
    } else {
      print('No image selected.');
    }
  }

  Future<bool?> _showConfirmDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to upload this image?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: Text('Create room')),
              TextField(
                controller: _numberController,
                decoration: const InputDecoration(
                  labelText: 'Room number',
                  hintText: 'P01',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  hintText: '20.000',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),

              const SizedBox(height: 10),
              TextField(
                controller: _introduceController,
                decoration: const InputDecoration(
                  labelText: 'Introduce',
                  hintText: 'nguyen',
                ),
              ),
              const SizedBox(height: 10),
              // Dropdown to select Room Type
              DropdownButtonFormField<String>(
                value: _selectedRoomType,
                hint: const Text('Select Room Type'),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRoomType = newValue;
                  });
                },
                items: _roomTypeOptions
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              // MultiSelectDialog to select Services
              MultiSelectDialogField<String>(
                items: _serviceOptions
                    .map((service) => MultiSelectItem<String>(service, service))
                    .toList(),
                title: const Text('Select Services'),
                initialValue:
                    _selectedServices, // Thay đổi từ selectedItems thành initialValue
                onConfirm: (values) {
                  setState(() {
                    _selectedServices = values;
                  });
                },
              ),
              const SizedBox(height: 10),
              Center(
                child: IconButton(
                  onPressed: () async {
                    String tempDocumentId = randomAlphaNumeric(10);
                    await pickAndUploadImage(tempDocumentId);
                  },
                  icon: const Icon(Icons.camera_alt),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (imageUrl.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please pick an image')),
                      );
                      return;
                    }
                    final String number = _numberController.text;
                    final int price = int.tryParse(_priceController.text) ?? 0;
                    final String introduce = _introduceController.text;
                    final String roomType = _selectedRoomType ?? 'Unknown';
                    final List<String> services = _selectedServices.isNotEmpty
                        ? _selectedServices
                        : ['Unknown'];

                    await _item.add({
                      "Id": randomAlphaNumeric(10),
                      "number": number,
                      "price": price,
                      "intro": introduce,
                      "status": "empty",
                      "img": imageUrl,
                      "roomType": roomType, // Add room type to Firestore
                      "services":
                          services, // Add selected services to Firestore
                    });
                    _numberController.clear();
                    _priceController.clear();
                    _introduceController.clear();
                    _selectedRoomType = null;
                    _selectedServices = [];
                    Navigator.of(context).pop();
                  },
                  child: const Text('Create'),
                ),
              ),
            ],
          ),
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
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      // Phần chứa hình ảnh
                      Container(
                        width: 100, // Thay đổi kích thước nếu cần
                        height: 100, // Thay đổi kích thước nếu cần
                        decoration: BoxDecoration(
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
                                      color: const Color(0xff1A4368),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${thisItem['number']}",
                                    style: const TextStyle(
                                      fontFamily:
                                          'Courier', // Thay đổi font chữ
                                      fontSize: 14,
                                      color:
                                          Colors.black, // Màu chữ của giá trị
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
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
                                      color: const Color(0xff1A4368),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${thisItem['price']} VND/Night",
                                    style: const TextStyle(
                                      fontFamily:
                                          'Courier', // Thay đổi font chữ
                                      fontSize: 14,
                                      color:
                                          Colors.black, // Màu chữ của giá trị
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
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
                                      color: const Color(0xff1A4368),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${thisItem['status']}",
                                    style: const TextStyle(
                                      fontFamily:
                                          'Courier', // Thay đổi font chữ
                                      fontSize: 14,
                                      color:
                                          Colors.black, // Màu chữ của giá trị
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
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
                                      color: const Color(0xff1A4368),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${thisItem['roomType']}",
                                    style: const TextStyle(
                                      fontFamily:
                                          'Courier', // Thay đổi font chữ
                                      fontSize: 14,
                                      color:
                                          Colors.black, // Màu chữ của giá trị
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                      // Phần chứa các nút hành động
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _numberController.text = thisItem["number"];
                              _editCategory(document.id, thisItem);
                            },
                            child: const Icon(Icons.edit, color: Colors.amber),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () async {
                              await _showDeleteConfirmationDialog(
                                  context, document.id);
                            },
                            child: const Icon(Icons.delete, color: Colors.red),
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
        onPressed: () {
          _create();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _editCategory(String id, Map<String, dynamic> thisItems) =>
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
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Detail',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ListTile(
                  title: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          pickAndUploadImage(id);
                        },
                        child: CircleAvatar(
                          radius: 27,
                          backgroundImage: imageUrl.isNotEmpty
                              ? NetworkImage(imageUrl)
                              : thisItems['img'] != null
                                  ? NetworkImage(thisItems['img'])
                                  : null,
                          child: thisItems['img'] == null
                              ? const Icon(Icons.image)
                              : null,
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: TextFormField(
                          controller: _numberController,
                          decoration: const InputDecoration(hintText: 'number'),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final String number = _numberController.text;
                          if (number.isNotEmpty) {
                            if (imageUrl.isNotEmpty) {
                              thisItems['img'] = imageUrl;
                            }
                            await _item.doc(id).update({
                              'number': number,
                              'img': thisItems['img'],
                            });
                            setState(() {
                              imageUrl = '';
                            });
                            _numberController.clear();
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please fill the number')),
                            );
                          }
                        },
                        child: const Text('Update'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, String id) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Confirmation'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                await _item.doc(id).delete();
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
    if (confirm == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item deleted successfully')),
      );
    }
  }

  @override
  void dispose() {
    _numberController.dispose();
    _priceController.dispose();
    _introduceController.dispose();
    super.dispose();
  }
}
