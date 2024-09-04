import 'package:booking/app/my_app.dart';
import 'package:booking/user/pages/intro_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  // Khởi tạo Firebase
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCaSZINQu93RK-593Spsraw1ldsxw-Ikj0",
          authDomain: "ksan-12952.firebaseapp.com",
          projectId: "ksan-12952",
          storageBucket: "ksan-12952.appspot.com",
          messagingSenderId: "403220053356",
          appId: "1:403220053356:web:17d8e912d117d9bbcbc749",
          measurementId: "G-5P1SNPJE4N"),
    );
  } else {
    await Firebase.initializeApp(
    options:const FirebaseOptions(
    apiKey: "AIzaSyAktqPqOPGBV65HizPYV0WXAWXTj_7LtyQ",
    appId: "1:403220053356:android:846171e3b48f389acbc749",
    messagingSenderId: "403220053356",
    projectId: "ksan-12952"
       
    )
    

    
       
  );
  }

  runApp( const MyApp());
}
