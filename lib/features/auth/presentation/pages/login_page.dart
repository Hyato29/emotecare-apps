// lib/features/auth/presentation/pages/login_page.dart

import 'package:emotcare_apps/app/themes/colors.dart';
import 'package:emotcare_apps/app/themes/fontweight.dart'; // Asumsi ini berisi 'bold'
import 'package:emotcare_apps/app/ui/appbar_widget.dart';
import 'package:emotcare_apps/app/ui/info_dialog.dart';
import 'package:emotcare_apps/app/ui/labelform_widget.dart';
import 'package:emotcare_apps/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:emotcare_apps/features/auth/presentation/widgets/passform_widget.dart';
import 'package:emotcare_apps/features/auth/presentation/widgets/textform_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// --- Import yang Diperlukan untuk Logic ---
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPagesState();
}

class _LoginPagesState extends State<LoginPage> {
  // --- DIUBAH: dari phoneController ke emailController ---
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose(); // <-- DIUBAH
    passController.dispose();
    super.dispose();
  }

  // --- TAMBAHAN: Logika Navigasi Berbasis Role ---
  void _handleLoginSuccess(BuildContext context, String? role) {
    if (role == 'patient') {
      context.goNamed(
        'home_patient',
      ); // Ganti dengan nama rute home pasien Anda
    } else if (role == 'healt_center') {
      context.goNamed(
        'home_health_center',
      ); // Ganti dengan nama rute home admin Anda
    } else {
      context.goNamed('home_patient');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context),
      resizeToAvoidBottomInset: false,
      body: BlocListener<AuthCubit, AuthState>(
        // <-- 1. Dengarkan AuthCubit
        listener: (context, state) {
          // 2. Dengarkan state 'Authenticated'
          if (state is Authenticated) {
            // Panggil dialog sukses (opsional)
            showSuccessDialog(
              context: context,
              content: 'Selamat datang, ${state.user.name}!',
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                _handleLoginSuccess(context, state.user.role);
              },
            );

            // 3. Dengarkan state 'AuthFailure'
          } else if (state is AuthFailure) {
            showErrorDialog(
              context: context,
              content: state.error,
              onPressed: () {
                context.pop();
                context.pop();
              },
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Masuk",
                  style: TextStyle(
                    fontSize: 36,
                    color: primaryColor,
                    fontWeight: bold,
                  ),
                ),
                const SizedBox(height: 32),
                LabelformWidget(label: "Email"),
                const SizedBox(height: 8),
                TextformWidget(
                  label: "Masukkan Email Anda",
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                ),
                const SizedBox(height: 24),
                LabelformWidget(label: "Kata Sandi"),
                const SizedBox(height: 8),
                PassformWidget(
                  label: "Masukkan Kata Sandi",
                  controller: passController,
                ),
                const SizedBox(height: 52),

                // --- PERBAIKI BLOCBUILDER INI ---
                BlocBuilder<AuthCubit, AuthState>(
                  // <-- 4. Dengarkan AuthCubit
                  builder: (context, state) {
                    // 5. Cek state 'AuthLoading'
                    final isLoading = (state is AuthLoading);

                    return SizedBox(
                      width: double.infinity,
                      height: 70,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        // 6. Panggil AuthCubit.login
                        onPressed: isLoading
                            ? null
                            : () {
                                context.read<AuthCubit>().login(
                                  emailController.text,
                                  passController.text,
                                );
                              },
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                "Masuk",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: bold,
                                ),
                              ),
                      ),
                    );
                  },
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
                      onTap: () =>
                          context.pushNamed('register'), // Ini sudah benar
                      child: Text(
                        "Daftar Disini",
                        style: TextStyle(
                          fontSize: 20,
                          color: primaryColor,
                          fontWeight: bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
