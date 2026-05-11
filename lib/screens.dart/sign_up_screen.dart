import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
                'creat new account',
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
            ],
          ),
        ),
      ),
    );
  }
}
