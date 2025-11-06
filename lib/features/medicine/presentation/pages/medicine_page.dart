// lib/features/medicine/presentation/pages/medicine_page.dart

import 'package:emotcare_apps/app/themes/colors.dart';
import 'package:emotcare_apps/app/themes/fontweight.dart';
import 'package:emotcare_apps/features/medicine/domain/entities/prescription.dart';
import 'package:emotcare_apps/features/medicine/presentation/cubit/prescription/prescription_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dotted_border/dotted_border.dart'; // <-- Import package baru

class MedicinePage extends StatefulWidget {
  // Hapus 'const' agar bisa menggunakan data non-final
  MedicinePage({super.key});

  // Dummy data untuk Video Edukasi
  final List<Map<String, String>> videoItems = [
    {
      "image": "assets/images/logo.jpg", // Ganti dengan path Anda
      "title": "Tips Mengatasi Bosan Minum Obat",
      "tag": "Baru",
    },
    {
      "image": "assets/images/logo.jpg", // Ganti dengan path Anda
      "title": "Tips Mengatasi Bosan Minum Obat",
      "tag": "Sudah Ditonton",
    },
    {
      "image": "assets/images/logo.jpg", // Ganti dengan path Anda
      "title": "Tips Mengatasi Bosan Minum Obat",
      "tag": "Baru",
    },
  ];

  @override
  State<MedicinePage> createState() => _MedicinePageState();
}

class _MedicinePageState extends State<MedicinePage> {
  @override
  void initState() {
    super.initState();
    // Panggil data saat halaman pertama kali dimuat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PrescriptionListCubit>().fetchPrescriptions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Pengingat Minum Obat", // Judul dari gambar
          style: TextStyle(color: Colors.black, fontWeight: bold, fontSize: 18),
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
          context.read<PrescriptionListCubit>().fetchPrescriptions();
        },
        // Ganti Column menjadi SingleChildScrollView
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Tombol "Buat Pengingat Baru"
              _buildCreateReminderButton(context),
              const SizedBox(height: 24),

              // 2. Judul Riwayat
              Text(
                'Riwayat Pengingat Obat',
                style: TextStyle(fontSize: 18, fontWeight: bold),
              ),
              const SizedBox(height: 16),

              // 3. Daftar Riwayat (dari Cubit)
              _buildHistoryList(),
              const SizedBox(height: 24),

              // 4. Judul Video
              Text(
                'Video Edukasi',
                style: TextStyle(fontSize: 18, fontWeight: bold),
              ),
              const SizedBox(height: 16),

              // 5. Daftar Video (Horizontal)
              _buildVideoEducationList(),
            ],
          ),
        ),
      ),
    );
  }

  /// Tombol "Buat Pengingat Baru" dengan garis putus-putus
  Widget _buildCreateReminderButton(BuildContext context) {
    return InkWell(
      onTap: () {
        // Arahkan ke halaman PENCARIAN obat untuk memulai
        context.pushNamed('medicine_search');
      },
      child: DottedBorder(
        child: Container(
          width: double.infinity,
          height: 80,
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_rounded, color: primaryColor, size: 28),
              const SizedBox(width: 12),
              Text(
                'Buat Pengingat Baru',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 16,
                  fontWeight: semiBold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Daftar "Riwayat Pengingat Obat"
  Widget _buildHistoryList() {
    return BlocBuilder<PrescriptionListCubit, PrescriptionListState>(
      builder: (context, state) {
        if (state is PrescriptionListLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is PrescriptionListError) {
          return Center(child: Text(state.message));
        }
        if (state is PrescriptionListLoaded) {
          if (state.prescriptions.isEmpty) {
            return const Center(child: Text("Belum ada pengingat."));
          }
          // Tampilkan ListView (tanpa scroll, karena sudah di SingleChildScrollView)
          return ListView.builder(
            itemCount: state.prescriptions.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final prescription = state.prescriptions[index];
              return _buildReminderItem(prescription);
            },
          );
        }
        return const SizedBox.shrink(); // State Initial
      },
    );
  }

  /// Widget untuk satu item pengingat (UI dari gambar)
  Widget _buildReminderItem(Prescription prescription) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today_outlined, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // Data tanggal/hari tidak ada di API, jadi kita gunakan "Duration"
                  prescription.duration,
                  style: TextStyle(fontWeight: bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  prescription.medicine.name,
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            // Data waktu tidak ada, kita tampilkan "Frequency"
            prescription.frequency,
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

  /// Daftar "Video Edukasi"
  Widget _buildVideoEducationList() {
    // 1. Hapus Container (tidak perlu height)
    return ListView.builder(
      // 2. Hapus scrollDirection (default-nya vertical)

      // 3. Tambahkan shrinkWrap dan physics agar muat di dalam SingleChildScrollView
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      itemCount: widget.videoItems.length,
      itemBuilder: (context, index) {
        final video = widget.videoItems[index];
        // 4. Panggil _buildVideoCard (yang sudah diperbaiki di bawah)
        return _buildVideoCard(
          image: video['image']!,
          title: video['title']!,
          tag: video['tag']!,
        );
      },
    );
  }

  /// Widget untuk satu kartu video (Sekarang layout Row/Horizontal)
  Widget _buildVideoCard({
    required String image,
    required String title,
    required String tag,
  }) {
    bool isNew = tag == "Baru";
    // Mirip dengan _buildReminderItem, tapi dengan layout berbeda
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          // 1. Gambar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              image,
              width: 80, // Ukuran thumbnail
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),

          // 2. Teks (Mengisi sisa ruang)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: semiBold, // Gunakan semiBold
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // 3. Tag (Baru / Sudah Ditonton)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: (isNew ? Colors.blue[50] : Colors.orange[50]),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      color: (isNew ? Colors.blue[700] : Colors.orange[700]),
                      fontWeight: bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
