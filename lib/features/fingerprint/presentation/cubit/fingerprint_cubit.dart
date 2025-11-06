// lib/features/auth/presentation/cubit/fingerprint/fingerprint_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:emotcare_apps/features/auth/domain/entities/user.dart';
// --- GANTI IMPORT INI ---
import 'package:emotcare_apps/features/auth/domain/usecases/get_credentials.dart';
import 'package:emotcare_apps/features/auth/domain/usecases/login_user.dart';
import 'package:emotcare_apps/features/auth/domain/usecases/save_token.dart';
// ----------------------
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:developer' as dev;

part 'fingerprint_state.dart';

class FingerprintCubit extends Cubit<FingerprintState> {
  // --- GANTI DEPENDENSI ---
  final LoginUser loginUser;
  final GetCredentials getCredentials;
  final SaveToken saveToken;
  // ------------------------
  final LocalAuthentication _auth = LocalAuthentication();

  FingerprintCubit({
    required this.loginUser,
    required this.getCredentials,
    required this.saveToken,
  }) : super(FingerprintInitial());

  // Fungsi ini dipanggil saat tombol fingerprint ditekan
  Future<void> checkBiometricLogin() async {
    emit(FingerprintLoading());
    dev.log('FingerprintCubit: Memulai login biometrik...', name: 'AuthDebug');

    // 1. Cek dulu apakah ada credential (email/pass) yang tersimpan
    final credResult = await getCredentials();
    final credentials = credResult.getOrElse(() => {});

    final email = credentials['email'];
    final password = credentials['password'];

    // 2. Jika tidak ada credential, minta login manual
    if (email == null || password == null) {
      dev.log(
        'FingerprintCubit: Credential tidak ditemukan.',
        name: 'AuthDebug',
      );
      emit(
        FingerprintFailure(
          "Sesi Anda Telah Berakhir. Silakan Login untuk Akfitkan Fingerprint",
        ),
      );
      return;
    }

    dev.log(
      'FingerprintCubit: Credential ditemukan. Membuka dialog biometrik...',
      name: 'AuthDebug',
    );

    // 3. Jika ADA credential, baru panggil biometrik
    bool authenticated = false;
    try {
      authenticated = await _auth.authenticate(
        localizedReason: 'Silahkan pindai sidik jari untuk masuk',
        options: const AuthenticationOptions(stickyAuth: true),
      );
    } on PlatformException {
      emit(FingerprintFailure("Fingerprint Error! Silahkan coba lagi"));
      return;
    }

    if (!authenticated) {
      emit(FingerprintFailure("Otentikasi dibatalkan."));
      return;
    }

    // 4. Jika biometrik sukses, PANGGIL API LOGIN
    dev.log(
      'FingerprintCubit: Biometrik sukses. Memanggil API Login...',
      name: 'AuthDebug',
    );
    final loginResult = await loginUser(email: email, password: password);

    loginResult.fold(
      (failure) {
        dev.log(
          'FingerprintCubit: Gagal login ulang: ${failure.message}',
          name: 'AuthDebug',
        );
        emit(FingerprintFailure("Gagal login ulang: ${failure.message}"));
      },
      (authResult) async {
        dev.log(
          'FingerprintCubit: Berhasil login ulang & dapat token baru.',
          name: 'AuthDebug',
        );
        // 5. Simpan token BARU
        await saveToken(authResult.token);
        emit(FingerprintSuccess(authResult.user));
      },
    );
  }
}
