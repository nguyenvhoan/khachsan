import 'package:booking/user/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DatabaseService {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    Future<bool> registration(BuildContext context, String email, String password, String name) async {
    try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: email,
    password: password,
    );
      
        await db.collection('user').doc(FirebaseAuth.instance.currentUser?.uid ?? '').set(
          {
            'name':name,
            'email':email,
            'password':password 

          }
        );
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content:const Text('Bạn đã đăng ký thành công.'),
        duration:const Duration(seconds: 3),
        action: SnackBarAction(
        label: 'Đóng',
      onPressed: () {
                                  // Xử lý khi người dùng bấm vào nút Đóng
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
      )
      
    );
     return true; 
      } on FirebaseAuthException catch (e) {
          if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content:const Text('Email này đã tồn tại.'),
            duration:const Duration(seconds: 3),
            action: SnackBarAction(
            label: 'Đóng',
            onPressed: () {
              // Xử lý khi người dùng bấm vào nút Đóng  
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
        ),)
          );
        }
         return false;
      } catch (e) {
        print(e);
        return false;
      }
       
 }

Future<void> signIn(BuildContext context, String email,String password)async{
      try{
         String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      print('User ID: $userId');
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text( 'Đăng nhập thành công',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, ),
          ),
          backgroundColor: Colors.black,
          shape: Border.all(
            width: 1,
            color: Colors.white
          ),
          behavior: SnackBarBehavior.floating,
          ),
          
          );
        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));

      }
      on FirebaseAuthException catch (e){
        if(e.code=='user-not-found'){
          print('No User Found For That Email');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email không tồn tại hoặc chưa đăng ký',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18,),
          ),
          backgroundColor: Colors.black,
          shape: Border.all(
            width: 1,
            color: Colors.white
          ),
          behavior: SnackBarBehavior.floating,
          
          ),
          );
          
        }
        else if(e.code=='wrong-password'){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text( 'Mật khẩu không chính xác',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, ),
          ),
          backgroundColor: Colors.black,
          shape: Border.all(
            width: 1,
            color: Colors.white
          ),
          behavior: SnackBarBehavior.floating,
          ),
          
          );
        }
        else if(e.code=='invalid-email'){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text( 'Định dạng email không đúng',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, ),
          ),
          backgroundColor: Colors.black,
          shape: Border.all(
            width: 1,
            color: Colors.white
          ),
          behavior: SnackBarBehavior.floating,
          ),
          
          );
        }
      }
    }
    Future<List<String>> getService() async {
  List<String> services = [];

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Service').get();
    
    for (var doc in querySnapshot.docs) {
      
      services.add(doc['service']); 
    }
  } catch (e) {
    print(e.toString());
  }
  
  return services;
}

  

}