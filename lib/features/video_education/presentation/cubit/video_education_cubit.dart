// lib/features/education/presentation/cubit/video_education_cubit.dart
// (VERSI FINAL LENGKAP)

import 'package:bloc/bloc.dart';
import 'package:emotcare_apps/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:emotcare_apps/features/video_education/domain/entities/video_education.dart';
import 'package:emotcare_apps/features/video_education/domain/usecases/get_video_educations.dart';
import 'package:flutter/foundation.dart';

import 'package:emotcare_apps/features/video_education/domain/usecases/mark_video_as_watched.dart';
import 'dart:developer' as dev;

part 'video_education_state.dart';

class VideoEducationCubit extends Cubit<VideoEducationState> {
  final GetVideoEducations getVideoEducations;
  final MarkVideoAsWatched markVideoAsWatched;
  final AuthCubit authCubit;

  VideoEducationCubit({
    required this.getVideoEducations,
    required this.markVideoAsWatched,
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
      videoLists,
    ) {
      // <-- Tipe: VideoEducationLists (Entity)

      // 'recommended' dan 'others' adalah List<VideoEducation> (Entity)
      final recommended = videoLists.recommendedVideos;
      final others = videoLists.otherVideos;

      if (recommended.isEmpty && others.isEmpty) {
        emit(VideoEducationError("Tidak ada video edukasi yang tersedia."));
        return;
      }

      // 'videoToPlayFirst' adalah VideoEducation (Entity)
      VideoEducation videoToPlayFirst = const VideoEducation.empty();

      if (recommended.isNotEmpty) {
        // 'recommended' adalah List<VideoEducation>
        videoToPlayFirst = recommended.firstWhere(
          (v) => !v.isWatched,
          // 'recommended.first' juga VideoEducation (Entity)
          // Tipe datanya cocok! (Entity == Entity)
          orElse: () => recommended.first,
        );
      }

      if (videoToPlayFirst.id == 0 && others.isNotEmpty) {
        // 'others' adalah List<VideoEducation>
        videoToPlayFirst = others.firstWhere(
          (v) => !v.isWatched,
          // 'others.first' juga VideoEducation (Entity)
          // Tipe datanya cocok! (Entity == Entity)
          orElse: () => others.first,
        );
      }

      emit(
        VideoEducationLoaded(
          selectedVideo: videoToPlayFirst,
          recommendedVideos: recommended,
          otherVideos: others,
        ),
      );
    });
  }

  // --- Fungsi selectVideo (JAUH LEBIH SEDERHANA) ---
  void selectVideo(VideoEducation newVideo) {
    if (state is! VideoEducationLoaded) {
      return;
    }
    final currentState = state as VideoEducationLoaded;

    // --- HAPUS BARIS DI BAWAH INI ---
    // if (newVideo.id == currentState.selectedVideo.id) return;
    // ---------------------------------

    // Cukup ganti 'selectedVideo'
    // Memancarkan state baru (walaupun datanya mirip)
    // akan memicu BlocListener di UI
    emit(currentState.copyWith(selectedVideo: newVideo));
  }
  // ---------------------------------------------

  // --- Fungsi onVideoEnded (SUDAH BENAR) ---
  Future<void> onVideoEnded(VideoEducation video) async {
    if (state is! VideoEducationLoaded) return;
    final currentState = state as VideoEducationLoaded;

    if (video.isWatched) {
      dev.log(
        'Cubit: Video ${video.id} sudah ditonton.',
        name: 'EducationDebug',
      );
      return;
    }

    final authState = authCubit.state;
    if (authState is! Authenticated) {
      dev.log(
        'Cubit: Batal markAsWatched, user tidak login.',
        name: 'EducationDebug',
      );
      return;
    }

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
        dev.log(
          'Cubit: Gagal markAsWatched: ${failure.message}',
          name: 'EducationDebug',
        );
      },
      (success) {
        dev.log(
          'Cubit: Sukses markAsWatched. Memperbarui UI...',
          name: 'EducationDebug',
        );

        VideoEducation updateVideoStatus(VideoEducation v) {
          return v.id == video.id ? v.copyWith(isWatched: true) : v;
        }

        // Perbarui video di SEMUA tempat
        final updatedSelectedVideo = updateVideoStatus(
          currentState.selectedVideo,
        );
        final updatedRecommended = currentState.recommendedVideos
            .map(updateVideoStatus)
            .toList();
        final updatedOthers = currentState.otherVideos
            .map(updateVideoStatus)
            .toList();

        // Emit state baru
        emit(
          VideoEducationLoaded(
            selectedVideo: updatedSelectedVideo,
            recommendedVideos: updatedRecommended,
            otherVideos: updatedOthers,
          ),
        );
      },
    );
  }
}
