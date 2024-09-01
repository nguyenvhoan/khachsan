import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RoomTypeModel {
  final CollectionReference _sizeCollection =
      FirebaseFirestore.instance.collection('RoomType');

  // Constructor
  RoomTypeModel();

  // Method to update the room type
  Future<void> updateType(String id, String newName) async {
    try {
      await _sizeCollection.doc(id).update({
        'roomtype': newName,
      });
      print('Room type updated successfully');
    } catch (e) {
      print('Error updating room type: $e');
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
      print('Room type deleted successfully');
    } catch (e) {
      print('Error deleting room type: $e');
    }
  }
}
