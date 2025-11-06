import 'package:emotcare_apps/app/themes/colors.dart';
import 'package:flutter/material.dart';

class PassformWidget extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  const PassformWidget({
    required this.label,
    required this.controller,
    super.key,
  });

  @override
  State<PassformWidget> createState() => _PassformWidgetState();
}

class _PassformWidgetState extends State<PassformWidget> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      textAlign: TextAlign.center,
      obscureText: _obscureText,
      style: TextStyle(color: primaryColor),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: primaryColor),
        ),
        hintText: widget.label,
        hintStyle: TextStyle(color: greyColor),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          icon: _obscureText
              ? Icon(Icons.visibility_off_outlined)
              : Icon(Icons.visibility_outlined),
          color: primaryColor,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      ),
    );
  }
}
