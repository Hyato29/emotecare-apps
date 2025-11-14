// lib/features/schedule_control/presentation/pages/schedule_control_page.dart

import 'package:emotcare_apps/app/themes/colors.dart';
import 'package:emotcare_apps/app/themes/fontweight.dart';
import 'package:emotcare_apps/features/schedule_control/domain/entities/schedule.dart';
import 'package:emotcare_apps/features/schedule_control/presentation/cubit/schedule_control_cubit.dart';
import 'package:emotcare_apps/features/schedule_control/presentation/widgets/schedule_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ScheduleControlPage extends StatefulWidget {
  const ScheduleControlPage({super.key});

  @override
  State<ScheduleControlPage> createState() => _ScheduleControlPageState();
}

class _ScheduleControlPageState extends State<ScheduleControlPage> {
  // 0 = Kontrol, 1 = Riwayat
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScheduleControlCubit>().fetchSchedules();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Jadwal Kontrol",
          style: TextStyle(color: Colors.black, fontWeight: bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ScheduleControlCubit>().fetchSchedules();
        },
        child: BlocBuilder<ScheduleControlCubit, ScheduleControlState>(
          builder: (context, state) {
            if (state is ScheduleControlLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ScheduleControlError) {
              return Center(child: Text(state.message));
            }
            if (state is ScheduleControlLoaded) {
              // Cek apakah KEDUA list kosong
              if (state.upcomingSchedules.isEmpty &&
                  state.pastSchedules.isEmpty) {
                return _buildEmptyState();
              }
              // Jika ada data, tampilkan UI tab
              return _buildDataState(state);
            }
            return const SizedBox.shrink(); // State Initial
          },
        ),
      ),
    );
  }

  // --- WIDGET UNTUK TAMPILAN KOSONG ---
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/schedule_control.jpg', // Ganti dengan path gambar Anda
            height: 150,
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada kunjungan saat ini',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: medium,
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET UNTUK TAMPILAN JIKA ADA DATA ---
  Widget _buildDataState(ScheduleControlLoaded state) {
    // Tentukan list mana yang akan ditampilkan
    final listToShow = _selectedTabIndex == 0
        ? state.upcomingSchedules
        : state.pastSchedules;

    return Column(
      children: [
        _buildTabBar(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            child: _buildScheduleList(listToShow),
          ),
        ),
      ],
    );
  }

  // --- WIDGET UNTUK TAB BAR ("Kontrol" / "Riwayat") ---
  Widget _buildTabBar() {
    return Container(
      color: Colors.grey[100], // Latar belakang tab
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
      child: Row(
        children: [
          _buildTabItem(context, 'Kontrol', 0),
          const SizedBox(width: 16),
          _buildTabItem(context, 'Riwayat', 1),
        ],
      ),
    );
  }

  Widget _buildTabItem(BuildContext context, String title, int index) {
    final bool isActive = _selectedTabIndex == index;
    return Expanded(
      child: ElevatedButton(
        onPressed: () => setState(() => _selectedTabIndex = index),
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive ? primaryColor : Colors.white,
          foregroundColor: isActive ? Colors.white : Colors.grey[600],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
          elevation: isActive ? 2 : 0,
        ),
        child: Text(title, style: TextStyle(fontWeight: bold)),
      ),
    );
  }

  // --- WIDGET UNTUK DAFTAR JADWAL (Menerima list) ---
  Widget _buildScheduleList(List<Schedule> schedules) {
    if (schedules.isEmpty) {
      return Center(
        child: Text(
          _selectedTabIndex == 0
              ? 'Tidak ada jadwal kontrol.'
              : 'Tidak ada riwayat kontrol.',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return ListView.builder(
      itemCount: schedules.length,
      itemBuilder: (context, index) {
        final schedule = schedules[index];
        return ScheduleItemWidget(
          date: schedule.scheduleDate, // Sesuaikan dengan data Anda
          location: schedule.location,
          time: schedule.scheduleTime,
        );
      },
    );
  }
}
