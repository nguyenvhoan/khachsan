import 'package:booking/Management/Restaurant/TableForm.dart';
import 'package:booking/Management/Restaurant/table_delete_dialog.dart';
import 'package:booking/Management/Restaurant/table_edit_dialog.dart';
import 'package:booking/Management/Room/RoomForm.dart';
import 'package:booking/Management/Room/image_picker_util.dart';
import 'package:booking/Management/Room/room_delete_dialog.dart';
import 'package:booking/Management/Room/room_edit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';

class TableScreen extends StatefulWidget {
  const TableScreen({Key? key}) : super(key: key);

  @override
  State<TableScreen> createState() => TableScreenState();
}

class TableScreenState extends State<TableScreen> {
  final TextEditingController _priceController = TextEditingController();
  final CollectionReference _item =
      FirebaseFirestore.instance.collection('Table');
  final CollectionReference _tableTypes =
      FirebaseFirestore.instance.collection('TableType');
  final TextEditingController _dayController = TextEditingController();

  Stream<QuerySnapshot>? _stream;
  String imageUrl = '';
  String? _selectedTableType;
  List<String> _tableTypeOptions = [];

  @override
  void initState() {
    super.initState();
    _stream = FirebaseFirestore.instance.collection('Table').snapshots();
    _loadTableTypes();
  }

  Future<void> _loadTableTypes() async {
    try {
      QuerySnapshot snapshot = await _tableTypes.get();
      List<String> tableTypes =
          snapshot.docs.map((doc) => doc['tabletype'] as String).toList();
      setState(() {
        _tableTypeOptions = tableTypes;
      });
    } catch (e) {
      print('Error loading table types: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load table types.')));
    }
  }

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return TableForm(
          priceController: _priceController,
          selectedTableType: _selectedTableType,
          roomTypeOptions: _tableTypeOptions,
          dayController: _dayController,
          onRoomTypeChanged: (String? newValue) {
            setState(() {
              _selectedTableType = newValue;
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

            final int price = int.tryParse(_priceController.text) ?? 0;
            final String tableType = _selectedTableType ?? 'Unknown';

            await _item.add({
              "Id": randomAlphaNumeric(10),
              "price": price,
              "day": _dayController.text,
              "img": imageUrl,
              "tabletype": tableType,
              "status": "Empty"
            });
            _dayController.clear();
            _priceController.clear();
            _selectedTableType = null;
            imageUrl = ''; // Reset image URL after submission
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

            if (documents.isEmpty) {
              return const Center(child: Text('No tables found.'));
            }

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
                    color: Colors.transparent,
                    border: Border.all(
                      color: const Color.fromARGB(255, 83, 214, 250),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      // Hình ảnh
                      Container(
                        width: 100,
                        height: 100,
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
                            ? const Icon(Icons.image, size: 50)
                            : null,
                      ),
                      const SizedBox(width: 10),
                      // Thông tin
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "Table Type: ",
                                    style: TextStyle(
                                      fontFamily: 'Courier',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 31, 144, 243),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${thisItem['tabletype']}",
                                    style: const TextStyle(
                                      fontFamily: 'Courier',
                                      fontSize: 20,
                                      color: Colors.white,
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
                                      fontFamily: 'Courier',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 31, 144, 243),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${thisItem['price']} VND/Table",
                                    style: const TextStyle(
                                      fontFamily: 'Courier',
                                      fontSize: 20,
                                      color: Colors.white,
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
                                    text: "Date: ",
                                    style: TextStyle(
                                      fontFamily: 'Courier',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 31, 144, 243),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${thisItem['day']} ",
                                    style: const TextStyle(
                                      fontFamily: 'Courier',
                                      fontSize: 20,
                                      color: Colors.white,
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
                                      fontFamily: 'Courier',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 31, 144, 243),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${thisItem['status']} ",
                                    style: const TextStyle(
                                      fontFamily: 'Courier',
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Nút chỉnh sửa và xóa
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Color.fromARGB(255, 23, 127, 230),
                            ),
                            onPressed: () => showEditDialogTable(
                              context,
                              document.id,
                              thisItem,
                              _priceController,
                              imageUrl,
                              () async {
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
                            onPressed: () => showDeleteConfirmationDialogTable(
                              context,
                              document.id,
                              () async {
                                await _item.doc(document.id).delete();
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
