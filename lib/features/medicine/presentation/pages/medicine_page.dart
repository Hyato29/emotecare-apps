// lib/features/medicine/presentation/pages/medicine_page.dart

import 'package:emotcare_apps/app/themes/colors.dart';
import 'package:emotcare_apps/app/themes/fontweight.dart';
import 'package:emotcare_apps/features/medicine/domain/entities/prescription.dart';
import 'package:emotcare_apps/features/medicine/presentation/cubit/prescription/prescription_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dotted_border/dotted_border.dart';

// Import baru untuk video
import 'package:emotcare_apps/features/video_education/presentation/cubit/video_education_cubit.dart';
import 'package:emotcare_apps/features/video_education/domain/entities/video_education.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MedicinePage extends StatefulWidget {
  MedicinePage({super.key});

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

      // Panggil data video (sudah benar)
      if (context.read<VideoEducationCubit>().state is VideoEducationInitial) {
        context.read<VideoEducationCubit>().fetchVideos();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Pengingat Minum Obat",
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
          context.read<VideoEducationCubit>().fetchVideos();
        },
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
    return BlocBuilder<VideoEducationCubit, VideoEducationState>(
      builder: (context, state) {
        if (state is VideoEducationLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is VideoEducationError) {
          return Center(child: Text(state.message));
        }
        if (state is VideoEducationLoaded) {
          final allVideos = [state.selectedVideo, ...state.otherVideos];
          final videosToShow = allVideos.take(3).toList();

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: videosToShow.length,
            itemBuilder: (context, index) {
              final video = videosToShow[index];
              // Panggil _buildVideoCard (yang sudah diperbaiki)
              return _buildVideoCard(video: video);
            },
          );
        }
        return const Center(child: Text("Memuat video..."));
      },
    );
  }

  /// Widget untuk satu kartu video (Layout Row/Horizontal)
  Widget _buildVideoCard({
    required VideoEducation video, // Terima entity VideoEducation
  }) {
    // --- PERBAIKAN LOGIKA TAG DI SINI ---
    // Tentukan warna tag berdasarkan status isWatched (boolean)
    bool isWatched = video.isWatched;
    String tagText = isWatched ? "Sudah Ditonton" : "Baru";
    Color tagColor = isWatched ? Colors.orange[700]! : Colors.blue[700]!;
    Color tagBgColor = isWatched ? Colors.orange[50]! : Colors.blue[50]!;
    // ------------------------------------

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: InkWell(
        onTap: () {
          context.pushNamed('education');
        },
        child: Row(
          children: [
            // 1. Gambar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: video.thumbnailUrl, // Gunakan data dari entity
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Container(width: 80, height: 80, color: Colors.grey[200]),
                errorWidget: (context, url, error) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: const Icon(Icons.error),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // 2. Teks (Mengisi sisa ruang)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title, // Gunakan data dari entity
                    style: TextStyle(fontWeight: semiBold, fontSize: 14),
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
                      color: tagBgColor, // Gunakan warna dinamis
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      tagText, // Gunakan teks dinamis
                      style: TextStyle(
                        color: tagColor, // Gunakan warna dinamis
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
      ),
    );
  }
}
