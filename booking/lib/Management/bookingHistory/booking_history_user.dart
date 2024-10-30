import 'package:booking/Management/Order/room_selection_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookingHistoryUser extends StatefulWidget {
  const BookingHistoryUser({super.key});

  @override
  State<BookingHistoryUser> createState() => _BookingHistoryUserState();
}

class _BookingHistoryUserState extends State<BookingHistoryUser> {
  final CollectionReference _item =
      FirebaseFirestore.instance.collection('HistoryCustomer');
  Stream<QuerySnapshot>? _stream;
  List<Map<String, dynamic>> _requestData = [];

  @override
  void initState() {
    super.initState();
    _stream = _item.snapshots(); // Stream để theo dõi thay đổi dữ liệu
    _loadRequest(); // Gọi hàm _loadRequest() khi khởi tạo
  }

  Future<void> _loadRequest() async {
    try {
      QuerySnapshot snapshot =
          await _item.get(); // Lấy toàn bộ dữ liệu từ 'Request'

      // Chuyển đổi tài liệu thành danh sách Map
      List<Map<String, dynamic>> requests = snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      setState(() {
        _requestData = requests; // Lưu dữ liệu để sử dụng trong UI
      });

      debugPrint(_requestData.toString()); // Sử dụng debugPrint thay vì print
    } catch (e) {
      debugPrint('Error loading request data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load request data.')),
      );
    }
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFF2A2A40),
    body: StreamBuilder<QuerySnapshot>(
      stream: _stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Some error occurred: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          QuerySnapshot querySnapshot = snapshot.data!;
          List<QueryDocumentSnapshot> documents = querySnapshot.docs;

          List<Widget> children = [];
           children.add(const Center(child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text('DANH SÁCH BÀN', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)
            )
            )
            )
            );


          for (var document in documents) {
            Map<String, dynamic> thisItem = document.data() as Map<String, dynamic>;
            if (thisItem['requestType'] == 'table') {
              children.add(Type(thisItem: thisItem, type: 'table'));
            }
          }

          children.add(const Center(child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text('DANH SÁCH PHÒNG', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)
            )
            )
            )
            );

          
          for (var document in documents) {
            Map<String, dynamic> thisItem = document.data() as Map<String, dynamic>;
            if (thisItem['requestType'] == 'room') {
              children.add(Type(thisItem: thisItem, type: 'room'));
            }
          }

          return ListView(
            children: children,
          );
        } else {
          return const Center(child: Text('No request found.'));
        }
      },
    ),
  );
}
}

class Type extends StatelessWidget {
   Type({
    super.key,
    required this.thisItem,
    required this.type,
  });
  var type;

  final Map<String, dynamic> thisItem;

  @override
  Widget build(BuildContext context) {
    if(thisItem['requestType']==type){
        return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(
          top: 20, left: 25, right: 25, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: const Color.fromARGB(255, 83, 214, 250),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Hình ảnh
          Container(
            width: 150,
            height: 150,
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
                ? const Icon(Icons.image, size: 50)
                : null,
          ),
          const SizedBox(width: 10),
          // Thông tin
          Expanded(
            child: Row(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "Room Type: ",
                                    style: TextStyle(
                                      fontFamily: 'Courier',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(
                                          255, 31, 144, 243),
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        "${thisItem['roomType']}",
                                    style: const TextStyle(
                                      fontFamily: 'Courier',
                                      fontSize: 20,
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
                                    text: "Day: ",
                                    style: TextStyle(
                                      fontFamily: 'Courier',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(
                                          255, 31, 144, 243),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${thisItem['day']} ",
                                    style: const TextStyle(
                                      fontFamily: 'Courier',
                                      fontSize: 20,
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
                                    text: "Start: ",
                                    style: TextStyle(
                                      fontFamily: 'Courier',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(
                                          255, 31, 144, 243),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${thisItem['start']} ",
                                    style: const TextStyle(
                                      fontFamily: 'Courier',
                                      fontSize: 20,
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
                                    text: "End: ",
                                    style: TextStyle(
                                      fontFamily: 'Courier',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(
                                          255, 31, 144, 243),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${thisItem['end']} ",
                                    style: const TextStyle(
                                      fontFamily: 'Courier',
                                      fontSize: 20,
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
                                    text: "Price: ",
                                    style: TextStyle(
                                      fontFamily: 'Courier',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(
                                          255, 31, 144, 243),
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        "${thisItem['price']}VND/Room ",
                                    style: const TextStyle(
                                      fontFamily: 'Courier',
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  width: 50,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "Email: ",
                            style: TextStyle(
                              fontFamily: 'Courier',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(
                                  255, 31, 144, 243),
                            ),
                          ),
                          TextSpan(
                            text: "${thisItem['emailUser']}",
                            style: const TextStyle(
                              fontFamily: 'Courier',
                              fontSize: 20,
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
                            text: "RoomNumber: ",
                            style: TextStyle(
                              fontFamily: 'Courier',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(
                                  255, 31, 144, 243),
                            ),
                          ),
                          TextSpan(
                            text: "${thisItem['roomNumber']} ",
                            style: const TextStyle(
                              fontFamily: 'Courier',
                              fontSize: 20,
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
                            text: "Name: ",
                            style: TextStyle(
                              fontFamily: 'Courier',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(
                                  255, 31, 144, 243),
                            ),
                          ),
                          TextSpan(
                            text: "${thisItem['nameUser']} ",
                            style: const TextStyle(
                              fontFamily: 'Courier',
                              fontSize: 20,
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
                            text: "Phone: ",
                            style: TextStyle(
                              fontFamily: 'Courier',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(
                                  255, 31, 144, 243),
                            ),
                          ),
                          TextSpan(
                            text: "${thisItem['phoneNumber']} ",
                            style: const TextStyle(
                              fontFamily: 'Courier',
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child:      PopupMenuButton<String>(
              onSelected: ( value) async {
                  if (value == 'Select Room') {
                  print('------------------------------------------------');
                  print('this items  : +${thisItem}');
                  print('------------------------------------------------');

                  thisItem['requestType']=='room'?
                      await showRoomSelectionDialog(
                    context,
                    thisItem // Thay 'requestId' bằng tên trường thực tế
                  ):showTable(
                    context,
                    thisItem // Thay 'requestId' bằng tên trường thực tế
                  );
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'Select Room',
                    child: Text('Select Room'),
                  ),
                  // Thêm các mục menu khác nếu cần
                ];
              },
            ),
          ),
        ],
      ),
    );

    }
    else return Container();
    
  }
}
