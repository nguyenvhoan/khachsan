import 'package:booking/app/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main(List<String> args) async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:const FirebaseOptions(
    apiKey: "AIzaSyAktqPqOPGBV65HizPYV0WXAWXTj_7LtyQ",
    appId: "1:403220053356:android:846171e3b48f389acbc749",
    messagingSenderId: "403220053356",
    projectId: "ksan-12952"      
      )  
  );
  runApp(const MyApp());
}