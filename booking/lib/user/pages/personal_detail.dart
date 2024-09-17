import 'dart:io';

import 'package:booking/model/database_service.dart';
import 'package:booking/user/pages/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';


class PersonalDetail extends StatefulWidget {
   PersonalDetail({super.key, required this.account});
var account;
  @override
  State<PersonalDetail> createState() => _PersonalDetailState();
}

class _PersonalDetailState extends State<PersonalDetail> {
    Map<String, dynamic>? user; 
    final FirebaseFirestore db = FirebaseFirestore.instance;
    DatabaseService _databaseService=DatabaseService();
    File? imageFile;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController dayController= TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordControler=TextEditingController();


 

  

    
Future<void> _selectedStartDate() async{
    DateTime? _picked=await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if(_picked!=null){
      setState(() {
        dayController.text=_picked.toString().split(" ")[0];
        
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
        passwordControler.text = user!['password'];
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
      
      
      body: user!=null ? Container(
        width: double.infinity,
        height:   double.infinity ,
        child: SingleChildScrollView(
          child: Column(
            children:[ 
              Padding(
                padding: EdgeInsets.only(bottom: 0),
                child: Stack(
                fit: StackFit.loose,
                children:[
                  Container(
                    margin: EdgeInsets.only(bottom: 50),
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
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage(account: widget.account)));
                      }, icon: Icon(Icons.undo,
                      color: Colors.white,)
                      ),
                      
                      
                    ),
                    ),
                    
                ] 
                ),
              ),
              const Text('Personal Information',
              textAlign: TextAlign.start,
              style:TextStyle(
                fontFamily: 'Calis',
                fontSize: 20,
              )
              ),
              Container(
                  margin: EdgeInsets.only(top: 30,right: 30,left: 30),          
                 decoration:BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                   boxShadow: [
                      BoxShadow(
                      color: Colors.black.withOpacity(0.1), 
                      spreadRadius: 3,
                       blurRadius: 7, 
                       offset: Offset(0, 2), 
                        ),
                      ],
                      ),
                      height: 50,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20,),
                        child: TextFormField(
                          readOnly: true,
                        validator: (value){
                        if(value==null||value.isEmpty){
                        return 'Bắt buộc nhập';
                        }
                        },
                        controller: fullNameController,         
                        decoration: const InputDecoration(
                          
                        border: InputBorder.none,
                        // label:Text( 'Enter card number *', style:TextStyle(color: Color(0xffBEBCBC)),),
                         floatingLabelBehavior: FloatingLabelBehavior.never,
                                           
                                           
                                         
                                         
                         ),
                       ),
                      ),
               ),
               Container(
                  margin: EdgeInsets.only(top: 30,right: 30,left: 30),          
                 decoration:BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                   boxShadow: [
                      BoxShadow(
                      color: Colors.black.withOpacity(0.1), 
                      spreadRadius: 3,
                       blurRadius: 7, 
                       offset: Offset(0, 2), 
                        ),
                      ],
                      ),
                      height: 50,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, ),
                        child: TextFormField(
                          readOnly: true,
                        validator: (value){
                        if(value==null||value.isEmpty){
                        return 'Bắt buộc nhập';
                        }
                        },
                        controller: dayController,         
                        decoration:const  InputDecoration(
                          
                        border: InputBorder.none,
                        // label:Text( 'Enter card number *', style:TextStyle(color: Color(0xffBEBCBC)),),
                         floatingLabelBehavior: FloatingLabelBehavior.never,
                                           
                                           
                                         
                                         
                         ),
                       ),
                      ),
               ),
               Container(
                  margin: EdgeInsets.only(top: 30,right: 30,left: 30),          
                 decoration:BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                   boxShadow: [
                      BoxShadow(
                      color: Colors.black.withOpacity(0.1), 
                      spreadRadius: 3,
                       blurRadius: 7, 
                       offset: Offset(0, 2), 
                        ),
                      ],
                      ),
                      height: 50,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, ),
                        child: TextFormField(
                          readOnly: true,
                        validator: (value){
                        if(value==null||value.isEmpty){
                        return 'Bắt buộc nhập';
                        }
                        },
                        controller: addressController,         
                        decoration:const  InputDecoration(
                          
                        border: InputBorder.none,
                        // label:Text( 'Enter card number *', style:TextStyle(color: Color(0xffBEBCBC)),),
                         floatingLabelBehavior: FloatingLabelBehavior.never,
                                           
                                           
                                         
                                         
                         ),
                       ),
                      ),
               ),
               SizedBox(height: 40,),
               const Text('Account',
              textAlign: TextAlign.start,
              style:TextStyle(
                fontFamily: 'Calis',
                fontSize: 20,
              )
              ),
               Container(
                  margin: EdgeInsets.only(top: 10,right: 30,left: 30),          
                 decoration:BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                   boxShadow: [
                      BoxShadow(
                      color: Colors.black.withOpacity(0.1), 
                      spreadRadius: 3,
                       blurRadius: 7, 
                       offset: Offset(0, 2), 
                        ),
                      ],
                      ),
                      height: 50,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20,bottom: 1),
                        child: TextFormField(
                          readOnly: true,
                        validator: (value){
                        if(value==null||value.isEmpty){
                        return 'Bắt buộc nhập';
                        }
                        },
                        controller: emailController,         
                        decoration: const InputDecoration(
                          
                          
                        border: InputBorder.none,
                        // label:Text( 'Enter card number *', style:TextStyle(color: Color(0xffBEBCBC)),),
                         floatingLabelBehavior: FloatingLabelBehavior.never,
                                           
                                           
                                         
                                         
                         ),
                       ),
                      ),
               ),
               Container(
                  margin: EdgeInsets.only(top: 10,right: 30,left: 30),          
                 decoration:BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                   boxShadow: [
                      BoxShadow(
                      color: Colors.black.withOpacity(0.1), 
                      spreadRadius: 3,
                       blurRadius: 7, 
                       offset: Offset(0, 2), 
                        ),
                      ],
                      ),
                      height: 50,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20,bottom: 12),
                        child: TextFormField(
                          readOnly: true,
                        validator: (value){
                        if(value==null||value.isEmpty){
                        return 'Bắt buộc nhập';
                        }
                        },
                        controller: passwordControler,         
                        decoration: const InputDecoration(
                          label: Text('Địa chỉ'),
                          
                        border: InputBorder.none,
                        // label:Text( 'Enter card number *', style:TextStyle(color: Color(0xffBEBCBC)),),
                         floatingLabelBehavior: FloatingLabelBehavior.never,
                                           
                                           
                                         
                                         
                         ),
                       ),
                      ),
               ),
                // GestureDetector(
                //   onTap: (){
                //     user!['address']=addressController.text;
                //     user!['day']=dayController.text;
                //     _databaseService.updateUser(widget.account, user, context);
                //   },
                //   child: Container(
                //     margin: EdgeInsets.only(top: 30),
                //     decoration: BoxDecoration(
                //       color: Color(0xff1A4368),
                //       borderRadius: BorderRadius.circular(20),
                //     ),
                //     child: const Padding(
                //       padding: EdgeInsets.only(left: 100,right: 100, top: 15, bottom: 15),
                //       child: Text('Update',
                //       style: TextStyle(color: Colors.white,
                //       fontSize: 20),)),
                //   ),
                // ),
                  
                
            ]
          ),
        ),
      ):Center(
                      child: CircularProgressIndicator(), // Hoặc bạn có thể thay thế bằng một widget khác thông báo lỗi

      )
    );
  }
}