import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:art_marketplace/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_dropdownbuttom.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final List<String> monthsList = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  final List<String> locationsList = [
    'Amman',
    'Cairo',
    'syria',
    'palestine',
    'spain',
    'New York',
    'Los Angeles',
    'Chicago',
    'Houston',
    'Phoenix',
    'Philadelphia',
    'San Antonio',
    'San Diego',
    'Dallas',
    'San Jose',
  ];
  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final auth = context.watch<AuthProvider>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(44.0), // الارتفاع القياسي لآيفون
        child: CupertinoNavigationBar(
          middle: Text(
            "Sign Up",
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
            // width: MediaQuery.of(context).size.width * 0.8,
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(height: 30),
              const Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  "Get started on paintpay",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),

              SizedBox(height: 20),
              const Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  "Email",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),

              // FontWeight.w400
              SizedBox(height: 10),
              CustomTextFeild(
                hint: "Email",
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),
              const Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  "Password",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),

              SizedBox(height: 10),
              CustomTextFeild(
                hint: "Password",
                controller: _passwordController,
                ispassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              const Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  "Birthday",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),

              SizedBox(height: 10),

              ///back
              Consumer<AuthProvider>(
                builder: (context, auth, child) {
                  return Row(
                    // mainAxisAlignment: MainAxisAlignment.,
                    children: [
                      // Month Dropdown
                      Expanded(
                        child: CustomDropdownbuttom(
                          hint: 'month',
                          list: monthsList,
                          onChanged: (val) {
                            context.read<AuthProvider>().updateMonth(val);
                          },
                        ),
                      ),

                      SizedBox(width: 10),
                      //day Dropdown
                      Expanded(
                        child: CustomDropdownbuttom(
                          hint: "day",
                          list: List.generate(31, (index) => index + 1),
                          onChanged: (val) {
                            context.read<AuthProvider>().updateDay(val);
                          },
                        ),
                      ),

                      SizedBox(width: 10),
                      // Year Dropdown
                      Expanded(
                        child: CustomDropdownbuttom(
                          hint: 'year',
                          list: List.generate(
                            100,
                            (index) => DateTime.now().year - index,
                          ),
                          onChanged: (val) {
                            context.read<AuthProvider>().updateYear(val);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 20),
              const Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  "Username",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),

              SizedBox(height: 10),
              CustomTextFeild(
                hint: "Username",
                controller: _usernameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Username is required';
                  }
                  if (value.length < 4) {
                    return "Username is too short";
                  }
                  if (value.length > 20) {
                    return "Username is too long";
                  }
                  if (!RegExp(r'^[a-zA-Z0-9_\.]+$').hasMatch(value)) {
                    return "Only letters, numbersو, . , and _ allowed";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              const Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  "location",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              SizedBox(height: 10),
              Consumer<AuthProvider>(
                builder: (context, auth, child) {
                  //location dropdown
                  return Expanded(
                    child: CustomDropdownbuttom(
                      hint: "location",
                      list: locationsList,
                      onChanged: (val) {
                        context.read<AuthProvider>().updateLocation(val);
                      },
                    ),
                  );
                },
              ),
              // SizedBox(height: 20),
              Consumer<AuthProvider>(
                builder: (context, auth, child) {
                  return CustomButton(
                    text: "sign up",
                    isLoading: auth.isLoading,
                    onPressed: auth.isLoading
                        ? null
                        : () async {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            try {
                              bool success = await context
                                  .read<AuthProvider>()
                                  .signUp(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text,
                                    username: _usernameController.text,
                                  );
                              if (success && mounted) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/',
                                  (route) => false,
                                );
                              }
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
            ],
          ),
        ),
      ),
    );
  }
}
