// lib/features/education/presentation/cubit/video_education_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:emotcare_apps/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:emotcare_apps/features/video_education/domain/entities/video_education.dart';
import 'package:emotcare_apps/features/video_education/domain/usecases/get_video_educations.dart';
import 'package:flutter/foundation.dart';
// Import YoutubePlayerValue untuk mengecek durasi
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

part 'video_education_state.dart';

class VideoEducationCubit extends Cubit<VideoEducationState> {
  final GetVideoEducations getVideoEducations;
  final AuthCubit authCubit;

  VideoEducationCubit({
    required this.getVideoEducations,
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
        // Pisahkan video pertama dan sisa videonya
        emit(
          VideoEducationLoaded(
            selectedVideo: videos.first,
            otherVideos: videos.skip(1).toList(),
          ),
        );
      }
    });
  }

  // Fungsi untuk mengganti video
  void selectVideo(
    VideoEducation newVideo,
    YoutubePlayerValue? oldVideoStatus,
  ) {
    if (state is! VideoEducationLoaded)
      return; // Hanya berjalan jika data sudah dimuat

    final currentState = state as VideoEducationLoaded;
    final currentSelectedVideo = currentState.selectedVideo;
    final currentOtherVideos = currentState.otherVideos;

    // 1. Tentukan status video yang lama (yang baru selesai ditonton)
    String newStatusForOldVideo = currentSelectedVideo.status; // Default
    if (oldVideoStatus != null) {
      final totalDuration = oldVideoStatus.metaData.duration;
      final currentPosition = oldVideoStatus.position;

      // Jika video selesai (atau hampir selesai)
      if (currentPosition >= totalDuration - const Duration(seconds: 2) &&
          totalDuration.inSeconds > 0) {
        newStatusForOldVideo = "Sudah Ditonton";
      }
      // Jika video sudah diputar (lebih dari 0 detik) tapi belum selesai
      else if (currentPosition > Duration.zero) {
        newStatusForOldVideo = "Belum Selesai Ditonton";
      }
      // Jika tidak, status tetap "Baru"
    }

    // 2. Buat salinan video lama dengan status baru
    final updatedOldVideo = currentSelectedVideo.copyWith(
      status: newStatusForOldVideo,
    );

    // 3. Buat daftar "video lainnya" yang baru
    List<VideoEducation> newOtherVideos = [];
    newOtherVideos.addAll(currentOtherVideos);
    // Masukkan video lama ke daftar di posisi paling atas
    newOtherVideos.insert(0, updatedOldVideo);

    // 4. Hapus video yang baru dipilih dari daftar (jika ada)
    newOtherVideos.removeWhere((video) => video.id == newVideo.id);

    // 5. Emit state baru
    emit(
      VideoEducationLoaded(
        selectedVideo: newVideo, // Video baru jadi video utama
        otherVideos: newOtherVideos, // Daftar baru untuk "video lainnya"
      ),
    );
  }
}
