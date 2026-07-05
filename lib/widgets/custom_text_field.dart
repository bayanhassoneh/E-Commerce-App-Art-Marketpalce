import 'package:flutter/material.dart';

class CustomTextFeild extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool ispassword;
  final String? Function(String?)? validator;
  const CustomTextFeild({
    super.key,
    required this.hint,
    required this.controller,
    this.ispassword = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: ispassword,
      validator: validator,
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: const Color.fromARGB(255, 5, 13, 246)),
          // borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
