// import 'package:booking/Management/widget/Bottom_option.dart';
// import 'package:booking/model/database_service.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';



// String color='0xffFFFFFF';

// List<String> items=[];
// class Restaurant extends StatefulWidget {
//   Restaurant({super.key});

//   @override
//   State<Restaurant> createState() => _RestaurantState();
// }
// final FirebaseFirestore db = FirebaseFirestore.instance;
// class _RestaurantState extends State<Restaurant> {
//   List<String> services = [];
//   List<String> cates = [];
//   @override
//   void initState() {
//     super.initState();
//     fetchServices();
    
//   }

//   Future<void> fetchServices() async {
//     List<String> fetchedServices = await _databaseService.getService();
//     setState(() {
//       services = fetchedServices;
//     });
//     print(services);
//   }
  
    

//   DatabaseService _databaseService =DatabaseService();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF2A2A40),
      
      
//       body: StreamBuilder(
//         stream: db.collection('Restaurant').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return SingleChildScrollView(
//               child: Wrap(
//                 spacing: 20, // Khoảng cách giữa các item
//                 runSpacing: 20, // Khoảng cách giữa các hàng
//                 children: snapshot.data!.docs.map<Widget>((documentSnapshot) {
//                   String color = documentSnapshot['status'] == 0 ? '0xff00FFFF' : '0xffFFFFFF';
//                   return Container(
//                     margin: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
//                     constraints: BoxConstraints(
//                       maxWidth: MediaQuery.sizeOf(context).width , // Chiều rộng tối thiểu
//                     ),
                    
//                     decoration: BoxDecoration(
//                       color: Color(int.parse(color)),
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(
//                         color: Colors.grey,
//                         width: 2.0,
//                       ),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.all(20),
//                       child: Row(
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.all(5),
//                             child: Image.network(
//                               'asset/images/icons/table.png', 
//                               fit: BoxFit.cover,
//                               width: 100,
//                               height: 100,
//                             ),
//                           ),
//                           Expanded( 
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(children: [
//                                   Text('Số bàn: '),
//                                   Text(documentSnapshot['id']),
//                                 ]),
                                
                                
//                                 Row(children: [
//                                   Text('Giá thuê: '),
//                                   Text((documentSnapshot['price']).toString()),
//                                 ]),
//                                 Row(children: [
//                                   Text('Trạng thái: '),
//                                   Text(documentSnapshot['status'] == 1 ? 'Đã thuê' : 'Chưa thuê'),
//                                 ]),
                                
//                               ],
//                             ),
//                           ),
                          
//                           IconButton(
//                             onPressed: () {
                              
//                               // showModalBottomSheet(context: context, builder: (BuildContext content){
//                               //   return UpdateBottomRoom(
//                               //     code: documentSnapshot['id'],
//                               //     cate: documentSnapshot['cate'],
//                               //     des: documentSnapshot['des'],
//                               //     price: documentSnapshot['price'],
//                               //     status: documentSnapshot['status'],
//                               //     items: List<String>.from(documentSnapshot['service']),

//                               //   );
//                               // });
//                             },
//                             icon: Icon(Icons.edit),
                            
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             );
//           }
//           return Center(child: CircularProgressIndicator());
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.add),
//         onPressed: () {
//           showModalBottomSheet(
//             context: context,
//             builder: (BuildContext content) {
//               return BottomOption();
//             },
//           );
//         },
//       ),
//     );
//   }
// }



