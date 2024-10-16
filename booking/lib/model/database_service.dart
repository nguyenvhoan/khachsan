import 'package:booking/user/pages/home_page.dart';
import 'package:booking/user/pages/personal_detail.dart';
import 'package:booking/user/widget/alert_update_profile.dart';
import 'package:booking/user/widget/navigation_menu.dart';
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
            'password':password ,
            'address':'',
            'day':'',
            'img':'',
            'score':'',
            'scoreUsed':'',

          }
        );
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content:const Text('Bạn đã đăng ký thành công.'),
        duration:const Duration(seconds: 3),
        action: SnackBarAction(
        label: 'Đóng',
      onPressed: () {

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
        String? userId = await getUserIdByEmail(email);
      print('User ID: $userId');
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:const Text( 'Đăng nhập thành công',
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
          
        Navigator.push(context, MaterialPageRoute(builder: (context)=>NavigationMenu(account: userId,)));
        

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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:const Text( 'Định dạng email không đúng',
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
    Future<String?> getUserIdByEmail(String email) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('user') // Tên bộ sưu tập
        .where('email', isEqualTo: email) // Điều kiện tìm kiếm
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Nếu tìm thấy tài liệu
      return querySnapshot.docs.first.id; // Trả về ID của tài liệu đầu tiên
    } else {
      print('No user found with that email');
      return null; // Không tìm thấy người dùng
    }
  } catch (e) {
    print('Error getting user ID: $e');
    return null; // Xử lý lỗi
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


 Future<void> createReq(Map<String,dynamic> req) async {
      try {
          db.collection('Request').doc('request '+ req['id']).set(req);

      }
        catch(e){
          print(e.toString());
        }
    
      }
      Future<void> createHistory(String account, Map<String, dynamic> req) async {
          try {
            await db.collection('user').doc(account).set({
              'History': req,
            }, SetOptions(merge: true)); // Sử dụng merge để tránh ghi đè dữ liệu khác
          } catch (e) {
            print('Lỗi khi tạo lịch sử: ${e.toString()}');
          }
        }
      void updateUser(String userId, Map<String, dynamic>? updatedData, BuildContext context) async {
    
     bool? confirm = await AlertUpdateUser.showConfirmDialog(context);
    if(confirm==true){
      try {

    await FirebaseFirestore.instance.collection('user').doc(userId).update(updatedData!);
    print('User updated successfully');
    Navigator.push(context, MaterialPageRoute(builder: (context)=>PersonalDetail(account: userId)));
  }
  catch (e) {
    print('Error updating user: $e');
  }
    } 
     else {
      print('User cancelled the update .');
    }
   
}

Future<int?> getScore(String email) async {
  try {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(email) // Sử dụng email làm ID tài liệu
        .get();

    if (documentSnapshot.exists) {
      var data = documentSnapshot.data() as Map<String, dynamic>?;

      if (data != null && data['score'] != null) {
     
        return data['score'] as int?;
      } else {
        print('Score not found for user with email: $email');
        return null; 
      }
    } else {
      print('No user found with that email');
      return null; 
    }
  } catch (e) {
    print('Error getting user score: $e');
    return null; // Xử lý lỗi
  }
}
Future<void> updateScore(String email, int newScore) async {
  try {
    int? currentScore = await getScore(email);

    if (currentScore != null) {
      int updatedScore = currentScore + newScore;

      await FirebaseFirestore.instance.collection('user').doc(email).update({
        'score': updatedScore, 
      });
    } else {
      print('Current score is null. Cannot update.');
    }
  } catch (e) {
    print('Error updating user score: $e');
  }
}

Future<List<Map<String, dynamic>>> getRequestsByUserEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await db
          .collection('Request')
          .where('idUser', isEqualTo: email)
          .get();

      List<Map<String, dynamic>> requests = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id, // ID của document
          ...doc.data() as Map<String, dynamic> // Dữ liệu của document
        };
      }).toList();

      return requests;
    } catch (e) {
      print("Error getting requests: $e");
      return [];
    }
  }

Future<void> exchangePoint(String email, int newScore,List<Map<String, dynamic>> voucher,BuildContext context, Function onSuccess) async {
  
   bool? confirm = await AlertUpdateUser.showConfirmDialogVoucher(context);
   if(confirm==true){
  try {
    int? currentScore = await getScore(email);

    if (currentScore != null) {
      if (newScore > currentScore) {
        print('New score exceeds current score. Cannot update.');
        return; 
      }

      int updatedScore = currentScore - newScore;
      await FirebaseFirestore.instance.collection('user').doc(email).update({
        'score': updatedScore,
        'voucher': voucher,
      });

      print('Score updated successfully to $updatedScore.');
    } else {
      print('Current score is null. Cannot update.');
    }
  } catch (e) {
    print('Error updating user score: $e');
  }
   }
   else {
      print('User cancelled the update .');
    }
}
Future<int?> getUsedScore(String email) async {
  try {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(email) // Sử dụng email làm ID tài liệu
        .get();

    if (documentSnapshot.exists) {
      var data = documentSnapshot.data() as Map<String, dynamic>?;

      if (data != null && data['scoreUsed'] != null) {
     
        return data['scoreUsed'] as int?;
      } else {
        print('Score not found for user with email: $email');
        return null; 
      }
    } else {
      print('No user found with that email');
      return null; 
    }
  } catch (e) {
    print('Error getting user score: $e');
    return null; // Xử lý lỗi
  }
}


   

}


 

  

