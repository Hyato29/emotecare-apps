// lib/features/video_education/data/models/video_education_model.dart

import 'package:emotcare_apps/features/video_education/domain/entities/video_education.dart';

// (Kelas VideoEducationModel Anda seharusnya sudah benar)
class VideoEducationModel extends VideoEducation {
  const VideoEducationModel({
    required super.id,
    required super.title,
    required super.description,
    required super.youtubeVideoId,
    required super.thumbnailUrl,
    required super.embedUrl,
    required super.isWatched,
  });

  factory VideoEducationModel.fromJson(Map<String, dynamic> json) {
    return VideoEducationModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      youtubeVideoId: json['youtube_video_id'] ?? '',
      thumbnailUrl: json['thumbnail_url'] ?? '',
      embedUrl: json['embed_url'] ?? '',
      isWatched: (json['watched_by_users_count'] ?? 0) > 0,
    );
  }
}

// --- PERBAIKI KELAS INI ---
class VideoEducationListsModel extends VideoEducationLists {
  
  // 1. Constructor ini memanggil 'super' (yang mengharapkan List<VideoEducation>)
  const VideoEducationListsModel({
    required super.recommendedVideos,
    required super.otherVideos,
  });

  // 2. Factory ini yang melakukan konversi
  factory VideoEducationListsModel.fromJson(Map<String, dynamic> json) {
    
    // Helper ini membuat List<VideoEducationModel>
    List<VideoEducationModel> parseList(dynamic list) {
      if (list is! List) return [];
      return list
          .map((item) => VideoEducationModel.fromJson(item))
          .toList();
    }

    // Panggil constructor VideoEducationListsModel
    return VideoEducationListsModel(
      // 3. Konversi List<Model> menjadi List<Entity> menggunakan List.from()
      //    (Ini adalah bagian yang sering terlewat)
      recommendedVideos: List<VideoEducation>.from(parseList(json['recommended_videos'])),
      otherVideos: List<VideoEducation>.from(parseList(json['other_videos'])),
    );
  }
}