// lib/features/fingerprint/presentation/pages/fingerprint_page.dart

import 'package:emotcare_apps/app/themes/colors.dart';
import 'package:emotcare_apps/app/themes/fontweight.dart';
import 'package:emotcare_apps/app/ui/info_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// --- GANTI SEMUA IMPORT CUBIT LAMA DENGAN INI ---
import 'package:emotcare_apps/features/auth/presentation/cubit/auth_cubit.dart';

class FingerPrintPage extends StatelessWidget {
  const FingerPrintPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          // --- HAPUS MultiBlocListener, GANTI DENGAN BlocListener ---
          child: BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                showErrorDialog(
                  context: context,
                  content: state.error,
                );
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Image.asset("assets/images/logo.png", height: 150),
                const Spacer(),
                _buildAuthButtonsRow(context),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthButtonsRow(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                height: 70,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () => context.pushNamed('login'), // Tombol Masuk
                  child: Text(
                    "Masuk",
                    style: TextStyle(fontSize: 24, fontWeight: bold),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // --- PERBAIKI BLOCBUILDER ---
            // Dengarkan AuthCubit, BUKAN FingerprintCubit
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                // Tampilkan loading HANYA saat state AuthLoading
                final isLoading = (state is AuthLoading);

                return SizedBox(
                  width: 70,
                  height: 70,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: const OvalBorder(),
                      backgroundColor: Colors.white,
                      side: BorderSide(color: primaryColor, width: 2),
                    ),
                    // Nonaktifkan tombol saat loading
                    onPressed: isLoading
                        ? null
                        : () {
                            // Panggil 'biometricLogin' dari AuthCubit
                            context.read<AuthCubit>().biometricLogin();
                          },
                    child: isLoading
                        ? CircularProgressIndicator(color: primaryColor)
                        : Icon(
                            Icons.fingerprint,
                            size: 40,
                            color: primaryColor,
                          ),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Belum punya akun?",
              style: TextStyle(color: primaryColor, fontSize: 20),
            ),
            const SizedBox(width: 5),
            InkWell(
              onTap: () => context.pushNamed('register'), // Tombol Daftar
              child: Text(
                "Daftar Disini",
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
