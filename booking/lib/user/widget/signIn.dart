import 'package:booking/model/database_service.dart';
import 'package:booking/ui/button_confirm_landing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Signin extends StatefulWidget {
  const Signin({super.key, required this.onGetStarted});
  final VoidCallback onGetStarted;

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  bool _obscureText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void createAndNavigateToHomePage() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _databaseService.signIn(
          context,
          _emailController.text,
          _passwordController.text,
        );
      } catch (e) {
        print('Lỗi đăng nhập: $e');
        // Có thể hiển thị SnackBar ở đây nếu muốn
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: MediaQuery.of(context).size.height / 1.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Container(
          margin: const EdgeInsets.only(top: 70, left: 15, right: 15),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 20),
                    if (_isLoading)
                      Center(
                        child: LoadingAnimationWidget.twistingDots(
                          leftDotColor: const Color(0xFF1A1A3F),
                          rightDotColor: const Color(0xFFEA3799),
                          size: 40,
                        ),
                      ),
                    TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Hãy nhập Gmail';
                        }
                        return null;
                      },
                      style: const TextStyle(color: Colors.black),
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Color(0xff57A5EC), width: 1.5),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xff57A5EC), width: 1.5),
                        ),
                        labelText: 'Gmail',
                        labelStyle: const TextStyle(
                          color: Color(0xff57A5EC),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        prefixIcon: const Icon(Icons.email, color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Hãy nhập mật khẩu';
                        }
                        return null;
                      },
                      style: const TextStyle(color: Colors.black),
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Color(0xff57A5EC), width: 1.5),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xff57A5EC), width: 1.5),
                        ),
                        labelText: 'Password',
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xff57A5EC),
                        ),
                        prefixIcon: const Icon(Icons.lock, color: Colors.black),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Forgot Password?',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: ButtonConfirmLanding(
                        onGetStarted: createAndNavigateToHomePage,
                        textTitle: 'Sign In',
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        GestureDetector(
                          onTap: widget.onGetStarted,
                          child: const Text(
                            " Sign up",
                            style: TextStyle(
                              color: Color(0xff57A5EC),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
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
