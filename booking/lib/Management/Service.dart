import 'package:booking/controller/nav_option_service.dart';
import 'package:booking/model/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class Service extends StatefulWidget {
  const Service({super.key});

  @override
  State<Service> createState() => _ServiceState();
}

class _ServiceState extends State<Service> {
  final TextEditingController _serviceController = TextEditingController();

  Stream<QuerySnapshot>? _stream;
  final ServiceModel _service = ServiceModel();

  final NavOptionService _navOptionService = NavOptionService();

  @override
  void initState() {
    super.initState();
    _stream = FirebaseFirestore.instance.collection('Service').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A2A40),
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
                    itemBuilder: (BuildContext context, int indext) {
                      var item = documents[indext];
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
                              "${item['service']}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w200,
                                  color: Colors.white,
                                  fontSize: 20),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _serviceController.text = item["service"];
                                    _navOptionService.editType(
                                        item.id, context, _serviceController);
                                  },
                                  child: const Icon(
                                    Icons.edit,
                                    color: Color.fromARGB(255, 23, 127, 230),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                GestureDetector(
                                  onTap: () async {
                                    await _service.showDeleteConfirmationDialog(
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
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navOptionService.create(context, _serviceController);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
