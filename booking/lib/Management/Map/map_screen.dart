import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final CollectionReference _item =
      FirebaseFirestore.instance.collection('Room');

  final CollectionReference _roomTypes =
      FirebaseFirestore.instance.collection('RoomType');

  Stream<QuerySnapshot>? _stream;
  String imageUrl = '';
  String? _selectedRoomType;

  List<String> _roomTypeOptions = [];

  @override
  void initState() {
    super.initState();
    _stream = FirebaseFirestore.instance.collection('Room').snapshots();
    _loadRoomTypes();
  }

  Future<void> _loadRoomTypes() async {
    try {
      QuerySnapshot snapshot = await _roomTypes.get();
      List<String> roomTypes =
          snapshot.docs.map((doc) => doc['number'] as String).toList();
      setState(() {
        _roomTypeOptions = roomTypes;
      });
    } catch (e) {
      print('Error loading room types: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load room types.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A2A40),
      body: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text('Some error occurred: ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            QuerySnapshot querySnapshot = snapshot.data!;
            List<QueryDocumentSnapshot> documents = querySnapshot.docs;
            // Sắp xếp các tài liệu
            documents.sort((a, b) {
              String numberA = a['number'] ?? '';
              String numberB = b['number'] ?? '';
              return numberA.compareTo(numberB); // So sánh theo thứ tự số
            });

            // Tạo một bản đồ để phân loại phòng theo tầng
            Map<String, List<QueryDocumentSnapshot>> floors = {};

            for (var doc in documents) {
              String floor = doc['floor']; // Thay 'floor' bằng trường của bạn
              if (!floors.containsKey(floor)) {
                floors[floor] = [];
              }
              floors[floor]!.add(doc);
            }

            // Sắp xếp các tầng
            List<String> sortedFloors = floors.keys.toList()..sort();

            // Kết hợp danh sách đã sắp xếp
            List<QueryDocumentSnapshot> sortedDocuments = [];
            for (String floor in sortedFloors) {
              sortedDocuments.addAll(floors[floor]!);
            }

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5, // Số cột
                childAspectRatio: 1, // Tỷ lệ chiều cao / chiều rộng của các ô
              ),
              itemCount: sortedDocuments.length,
              itemBuilder: (BuildContext context, int index) {
                QueryDocumentSnapshot document = sortedDocuments[index];
                Map<String, dynamic> thisItem =
                    document.data() as Map<String, dynamic>;

                return Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: thisItem['status'] ==
                              'servicing' // Kiểm tra trạng thái của phòng
                          ? Colors.red // Màu đỏ nếu phòng full
                          : const Color.fromARGB(
                              255, 83, 214, 250), // Màu xanh nếu không
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      // Phần chứa hình ảnh
                      Container(
                        width: 150, // Thay đổi kích thước nếu cần
                        height: 150, // Thay đổi kích thước nếu cần
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: thisItem['img'] != null
                              ? DecorationImage(
                                  image: NetworkImage(thisItem['img']),
                                  fit: BoxFit.cover,
                                )
                              : null,
                          color: Colors.transparent,
                        ),
                        child: thisItem['img'] == null
                            ? const Icon(Icons.image, size: 40)
                            : null,
                      ),

                      const SizedBox(height: 5),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: "Floor: ",
                              style: TextStyle(
                                fontFamily: 'Courier',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 31, 144, 243),
                              ),
                            ),
                            TextSpan(
                              text: "${thisItem['floor']}",
                              style: const TextStyle(
                                fontFamily: 'Courier',
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Phần chứa thông tin chi tiết
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: "Number: ",
                              style: TextStyle(
                                fontFamily: 'Courier',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 31, 144, 243),
                              ),
                            ),
                            TextSpan(
                              text: "${thisItem['number']}",
                              style: const TextStyle(
                                fontFamily: 'Courier',
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: "Status: ",
                              style: TextStyle(
                                fontFamily: 'Courier',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 31, 144, 243),
                              ),
                            ),
                            TextSpan(
                              text: "${thisItem['status']}",
                              style: const TextStyle(
                                fontFamily: 'Courier',
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
