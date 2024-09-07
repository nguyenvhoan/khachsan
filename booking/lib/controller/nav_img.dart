import 'package:booking/model/discount_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Image {
  final CollectionReference _item =
      FirebaseFirestore.instance.collection('Discount');
  final DiscountModel _discountModel = DiscountModel();
  String imageUrl = '';
}
