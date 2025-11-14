// lib/features/education/presentation/cubit/video_education_state.dart
part of 'video_education_cubit.dart';

@immutable
abstract class VideoEducationState {}

class VideoEducationInitial extends VideoEducationState {}

class VideoEducationLoading extends VideoEducationState {}

class VideoEducationError extends VideoEducationState {
  final String message;
  VideoEducationError(this.message);
}

class VideoEducationLoaded extends VideoEducationState {
  // --- PERBARUI PROPERTI STATE INI ---
  final VideoEducation selectedVideo;
  final List<VideoEducation> recommendedVideos;
  final List<VideoEducation> otherVideos;
  // ----------------------------------

  VideoEducationLoaded({
    required this.selectedVideo,
    required this.recommendedVideos,
    required this.otherVideos,
  });

  // --- TAMBAHKAN FUNGSI copyWith ---
  // (Penting untuk memperbarui state)
  VideoEducationLoaded copyWith({
    VideoEducation? selectedVideo,
    List<VideoEducation>? recommendedVideos,
    List<VideoEducation>? otherVideos,
  }) {
    return VideoEducationLoaded(
      selectedVideo: selectedVideo ?? this.selectedVideo,
      recommendedVideos: recommendedVideos ?? this.recommendedVideos,
      otherVideos: otherVideos ?? this.otherVideos,
    );
  }
  // ---------------------------------
}