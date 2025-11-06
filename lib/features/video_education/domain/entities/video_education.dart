// lib/features/education/domain/entities/video_education.dart
import 'package:equatable/equatable.dart';

class VideoEducation extends Equatable {
  final int id;
  final String title;
  final String description;
  final String youtubeVideoId;
  final String thumbnailUrl;
  final String embedUrl;
  // --- GANTI INI ---
  // final String status;
  // --- MENJADI INI ---
  final bool isWatched;

  const VideoEducation({
    required this.id,
    required this.title,
    required this.description,
    required this.youtubeVideoId,
    required this.thumbnailUrl,
    required this.embedUrl,
    // --- UBAH INI ---
    // this.status = "Baru",
    // --- MENJADI INI ---
    this.isWatched = false,
  });

  // --- 3. PERBAIKI FUNGSI copyWith ---
  VideoEducation copyWith({
    int? id,
    String? title,
    String? description,
    String? youtubeVideoId,
    String? thumbnailUrl,
    String? embedUrl,
    bool? isWatched, // <-- Ubah ke bool
  }) {
    return VideoEducation(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      youtubeVideoId: youtubeVideoId ?? this.youtubeVideoId,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      embedUrl: embedUrl ?? this.embedUrl,
      isWatched: isWatched ?? this.isWatched, // <-- Terapkan bool
    );
  }
  // ---------------------------------

  @override
  // --- TAMBAHKAN isWatched KE props ---
  List<Object?> get props => [
    id,
    title,
    youtubeVideoId,
    thumbnailUrl,
    isWatched,
  ];
}
