import 'package:emotcare_apps/app/themes/colors.dart';
import 'package:flutter/material.dart';

class MenuWidget extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;
  const MenuWidget({
    super.key,
    required this.imagePath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 60,
            width: 60,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: greyColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(imagePath, width: 40, height: 40),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
