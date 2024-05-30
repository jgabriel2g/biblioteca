import 'package:flutter/material.dart';

class InputDecorationWidget extends StatelessWidget {
  final TextInputType keyboardType;
  final bool obscureText;
  final int? maxLines;
  final bool readOnly;
  final String hintText;
  final String labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final TextEditingController? controller;

  const InputDecorationWidget(
      {super.key,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.maxLines,
      this.readOnly = false,
      required this.hintText,
      required this.labelText,
      this.prefixIcon,
      this.suffixIcon,
      this.validator,
      this.onTap,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      readOnly: readOnly,
      validator: validator,
      controller: controller,
      onTap: onTap,
      style: const TextStyle(
          color: Color.fromARGB(255, 11, 73, 105), fontFamily: "MonM"),
      decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          errorStyle: const TextStyle(color: Colors.red, fontFamily: "MonM"),
          hintStyle: const TextStyle(
              color: Color.fromARGB(154, 11, 74, 105), fontFamily: "MonM"),
          labelStyle: const TextStyle(
              color: Color.fromARGB(255, 11, 73, 105), fontFamily: "MonM"),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(
                  color: Color.fromARGB(255, 11, 73, 105), width: 2)),
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(
                  color: Color.fromARGB(255, 11, 73, 105), width: 2)),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(
                  color: Color.fromARGB(255, 11, 73, 105), width: 2)),
          errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(
                  color: Color.fromARGB(255, 11, 73, 105), width: 2)),
          focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(
                  color: Color.fromARGB(255, 11, 73, 105), width: 2))),
    );
  }
}
