//import 'dart:math';
//import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:art_marketplace/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
    print("SIGN IN SCREEN BUILD");
    //final auth = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //do not resize the screen when the keyboard appears
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
        padding: const EdgeInsets.all(35.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(height: 100),
              Align(
                alignment: AlignmentDirectional.topCenter,
                child: ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      colors: <Color>[
                        Color.fromARGB(255, 2, 2, 255), // الأزرق القوي
                        Color.fromARGB(255, 179, 132, 233), // البنفسجي
                      ],
                      begin: Alignment.centerLeft, // بيبدأ الأزرق من اليسار
                      end: Alignment.centerRight, // بينتهي البنفسجي على اليمين
                    ).createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    );
                    // السطر اللي فوق بضمن إنه الـ 0 و 0 هي أول النص، والجرادينت بيمشي على قد عرض النص بالظبط
                  },
                  child: const Text(
                    'log into PaintPay',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors
                          .white, // ضروري يكون أبيض عشان الشيدر يطبع الألوان عليه صح
                    ),
                  ),
                ),
                // Text(
                //   'log into PaintPay',
                //   style: TextStyle(
                //     foreground: Paint()
                //       ..shader = LinearGradient(
                //         colors: <Color>[
                //           const Color.fromARGB(255, 2, 2, 255),
                //           const Color.fromARGB(255, 179, 132, 233),
                //         ],
                //       ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                //     fontWeight: FontWeight.bold,
                //     fontSize: 20,
                //   ),
                // ),
              ),
              const SizedBox(height: 20),
              CustomTextFeild(
                hint: "Email",
                controller: _emailcontroller,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              CustomTextFeild(
                hint: "Password",
                controller: _passwordcontroller,
                ispassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              Consumer<AuthProvider>(
                builder: (context, auth, child) {
                  return CustomButton(
                    text: "log in",
                    isLoading: auth.isLoading,
                    onPressed: auth.isLoading
                        ? null
                        : () async {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            try {
                              await auth.signIn(
                                _emailcontroller.text.trim(),
                                _passwordcontroller.text,
                              );
                            } on Exception catch (e) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          },
                  );
                },
              ),
              const SizedBox(height: 10),

              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                  overlayColor: const Color.fromARGB(255, 214, 213, 213),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/forgetPassword');
                },
                child: Text("forgot password?"),
              ),

              const SizedBox(height: 50),
              Consumer<AuthProvider>(
                builder: (context, auth, child) {
                  return SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        overlayColor: Colors.blueAccent,
                      ),
                      onPressed: auth.isLoading
                          ? null
                          : () {
                              auth.googleSignIn();
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
                                const SizedBox(width: 10),
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
