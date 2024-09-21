import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

Future<String?> pickAndUploadImage(String documentId) async {
  final ImagePicker picker = ImagePicker();
  final XFile? picture = await picker.pickImage(source: ImageSource.gallery);

  if (picture != null) {
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
      return null;
    }
  } else {
    print('No image selected.');
    return null;
  }
}
