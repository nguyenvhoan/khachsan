import 'package:booking/Management/Restaurant/table_delete_dialog.dart';
import 'package:booking/Management/Restaurant/table_edit_dialog.dart';
import 'package:booking/Management/Restaurant/table_service.dart';
import 'package:booking/Management/RoomType/image_picker_util.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';

class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  State<TableScreen> createState() => TableScreenState();
}

class TableScreenState extends State<TableScreen> {
  final TextEditingController _priceController = TextEditingController();
  final CollectionReference _item =
      FirebaseFirestore.instance.collection('Table');
  final TableService _tableService = TableService();
  Stream<QuerySnapshot>? _stream;

  @override
  void initState() {
    super.initState();
    _stream = _item.snapshots();
    _tableService.checkForNewDay(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A2A40),
      body: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            QuerySnapshot querySnapshot = snapshot.data!;
            List<QueryDocumentSnapshot> documents = querySnapshot.docs;
            // Sắp xếp các tài liệu
            documents.sort((a, b) {
              String numberA = a['tabletype'] ?? '';
              String numberB = b['tabletype'] ?? '';
              return numberA.compareTo(numberB); // So sánh theo thứ tự số
            });
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No tables found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var document = snapshot.data!.docs[index];
              var thisItem = document.data() as Map<String, dynamic>;

              return _buildTableItem(context, document.id, thisItem);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createMultipleTablesForEachType,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTableItem(
      BuildContext context, String docId, Map<String, dynamic> thisItem) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: const Color.fromARGB(255, 83, 214, 250)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRichText("Table Type: ", thisItem['tabletype']),
                _buildRichText("Date: ", thisItem['day']),
                _buildRichText("Status: ", thisItem['status']),
              ],
            ),
          ),
          _buildActionButtons(context, docId, thisItem),
        ],
      ),
    );
  }

  Widget _buildRichText(String label, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: const TextStyle(
              fontFamily: 'Courier',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 31, 144, 243),
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              fontFamily: 'Courier',
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
      BuildContext context, String docId, Map<String, dynamic> thisItem) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon:
              const Icon(Icons.edit, color: Color.fromARGB(255, 23, 127, 230)),
          onPressed: () => showEditDialogTable(
            context,
            docId,
            thisItem,
            _priceController,
            '',
            () async {
              String tempDocumentId = randomAlphaNumeric(10);
              String? url = await pickAndUploadImage(tempDocumentId);
              if (url != null) {
                setState(() {
                  // Update imageUrl here if needed
                });
              }
            },
          ),
        ),
        IconButton(
          icon:
              const Icon(Icons.delete, color: Color.fromARGB(255, 230, 23, 23)),
          onPressed: () => showDeleteConfirmationDialogTable(
            context,
            docId,
            () async {
              await _item.doc(docId).delete();
            },
          ),
        ),
      ],
    );
  }

  void _createMultipleTablesForEachType() {
    // Implement your logic for creating multiple tables
  }
}
