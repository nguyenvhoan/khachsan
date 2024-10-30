import 'package:booking/model/database_service.dart';
import 'package:booking/user/pages/detail_voucher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotifyPage extends StatefulWidget {
  NotifyPage({super.key, required this.account});
  final String account; // Đổi thành final String để rõ ràng hơn

  @override
  State<NotifyPage> createState() => _NotifyPageState();
}

class _NotifyPageState extends State<NotifyPage> {
  DatabaseService _databaseService = DatabaseService();
  final FirebaseFirestore db = FirebaseFirestore.instance;
  List<Map<String, dynamic>> services = []; // Thay đổi kiểu dữ liệu

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  Future<void> fetchServices() async {
    List<Map<String, dynamic>> fetchedServices = await _databaseService.getNotify(widget.account);
    setState(() {
      services = fetchedServices;
    });
    print(services);
  }

  String formatDate(DateTime dateTime) {
    return DateFormat('EEEE, dd/MM').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset('asset/images/icons/icon_back.png'),
        ),
        title: const Text(
          'Booking History',
          style: TextStyle(
            fontFamily: 'Candal',
            color: Color(0xff3CA0B6),
            fontSize: 32,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              child: services.isEmpty
                  ? Center(child: Text('Danh sách hiện tại trống.'))
                  : ListView.builder(
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        Timestamp timestamp = services[index]['time'];
                        DateTime dateTime = timestamp.toDate();
                        String formattedDate = formatDate(dateTime);
                        return Container(
                          margin: EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
                                  width: size.width / 2.8,
                                  height: size.height / 6,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: services[index]['img'] != null
                                        ? DecorationImage(
                                            image: NetworkImage(services[index]['img']),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                    color: Colors.transparent,
                                  ),
                                  child: services[index]['img'] == null
                                      ? const Icon(Icons.image, size: 40) // Tăng kích thước icon
                                      : null,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                             children: [
                                            Text(
                                           formattedDate,
                                          style:const TextStyle(
                                           fontSize: 10,
                                           fontWeight: FontWeight.bold,
                                           color: Color(0xffBEBCBC)
                                           ),
                                          ),
                                         GestureDetector(
                                           child: Icon(Icons.menu),
                                         )
                                           ],
                                        ),
                                         Text('Đã có ${services[index]['requestType']}',
                                          textAlign: TextAlign.center,
                                         style:const TextStyle(
                                           fontWeight: FontWeight.bold,
                                           color: Color(0xff57A5EC),
                                           fontSize: 19,
                                           
                                         ),overflow: TextOverflow.ellipsis,
                                         maxLines: 2,softWrap: true,
                                         ),
                                         SizedBox(height: 5,),
                                         Text('Total price: ${services[index]['price']} VND',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10
                                      
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                          Text('Number Room: ${services[index]['numberRoom']}',
                                         style: const TextStyle(
                                           fontWeight: FontWeight.bold,
                                           fontSize: 10
                                    
                                         ),
                                         ),
                                          SizedBox(height: 5,),
                                           const Text('Click to see more!',
                                           style:  TextStyle(
                                             fontWeight: FontWeight.bold,
                                             fontSize: 10
                                       
                                           ),
                                           ),
                                      ],
                                    ),
                                  )
                                  )
                                // Thêm các widget khác cho thông tin dịch vụ ở đây
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}