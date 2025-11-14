// lib/features/video_education/domain/entities/video_education.dart

import 'package:equatable/equatable.dart';
// JANGAN import '.../models/video_education_model.dart' DI SINI

// 1. Pastikan kelas ini tidak berubah
class VideoEducation extends Equatable {
  final int id;
  final String title;
  final String description;
  final String youtubeVideoId;
  final String thumbnailUrl;
  final String embedUrl;
  final bool isWatched;

  const VideoEducation({
    required this.id,
    required this.title,
    required this.description,
    required this.youtubeVideoId,
    required this.thumbnailUrl,
    required this.embedUrl,
    this.isWatched = false,
  });

  // Pastikan constructor 'empty' ini ada
  const VideoEducation.empty()
      : this(
          id: 0,
          title: '',
          description: '',
          youtubeVideoId: '',
          thumbnailUrl: '',
          embedUrl: '',
          isWatched: false,
        );

  VideoEducation copyWith({
    int? id,
    String? title,
    String? description,
    String? youtubeVideoId,
    String? thumbnailUrl,
    String? embedUrl,
    bool? isWatched,
  }) {
    return VideoEducation(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      youtubeVideoId: youtubeVideoId ?? this.youtubeVideoId,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      embedUrl: embedUrl ?? this.embedUrl,
      isWatched: isWatched ?? this.isWatched,
    );
  }

  @override
  List<Object?> get props =>
      [id, title, youtubeVideoId, thumbnailUrl, isWatched];
}

// 2. --- PERIKSA KELAS INI ---
// Ini adalah kemungkinan besar sumber error Anda.
class VideoEducationLists extends Equatable {
  
  // PASTIKAN TIPE DATA DI SINI ADALAH 'VideoEducation' (ENTITY)
  final List<VideoEducation> recommendedVideos;
  final List<VideoEducation> otherVideos;

  // JANGAN GUNAKAN 'VideoEducationModel' DI SINI
  // final List<VideoEducationModel> recommendedVideos; // <-- SALAH
  // final List<VideoEducationModel> otherVideos; // <-- SALAH

  const VideoEducationLists({
    required this.recommendedVideos,
    required this.otherVideos,
  });

  @override
  List<Object?> get props => [recommendedVideos, otherVideos];
}