import 'package:booking/controller/nav_option_room_type.dart';
import 'package:booking/model/room_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RoomType extends StatefulWidget {
  const RoomType({super.key});

  @override
  State<RoomType> createState() => _RoomTypeState();
}

NavOptionRoomType _navOptionRoomType = NavOptionRoomType();

class _RoomTypeState extends State<RoomType> {
  final TextEditingController _roomTypetController = TextEditingController();
  Stream<QuerySnapshot>? _stream;
  final RoomTypeModel _roomType = RoomTypeModel();

  @override
  void initState() {
    super.initState();
    _stream = FirebaseFirestore.instance.collection('RoomType').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A2A40),
      body: _stream == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: _stream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                      child: Text('Some error occurred: ${snapshot.error}'));
                }
                if (snapshot.hasData) {
                  List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      var item = documents[index];
                      return Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.only(
                            bottom: 5, top: 20, left: 20, right: 20),
                        decoration: BoxDecoration(
                          color: Colors
                              .transparent, // Background color of the item
                          border: Border.all(
                            color: const Color.fromARGB(
                                255, 83, 214, 250), // Border color
                            // Border width
                          ),
                          borderRadius:
                              BorderRadius.circular(8), // Border radius
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${item['roomtype']}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w200,
                                  color: Colors.white,
                                  fontSize: 20),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _roomTypetController.text =
                                        item["roomtype"];
                                    _navOptionRoomType.editType(
                                        item.id, context, _roomTypetController);
                                  },
                                  child: const Icon(
                                    Icons.edit,
                                    color: Color.fromARGB(255, 23, 127, 230),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                GestureDetector(
                                  onTap: () async {
                                    await _roomType
                                        .showDeleteConfirmationDialog(
                                            context, item.id);
                                  },
                                  child: const Icon(
                                    Icons.delete,
                                    color: Color.fromARGB(255, 230, 23, 23),
                                  ),
                                )
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
          _navOptionRoomType.create(context, _roomTypetController);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
