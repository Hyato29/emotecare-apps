import 'dart:async'; // <-- TAMBAHKAN import ini untuk Timer

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emotcare_apps/app/themes/colors.dart';
import 'package:emotcare_apps/app/themes/fontweight.dart';
import 'package:emotcare_apps/app/ui/alert_dialog.dart';
import 'package:emotcare_apps/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:emotcare_apps/features/home/domain/entities/banner.dart';
import 'package:emotcare_apps/features/home/presentation/cubit/home_cubit.dart';
import 'package:emotcare_apps/features/home/presentation/widgets/menu_widget.dart';
import 'package:emotcare_apps/features/home/presentation/widgets/profile_card_widget.dart';
// --- TAMBAHKAN IMPORT UNTUK VIDEO EDUCATION ---
import 'package:emotcare_apps/features/video_education/domain/entities/video_education.dart';
import 'package:emotcare_apps/features/video_education/presentation/cubit/video_education_cubit.dart';
// ---------------------------------------------
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

class PatientHomePage extends StatefulWidget {
  const PatientHomePage({super.key});

  @override
  State<PatientHomePage> createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage> {
  final List<Map<String, String>> menuItems = [
    {
      'image': 'assets/icons/medicine.svg',
      'label': 'Daftar Obat',
      'routeName': 'medicine',
    },
    {
      'image': 'assets/icons/video.svg',
      'label': 'Edukasi & Motivasi',
      'routeName': 'education',
    },
    {
      'image': 'assets/icons/schedule.svg',
      'label': 'Jadwal Kontrol',
      'routeName': 'schedule_control',
    },
    {
      'image': 'assets/icons/recap.svg',
      'label': 'Rekap Minum Obat',
      'routeName': 'comming_soon',
    },
    {
      'image': 'assets/icons/report_side_effect.svg',
      'label': 'Lapor Efek Samping',
      'routeName': 'report_side_effect',
    },
    {
      'image': 'assets/icons/report_complaint.svg',
      'label': 'Lapor Keluhan',
      'routeName': 'report_complaint',
    },
    {
      'image': 'assets/icons/report_complaint.svg',
      'label': 'Konseling Tenaga Kesehatan',
      'routeName': 'comming_soon',
    },
  ];

  // --- TAMBAHKAN VARIABEL UNTUK AUTO-SLIDE ---
  late final PageController _pageController;
  Timer? _bannerTimer;
  int _currentPage = 0;
  int _bannerCount = 0;
  // ------------------------------------------

  @override
  void initState() {
    super.initState();
    // Inisialisasi PageController
    _pageController = PageController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  // --- TAMBAHKAN DISPOSE UNTUK MEMBERSIHKAN ---
  @override
  void dispose() {
    _pageController.dispose();
    _bannerTimer?.cancel(); // Hentikan timer
    super.dispose();
  }
  // ------------------------------------------

  Future<void> _fetchData() async {
    // Panggil kedua cubit untuk refresh
    context.read<HomeCubit>().fetchBanners();
    context.read<VideoEducationCubit>().fetchVideos(); // <-- TAMBAHKAN INI
  }

  // --- FUNGSI BARU UNTUK MEMULAI TIMER ---
  void _startBannerTimer() {
    // ... (existing code)
    _bannerTimer?.cancel();

    if (_bannerCount > 0) {
      _bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (!_pageController.hasClients) return;

        int nextPage = _currentPage + 1;
        if (nextPage >= _bannerCount) {
          nextPage = 0;
        }

        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      });
    }
    // ... (existing code)
  }
  // --------------------------------------

  void _showLogoutDialog(BuildContext context) {
    // ... (existing code)
    showModernDialog(
      context: context,
      icon: Icons.warning_rounded,
      title: 'Konfirmasi Logout',
      content: 'Apakah Anda yakin ingin keluar dari akun ini?',
      confirmText: 'Keluar',
      confirmColor: const Color.fromARGB(255, 179, 12, 0),
      onConfirm: () {
        context.read<AuthCubit>().logout();
      },
    );
    // ... (existing code)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   // ... (existing code)
      //   title: Image.asset('assets/images/logo.jpg', height: 40),
      //   centerTitle: true,
      //   backgroundColor: Colors.white,
      //   automaticallyImplyLeading: false, // Sembunyikan tombol kembali
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.logout, color: Colors.red),
      //       tooltip: 'Logout',
      //       onPressed: () {
      //         _showLogoutDialog(context);
      //       },
      //     ),
      //   ],
      //   // ... (existing code)
      // ),
      body: RefreshIndicator(
        onRefresh: _fetchData,
        color: primaryColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ProfileCardWidget(),
                  const SizedBox(height: 24),
                  Text(
                    'Selamat Datang',
                    // ... (existing code)
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildMenuGrid(context),
                  const SizedBox(height: 14),
                  Text(
                    'Spotlight',
                    // ... (existing code)
                    style: TextStyle(fontSize: 18, fontWeight: bold),
                  ),
                  const SizedBox(height: 14),
                  _buildSpotlightBanner(),
                  const SizedBox(height: 14),
                  Text(
                    'Video Terkini',
                    // ... (existing code)
                    style: TextStyle(fontSize: 18, fontWeight: bold),
                  ),
                  const SizedBox(height: 14),
                  // --- TAMBAHKAN WIDGET VIDEO TERKINI ---
                  _buildLatestVideos(),
                  const SizedBox(height: 14),
                  // ------------------------------------
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpotlightBanner() {
    // ... (existing code)
    final String baseUrl = "${dotenv.env['BASE_URL']}/storage/";

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is BannerLoading) {
          _bannerTimer?.cancel(); // Hentikan timer saat loading
          _bannerCount = 0;
          return Container(
            height: 150,
            alignment: Alignment.center,
            child: CircularProgressIndicator(color: primaryColor),
          );
        }
        if (state is BannerError) {
          _bannerTimer?.cancel(); // Hentikan timer saat error
          _bannerCount = 0;
          return Container(
            height: 150,
            alignment: Alignment.center,
            child: Text(
              state.message,
              style: TextStyle(color: Colors.red[700]),
            ),
          );
        }
        if (state is BannerLoaded) {
          if (state.banners.isEmpty) {
            _bannerTimer?.cancel(); // Hentikan timer jika tidak ada banner
            _bannerCount = 0;
            return const SizedBox(
              height: 150,
              child: Center(child: Text("Tidak ada informasi saat ini.")),
            );
          }

          // --- LOGIKA TIMER ---
          _bannerCount = state.banners.length;
          // Mulai timer jika belum berjalan
          if (_bannerTimer == null || !_bannerTimer!.isActive) {
            _startBannerTimer();
          }
          // --------------------

          return Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(15),
            ),
            child: PageView.builder(
              controller: _pageController, // <-- PASANG CONTROLLER
              itemCount: state.banners.length,
              // --- TAMBAHKAN onPageChanged ---
              // (Untuk sinkronisasi jika user slide manual)
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              // -----------------------------
              itemBuilder: (context, index) {
                // ... (existing code)
                final BannerEntity banner = state.banners[index];
                final String imageUrl = "$baseUrl${banner.imageUrl}";

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Container(color: Colors.grey[300]),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: Icon(Icons.error, color: Colors.red[400]),
                      ),
                    ),
                  ),
                );
                // ... (existing code)
              },
            ),
          );
        }
        // State HomeInitial
        return Container(
          height: 150,
          alignment: Alignment.center,
          child: CircularProgressIndicator(color: primaryColor),
        );
      },
    );
  }

  // --- WIDGET BARU UNTUK VIDEO TERKINI ---
  Widget _buildLatestVideos() {
    return BlocBuilder<VideoEducationCubit, VideoEducationState>(
      builder: (context, state) {
        if (state is VideoEducationLoading) {
          return Container(
            height: 150, // Sesuaikan tinggi
            alignment: Alignment.center,
            child: CircularProgressIndicator(color: primaryColor),
          );
        }
        if (state is VideoEducationError) {
          return Container(
            height: 150,
            alignment: Alignment.center,
            child: Text(
              state.message,
              style: TextStyle(color: Colors.red[700]),
            ),
          );
        }
        if (state is VideoEducationLoaded) {
          // Gabungkan kedua list (rekomendasi dan lainnya)
          final allVideos = [...state.recommendedVideos, ...state.otherVideos];

          if (allVideos.isEmpty) {
            return const SizedBox(
              height: 150,
              child: Center(child: Text("Tidak ada video terkini.")),
            );
          }

          // Ambil 3 video pertama dari list gabungan
          final latestVideos = allVideos.take(3).toList();

          return ListView.builder(
            scrollDirection: Axis.vertical, // Scroll ke bawah
            shrinkWrap: true, // Agar muat di dalam SingleChildScrollView
            physics:
                const NeverScrollableScrollPhysics(), // Nonaktifkan scroll internal
            itemCount: latestVideos.length,
            itemBuilder: (context, index) {
              final video = latestVideos[index];
              return _buildVideoCard(video: video);
            },
          );
        }
        // State Initial
        return Container(
          height: 150,
          alignment: Alignment.center,
          child: CircularProgressIndicator(color: primaryColor),
        );
      },
    );
  }

  // --- WIDGET BARU UNTUK CARD VIDEO ---
  Widget _buildVideoCard({required VideoEducation video}) {
    bool isWatched = video.isWatched;
    String tagText = isWatched ? "Sudah Ditonton" : "Baru";
    Color tagColor = isWatched ? Colors.orange[700]! : Colors.blue[700]!;
    Color tagBgColor = isWatched ? Colors.orange[50]! : Colors.blue[50]!;

    // Warna biru untuk judul (sesuai gambar)
    Color titleColor = const Color(
      0xFF007BFF,
    ); // Anda bisa ganti ke primaryColor

    return InkWell(
      onTap: () {
        // Arahkan ke halaman video edukasi
        context.pushNamed('education');
      },
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
                placeholder: (context, url) =>
                    Container(width: 120, height: 90, color: Colors.grey[200]),
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
                      color: titleColor, // Warna biru
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
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    // ... (existing code)
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: greyColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 16, // Beri jarak main axis
          childAspectRatio: 0.8, // Sesuaikan rasio
        ),
        padding: const EdgeInsets.all(16.0),
        itemCount: menuItems.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return MenuWidget(
            imagePath: item['image']!,
            label: item['label']!,
            onTap: () {
              context.pushNamed(item['routeName']!);
            },
          );
        },
      ),
    );
    // ... (existing code)
  }
}
