import 'package:booking/model/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class NavOptionService {
  final CollectionReference _item =
      FirebaseFirestore.instance.collection('Service');
  final ServiceModel _service = ServiceModel();

  Future<void> create(
      BuildContext context, TextEditingController serviceController) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled:
            true, // Cho phép Modal mở rộng kích thước tùy thuộc vào nội dung
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text('Create Service'),
                ),
                TextField(
                  controller: serviceController,
                  decoration: const InputDecoration(
                      labelText: 'Service', hintText: 'Wifi'),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: ElevatedButton(
                      onPressed: () async {
                        String Id = randomAlphaNumeric(10);
                        final String service = serviceController.text;
                        if (service.isNotEmpty) {
                          await _item.add({
                            "service": service,
                            "id": Id,
                          });
                          serviceController.text = '';
                          Navigator.of(context)
                              .pop(); // Đóng Modal Bottom Sheet
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Service cannot be empty'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      child: const Text('Create')),
                )
              ],
            ),
          );
        });
  }

  Future<void> editType(String id, BuildContext context,
          TextEditingController serviceController) =>
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
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Detail',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: serviceController,
                  decoration: const InputDecoration(
                    labelText: 'service',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await _service.updateService(id, serviceController.text);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
}
