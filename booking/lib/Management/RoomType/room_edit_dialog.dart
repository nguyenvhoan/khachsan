import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> showEditDialog(
  BuildContext context,
  String id,
  Map<String, dynamic> thisItem,
  TextEditingController numberController,
  TextEditingController priceController,
  TextEditingController introduceController,
  String imageUrl,
  Function onPickImage,
) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Edit Room'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image and other widgets go here
              GestureDetector(
                onTap: () => onPickImage(), // Use the passed function
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
              TextField(
                controller: numberController,
                decoration: const InputDecoration(labelText: 'Room Number'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: introduceController,
                decoration: const InputDecoration(labelText: 'Introduction'),
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
              if (numberController.text.isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection('Room')
                    .doc(id)
                    .update({
                  'number': numberController.text,
                  'price': int.tryParse(priceController.text) ?? 0,
                  'intro': introduceController.text,
                  'img': imageUrl,
                });
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
}
