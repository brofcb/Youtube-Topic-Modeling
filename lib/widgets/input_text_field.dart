import 'package:flutter/material.dart';

class InputTextField extends StatelessWidget {
  const InputTextField(
      {required this.hintText,
      required this.onChanged,
      this.obscureText,
      this.keyboardType,
      this.labelText,
      this.errorText,
      this.onClear,
      this.controller});
  final String hintText;
  final ValueChanged<String>? onChanged;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final String? labelText;
  final String? errorText;
  final VoidCallback? onClear;
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      obscureText: false,
      onChanged: onChanged,
      controller: controller,
      style: const TextStyle(
        color: Colors.black,
      ),
      decoration: InputDecoration(
        focusColor: Colors.red,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        labelText: labelText,
        errorText: errorText,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
          borderRadius: BorderRadius.circular(15.0),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
      ),
    );
  }
}
