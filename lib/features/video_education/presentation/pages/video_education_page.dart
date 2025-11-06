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

  // Fungsi untuk memulai/mengganti video
  void _playVideo(VideoEducation newVideo) {
    // --- HAPUS LOGIKA LAMA (oldVideoStatus) ---
    // Cukup panggil cubit untuk menukar video di UI
    context.read<VideoEducationCubit>().selectVideo(newVideo);
  }

  // --- FUNGSI BARU: Listener untuk status player ---
  void _onPlayerStateChanged(PlayerState state) {
    if (state == PlayerState.ended) {
      if (_currentVideo != null) {
        // Panggil Cubit saat video selesai
        context.read<VideoEducationCubit>().onVideoEnded(_currentVideo!);
      }
    }
  }
  // ----------------------------------------------

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

              // Simpan video saat ini
              setState(() {
                _currentVideo = state.selectedVideo;
              });

              if (_controller == null) {
                // Buat controller baru
                _controller =
                    YoutubePlayerController(
                        initialVideoId: newVideoId,
                        flags: const YoutubePlayerFlags(autoPlay: false),
                      )
                      // --- TAMBAHKAN LISTENER ---
                      ..addListener(() {
                        _onPlayerStateChanged(_controller!.value.playerState);
                      });
                // --------------------------
              } else if (_controller!.metadata.videoId != newVideoId) {
                // Jika video diganti, muat video baru
                _controller!.load(newVideoId);
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
                // Build UI dari state Cubit
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        ),
                        const SizedBox(height: 24),
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
                            return _buildVideoListItem(video);
                          }).toList(),
                        ),
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
    // Jika controller BELUM dibuat (pertama kali load)
    // atau jika video yang dipilih BUKAN video yang sedang diputar
    if (_controller == null || _currentVideo?.id != video.id) {
      return InkWell(
        onTap: () => _playVideo(video), // Panggil player
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
    // Jika controller SUDAH dibuat, tampilkan player
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

  /// Widget untuk satu item di "Video Lainnya"
  Widget _buildVideoListItem(VideoEducation video) {
    // --- PERBAIKI LOGIKA TAG ---
    // Tentukan warna tag berdasarkan status isWatched
    bool isWatched = video.isWatched;
    String tagText = isWatched ? "Sudah Ditonton" : "Baru";
    Color tagColor = isWatched ? Colors.orange[700]! : Colors.blue[700]!;
    Color tagBgColor = isWatched ? Colors.orange[50]! : Colors.blue[50]!;
    // ----------------------------

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () => _playVideo(video), // Panggil ganti video
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: video.thumbnailUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Container(width: 80, height: 80, color: Colors.grey[200]),
                  errorWidget: (context, url, error) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: const Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.title,
                      style: TextStyle(fontWeight: bold, fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      video.description,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Tag Dinamis
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: tagBgColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        tagText, // <-- Tampilkan status dinamis
                        style: TextStyle(
                          color: tagColor,
                          fontWeight: bold,
                          fontSize: 10,
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
