import 'package:booking/model/auth_model.dart';
import 'package:booking/model/database_service.dart';
import 'package:booking/user/widget/signIn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key, required this.onGetStarted});
final VoidCallback  onGetStarted;
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _nameController=TextEditingController();
  TextEditingController _emailController=TextEditingController();
  TextEditingController _passwordController=TextEditingController();
  TextEditingController _repasswordController=TextEditingController();
  bool _obscureText = true;
  final _formkey = GlobalKey<FormState>();

  final CollectionReference _databaseReference =
      FirebaseFirestore.instance.collection('User');
  
  String email="",name="",password="", userId="";
  DatabaseService _databaseService = DatabaseService();
   bool _isLoading = false;

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(   
           height: MediaQuery.of(context).size.height / 1.8 , 
          decoration:const BoxDecoration(
            
                  color: Colors.white,
                  borderRadius:const BorderRadius.only(
                    topLeft: Radius.circular(30), 
                    topRight: Radius.circular(30), 
                  ),
                ),
          child: Container(
            margin:const EdgeInsets.only(top:60, left: 15,right: 15),
            child: Form(
              key: _formkey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Column(        
                    children: [   
                      if (_isLoading) 
                          Positioned.fill(
                            child: Container(
                               // Nền mờ
                              child: Center(
                                child: LoadingAnimationWidget.twistingDots(
                                  leftDotColor: const Color(0xFF1A1A3F),
                                  rightDotColor: const Color(0xFFEA3799),
                                  size: 40, 
                                ),
                              ),
                            ),
                          ),       
                      TextFormField( 
                            validator: (value){
                            if(value==null||value.isEmpty){
                              return 'Hãy nhập userName';
                            }final specialCharRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
                            if (specialCharRegex.hasMatch(value)) {
                              return 'UserName không được chứa ký tự đặc biệt';
                            }
                             if(value.length<7){
                              return 'Tài khoản phải lớn hơn 7 kí tự';
                            }
                          },
                        controller: _nameController,                                       
                            style: const TextStyle(
                              color: Colors.black ,
                            ),  
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  width: 2,
                                  style: BorderStyle.solid,
                                  strokeAlign: 50,
                                ),
                              ),
                              labelText: 'FullName',
                              labelStyle: const TextStyle(
                                color: Color(0xff57A5EC), 
                              ),
                              prefixIcon: const Icon(
                                Icons.email,
                                color: Colors.black,
                              ),
                            
                            ),
                          ),
                          SizedBox(height: 10,),
                          TextFormField(
                            validator: (value){
                                if(value==null||value.isEmpty){
                                  return 'Hãy nhập email';
                                }
                                final emailRegex = RegExp(r'^[\w-\.]+@gmail\.com$');
                                if (!emailRegex.hasMatch(value)) {
                                  return 'Email phải có đuôi "@gmail.com"';
                                }
                              },  
                            controller: _emailController  ,                                      
                            style: const TextStyle(
                              color: Colors.black ,
                            ),  
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 10.0),          
              
                              border: OutlineInputBorder(
                                
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  width: 2,
                                  style: BorderStyle.solid,
                                  strokeAlign: 50,
                                ),
                              ),
                              labelText: 'Phone or Gmail',
                              labelStyle: const TextStyle(
                                color: Color(0xff57A5EC), 
                              ),
                              prefixIcon: const Icon(
                                Icons.email,
                                color: Colors.black,
                              ),
                            
                            ),
                          ),
                          SizedBox(height: 10,),  
                      TextFormField( 
                            validator: (value){
                            if(value==null||value.isEmpty){
                              return 'Hãy nhập password';
                            }
                             if(value.length<7){  
                              return 'Mật khẩu phải lớn hơn 7 kí tự';
                            }
                          },
                        controller: _passwordController,
                            obscureText: _obscureText, 
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  width: 2,
                                  style: BorderStyle.solid,
                                  strokeAlign: 50,
                                ),
                              ),
                              labelText: 'Password',
                              labelStyle: const TextStyle(
                                color: Color(0xff57A5EC), 
                              ),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Colors.black,
                              ),
                              suffixIcon:  IconButton(    
                               icon: Icon(Icons.visibility),
                                color: Colors.black,
                                onPressed: (){
                                  setState(() {
                                    _obscureText=!_obscureText;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 5,),
                          TextFormField( 
                                  validator: (value){
                              if(value==null||value!=_passwordController.text){
                                return 'Mật khẩu không khớp';
                              }
                            },
                            controller: _repasswordController,
                            obscureText: _obscureText, 
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                               contentPadding: EdgeInsets.symmetric(vertical: 10.0),          
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  width: 2,
                                  style: BorderStyle.solid,
                                  strokeAlign: 50,
                                ),
                              ),
                              labelText: 'Confirm Password',
                              labelStyle: const TextStyle(
                                color: Color(0xff57A5EC), 
                              ),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Colors.black,
                              ),
                              suffixIcon:  IconButton(    
                               icon: Icon(Icons.visibility),
                                color: Colors.black,
                                onPressed: (){
                                  setState(() {
                                    _obscureText=!_obscureText;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 5,),
                          const Text('Forgot Password?',textAlign: TextAlign.end, style: TextStyle(
                              color: Colors.grey
                          ),),
                          SizedBox(height: 10,),
           
                          GestureDetector(
                            onTap: () async{
                              if (_formkey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true; 
                                });
        
                                String email = _emailController.text;
                                String password = _passwordController.text;
        
                                bool success = await _databaseService.registration(
                                  context,
                                  email,
                                  password,
                                  _nameController.text,
                                );
        
                                if (success) {
                                  widget.onGetStarted(); 
                                }
        
                                setState(() {
                                  _isLoading = false; 
                                });
                              }
                               
                            },
                        child: Container(
                          alignment: Alignment.center,
                          child: Text('Sign In', textAlign:TextAlign.center,
                          style: TextStyle(fontWeight:FontWeight.bold, color: Colors.white),
                          ),
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Color(0xff1A4368),
                            borderRadius: BorderRadius.circular(25)
                            ),
                        
                          ),
                      ),
                      const SizedBox(height: 5,),
                       Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?", textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),),
                            GestureDetector(
                              onTap:widget.onGetStarted,
                              child:const Text("Sign in", style: TextStyle(
                                color: Color(0xff57A5EC),
                              ),),
                            ),
        
                          ],
                        ),
                          
                         ],
                  ),
                ),
              ),
            ),
          ),
          
        ),
      ),
    );
  }
}