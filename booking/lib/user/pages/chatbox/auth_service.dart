import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? getCurrentUser(){
    return _auth.currentUser;
  }
}