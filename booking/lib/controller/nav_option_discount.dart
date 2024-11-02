import 'dart:io';
import 'dart:typed_data';
import 'package:booking/model/discount_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class NavOptionDiscount {
  final CollectionReference _item =
      FirebaseFirestore.instance.collection('Discount');

  Future<bool?> _showConfirmDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to delete this item?'),
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

  Future<String?> pickAndUploadImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? picture = await picker.pickImage(source: ImageSource.gallery);

    if (picture != null) {
      bool? confirm = await _showConfirmDialog(context);
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

          return downloadUrl;
        } catch (e) {
          print('Error uploading image: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload image.')),
          );
          return null;
        }
      } else {
        print('User cancelled the image upload.');
        return null;
      }
    } else {
      print('No image selected.');
      return null;
    }
  }

  Future<void> create(
    BuildContext context,
    TextEditingController nameController,
    TextEditingController introduController,
    TextEditingController pointController,
    TextEditingController priceController,
  ) async {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      builder: (BuildContext ctx) {
        String? imgUrl;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                // Add this line
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text('Create Discount'),
                    ),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        hintText: 'Name',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: introduController,
                      decoration: const InputDecoration(
                        labelText: 'Introduction',
                        hintText: 'Introduction',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: pointController,
                      decoration: const InputDecoration(
                        labelText: 'Point',
                        hintText: '1000',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: priceController,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        hintText: '1000 vnd',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          // Chọn ảnh khi nhấn nút
                          imgUrl = await pickAndUploadImage(ctx);
                          if (imgUrl != null) {
                            setState(
                                () {}); // Cập nhật trạng thái để phản ánh việc chọn ảnh
                          }
                        },
                        child: const Text('Choose Image'),
                      ),
                    ),
                    if (imgUrl != null) // Hiển thị ảnh nếu đã chọn
                      Center(
                        child: Image.network(
                          imgUrl!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          final String name = nameController.text;
                          final String introduc = introduController.text;
                          final String pointText = pointController.text;
                          final String priceText = priceController.text;
                          final int? point = int.tryParse(pointText);
                          final int? price = int.tryParse(priceText);

                          if (point != null &&
                              price != null &&
                              name.isNotEmpty &&
                              imgUrl != null) {
                            await FirebaseFirestore.instance
                                .collection('Discount')
                                .add({
                              "name": name,
                              "id": randomAlphaNumeric(10),
                              "introduc": introduc,
                              "point": point,
                              "price": price,
                              "img": imgUrl,
                            });
                            nameController.clear();
                            introduController.clear();
                            pointController.clear();
                            priceController.clear();
                            Navigator.of(ctx).pop(); // Đóng BottomSheet
                          } else {
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Please fill all fields and choose an image'),
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        child: const Text('Create'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> editType(
    String id,
    BuildContext context,
    TextEditingController nameController,
    TextEditingController introController,
    TextEditingController pointController,
    TextEditingController priceController,
  ) async {
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
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name Discount',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: introController,
                decoration: const InputDecoration(
                  labelText: 'Intro',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: pointController,
                decoration: const InputDecoration(
                  labelText: 'Point',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await _item.doc(id).update({
                "name": nameController.text,
                "introduc": introController.text,
                "point": int.tryParse(pointController.text) ?? 0,
                "price": int.tryParse(priceController.text)
              });
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

  Future<void> deleteType(String id, BuildContext context) async {
    bool? confirm = await _showConfirmDialog(context);
    if (confirm == true) {
      try {
        await _item.doc(id).delete();
      } catch (e) {
        print('Error deleting discount: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete discount.')),
        );
      }
    } else {
      print('User cancelled the delete operation.');
    }
  }
}
