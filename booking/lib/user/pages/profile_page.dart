import 'dart:developer';
import 'dart:io';

import 'package:booking/user/pages/Test.dart';
import 'package:booking/user/pages/booking_history.dart';
import 'package:booking/user/pages/intro_page.dart';
import 'package:booking/user/pages/edit_personal_page.dart';
import 'package:booking/user/pages/notify_page.dart';
import 'package:booking/user/widget/navigation_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
   ProfilePage({super.key, required this.account});
var account;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
    Map<String, dynamic>? user; 
  final FirebaseFirestore db = FirebaseFirestore.instance;
    File? imageFile;
  TextEditingController fullNameController = TextEditingController();

 void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      print(pickedFile.path);
      setState(() {
        imageFile = File(pickedFile.path); // Cập nhật biến imageFile
      });
      await uploadImage();
    }
  }

  

    

    showPhotoOption(){
      showDialog(context: context, builder: (context){
        return AlertDialog(
          title: Text('Upload Profile Picture'),
          content: GestureDetector(
            onTap: (){
              Navigator.pop(context);
              selectImage(ImageSource.gallery);},
            child: Row(children:[Icon(Icons.photo_album), Text('Select from Gallery')])),
        );
      });
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
          
        });
      } else {
        print('Tài liệu không tồn tại');
      }
    } catch (e) {
      print('Lỗi khi lấy dữ liệu: $e');
    }
  }


  Future<void> uploadImage() async {
    if (imageFile == null) return;

    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = FirebaseStorage.instance.ref().child('profile_pictures/$fileName');

      // Tải lên file
      await ref.putFile(imageFile!);
      
      // Lấy URL tải về
      String downloadUrl = await ref.getDownloadURL();
      print('Download URL: $downloadUrl');

      // Lưu URL vào Firestore
      await db.collection('user').doc(widget.account).update({
        'img': downloadUrl, // Thay đổi 'profile_picture' thành tên trường bạn muốn
      });
      
      

    } catch (e) {
      print('Lỗi khi tải lên: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
      Size size =MediaQuery.sizeOf(context);

    return Scaffold(
      
      body: user!=null ? Container(
        width: double.infinity,
        height:   double.infinity ,
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
                    
                    child: IconButton(
                      color: Colors.black,
                      onPressed: (
                        
                      ){
                        showPhotoOption();
                      },
                    icon: Icon(Icons.edit),
                    ),
                  ),
                  ),
                  
                  
              ] 
              ),
            ),
          Container(
                  
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Text(user!['name'], style:const TextStyle(
                        color: Color(0xff3CA0B6),
                        fontFamily: 'Candal',
                        fontSize: 25
                        ),
                        ),
                        Text(user!['email'], style:const TextStyle(
                        color: Color(0xff3CA0B6),
                        fontFamily: 'Candal',
                        fontSize: 15
                        ),
                        ),
                        Container(
                          margin: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            boxShadow: [
                                  BoxShadow(
                                  color: Colors.black.withOpacity(0.1), 
                                  spreadRadius: 3,
                                  blurRadius: 7, 
                                  offset: Offset(0, 2), 
                                ),
                              ],
                            color: const Color.fromARGB(255, 242, 236, 236),
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child:  Column(
                              children: [
                                 Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>EditPersonalDetail(account:widget.account)));
                                    },
                                    child:const Row(
                                      children: [
                                        SizedBox(width: 10,),
                                        Icon(Icons.details),
                                        SizedBox(width: 10,),
                                        Text('Personal Detail', 
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold
                                        ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                 Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>NotifyPage(account: widget.account)));

                                    },
                                    child:const Row(
                                      
                                      children: [
                                        SizedBox(width: 10,),
                                        Icon(Icons.notification_add),
                                        SizedBox(width: 10,),
                                        Text('Notification', 
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold
                                        ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                 Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: GestureDetector(
                                    onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>BookingHistory(account: widget.account,type: 'room',)));
                                      },
                                    child:const Row(
                                      children: [
                                        SizedBox(width: 10,),
                                        Icon(Icons.home),
                                        SizedBox(width: 10,),
                                        Text('Booking History', 
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold
                                        ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                 Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>BookingHistory(account: widget.account, type: 'table',)));
                                    },
                                    child:const Row(
                                      children: [
                                        SizedBox(width: 10,),
                                        Icon(Icons.restaurant),
                                        SizedBox(width: 10,),
                                        Text('Dining Table History', 
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold
                                        ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(

                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            boxShadow: [
                                  BoxShadow(
                                  color: Colors.black.withOpacity(0.1), 
                                  spreadRadius: 3,
                                  blurRadius: 7, 
                                  offset: Offset(0, 2), 
                                ),
                              ],
                            color: const Color.fromARGB(255, 242, 236, 236),
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child:  Column(
                              children: [
                                 
                                 const Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 10,),
                                      Icon(Icons.question_mark),
                                      SizedBox(width: 10,),
                                      Text('Help and Support', 
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                      ),
                                      ),
                                    ],
                                  ),
                                ),
                                 Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: GestureDetector(
                                    onTap: (){
                                    },
                                    child:const  Row(
                                      children: [
                                        SizedBox(width: 10,),
                                        Icon(Icons.dangerous),
                                        SizedBox(width: 10,),
                                        Text('About Us', 
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold
                                        ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>PointUser(account: widget.account,)));
                                    },
                                    child:const Row(
                                      children: [
                                        SizedBox(width: 10,),
                                        Icon(Icons.point_of_sale),
                                        SizedBox(width: 10,),
                                        Text('Point', 
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold
                                        ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                ),
                
              
          ]
        ),
      ):Center(
                      child: CircularProgressIndicator(), // Hoặc bạn có thể thay thế bằng một widget khác thông báo lỗi

      )
    );
  }
}