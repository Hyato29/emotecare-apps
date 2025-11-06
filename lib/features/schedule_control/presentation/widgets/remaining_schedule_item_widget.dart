import 'package:emotcare_apps/app/themes/colors.dart';
import 'package:emotcare_apps/app/themes/fontweight.dart';
import 'package:flutter/material.dart';

class RemainingScheduleItemWidget extends StatelessWidget {
  final int indexNumber;
  final String date;
  final String time;

  const RemainingScheduleItemWidget({
    super.key,
    required this.indexNumber,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                indexNumber.toString(),
                style: TextStyle(color: Colors.white, fontWeight: bold),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.notifications_rounded, color: Colors.yellow, size: 24),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.date_range,
                    color: Colors.grey[600],
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    date,
                    style: TextStyle(fontSize: 14, fontWeight: semiBold),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.access_time_filled_rounded,
                    color: Colors.grey[600],
                    size: 16,
                  ),
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
            ],
          ),
        ],
      ),
    );
  }
}
