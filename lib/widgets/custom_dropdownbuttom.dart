import 'package:flutter/material.dart';

class CustomDropdownbuttom<T> extends StatelessWidget {
  final String hint;
  final ValueChanged<T?> onChanged;
  final List<T> list;

  const CustomDropdownbuttom({
    super.key,
    required this.hint,
    required this.list,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      isExpanded: true,

      decoration: InputDecoration(
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: const Color.fromARGB(255, 85, 39, 158)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      ),
      hint: Text(hint, style: TextStyle(color: Colors.grey)),
      items: list
          .map(
            (val) =>
                DropdownMenuItem<T>(value: val, child: Text(val.toString())),
          )
          .toList(),
      onChanged: (val) {
        onChanged(val);
      },
    );
  }
}
