import 'package:booking/Management/RoomType/image_picker_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> showEditDialogTable(
  BuildContext context,
  String id,
  Map<String, dynamic> thisItem,
  TextEditingController priceController,
  String imageUrl,
  Function onPickImage,
) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
        priceController.text=thisItem['price'].toString();
        return AlertDialog(
          title:  const Center(child: Text('Edit Table', style: TextStyle(
            fontFamily: 'Candal',
            fontSize: 22,
          ),)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image and other widgets go here
                GestureDetector(
                  onTap: () async {
                      String? url = await pickAndUploadImage('');
                      if (url != null) {
                        setState(() {
                          imageUrl = url; // Cập nhật imageUrl
                        });
                      }
                    }, // Use the passed function
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: imageUrl.isNotEmpty
                        ? NetworkImage(imageUrl)
                        : thisItem['img'] != null
                            ? NetworkImage(thisItem['img'])
                            : null,
                    child:
                        thisItem['img'] == null ? const Icon(Icons.image) : null,
                  ),
                ),
                // TextFields for editing
        
                Container(
                margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: priceController,
                      decoration: const InputDecoration(labelText: 'Price',
                      border: InputBorder.none),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                // Save changes
                if (priceController.text.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection('TableType')
                      .doc(id)
                      .update({
                    'price': int.tryParse(priceController.text) ?? 0,
                    'img': imageUrl,
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
                }
      );
    },
  );
}
