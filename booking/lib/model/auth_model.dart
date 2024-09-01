import 'package:firebase_auth/firebase_auth.dart';

class AuthModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Đăng ký người dùng mới
  Future<User?> registerWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      // Tạo người dùng mới với email và mật khẩu
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Nếu thành công, trả về đối tượng User đại diện cho người dùng
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // In thông báo lỗi nếu có ngoại lệ xảy ra
      print('Error: ${e.message}');
      return null;
    }
  }

  // Đăng nhập người dùng
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Error: ${e.message}');
      return null;
    }
  }

  // Đăng xuất người dùng
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
