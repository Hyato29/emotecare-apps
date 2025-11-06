import 'package:emotcare_apps/app/themes/colors.dart';
import 'package:emotcare_apps/app/themes/fontweight.dart';
import 'package:flutter/material.dart';

class LabelformWidget extends StatelessWidget {
  final String label;
  final Color? color;
  const LabelformWidget({required this.label, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(fontSize: 20, color: color ?? primaryColor, fontWeight: semiBold),
    );
  }
}
