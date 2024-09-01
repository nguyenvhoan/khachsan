import 'package:cloud_firestore/cloud_firestore.dart';

class RoomModel {
  final CollectionReference _roomCollection =
      FirebaseFirestore.instance.collection('Room');
}
