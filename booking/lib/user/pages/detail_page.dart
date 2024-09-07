import 'package:booking/model/database_service.dart';
import 'package:booking/user/pages/booking_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  DetailPage({super.key, required this.codeRoom, required this.account});
  final String codeRoom; 
  var account;
  
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  Map<String, dynamic>? data; 
  List<dynamic> services = [];
  final DatabaseService _databaseService = DatabaseService();
  
  @override
  void initState() {
    super.initState();
    getDataById(widget.codeRoom); 
  }

  Future<void> getDataById(String id) async {
    try {
      DocumentSnapshot documentSnapshot = await db.collection('Room').doc(id).get();

      if (documentSnapshot.exists) {
        setState(() {
          data = documentSnapshot.data() as Map<String, dynamic>?; 
          services = data?['services'] ?? []; // Lấy dịch vụ
        });
      } else {
        print('Tài liệu không tồn tại');
      }
    } catch (e) {
      print('Lỗi khi lấy dữ liệu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Room Detail', textAlign: TextAlign.center),
      ),
      body: data != null 
          ? Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(left: 25, right: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(                                      
                          width: double.infinity,
                          height: size.height / 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: data?['img'] != null
                              ? DecorationImage(
                                  image: NetworkImage(data!['img']),
                                  fit: BoxFit.cover,
                                )
                              : null,
                            color: Colors.transparent,
                          ),
                          child: data?['img'] == null
                            ? const Icon(Icons.image, size: 10)
                            : null,
                        ),
                        Center(
                          child: Text(
                            data?['roomType'] ?? '',
                            style: TextStyle(fontFamily: 'Candal', fontSize: 25),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Row(
                          children: [
                            Image.asset('asset/images/icons/Star.png'),
                            const SizedBox(width: 5),
                            const Text(
                              'Evaluate: ',
                              style: TextStyle(
                                color: Color(0xff1A4368),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Text(
                              '4.5',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Text(
                          data?['intro'] ?? '',
                          style: const TextStyle(fontFamily: 'Candal', fontSize: 15),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Features',
                          style: TextStyle(
                            color: Color(0xff1A4368),
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: services.map((service) {
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 1, horizontal: 5),
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                service,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), 
                          spreadRadius: 5,
                          blurRadius: 7, 
                          offset: Offset(0, 3), 
                        ),
                      ],
                    ),
                    height: 60,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(left: 25, right: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Text(
                                data!['price'].toString(),
                                style: const TextStyle(
                                  color: Color(0xff1A4368),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              const Text(
                                '/ night',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xffBEBCBC),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ]),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (context) => BookingPage(codeRoom: widget.codeRoom, account:  widget.account,))
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xff1A4368), 
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                                  child: Text(
                                    'Check out',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(), // Hoặc bạn có thể thay thế bằng một widget khác thông báo lỗi
            ),
    );
  }
}