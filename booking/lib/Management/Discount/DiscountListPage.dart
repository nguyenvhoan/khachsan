import 'package:booking/controller/nav_option_discount.dart'; // Import controller
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DiscountListPage extends StatelessWidget {
  final NavOptionDiscount _navOptionDiscount =
      NavOptionDiscount(); // Initialize the controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A2A40),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Discount').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final discounts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: discounts.length,
            itemBuilder: (context, index) {
              final discount = discounts[index].data() as Map<String, dynamic>;
              final imgUrl = discount['img'] as String;
              final docId = discounts[index].id;
              final point = discount['point'] as int? ?? 0;
              final price = discount['price'] as int? ?? 0;

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent, // Background color of the item
                    border: Border.all(
                      color: const Color.fromARGB(
                          255, 83, 214, 250), // Border color
                    ),
                    borderRadius: BorderRadius.circular(8), // Border radius
                  ),
                  child: Row(
                    children: [
                      // Phần chứa hình ảnh
                      Padding(
                        padding: const EdgeInsets.all(
                            10), // Padding around the image
                        child: Container(
                          width: 100, // Set the desired width
                          height: 100, // Set the desired height
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: imgUrl.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(imgUrl),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                            color: Colors.transparent,
                          ),
                          child: imgUrl.isEmpty
                              ? const Icon(
                                  Icons.image,
                                  size: 50, // Adjust icon size if needed
                                )
                              : null,
                        ),
                      ),
                      // Padding giữa hình ảnh và thông tin chi tiết
                      const SizedBox(width: 10),
                      // Phần chứa thông tin chi tiết
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(
                              10), // Padding for the text content
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Name: ${discount['name'] ?? 'No Name'}',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 106, 169, 221),
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Introduction: ${discount['introduc'] ?? 'No Introduction'}',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 223, 219, 219)),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Points: $point',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 240, 38, 38),
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Price: $price',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 240, 38, 38),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(
                            10), // Padding around the PopupMenuButton
                        child: PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'edit') {
                              // Open edit dialog
                              TextEditingController nameController =
                                  TextEditingController(text: discount['name']);
                              TextEditingController introController =
                                  TextEditingController(
                                      text: discount['introduc']);
                              TextEditingController pointController =
                                  TextEditingController(
                                      text: discount['point'].toString());
                              TextEditingController priceController =
                                  TextEditingController(
                                      text: discount['price'].toString());

                              await _navOptionDiscount.editType(
                                docId,
                                context,
                                nameController,
                                introController,
                                pointController,
                                priceController,
                              );
                            } else if (value == 'delete') {
                              // Confirm and delete
                              await _navOptionDiscount.deleteType(
                                  docId, context);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem<String>(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navOptionDiscount.create(
            context,
            TextEditingController(),
            TextEditingController(),
            TextEditingController(),
            TextEditingController(),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }
}
