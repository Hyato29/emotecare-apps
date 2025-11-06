import 'package:emotcare_apps/app/ui/appbar_widget.dart';
import 'package:emotcare_apps/app/themes/colors.dart';
import 'package:emotcare_apps/app/themes/fontweight.dart';
import 'package:emotcare_apps/app/ui/profile_card_widget.dart';

import 'package:emotcare_apps/features/schedule_control/presentation/widgets/history_schedule_item_widget.dart';
import 'package:emotcare_apps/features/schedule_control/presentation/widgets/remaining_schedule_item_widget.dart';
import 'package:flutter/material.dart';

class ScheduleControlPage extends StatefulWidget {
  const ScheduleControlPage({super.key});

  @override
  State<ScheduleControlPage> createState() => _ScheduleControlPageState();
}

class _ScheduleControlPageState extends State<ScheduleControlPage> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          child: Column(
            children: [
              ProfileCardWidget(),
              const SizedBox(height: 16),

              Text(
                'Anda telah menyelesaikan 5 kali kunjungan dari 8 rencana kontrol perawatan!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: primaryColor,
                  fontWeight: semiBold,
                ),
              ),
              const SizedBox(height: 16),

              Image.asset('assets/images/schedule_control.jpg', height: 150),
              const SizedBox(height: 16),

              Text(
                'Kunjungan Selanjutnya',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: medium,
                ),
              ),
              const SizedBox(height: 8),

              _buildNextScheduleCard(),
              const SizedBox(height: 24),

              _buildTabBar(),
              const SizedBox(height: 16),

              _buildContentList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextScheduleCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        'SENIN, 6 OKTOBER 2025',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: bold),
      ),
    );
  }

  Widget _buildTabBar() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => setState(() => _selectedTabIndex = 0),
            style: ElevatedButton.styleFrom(
              backgroundColor: _selectedTabIndex == 0
                  ? primaryColor
                  : Colors.grey[200],
              foregroundColor: _selectedTabIndex == 0
                  ? Colors.white
                  : Colors.grey[600],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text('Sisa Kontrol', style: TextStyle(fontWeight: bold)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: () => setState(() => _selectedTabIndex = 1),
            style: ElevatedButton.styleFrom(
              backgroundColor: _selectedTabIndex == 1
                  ? primaryColor
                  : Colors.grey[200],
              foregroundColor: _selectedTabIndex == 1
                  ? Colors.white
                  : Colors.grey[600],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text('Riwayat Kontrol', style: TextStyle(fontWeight: bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildContentList() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          if (_selectedTabIndex == 0) ...[
            RemainingScheduleItemWidget(
              indexNumber: 1,
              date: 'Senin, 6 Oktober 2025',
              time: '10:10 WIB',
            ),
            _buildDivider(),
            RemainingScheduleItemWidget(
              indexNumber: 2,
              date: 'Senin, 3 November 2025',
              time: '10:10 WIB',
            ),
            _buildDivider(),
            RemainingScheduleItemWidget(
              indexNumber: 3,
              date: 'Senin, 1 Desember 2025',
              time: '10:10 WIB',
            ),
          ] else ...[
            HistoryScheduleItemWidget(
              date: '07 September 2025',
              time: '10:10 WIB',
            ),
            _buildDivider(),
            HistoryScheduleItemWidget(
              date: '09 Agustus 2025',
              time: '15:00 WIB',
            ),
            _buildDivider(),
            HistoryScheduleItemWidget(date: '10 Juli 2025', time: '12:00 WIB'),
          ],
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, color: Colors.grey[300]);
  }
}
