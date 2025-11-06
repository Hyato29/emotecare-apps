// lib/features/education/presentation/cubit/video_education_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:emotcare_apps/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:emotcare_apps/features/video_education/domain/entities/video_education.dart';
import 'package:emotcare_apps/features/video_education/domain/usecases/get_video_educations.dart';
import 'package:flutter/foundation.dart';

// --- IMPORT USE CASE BARU ---
import 'package:emotcare_apps/features/video_education/domain/usecases/mark_video_as_watched.dart';
import 'dart:developer' as dev;
// ----------------------------

part 'video_education_state.dart';

class VideoEducationCubit extends Cubit<VideoEducationState> {
  final GetVideoEducations getVideoEducations;
  // --- TAMBAHKAN USE CASE BARU ---
  final MarkVideoAsWatched markVideoAsWatched;
  // ------------------------------
  final AuthCubit authCubit;

  VideoEducationCubit({
    required this.getVideoEducations,
    required this.markVideoAsWatched, // <-- Tambahkan di constructor
    required this.authCubit,
  }) : super(VideoEducationInitial());

  // Mengambil data dari API
  Future<void> fetchVideos() async {
    final authState = authCubit.state;
    if (authState is! Authenticated) {
      emit(VideoEducationError("Anda harus login untuk melihat data ini."));
      return;
    }

    emit(VideoEducationLoading());
    final result = await getVideoEducations(token: authState.token);

    result.fold((failure) => emit(VideoEducationError(failure.message)), (
      videos,
    ) {
      if (videos.isEmpty) {
        emit(VideoEducationError("Tidak ada video edukasi yang tersedia."));
      } else {
        // --- LOGIKA BARU UNTUK MEMILAH VIDEO ---
        // Pisahkan video yang sudah ditonton dan yang belum
        final watchedVideos = videos.where((v) => v.isWatched).toList();
        final unwatchedVideos = videos.where((v) => !v.isWatched).toList();

        // Prioritaskan video yang belum ditonton sebagai video utama
        if (unwatchedVideos.isNotEmpty) {
          emit(
            VideoEducationLoaded(
              selectedVideo: unwatchedVideos.first,
              // Gabungkan sisanya + video yang sudah ditonton
              otherVideos: [...unwatchedVideos.skip(1), ...watchedVideos],
            ),
          );
        } else {
          // Jika semua sudah ditonton, tampilkan video pertama
          emit(
            VideoEducationLoaded(
              selectedVideo: videos.first,
              otherVideos: videos.skip(1).toList(),
            ),
          );
        }
        // ----------------------------------------
      }
    });
  }

  // --- PERBAIKAN LOGIKA selectVideo ---
  // Fungsi ini sekarang HANYA untuk menukar video di UI
  void selectVideo(VideoEducation newVideo) {
    if (state is! VideoEducationLoaded) {
      return; // Hanya berjalan jika data sudah dimuat
    }

    final currentState = state as VideoEducationLoaded;
    final currentSelectedVideo = currentState.selectedVideo;
    final currentOtherVideos = currentState.otherVideos;

    // 1. Buat daftar "video lainnya" yang baru
    List<VideoEducation> newOtherVideos = [];
    newOtherVideos.addAll(currentOtherVideos);
    // Masukkan video lama ke daftar di posisi paling atas
    newOtherVideos.insert(0, currentSelectedVideo);

    // 2. Hapus video yang baru dipilih dari daftar (jika ada)
    newOtherVideos.removeWhere((video) => video.id == newVideo.id);

    // 3. Emit state baru
    emit(
      VideoEducationLoaded(
        selectedVideo: newVideo, // Video baru jadi video utama
        otherVideos: newOtherVideos, // Daftar baru untuk "video lainnya"
      ),
    );
  }
  // -----------------------------------

  // --- TAMBAHKAN FUNGSI BARU UNTUK MEMANGGIL API ---
  Future<void> onVideoEnded(VideoEducation video) async {
    // 1. Cek state saat ini
    if (state is! VideoEducationLoaded) return;
    final currentState = state as VideoEducationLoaded;

    // 2. Jika video sudah ditandai 'watched' di state, jangan panggil API
    if (video.isWatched) {
      dev.log(
        'Cubit: Video ${video.id} sudah ditonton.',
        name: 'EducationDebug',
      );
      return;
    }

    // 3. Dapatkan token
    final authState = authCubit.state;
    if (authState is! Authenticated) {
      dev.log(
        'Cubit: Batal markAsWatched, user tidak login.',
        name: 'EducationDebug',
      );
      return; // User tidak login
    }

    // 4. Panggil API untuk menandai
    dev.log(
      'Cubit: Menandai video ${video.id} sebagai ditonton...',
      name: 'EducationDebug',
    );
    final result = await markVideoAsWatched(
      token: authState.token,
      videoId: video.id,
    );

    result.fold(
      (failure) {
        // Jika gagal, cukup log (tidak perlu menghentikan user)
        dev.log(
          'Cubit: Gagal markAsWatched: ${failure.message}',
          name: 'EducationDebug',
        );
      },
      (success) {
        // 5. Jika API SUKSES, perbarui state di UI secara manual
        //    (agar UI update tanpa perlu refresh)
        dev.log(
          'Cubit: Sukses markAsWatched. Memperbarui UI...',
          name: 'EducationDebug',
        );

        // Buat salinan video yang dipilih dengan status baru
        final updatedSelectedVideo = currentState.selectedVideo.copyWith(
          isWatched: true,
        );

        // Cari video yang sama di 'otherVideos' dan perbarui juga (jika ada)
        final updatedOtherVideos = currentState.otherVideos.map((v) {
          if (v.id == video.id) {
            return v.copyWith(isWatched: true);
          }
          return v;
        }).toList();

        // Emit state baru dengan data yang sudah diperbarui
        emit(
          VideoEducationLoaded(
            selectedVideo: updatedSelectedVideo,
            otherVideos: updatedOtherVideos,
          ),
        );
      },
    );
  }

  // -----------------------------------------------
}
