import 'package:flutter/material.dart';

Future<void> showDeleteConfirmationDialog(
  BuildContext context,
  String id,
  Function onDelete, // Add an onDelete callback to handle the deletion
) async {
  final bool? confirm = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Confirmation'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
  if (confirm == true) {
    await onDelete(); // Call the provided onDelete callback if confirmed
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item deleted successfully')),
    );
  }
}
