import 'package:emotcare_apps/app/themes/colors.dart';
import 'package:emotcare_apps/app/ui/alert_dialog.dart';
import 'package:emotcare_apps/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:emotcare_apps/features/home/presentation/widgets/menu_widget.dart';
import 'package:emotcare_apps/app/ui/profile_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PatientHomePage extends StatelessWidget {
  PatientHomePage({super.key});

  final List<Map<String, String>> menuItems = [
    {
      'image': 'assets/images/Group30.jpg',
      'label': 'Daftar Obat',
      'routeName': 'medicine',
    },
    {
      'image': 'assets/images/Group31.jpg',
      'label': 'Edukasi & Motivasi',
      'routeName': 'education',
    },
    {
      'image': 'assets/images/Group32.jpg',
      'label': 'Jadwal Kontrol',
      'routeName': 'schedule_control',
    },
    {
      'image': 'assets/images/Group33.jpg',
      'label': 'Rekap Minum Obat',
      'routeName': 'comming_soon',
    },
    {
      'image': 'assets/images/Group34.jpg',
      'label': 'Lapor Efek Samping',
      'routeName': 'report_side_effect',
    },
    {
      'image': 'assets/images/Group35.jpg',
      'label': 'Lapor Keluhan Penyakit',
      'routeName': 'report_complaint',
    },
    {
      'image': 'assets/images/Group36.jpg',
      'label': 'Konseling Tenaga Kesehatan',
      'routeName': 'comming_soon',
    },
  ];

  void _showLogoutDialog(BuildContext context) {
    // Panggil helper kustom Anda
    showModernDialog(
      context: context,
      icon: Icons.warning_rounded,
      title: 'Konfirmasi Logout',
      content: 'Apakah Anda yakin ingin keluar dari akun ini?',
      confirmText: 'Keluar',
      confirmColor: const Color.fromARGB(255, 179, 12, 0),
      onConfirm: () {
        // Aksi logout tetap sama
        context.read<AuthCubit>().logout();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/logo.jpg', height: 40),
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, // Sembunyikan tombol kembali
        // --- TAMBAHKAN TOMBOL LOGOUT DI SINI ---
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            tooltip: 'Logout',
            onPressed: () {
              // Panggil fungsi dialog
              _showLogoutDialog(context);
            },
          ),
        ],
        // -------------------------------------
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          child: Column(
            children: [
              ProfileCardWidget(),
              const SizedBox(height: 32),
              Image.asset("assets/images/logo.jpg"),
              const SizedBox(height: 32),
              _buildMenuGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: purpleColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // <-- Tetap 4 kolom sesuai permintaan Anda
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.65,
        ),
        padding: const EdgeInsets.all(16.0),
        itemCount: menuItems.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return MenuWidget(
            imagePath: item['image']!,
            label: item['label']!,
            onTap: () {
              // Menggunakan pushNamed agar user bisa kembali ke halaman home
              context.pushNamed(item['routeName']!);
            },
          );
        },
      ),
    );
  }
}
