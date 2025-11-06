import 'package:emotcare_apps/features/video_education/domain/entities/video_education.dart';

class VideoEducationModel extends VideoEducation {
  const VideoEducationModel({
    required super.id,
    required super.title,
    required super.description,
    required super.youtubeVideoId,
    required super.thumbnailUrl,
    required super.embedUrl,
    required super.isWatched, // <-- Ubah 'status' menjadi 'isWatched'
  });

  factory VideoEducationModel.fromJson(Map<String, dynamic> json) {
    return VideoEducationModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      youtubeVideoId: json['youtube_video_id'] ?? '',
      thumbnailUrl: json['thumbnail_url'] ?? '',
      embedUrl: json['embed_url'] ?? '',
      // --- PERBAIKAN UTAMA ---
      // API mengirim 'watched_by_users_count' (bernilai 0 atau 1)
      // Kita ubah ini menjadi boolean
      isWatched: (json['watched_by_users_count'] ?? 0) > 0,
      // -----------------------
    );
  }
}
