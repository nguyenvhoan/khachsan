import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DiscountModel {
  final CollectionReference _sizeCollection =
      FirebaseFirestore.instance.collection('Discount');

  // Constructor
  DiscountModel();

  // Method to update the room type
  Future<void> updateDiscount(
      String id, String newName, String intro, int point) async {
    try {
      await _sizeCollection
          .doc(id)
          .update({'name': newName, 'introduc': intro, 'point': point});
      print('Discount updated successfully');
    } catch (e) {
      print('Error updating Discount: $e');
    }
  }

  // Method to show a confirmation dialog before deleting
  Future<void> showDeleteConfirmationDialog(
      BuildContext context, String id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content:
              const Text('Are you sure you want to delete this room type?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                await deleteType(id); // Call the delete method
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  // Method to delete a room type
  Future<void> deleteType(String id) async {
    try {
      await _sizeCollection.doc(id).delete();
      print('Discount deleted successfully');
    } catch (e) {
      print('Error deleting Discont: $e');
    }
  }
}
