// lib/features/education/domain/entities/video_education.dart
import 'package:equatable/equatable.dart';

class VideoEducation extends Equatable {
  final int id;
  final String title;
  final String description;
  final String youtubeVideoId;
  final String thumbnailUrl;
  final String embedUrl;
  final String status; // <-- 1. TAMBAHKAN STATUS

  const VideoEducation({
    required this.id,
    required this.title,
    required this.description,
    required this.youtubeVideoId,
    required this.thumbnailUrl,
    required this.embedUrl,
    this.status = "Baru", // <-- 2. BERI NILAI DEFAULT
  });

  // --- 3. TAMBAHKAN FUNGSI copyWith ---
  // Ini memungkinkan kita membuat salinan video dengan status baru
  VideoEducation copyWith({
    int? id,
    String? title,
    String? description,
    String? youtubeVideoId,
    String? thumbnailUrl,
    String? embedUrl,
    String? status,
  }) {
    return VideoEducation(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      youtubeVideoId: youtubeVideoId ?? this.youtubeVideoId,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      embedUrl: embedUrl ?? this.embedUrl,
      status: status ?? this.status, // <-- Ini bagian pentingnya
    );
  }
  // ---------------------------------

  @override
  List<Object?> get props => [id, title, youtubeVideoId, thumbnailUrl, status];
}