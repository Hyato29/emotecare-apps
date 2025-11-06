import 'package:emotcare_apps/app/themes/colors.dart';
import 'package:flutter/material.dart';

class TextformWidget extends StatelessWidget {
  final String label;
  final TextInputType keyboardType;
  final TextEditingController controller;
  const TextformWidget({
    required this.label,
    required this.keyboardType,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.center,
      style: TextStyle(color: primaryColor),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: primaryColor),
        ),
        hintText: label,
        hintStyle: TextStyle(color: greyColor),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      ),
      keyboardType: keyboardType,
    );
  }
}
