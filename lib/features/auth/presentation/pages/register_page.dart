// lib/features/auth/presentation/pages/register_page.dart

import 'package:emotcare_apps/app/themes/colors.dart';
import 'package:emotcare_apps/app/ui/appbar_widget.dart';
import 'package:emotcare_apps/app/ui/info_dialog.dart';
import 'package:emotcare_apps/app/ui/labelform_widget.dart';
import 'package:emotcare_apps/features/auth/presentation/widgets/genderform_widget.dart';
import 'package:emotcare_apps/features/auth/presentation/widgets/passform_widget.dart';
import 'package:emotcare_apps/features/auth/presentation/widgets/textform_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

// --- GANTI IMPORT LAMA (RegisterCubit) DENGAN INI ---
import 'package:emotcare_apps/features/auth/presentation/cubit/auth_cubit.dart';
// --------------------------------------------------

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nikController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confPassController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    nikController.dispose();
    phoneController.dispose();
    genderController.dispose();
    passController.dispose();
    confPassController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context),
      // --- PERBAIKI BLOCLISTENER ---
      body: BlocListener<AuthCubit, AuthState>(
        // <-- 1. Dengarkan AuthCubit
        listener: (context, state) {
          // 2. State untuk GPS (tidak berubah, tapi ini dari AuthCubit)
          if (state is GetLocationSuccess) {
            addressController.text = state.address;
          } else if (state is GetLocationFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
            if (state.openSettings) {
              openAppSettings();
            }
          } else if (state is Unauthenticated && state.message != null) {
            // Tampilkan pesan sukses dari AuthCubit
            showSuccessDialog(
              context: context,
              content: state.message!, // "Registrasi berhasil! Silakan login."
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                context.goNamed('login'); // Arahkan ke login
              },
            );
          }
          // 4. State untuk Gagal Register
          else if (state is AuthFailure) {
            showErrorDialog(
              context: context,
              content: state.error,
              onPressed: () {
                context.pop();
                context.pop();
                context.pop();
              },
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                LabelformWidget(label: "Nama Lengkap"),
                const SizedBox(height: 8),
                TextformWidget(
                  label: "Masukkan Nama Lengkap Anda",
                  keyboardType: TextInputType.text,
                  controller: nameController,
                ),
                const SizedBox(height: 8),
                LabelformWidget(label: "Email"),
                const SizedBox(height: 8),
                TextformWidget(
                  label: "Masukkan Email Anda",
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                ),
                const SizedBox(height: 8),
                LabelformWidget(label: "NIK"),
                const SizedBox(height: 8),
                TextformWidget(
                  label: "Masukkan NIK Anda (16 digit)",
                  keyboardType: TextInputType.number,
                  controller: nikController,
                ),
                const SizedBox(height: 8),
                LabelformWidget(label: "Alamat"),
                const SizedBox(height: 8),

                // --- PERBAIKI BLOCBUILDER ---
                BlocBuilder<AuthCubit, AuthState>(
                  // <-- 5. Dengarkan AuthCubit
                  builder: (context, state) {
                    final isLocationLoading = (state is GetLocationLoading);
                    return TextFormField(
                      controller: addressController,
                      readOnly: true,
                      onTap: isLocationLoading
                          ? null
                          : () {
                              context.read<AuthCubit>().getCurrentLocation();
                            },
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: "Tekan untuk mengambil alamat GPS",
                        hintStyle: TextStyle(color: greyColor),
                        suffixIcon: isLocationLoading
                            ? Container(
                                padding: const EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: primaryColor,
                                ),
                              )
                            : Icon(Icons.gps_fixed, color: primaryColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: primaryColor, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: primaryColor),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                LabelformWidget(label: "Nomor Whatsapp"),
                const SizedBox(height: 8),
                TextformWidget(
                  label: "Masukkan Nomor Whatsapp Anda",
                  keyboardType: TextInputType.phone,
                  controller: phoneController,
                ),
                const SizedBox(height: 8),
                LabelformWidget(label: "Jenis Kelamin"),
                const SizedBox(height: 8),
                GenderformWidget(
                  label: "Pilih Jenis Kelamin Anda",
                  controller: genderController,
                ),
                const SizedBox(height: 8),
                LabelformWidget(label: "Kata Sandi"),
                const SizedBox(height: 8),
                PassformWidget(
                  label: "Masukkan Kata Sandi",
                  controller: passController,
                ),
                const SizedBox(height: 8),
                LabelformWidget(label: "Konfirmasi Kata Sandi"),
                const SizedBox(height: 8),
                PassformWidget(
                  label: "Tulis Ulang Kata Sandi",
                  controller: confPassController,
                ),
                const SizedBox(height: 32),

                // --- PERBAIKI BLOCBUILDER ---
                BlocBuilder<AuthCubit, AuthState>(
                  // <-- 6. Dengarkan AuthCubit
                  builder: (context, state) {
                    // Tampilkan loading jika AuthLoading
                    final isRegisterLoading = (state is AuthLoading);
                    return SizedBox(
                      width: double.infinity,
                      height: 70,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: isRegisterLoading
                            ? null
                            : () {
                                String genderValue;
                                if (genderController.text == 'Laki-laki') {
                                  genderValue = 'male';
                                } else if (genderController.text ==
                                    'Perempuan') {
                                  genderValue = 'female';
                                } else {
                                  genderValue = '';
                                }

                                // 7. Panggil AuthCubit.register
                                context.read<AuthCubit>().register(
                                  // Kirim sebagai Map<String, String>
                                  {
                                    'name': nameController.text,
                                    'email': emailController.text,
                                    'nik': nikController.text,
                                    'contact': phoneController.text,
                                    'gender': genderValue,
                                    'address': addressController.text,
                                    'password': passController.text,
                                    'password_confirmation':
                                        confPassController.text,
                                  },
                                );
                              },
                        child: isRegisterLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Daftar",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
