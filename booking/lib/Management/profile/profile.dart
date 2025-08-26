import 'package:booking/Management/RoomType/image_picker_util.dart';
import 'package:booking/model/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ProfileAdmin extends StatefulWidget {
   ProfileAdmin({super.key, required this.user});
  var user;

  @override
  State<ProfileAdmin> createState() => _ProfileAdminState();
}

class _ProfileAdminState extends State<ProfileAdmin> {
  DatabaseService _databaseService=DatabaseService();
  TextEditingController fullNameController = TextEditingController();
  String id='';
  TextEditingController username= TextEditingController();
  TextEditingController role = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();
  List<String> lstRole = [];
  final CollectionReference _service =
      FirebaseFirestore.instance.collection('role');
  @override
  void initState() {
    super.initState();
    fetch();
          _loadServices();
  }
  Future<void> _loadServices() async {
    try {
      QuerySnapshot snapshot = await _service.get();
      List<String> services =
          snapshot.docs.map((doc) => doc['name'] as String).toList();
      setState(() {
        lstRole = services;
      });
    } catch (e) {
      print('Error loading role: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load role.')));
    }
  }
  Future<void> fetch()async {
    String? a = await _databaseService.getAdminByUname(widget.user['username']);
    id=a!;
  }
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.sizeOf(context);
    fullNameController.text=widget.user['fullname'];
    username.text=widget.user['username'];
    role.text=widget.user['role'];
    password.text=widget.user['password'];
    phone.text=widget.user['phone'];
    
     return Scaffold(
      
      
      body: widget.user!=null ? SizedBox(
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
                  height: 250,
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
                  left: size.width/3  ,
                  child: ClipOval(
                    
                      child: Container(
                        width: size.width , 
                       height: size.width ,
                       decoration:BoxDecoration(
                                      image: DecorationImage(
                          image: widget.user['img'] != null
                              ? NetworkImage(widget.user['img']) 
                              : (widget.user['img'] != null && widget.user['img'].isNotEmpty
                                  ? NetworkImage(widget.user['img']) 
                                  : const AssetImage('asset/images/london-west-hollywood-los-angeles-california-102897-2.jpg') as ImageProvider), 
                          fit: BoxFit.cover,
                        ),
                      ),
                      
                    ),
                  ),
                ),
                  Positioned(
                    top: 225,
                    left:size.width/1.7,
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
              const Text('Personal Information',
              textAlign: TextAlign.start,
              style:TextStyle(
                fontFamily: 'Calis',
                fontSize: 20,
              )
              ),
              Container(
                width: size.width/3,
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
                        padding: const EdgeInsets.only(left: 20,),
                        child: TextField(
                        
                        controller: fullNameController,         
                        decoration:const InputDecoration(
                      label: Text('FullName', style: TextStyle(fontFamily: 'Candal')),
                      border: InputBorder.none,
                    hintText: 'Chọn một mục...',
                    
                     ),
                       ),
                      ),
               ),
               Container(
                  width: size.width/3,

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
                        padding: const EdgeInsets.only(left: 20, ),
                        child: TextField(
                        
                        controller: username,         
                        decoration:const InputDecoration(
                      label: Text('UserName', style: TextStyle(fontFamily: 'Candal')),
                      border: InputBorder.none,
                    hintText: 'Chọn một mục...',
                    
                     ),
                       ),
                      ),
               ),
               Container(
                 width: size.width/3,
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
                        padding: const EdgeInsets.only(left: 20, ),
                        child: TextField(
                        
                        controller: password,         
                        decoration:const InputDecoration(
                      label: Text('Password', style: TextStyle(fontFamily: 'Candal')),
                      border: InputBorder.none,
                    hintText: 'Chọn một mục...',
                    
                     ),
                       ),
                      ),
               ),
               Container(
                 width: size.width/3,
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
                        padding: const EdgeInsets.only(left: 20, ),
                        child: TextField(
                        
                        controller: phone,         
                        decoration:const InputDecoration(
                      label: Text('Phone', style: TextStyle(fontFamily: 'Candal')),
                      border: InputBorder.none,
                    hintText: 'Chọn một mục...',
                    
                     ),
                       ),
                      ),
               ),
               const SizedBox(height: 40,),
               const Text('Role',
              textAlign: TextAlign.start,
              style:TextStyle(
                fontFamily: 'Calis',
                fontSize: 20,
              )
              ),
               Container(
                height: 50,
                width: size.width/3,
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
                child: Padding(
                    padding: EdgeInsets.only(left: 20),
                  child: TextField(
                    readOnly: true,
                    controller: role,
                    decoration: InputDecoration(
                      label: Text('Role', style: TextStyle(fontFamily: 'Candal')),
                      border: InputBorder.none,
                    hintText: 'Chọn một mục...',
                    suffixIcon: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      
                      dropdownColor: Colors.white,
                      focusColor: Colors.white,
                      icon: Icon(Icons.arrow_drop_down),
                      items: lstRole.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        role.text=newValue!;
                      },
                    ),
                  ),
                              ),
                            ),
                ),
              ),
               Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color:Colors.blueAccent,
                  border: Border.all(
                    width: 1,
                    color: Colors.white
                  ),
                  borderRadius: BorderRadius.circular(10)
                ),
                 child: GestureDetector(
                  onTap: (){
                    FirebaseFirestore.instance.collection('Admin').doc(id).update({
                      'username':username.text,
                      'fullname':fullNameController.text,
                      'password':password.text,
                      'role':role.text,
                      'img':widget.user['img']
                    });
                     ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Save Successful'),
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          duration: Duration(seconds: 2),
                        ),
                      );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10, right: 25,left: 25),
                    child: Text('Save', style: TextStyle(color: Colors.white),)),
                 ),
               )
               
                  
                
            ]
          ),
        ),
      ):const Center(
                      child: CircularProgressIndicator(), // Hoặc bạn có thể thay thế bằng một widget khác thông báo lỗi

      )
    );
  }
}