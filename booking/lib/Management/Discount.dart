import 'package:booking/controller/nav_option_discount.dart';
import 'package:booking/model/discount_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Discount extends StatefulWidget {
  const Discount({super.key});

  @override
  State<Discount> createState() => _DiscountState();
}

NavOptionDiscount _navOptionDiscount = NavOptionDiscount();

class _DiscountState extends State<Discount> {
  final TextEditingController _nameDiscountController = TextEditingController();
  final TextEditingController _introduController = TextEditingController();
  final TextEditingController _pointController = TextEditingController();
  Stream<QuerySnapshot>? _stream;
  final DiscountModel _discountModel = DiscountModel();

  @override
  void initState() {
    super.initState();
    _stream = FirebaseFirestore.instance.collection('Discount').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A2A40),
      body: _stream == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: _stream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                      child: Text('Some error occurred: ${snapshot.error}'));
                }
                if (snapshot.hasData) {
                  List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      var item = documents[index];
                      return Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.only(
                            bottom: 5, top: 20, left: 20, right: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: "Discount: ",
                                          style: TextStyle(
                                            fontFamily:
                                                'Courier', // Thay đổi font chữ
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xff1A4368),
                                          ),
                                        ),
                                        TextSpan(
                                          text: "${item['name']}",
                                          style: const TextStyle(
                                            fontFamily:
                                                'Courier', // Thay đổi font chữ
                                            fontSize: 14,
                                            color: Colors
                                                .black, // Màu chữ của giá trị
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: "Introduce: ",
                                          style: TextStyle(
                                            fontFamily:
                                                'Courier', // Thay đổi font chữ
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xff1A4368),
                                          ),
                                        ),
                                        TextSpan(
                                          text: "${item['introduc']}",
                                          style: const TextStyle(
                                            fontFamily:
                                                'Courier', // Thay đổi font chữ
                                            fontSize: 14,
                                            color: Colors
                                                .black, // Màu chữ của giá trị
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: "Point: ",
                                          style: TextStyle(
                                            fontFamily:
                                                'Courier', // Thay đổi font chữ
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xff1A4368),
                                          ),
                                        ),
                                        TextSpan(
                                          text: "${item['point']}",
                                          style: const TextStyle(
                                            fontFamily:
                                                'Courier', // Thay đổi font chữ
                                            fontSize: 14,
                                            color: Colors
                                                .black, // Màu chữ của giá trị
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _nameDiscountController.text = item["name"];
                                    _introduController.text = item["introduc"];
                                    _pointController.text =
                                        item["point"].toString();

                                    _navOptionDiscount.editType(
                                        item.id,
                                        context,
                                        _nameDiscountController,
                                        _introduController,
                                        _pointController);
                                  },
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.amber,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                GestureDetector(
                                  onTap: () async {
                                    await _discountModel
                                        .showDeleteConfirmationDialog(
                                            context, item.id);
                                  },
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navOptionDiscount.create(context, _nameDiscountController,
              _introduController, _pointController);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
