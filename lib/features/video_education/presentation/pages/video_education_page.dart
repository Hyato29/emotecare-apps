import 'package:emotcare_apps/app/themes/colors.dart';
import 'package:emotcare_apps/app/themes/fontweight.dart';
import 'package:emotcare_apps/features/video_education/domain/entities/video_education.dart';
import 'package:emotcare_apps/features/video_education/presentation/cubit/video_education_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoEducationPage extends StatefulWidget {
  const VideoEducationPage({super.key});

  @override
  State<VideoEducationPage> createState() => _VideoEducationPageState();
}

class _VideoEducationPageState extends State<VideoEducationPage> {
  YoutubePlayerController? _controller;
  VideoEducation? _currentVideo; // Melacak video yang sedang diputar

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Panggil fetchVideos jika state masih initial
      if (context.read<VideoEducationCubit>().state is VideoEducationInitial) {
        context.read<VideoEducationCubit>().fetchVideos();
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  // Fungsi untuk mengganti video di Cubit
  void _playVideo(VideoEducation newVideo) {
    context.read<VideoEducationCubit>().selectVideo(newVideo);
  }

  // Fungsi untuk memanggil API 'markAsWatched' saat video selesai
  void _onPlayerStateChanged(PlayerState state) {
    if (state == PlayerState.ended) {
      if (_currentVideo != null) {
        // Panggil Cubit saat video selesai
        context.read<VideoEducationCubit>().onVideoEnded(_currentVideo!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey.shade700),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "Video Edukasi",
          style: TextStyle(color: Colors.black, fontWeight: bold, fontSize: 20),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<VideoEducationCubit>().fetchVideos();
        },
        child: BlocListener<VideoEducationCubit, VideoEducationState>(
          listener: (context, state) {
            if (state is VideoEducationLoaded) {
              final newVideoId = state.selectedVideo.youtubeVideoId;

              // Simpan video saat ini untuk dikirim ke onVideoEnded
              setState(() {
                _currentVideo = state.selectedVideo;
              });

              if (_controller == null) {
                // Buat controller baru jika ini pertama kali
                _controller =
                    YoutubePlayerController(
                      initialVideoId: newVideoId,
                      flags: const YoutubePlayerFlags(
                        autoPlay: false, // <-- Ganti menjadi true
                        mute: false,
                      ),
                    )..addListener(() {
                      _onPlayerStateChanged(_controller!.value.playerState);
                    });
              } else if (_controller!.metadata.videoId != newVideoId) {
                // Saat ganti video, putar otomatis juga
                _controller!.load(newVideoId, startAt: 0);
                _controller!.play();
              }
            }
          },
          child: BlocBuilder<VideoEducationCubit, VideoEducationState>(
            builder: (context, state) {
              if (state is VideoEducationLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is VideoEducationError) {
                return Center(child: Text(state.message));
              }

              if (state is VideoEducationLoaded) {
                // UI Dibangun dari state 'Loaded' yang baru
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Player Video Utama
                        _buildMainVideoPlayer(state.selectedVideo),
                        const SizedBox(height: 16),
                        Text(
                          state.selectedVideo.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          state.selectedVideo.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 24),

                        // --- 2. DAFTAR REKOMENDASI ---
                        if (state.recommendedVideos.isNotEmpty) ...[
                          Text(
                            'Rekomendasi Untuk Anda', // Judul baru
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Column(
                            children: state.recommendedVideos.map((video) {
                              // Jangan tampilkan video yang sedang diputar di list
                              if (video.id == state.selectedVideo.id) {
                                return const SizedBox.shrink();
                              }
                              return _buildVideoListItem(video);
                            }).toList(),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // --- 3. DAFTAR VIDEO LAINNYA ---
                        if (state.otherVideos.isNotEmpty) ...[
                          Text(
                            'Video Lainnya',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Column(
                            children: state.otherVideos.map((video) {
                              // Jangan tampilkan video yang sedang diputar di list
                              if (video.id == state.selectedVideo.id) {
                                return const SizedBox.shrink();
                              }
                              return _buildVideoListItem(video);
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink(); // State Initial
            },
          ),
        ),
      ),
    );
  }

  /// Widget untuk video player utama
  Widget _buildMainVideoPlayer(VideoEducation video) {
    // Tampilkan thumbnail jika controller belum siap atau video beda
    if (_controller == null || _currentVideo?.id != video.id) {
      return InkWell(
        onTap: () => _playVideo(video),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: video.thumbnailUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Icon(Icons.error, color: Colors.red),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_circle_fill_rounded,
                color: Colors.white,
                size: 60,
              ),
            ),
          ],
        ),
      );
    }
    // Jika controller sudah siap dan videonya cocok, tampilkan player
    else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: YoutubePlayer(
          controller: _controller!,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.blueAccent,
        ),
      );
    }
  }

  /// Widget untuk satu item di daftar video
  Widget _buildVideoListItem(VideoEducation video) {
    // --- LOGIKA TAG BARU (BERDASARKAN BOOLEAN) ---
    bool isWatched = video.isWatched;
    String tagText = isWatched ? "Sudah Ditonton" : "Baru";
    Color tagColor = isWatched ? Colors.orange[700]! : Colors.blue[700]!;
    Color tagBgColor = isWatched ? Colors.orange[50]! : Colors.blue[50]!;
    // ---------------------------------------------

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () => _playVideo(video), // Klik untuk memutar
        child: Container(
          padding: const EdgeInsets.all(12), // Padding di dalam card
          margin: const EdgeInsets.only(bottom: 12), // Jarak antar card
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[300]!),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kiri: Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: video.thumbnailUrl,
                  width: 150, // Lebar gambar
                  height: 100, // Tinggi gambar
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 120,
                    height: 90,
                    color: Colors.grey[200],
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 120,
                    height: 90,
                    color: Colors.grey[200],
                    child: const Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Kanan: Kolom Teks
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul
                    Text(
                      video.title,
                      style: TextStyle(
                        fontWeight: bold,
                        fontSize: 14,
                        color: primaryColor, // Warna biru
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Deskripsi
                    Text(
                      video.description,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      maxLines: 2, // 2 baris deskripsi
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Tag
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8, // Padding tag
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: tagBgColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        tagText,
                        style: TextStyle(
                          color: tagColor,
                          fontWeight: bold,
                          fontSize: 10, // Ukuran font tag
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
