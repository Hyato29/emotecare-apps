import 'package:emotcare_apps/features/video_education/domain/entities/video_education.dart';

class VideoEducationModel extends VideoEducation {
  const VideoEducationModel({
    required super.id,
    required super.title,
    required super.description,
    required super.youtubeVideoId,
    required super.thumbnailUrl,
    required super.embedUrl,
    required super.status, // <-- Tambahkan 'status' ke super
  });

  factory VideoEducationModel.fromJson(Map<String, dynamic> json) {
    return VideoEducationModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      youtubeVideoId: json['youtube_video_id'] ?? '',
      thumbnailUrl: json['thumbnail_url'] ?? '',
      embedUrl: json['embed_url'] ?? '',
      // API tidak mengirim status, jadi kita atur default "Baru"
      status: json['status'] ?? "Baru",
    );
  }
}
