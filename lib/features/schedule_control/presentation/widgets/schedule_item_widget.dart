// lib/features/schedule_control/presentation/widgets/schedule_item_widget.dart
import 'package:emotcare_apps/app/themes/colors.dart';
import 'package:emotcare_apps/app/themes/fontweight.dart';
import 'package:flutter/material.dart';

class ScheduleItemWidget extends StatelessWidget {
  final String date;
  final String location;
  final String time;

  const ScheduleItemWidget({
    super.key,
    required this.date,
    required this.location,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(Icons.calendar_today_outlined, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: TextStyle(fontWeight: semiBold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            time,
            style: TextStyle(
              color: primaryColor,
              fontWeight: bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}