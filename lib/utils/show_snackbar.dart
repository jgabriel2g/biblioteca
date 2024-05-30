import 'package:biblioteca_cuc/utils/colors.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: const Duration(seconds: 1),
    backgroundColor: AppColors.blueColor,
    content: Text(
      content,
      style: const TextStyle(color: Colors.white, fontFamily: "MonB"),
    ),
  ));
}
