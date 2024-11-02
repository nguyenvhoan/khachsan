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
  final TextEditingController _nameController=TextEditingController();
  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();
  final TextEditingController _repasswordController=TextEditingController();
  bool _obscureText = true;
  final _formkey = GlobalKey<FormState>();

  final CollectionReference _databaseReference =
      FirebaseFirestore.instance.collection('User');
  
  String email="",name="",password="", userId="";
  final DatabaseService _databaseService = DatabaseService();
   bool _isLoading = false;

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      backgroundColor: Colors.transparent,
      
        body: Container(   
           height: MediaQuery.of(context).size.height / 1.8 , 
          decoration:const BoxDecoration(
            
                  color: Colors.white,
                  borderRadius:BorderRadius.only(
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
                  padding: const EdgeInsets.only(top: 5),
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
                             return null;
                          },
                        controller: _nameController,                                       
                            style: const TextStyle(
                              color: Colors.black ,
                            ),  
                            cursorColor: Colors.black, 
                            decoration:const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              labelText: 'FullName',
                              labelStyle:  TextStyle(
                                color: Color(0xff57A5EC), 
                              ),
                              prefixIcon:  Icon(
                                Icons.email,
                                color: Colors.black,
                              ),
                            
                            ),
                          ),
                          const SizedBox(height: 10,),
                          TextFormField(
                            validator: (value){
                                if(value==null||value.isEmpty){
                                  return 'Hãy nhập email';
                                }
                                final emailRegex = RegExp(r'^[\w-\.]+@gmail\.com$');
                                if (!emailRegex.hasMatch(value)) {
                                  return 'Email phải có đuôi "@gmail.com"';
                                }
                                return null;
                              },  
                            controller: _emailController  ,                                      
                            style: const TextStyle(
                              color: Colors.black ,
                            ),  
                            cursorColor: Colors.black, 
                            decoration:const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              labelText: 'Phone or Gmail',
                              labelStyle:  TextStyle(
                                color: Color(0xff57A5EC), 
                              ),
                              prefixIcon:  Icon(
                                Icons.email,
                                color: Colors.black,
                              ),
                            
                            ),
                          ),
                          const SizedBox(height: 10,),  
                      TextFormField( 
                            validator: (value){
                            if(value==null||value.isEmpty){
                              return 'Hãy nhập password';
                            }
                             if(value.length<7){  
                              return 'Mật khẩu phải lớn hơn 7 kí tự';
                            }
                             return null;
                          },
                        controller: _passwordController,
                            obscureText: _obscureText, 
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            cursorColor: Colors.black, 
                            decoration: InputDecoration(
                              enabledBorder:const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder:const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
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
                               icon: const Icon(Icons.visibility),
                                color: Colors.black,
                                onPressed: (){
                                  setState(() {
                                    _obscureText=!_obscureText;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          TextFormField( 
                                  validator: (value){
                              if(value==null||value!=_passwordController.text){
                                return 'Mật khẩu không khớp';
                              }
                              return null;
                            },
                            controller: _repasswordController,
                            obscureText: _obscureText, 
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            cursorColor: Colors.black, 
                            decoration: InputDecoration(
                              enabledBorder:const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder:const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
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
                               icon: const Icon(Icons.visibility),
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
                          const SizedBox(height: 10,),
           
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
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(
                            color: const Color(0xff1A4368),
                            borderRadius: BorderRadius.circular(25)
                            ),
                          child: Text('Sign In', textAlign:TextAlign.center,
                          style: TextStyle(fontWeight:FontWeight.bold, color: Colors.white),
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
      
    );
  }
}
