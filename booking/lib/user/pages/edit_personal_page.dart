
import 'dart:io';

import 'package:booking/model/database_service.dart';
import 'package:booking/user/pages/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';


class EditPersonalDetail extends StatefulWidget {
   EditPersonalDetail({super.key, required this.account});
var account;
  @override
  State<EditPersonalDetail> createState() => _EditPersonalDetailState();
}

class _EditPersonalDetailState extends State<EditPersonalDetail> {
    Map<String, dynamic>? user; 
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final DatabaseService _databaseService=DatabaseService();
    File? imageFile;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController dayController= TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();

bool _isReadOnly = true; // Trạng thái chỉ đọc

  void _toggleEdit() {
    setState(() {
      _isReadOnly = !_isReadOnly; // Chuyển đổi trạng thái
    });
  }

  

    
Future<void> _selectedStartDate() async{
    DateTime? picked=await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if(picked!=null){
      setState(() {
        dayController.text=picked.toString().split(" ")[0];
        
      });
    }
  }
    

  @override
  void initState() {
    super.initState();
    getUserById(widget.account);
          
  }
  Future<void> getUserById(String id) async {
  try {
    DocumentSnapshot documentSnapshot = await db.collection('user').doc(id).get();

    if (documentSnapshot.exists) {
      setState(() {
        user = documentSnapshot.data() as Map<String, dynamic>?; 
        // Gán giá trị cho các TextEditingController sau khi user đã được khởi tạo
        fullNameController.text = user!['name'];
        emailController.text = user!['email'];
        addressController.text = user!['address'];
        dayController.text = user!['day'];
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
      Size size =MediaQuery.sizeOf(context);


    return Scaffold(
      
      
      body: user!=null ? SizedBox(
        width: double.infinity,
        height:   double.infinity ,
        child: SingleChildScrollView(
          child: Column(
            children:[ 
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: Stack(
                fit: StackFit.loose,
                children:[
                  Container(
                    margin: const EdgeInsets.only(bottom: 50),
                  height: 200,
                  width: double.infinity,
                  
                  decoration:const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100), // Bo tròn góc dưới trái
                      bottomRight: Radius.circular(100),
                    ),
                    color: Color(0xff1A4368),
                  ),
                ),
                Positioned(
                  top:100,
                  left: 130  ,
                  child: ClipOval(
                    child: Container(
                      width: size.width / 3, 
                     height: size.width / 3,
                     decoration:BoxDecoration(
                image: DecorationImage(
    image: imageFile != null
        ? FileImage(imageFile!) 
        : (user!['img'] != null && user!['img'].isNotEmpty
            ? NetworkImage(user!['img']) 
            : const AssetImage('asset/images/london-west-hollywood-los-angeles-california-102897-2.jpg') as ImageProvider), 
    fit: BoxFit.cover,
  ),
              ),
                  )
                  ),
                ),
                  Positioned(
                    top: 180,
                    left: 220,
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 243, 239, 239),
                          borderRadius: BorderRadius.circular(30)
                      ),
                      
                      
                    ),
                    ),
                    Positioned(
                    top: 20,
                    left: 10,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                      ),
                      child: IconButton(onPressed: (){
                        Navigator.pop(context);
                      }, icon: Image.asset('asset/images/icons/icon_back.png'),
                      color: Colors.white,)
                      ),
                      
                      
                    ),
                    
                    
                ] 
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 30,right: 30,left: 30),          
                 decoration:BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                   boxShadow: [
                      BoxShadow(
                      color: Colors.black.withOpacity(0.1), 
                      spreadRadius: 3,
                       blurRadius: 7, 
                       offset: const Offset(0, 2), 
                        ),
                      ],
                      ),
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, top:4),
                        child: TextFormField(
                          readOnly: _isReadOnly,
                        validator: (value){
                        if(value==null||value.isEmpty){
                        return 'Bắt buộc nhập';
                        }
                        return null;
                        },
                        controller: fullNameController,         
                        decoration:  InputDecoration(
                          suffixIcon: IconButton(onPressed: _toggleEdit
          
                          ,icon: const Icon(Icons.edit)),
                        border: InputBorder.none,
                        // label:Text( 'Enter card number *', style:TextStyle(color: Color(0xffBEBCBC)),),
                         floatingLabelBehavior: FloatingLabelBehavior.never,
                                           
                                           
                                         
                                         
                         ),
                       ),
                      ),
               ),
               Container(
                  margin: const EdgeInsets.only(top: 30,right: 30,left: 30),          
                 decoration:BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                   boxShadow: [
                      BoxShadow(
                      color: Colors.black.withOpacity(0.1), 
                      spreadRadius: 3,
                       blurRadius: 7, 
                       offset: const Offset(0, 2), 
                        ),
                      ],
                      ),
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, top:4),
                        child: TextFormField(
                          readOnly: true,
                        validator: (value){
                        if(value==null||value.isEmpty){
                        return 'Bắt buộc nhập';
                        }
                        return null;
                        },
                        controller: dayController,         
                        decoration:  InputDecoration(
                          suffixIcon: IconButton(onPressed:() {
                              _selectedStartDate();
                          }
          
                          ,icon: const Icon(Icons.calendar_today)),
                        border: InputBorder.none,
                        // label:Text( 'Enter card number *', style:TextStyle(color: Color(0xffBEBCBC)),),
                         floatingLabelBehavior: FloatingLabelBehavior.never,
                                           
                                           
                                         
                                         
                         ),
                       ),
                      ),
               ),
               Container(
                  margin: const EdgeInsets.only(top: 30,right: 30,left: 30),          
                 decoration:BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                   boxShadow: [
                      BoxShadow(
                      color: Colors.black.withOpacity(0.1), 
                      spreadRadius: 3,
                       blurRadius: 7, 
                       offset: const Offset(0, 2), 
                        ),
                      ],
                      ),
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, top:4),
                        child: TextFormField(
                          readOnly: _isReadOnly,
                        validator: (value){
                        if(value==null||value.isEmpty){
                        return 'Bắt buộc nhập';
                        }
                        return null;
                        },
                        controller: emailController,         
                        decoration:  InputDecoration(
                          suffixIcon: IconButton(onPressed: _toggleEdit
          
                          ,icon: const Icon(Icons.edit)),
                        border: InputBorder.none,
                        // label:Text( 'Enter card number *', style:TextStyle(color: Color(0xffBEBCBC)),),
                         floatingLabelBehavior: FloatingLabelBehavior.never,
                                           
                                           
                                         
                                         
                         ),
                       ),
                      ),
               ),
               Container(
                  margin: const EdgeInsets.only(top: 30,right: 30,left: 30),          
                 decoration:BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                   boxShadow: [
                      BoxShadow(
                      color: Colors.black.withOpacity(0.1), 
                      spreadRadius: 3,
                       blurRadius: 7, 
                       offset: const Offset(0, 2), 
                        ),
                      ],
                      ),
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20,bottom: 12),
                        child: TextFormField(
                          readOnly: _isReadOnly,
                        validator: (value){
                        if(value==null||value.isEmpty){
                        return 'Bắt buộc nhập';
                        }
                        return null;
                        },
                        controller: addressController,         
                        decoration:  InputDecoration(
                          label: const Text('Địa chỉ'),
                          suffixIcon: IconButton(onPressed: _toggleEdit
          
                          ,icon: const Icon(Icons.edit)),
                        border: InputBorder.none,
                        // label:Text( 'Enter card number *', style:TextStyle(color: Color(0xffBEBCBC)),),
                         floatingLabelBehavior: FloatingLabelBehavior.never,
                                           
                                           
                                         
                                         
                         ),
                       ),
                      ),
               ),
                GestureDetector(
                  onTap: (){
                    user!['address']=addressController.text;
                    user!['day']=dayController.text;
                    _databaseService.updateUser(widget.account, user, context);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      color: const Color(0xff1A4368),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 100,right: 100, top: 15, bottom: 15),
                      child: Text('Update',
                      style: TextStyle(color: Colors.white,
                      fontSize: 20),)),
                  ),
                ),
                  
                
            ]
          ),
        ),
      ):const Center(
                      child: CircularProgressIndicator(), // Hoặc bạn có thể thay thế bằng một widget khác thông báo lỗi

      )
    );
  }
}