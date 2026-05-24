//import 'dart:math';
//import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:art_marketplace/auth_provider.dart';
import 'package:provider/provider.dart';

class CustomTextFeild extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool ispassword;

  const CustomTextFeild({
    super.key,
    required this.hint,
    required this.controller,
    this.ispassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextFormField(
        controller: controller,
        obscureText: ispassword,
        decoration: InputDecoration(
          labelText: hint,
          labelStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color.fromARGB(255, 5, 13, 246),
            ),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        validator: (value) {},
      ),
    );
  }
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailcontroller = TextEditingController();
  // final TextEditingController _usernamecontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(44.0), // الارتفاع القياسي لآيفون
        child: CupertinoNavigationBar(
          middle: Text(
            "sign in",
            style: TextStyle(color: CupertinoColors.inactiveGray, fontSize: 20),
            // textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(height: 100),
              Text(
                'log into PaintPay',
                style: TextStyle(
                  foreground: Paint()
                    ..shader = LinearGradient(
                      colors: <Color>[
                        const Color.fromARGB(255, 2, 2, 255),
                        const Color.fromARGB(255, 179, 132, 233),
                      ],
                    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 20),
              CustomTextFeild(hint: "Email", controller: _emailcontroller),

              SizedBox(height: 20),

              CustomTextFeild(
                hint: "Password",
                controller: _passwordcontroller,
                ispassword: true,
              ),
              SizedBox(height: 20),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 72, 78, 239),
                    foregroundColor: Colors.white,
                    //   maximumSize: Size(400, 30),
                    //  fixedSize: Size(400, 30),
                  ),
                  onPressed: () {
                    ///////////////////////////////////////////////back.
                  },
                  child: Text("log in", style: TextStyle(fontSize: 16)),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 40,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    overlayColor: const Color.fromARGB(255, 214, 213, 213),
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/SetPassowrd');
                  },
                  child: Text("forgot password?"),
                ),
              ),
              SizedBox(height: 50),
              Consumer<AuthProvider>(
                builder: (context, auth, child) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 50,

                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        overlayColor: Colors.blueAccent,
                      ),
                      onPressed: auth.isLoading
                          ? null
                          : () {
                              auth.signIn();
                            },
                      child: auth.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/Google_logo.webp',
                                  height: 20,
                                  width: 20,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(width: 10),
                                const Text(
                                  "Log in with Google",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                    ),
                  );
                },
              ),

              SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 72, 78, 239),
                    overlayColor: Colors.blueAccent,
                    //surfaceTintColor: Colors.blueAccent,
                    side: BorderSide(
                      color: const Color.fromARGB(255, 5, 13, 246),
                    ),
                    // disabledForegroundColor: Colors.blueAccent,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/SignUp');
                  },
                  child: Text("sign up", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
