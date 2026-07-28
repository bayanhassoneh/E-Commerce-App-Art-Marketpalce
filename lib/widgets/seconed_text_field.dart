import 'package:flutter/material.dart';

class SeconedTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  const SeconedTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: TextStyle(color: const Color.fromARGB(255, 102, 90, 112)),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 172, 181, 208),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 101, 101, 102),
          ),
          // borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
