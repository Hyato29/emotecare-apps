// lib/features/education/presentation/cubit/video_education_state.dart
part of 'video_education_cubit.dart';

@immutable
abstract class VideoEducationState {}

class VideoEducationInitial extends VideoEducationState {}

class VideoEducationLoading extends VideoEducationState {}

// --- PERBAIKI STATE INI ---
class VideoEducationLoaded extends VideoEducationState {
  final VideoEducation selectedVideo; // Video yang sedang diputar
  final List<VideoEducation> otherVideos; // Daftar di bawah

  VideoEducationLoaded({
    required this.selectedVideo,
    required this.otherVideos,
  });
}
// -------------------------

class VideoEducationError extends VideoEducationState {
  final String message;
  VideoEducationError(this.message);
}
