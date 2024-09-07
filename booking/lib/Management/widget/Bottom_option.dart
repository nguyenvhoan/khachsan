// import 'package:booking/model/database_service.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// List<String> list=[];
//  String selected='';
// class BottomOption extends StatefulWidget {
//      BottomOption({super.key});
 
//   @override
//   State<BottomOption> createState() => _BottomOptionState();
// }
// final DatabaseService _databaseService= DatabaseService();
// // List<Category> items = []; 

// TextEditingController codeTableController= TextEditingController();
// TextEditingController priceController=TextEditingController();
// TextEditingController quantController=TextEditingController();
// final FirebaseFirestore db = FirebaseFirestore.instance;




// class _BottomOptionState extends State<BottomOption> {
  
  
//   @override
//   Widget build(BuildContext context) {
    
//     return Padding(
//       padding: MediaQuery.of(context).viewInsets,
//       child: SingleChildScrollView(
//         padding:const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//         child: Column(
//           children: [
//               TextField(
//                 controller: codeTableController,             
//                 decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30) ,
//                 ),
//                 labelText: 'Số bàn :'
//               ),
              
//             ),
//             SizedBox(height: 5,),
//             TextField(
//                 controller: priceController,             
//                 decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30) ,
//                 ),
//                 labelText: 'Giá'
//               ),
              
//             ),
//             SizedBox(height: 5,),
//             TextField(
//                 controller: quantController,             
//                 decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30) ,
//                 ),
//                 labelText: 'Số lượng người :'
//               ),
              
//             ),
//             SizedBox(height: 10,),    
//             const SizedBox(height: 20,),
//             const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed:() async {
//                   // Room room= Room(
//                   //   id: coderoomController.text,
//                   //   cate: selected,
//                   //   price: int.parse(priceController.text),
//                   //   status: 0,
//                   //   des: desController.text,
//                   //   items: _selectedItems

//                   // );
                  
//                   await _databaseService.createTable(codeTableController.text,int.parse(priceController.text),int.parse(quantController.text));
//                   Navigator.pop(context);
//                 },
//               child:const Text('Submit')),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// // class DropdownButtonExample extends StatefulWidget {
// //   const DropdownButtonExample({super.key});

// //   @override
// //   State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
// // }

// // class _DropdownButtonExampleState extends State<DropdownButtonExample> {
// //   String dropdownValue = list.first;
  
// //   @override
// //   Widget build(BuildContext context) {
// //     selected=dropdownValue;
// //     return DropdownButton<String>(
// //       value: dropdownValue,
// //       icon: const Icon(Icons.arrow_downward),
// //       elevation: 16,
// //       style: const TextStyle(color: Colors.deepPurple),
// //       underline: Container(
// //         height: 2,
// //         color: Colors.deepPurpleAccent,
// //       ),
// //       onChanged: (String? value) {
// //         // This is called when the user selects an item.
// //         setState(() {
// //           dropdownValue = value!;
// //         });
// //       },
// //       items: list.map<DropdownMenuItem<String>>((String value) {
// //         return DropdownMenuItem<String>(
// //           value: value,
// //           child: Text(value),
// //         );
// //       }).toList(),
// //     );
// //   }
// // }
// // List<String> _selectedItems = [];
// // class MultiOption extends StatefulWidget {
// //    MultiOption({super.key, required this.service});
// //   List<String> service;
// //   @override
// //   State<MultiOption> createState() => _MultiOptionState();
// // }

// // class _MultiOptionState extends State<MultiOption> {
  
// //    void _showMultiSelect() async {
   
// //     final List<String> items = widget.service;

// //     final List<String>? results = await showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return MultiSelect(items: items);
// //       },
// //     );

// //     // Update UI
// //     if (results != null) {
// //       setState(() {
// //         _selectedItems = results;
// //       });
// //     }
// //   }

// //    @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       child: Padding(
// //         padding: const EdgeInsets.all(20),
// //         child: Column(
          
// //           crossAxisAlignment: CrossAxisAlignment.center,
// //           children: [
// //             // use this button to open the multi-select dialog
// //             ElevatedButton(
// //               onPressed: _showMultiSelect,
// //               child: const Text('Chọn các dịch vụ đính kèm ', textAlign: TextAlign.center,),
// //             ),
// //             const Divider(
// //               height: 30,
// //             ),
// //             // display selected items
// //             Center(
// //               child: Wrap(
// //                 children: _selectedItems
// //                     .map((e) => Chip(
// //                           label: Text(e),
// //                         ))
// //                     .toList(),
// //               ),
// //             )
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }