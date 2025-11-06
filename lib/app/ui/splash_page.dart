// lib/features/splash/splash_page.dart
import 'package:emotcare_apps/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Import warna tema Anda
import 'package:emotcare_apps/app/themes/colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

// --- 1. Tambahkan 'with SingleTickerProviderStateMixin' ---
// Ini diperlukan untuk mengontrol animasi
class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  // --- 2. Definisikan controller dan animasi ---
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // --- 3. Atur setup animasi ---
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Durasi fade-in
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut, // Efek animasi
    );

    // Mulai animasi
    _animationController.forward();
    // ----------------------------

    // Logika checkAuthStatus Anda tetap sama
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthCubit>().checkAuthStatus();
    });
  }

  // --- 4. Hapus controller saat widget dibuang ---
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  // ------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih (bersih)
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Spacer untuk mendorong logo ke tengah-atas
              const Spacer(flex: 1),

              // --- 5. Terapkan animasi di sini ---
              FadeTransition(
                opacity: _fadeAnimation,
                child: Center(
                  // Ganti dengan path logo Anda
                  child: Image.asset('assets/images/logo.jpg', width: 150),
                ),
              ),

              const Spacer(flex: 1),

              CircularProgressIndicator(color: primaryColor, strokeWidth: 3),
              const SizedBox(height: 16),
              Text(
                'Loading...',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),

              // Padding bawah
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
