import 'package:emotcare_apps/app/themes/colors.dart';
import 'package:emotcare_apps/app/themes/fontweight.dart';
import 'package:flutter/material.dart';

class HistoryScheduleItemWidget extends StatelessWidget {
  final String date;
  final String time;

  const HistoryScheduleItemWidget({
    super.key,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          const Icon(Icons.check_box, color: Colors.green, size: 30),
          const SizedBox(width: 8),
          Icon(Icons.date_range, color: purpleColor, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              date,
              style: TextStyle(fontSize: 14, fontWeight: semiBold),
            ),
          ),
          const SizedBox(width: 16),
          Icon(Icons.access_time_filled_rounded, color: purpleColor, size: 24),
          const SizedBox(width: 4),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: medium,
            ),
          ),
        ],
      ),
    );
  }
}
