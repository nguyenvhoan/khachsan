import 'package:booking/Management/RoomType/image_picker_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:random_string/random_string.dart';

class FormcreateAccountAdmin extends StatefulWidget {
  final TextEditingController fullname;
  final TextEditingController username;
  final TextEditingController password;
  final String? selectedRole;
  final List<String> roleOption;
  final void Function(String?) onChanged;
  String img;
  final VoidCallback onSubmit;
 
 

   FormcreateAccountAdmin({
    Key? key,
    required  this.fullname,
    required this.password,
    required this.username  ,
    required this.selectedRole,
    required this.onSubmit,

    required this.onChanged,
    required this.roleOption,
    required this.img,
  }) : super(key: key);

  @override
  State<FormcreateAccountAdmin> createState() => _FormcreateAccountAdminState();
}

class _FormcreateAccountAdminState extends State<FormcreateAccountAdmin> {
  String? _selectedRole;
  String? _usernameError;
  @override
  void initState() {
    super.initState();
    _selectedRole = widget.selectedRole; // Khởi tạo với giá trị từ widget
  }
   Future<bool> isUsernameUnique(String username) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('Admin')
        .where('username', isEqualTo: username)
        .get();
    return result.docs.isEmpty; // Trả về true nếu không có username trùng
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(10),
              child: const Center(child: Text('Create Account Admin', style: TextStyle(
                fontFamily: 'Candal',
                fontSize: 21
              ),))),
              Center(
                child: Text('Avatar', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
              ),
            Center(
              child: GestureDetector(
                    onTap: () async {
                          String? url = await pickAndUploadImage('');
                          if (url != null) {
                            setState(() {
                              widget.img = url; // Cập nhật imageUrl
                            });
                          }
                        },
                    child: Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: widget.img.isNotEmpty
                            ? NetworkImage(widget.img)
                            : widget.img != null
                                ? NetworkImage(widget.img)
                                : null,
                        child:
                            widget.img == null ? const Icon(Icons.image) : null,
                      ),
                    ),
                  ),
            ),
                //
            const SizedBox(height: 10),
            Container(
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: widget.fullname,
                  decoration: const InputDecoration(
                    label: Text('Full Name', style: TextStyle(fontFamily: 'Candal')),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 10),
            Container(
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: widget.username,
                  decoration: InputDecoration(
                    label: const Text('User Name', style: TextStyle(fontFamily: 'Candal')),
                    border: InputBorder.none,
                    
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: widget.password,
                  decoration: const InputDecoration(
                    label: Text('Password', style: TextStyle(fontFamily: 'Candal')),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 10),
            Container(
              margin: EdgeInsets.only(top: 10,),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.black
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                value: _selectedRole,
                hint: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: const Text('SelectRole')),
                  
                onChanged:(value) {
                  setState(() {
                   _selectedRole=value;
                  });
                },
                items:
                    widget.roleOption.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: ()async{
            
            final String fname = widget.fullname.text;
            final String uname = widget.username.text;
            final String pwd = widget.password.text;
            final String role =widget.selectedRole ?? 'Unknown';
            
            
                if (await isUsernameUnique(uname)) {
             FirebaseFirestore.instance.collection('Admin').add({
              "name": randomAlphaNumeric(10),
              "fullname": fname,
              "role": _selectedRole,
              "password": pwd,
              "username":uname,
              "id": randomString(7),
              "img": widget.img,
              
            });
            widget.fullname.clear();
             widget.username.clear();
             widget.password.clear();
            Navigator.of(context).pop();
                }
                  else ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content:const Text('Username đã tồn tại .'),
                    duration:const Duration(seconds: 3),
                    action: SnackBarAction(
                    label: 'Đóng',
                  onPressed: () {
                  
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                  ),
                  )

                );
                },
                
                child: const Text('Create'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
