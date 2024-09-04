import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 2,
        ),
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(
            top: 80, left: kIsWeb ? 85 : 15, right: kIsWeb ? 85 : 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      width: 2,
                      style: BorderStyle.solid,
                      strokeAlign: 50,
                    ),
                  ),
                  labelText: 'Gmail',
                  labelStyle: const TextStyle(
                    color: Color(0xff57A5EC), // Thay đổi màu của labelText
                  ),
                  prefixIcon: const Icon(
                    Icons.email,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: _obscureText,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
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
                    color: Color(0xff57A5EC), // Thay đổi màu của labelText
                  ),
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: Colors.black,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.visibility),
                    color: Colors.black,
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              const Text(
                'Forgot Password?',
                textAlign: TextAlign.end,
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Sign In',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                      color: Color(0xff1A4368),
                      borderRadius: BorderRadius.circular(25)),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Sign up",
                    style: TextStyle(
                      color: Color(0xff57A5EC),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
