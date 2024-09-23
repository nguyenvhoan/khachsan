// table_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class TableService {
  final CollectionReference _item =
      FirebaseFirestore.instance.collection('Table');
  final CollectionReference _tableTypes =
      FirebaseFirestore.instance.collection('TableType');

  Future<void> checkForNewDay(BuildContext context) async {
    try {
      QuerySnapshot snapshot = await _item.get();
      String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      for (QueryDocumentSnapshot document in snapshot.docs) {
        Map<String, dynamic> thisItem = document.data() as Map<String, dynamic>;
        String tableDate = thisItem['day'] ?? '';
        String tableStatus = thisItem['status'] ?? '';

        if (tableDate != currentDate && tableStatus == 'Empty') {
          await _item.doc(document.id).update({
            'day': currentDate,
            'status': 'Empty',
          });
        }
      }

      print("Tables updated for the new day.");
    } catch (e) {
      print('Error checking or updating tables: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to update tables for the new day.')),
      );
    }
  }

  Future<void> loadTableTypes(
      BuildContext context, Function(List<String>) onLoadComplete) async {
    try {
      QuerySnapshot snapshot = await _tableTypes.get();
      List<String> tableTypes =
          snapshot.docs.map((doc) => doc['tabletype'] as String).toList();
      onLoadComplete(tableTypes);
    } catch (e) {
      print('Error loading table types: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load table types.')));
    }
  }

  Future<void> createMultipleTablesForEachType(BuildContext context) async {
    try {
      QuerySnapshot snapshot = await _tableTypes.get();
      List<String> tableTypes =
          snapshot.docs.map((doc) => doc['tabletype'] as String).toList();

      for (String tableType in tableTypes) {
        for (int dayOffset = 0; dayOffset < 3; dayOffset++) {
          for (int i = 0; i < 5; i++) {
            String currentDate = DateFormat('yyyy-MM-dd')
                .format(DateTime.now().add(Duration(days: dayOffset)));

            await _item.add({
              "Id": randomAlphaNumeric(10),
              "day": currentDate,
              "tabletype": tableType,
              "status": "Empty",
            });
          }
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                '5 tables created for each table type for the next 3 days!')),
      );
    } catch (e) {
      print('Error creating tables: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create tables.')),
      );
    }
  }
}
