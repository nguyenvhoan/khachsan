import 'package:booking/model/database_service.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Signin extends StatefulWidget {
  const Signin({super.key, required this.onGetStarted});
final VoidCallback  onGetStarted;
  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  bool _obscureText = true;
  TextEditingController _emailController =TextEditingController();
  TextEditingController _passwordController =TextEditingController();
  DatabaseService _databaseService =DatabaseService();
   final _formkey = GlobalKey<FormState>();
   bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        
      backgroundColor: Colors.transparent,
        body: Container(
           height: MediaQuery.of(context).size.height / 1.8 ,
          decoration:const  BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30), 
                    topRight: Radius.circular(30), 
                  ),
                ),
          child: Container(
            margin: EdgeInsets.only(top:70, left: 15,right: 15),
            child: Form(
              key: _formkey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Column(
                    
                    children: [
                      if (_isLoading) 
                               Container(
                                 // Nền mờ
                                child: Center(
                                  child: LoadingAnimationWidget.twistingDots(
                                    leftDotColor: const Color(0xFF1A1A3F),
                                    rightDotColor: const Color(0xFFEA3799),
                                    size: 40, 
                                  ),
                                ),
                            ),
                      TextFormField(
                        validator: (value){
                        if(value==null||value.isEmpty){
                          return 'Hãy nhập gmail';
                        }
                      },
                            controller: _emailController,
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
                                
                              
                              labelText: 'Gmail',
                              labelStyle:  TextStyle(
                                color: Color(0xff57A5EC), // Thay đổi màu của labelText
                              ),
                              prefixIcon:  Icon(
                                Icons.email,
                                color: Colors.black,
                              ),
                            
                            ),
                          ),
                          SizedBox(height: 10,),
                        TextFormField(
                          obscureText: _obscureText,
                      validator: (value){
                        if(value==null||value.isEmpty){
                          return 'Hãy nhập password';
                        }
                      },
                            controller: _passwordController,
                            
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
                                color: Color(0xff57A5EC), // Thay đổi màu của labelText
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
                          SizedBox(height: 20,),
                          const Text('Forgot Password?',textAlign: TextAlign.end, style: TextStyle(
                              color: Colors.grey
                          ),),
                          SizedBox(height: 20,),
                          GestureDetector(
                           onTap: () {
                                if(_formkey.currentState!.validate()){   
                                  setState(() {
                                  _isLoading = true; 
                                });                         
                                  print('thanhcongccne');
                                     _databaseService.signIn(context,
                                   _emailController.text,_passwordController.text);
                                    
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
                      SizedBox(height: 20,),
                       Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?", textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),),
                            GestureDetector(
                              onTap: widget.onGetStarted,
                              child:const Text("Sign up", style: TextStyle(
                                color: Color(0xff57A5EC),
                              ),),
                            ),
                          
                          ],
                        ),
                        Container(
                          color: Colors.white,
                        )
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