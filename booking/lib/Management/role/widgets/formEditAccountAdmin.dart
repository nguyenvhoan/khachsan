

import 'package:booking/Management/RoomType/image_picker_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Hàm để hiển thị dialog chỉnh sửa tài khoản
Future<void> showEditDialogAccountAdmin(
  BuildContext context,
  String id,
  Map<String, dynamic> thisItem,
  TextEditingController fnc,
  TextEditingController pc,
  TextEditingController rc,
  TextEditingController uc,
  String imageUrl,
  List<String> lstRole,
) async {
  

  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
     print(thisItem);
  fnc.text = thisItem['fullname'];
  pc.text = thisItem['password'];
  rc.text = thisItem['role'];
  uc.text = thisItem['username'];
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('Edit Account Admin'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      String? url = await pickAndUploadImage('');
                      if (url != null) {
                        setState(() {
                          imageUrl = url; // Cập nhật imageUrl
                        });
                      }
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: imageUrl.isNotEmpty
                          ? NetworkImage(imageUrl)
                          : null,
                      child: imageUrl.isEmpty ? const Icon(Icons.image) : null,
                    ),
                  ),
                  // TextFields for editing
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: fnc,
                        decoration: const InputDecoration(
                          label: Text('Full Name', style: TextStyle(fontFamily: 'Candal')),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  // Các TextField khác...
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: uc,
                        decoration: const InputDecoration(
                          label: Text('UserName', style: TextStyle(fontFamily: 'Candal')),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                 Container(
                margin: EdgeInsets.only(top: 10,),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.black
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 5,bottom: 5,left: 10,right: 10),
                  child: TextField(
                    
                    controller: pc,
                    decoration: const InputDecoration(label: Text('Password', style: TextStyle(fontFamily: 'Candal')),
                    border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10,),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.black
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                    padding: EdgeInsets.only(top: 5,bottom: 5,left: 10,right: 10),
                  child: TextField(
                    readOnly: true,
                    controller: rc,
                    decoration: InputDecoration(
                      
                      border: InputBorder.none,
                      label: Text('Role', style: TextStyle(fontFamily: 'Candal', ),),
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
                        rc.text=newValue!;
                      },
                    ),
                  ),
                              ),
                            ),
                ),
              ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Save'),
                onPressed: () async {
                  try {
                    await FirebaseFirestore.instance
                      .collection('Admin')
                      .doc(id)
                      .update({
                        'fullname': fnc.text,
                        'username': uc.text,
                        'password': pc.text,
                        'role': rc.text,
                        'img': imageUrl, // Lưu imageUrl mới
                      });
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Update account successful'),
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error updating account: $e'),
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
            ],
          );
        },
      );
    },
  );
}
