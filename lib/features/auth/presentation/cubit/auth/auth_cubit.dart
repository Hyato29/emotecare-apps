// lib/features/auth/presentation/cubit/auth/auth_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:emotcare_apps/features/auth/domain/entities/user.dart';
import 'package:emotcare_apps/features/auth/domain/usecases/get_credentials.dart';
import 'package:emotcare_apps/features/auth/domain/usecases/get_token.dart';
import 'package:emotcare_apps/features/auth/domain/usecases/get_user_profile.dart';
import 'package:emotcare_apps/features/auth/domain/usecases/login_user.dart';
import 'package:emotcare_apps/features/auth/domain/usecases/register_user.dart';
import 'package:emotcare_apps/features/auth/domain/usecases/remove_credentials.dart';
import 'package:emotcare_apps/features/auth/domain/usecases/remove_token.dart';
import 'package:emotcare_apps/features/auth/domain/usecases/save_credentials.dart';
import 'package:emotcare_apps/features/auth/domain/usecases/save_token.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:developer' as dev;

import 'package:permission_handler/permission_handler.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  // Semua use case yang dibutuhkan
  final RegisterUser _registerUser;
  final LoginUser _loginUser;
  final GetUserProfile _getUserProfile;
  final GetToken _getToken;
  final SaveToken _saveToken;
  final RemoveToken _removeToken;
  final GetCredentials _getCredentials;
  final SaveCredentials _saveCredentials;
  final RemoveCredentials _removeCredentials;

  final LocalAuthentication _auth = LocalAuthentication();

  AuthCubit({
    required RegisterUser registerUser,
    required LoginUser loginUser,
    required GetUserProfile getUserProfile,
    required GetToken getToken,
    required SaveToken saveToken,
    required RemoveToken removeToken,
    required GetCredentials getCredentials,
    required SaveCredentials saveCredentials,
    required RemoveCredentials removeCredentials,
  }) : _registerUser = registerUser,
       _loginUser = loginUser,
       _getUserProfile = getUserProfile,
       _getToken = getToken,
       _saveToken = saveToken,
       _removeToken = removeToken,
       _getCredentials = getCredentials,
       _saveCredentials = saveCredentials,
       _removeCredentials = removeCredentials,
       super(AuthInitial());

  // Dipanggil dari main.dart
  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    const minSplashDuration = Duration(seconds: 3);
    final startTime = DateTime.now();

    final tokenResult = await _getToken();
    final token = tokenResult.getOrElse(() => null);

    if (token == null) {
      dev.log('AuthCubit: Token tidak ditemukan.', name: 'AuthDebug');
      emit(Unauthenticated());
      return;
    }

    dev.log('AuthCubit: Token ditemukan, memvalidasi...', name: 'AuthDebug');
    final result =
        await _getUserProfile(); // Usecase ini sudah mengambil token internal

    final apiDuration = DateTime.now().difference(startTime);
    if (apiDuration < minSplashDuration) {
      await Future.delayed(minSplashDuration - apiDuration);
    }

    result.fold(
      (failure) {
        dev.log(
          'AuthCubit: Validasi token gagal: ${failure.message}',
          name: 'AuthDebug',
        );
        emit(Unauthenticated(message: failure.message));
      },
      (user) {
        dev.log(
          'AuthCubit: Validasi token sukses. Role: "${user.role}"',
          name: 'AuthDebug',
        );
        emit(Authenticated(user, token)); // Simpan token dan user
      },
    );
  }

  // Dipanggil dari RegisterPage
  Future<void> register(Map<String, String> data) async {
    emit(AuthLoading()); // Mungkin Anda ingin state RegisterLoading...
    final result = await _registerUser(
      name: data['name']!,
      email: data['email']!,
      nik: data['nik']!,
      contact: data['contact']!,
      gender: data['gender']!,
      address: data['address']!,
      password: data['password']!,
      passwordConfirmation: data['password_confirmation']!,
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.message)), // State Gagal baru
      (authResult) => emit(
        Unauthenticated(message: "Registrasi berhasil! Silakan login."),
      ), // Sukses, tapi kembali ke login
    );
  }

  // Dipanggil dari LoginPage
  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      emit(AuthFailure("Email dan password harus diisi."));
      return;
    }
    emit(AuthLoading());

    final result = await _loginUser(email: email, password: password);

    result.fold((failure) => emit(AuthFailure(failure.message)), (
      authResult,
    ) async {
      await _saveToken(authResult.token);
      await _saveCredentials(email, password);
      emit(Authenticated(authResult.user, authResult.token));
    });
  }

  // Dipanggil dari FingerprintPage
  Future<void> biometricLogin() async {
    emit(AuthLoading());

    final credResult = await _getCredentials();
    final credentials = credResult.getOrElse(() => {});
    final email = credentials['email'];
    final password = credentials['password'];

    if (email == null || password == null) {
      emit(
        AuthFailure("Login tidak tersimpan. Silakan login manual satu kali."),
      );
      return;
    }

    bool authenticated = false;
    try {
      authenticated = await _auth.authenticate(
        localizedReason: 'Silahkan pindai sidik jari untuk masuk',
        options: const AuthenticationOptions(stickyAuth: true),
      );
    } on PlatformException catch (e) {
      emit(AuthFailure("Error biometrik: ${e.message}"));
      return;
    }

    if (!authenticated) {
      emit(AuthInitial()); // Kembali ke awal
      return;
    }

    // Jika biometrik sukses, panggil fungsi login
    await login(email, password);
  }

  // Dipanggil dari tombol Logout
  Future<void> logout() async {
    await _removeToken();
    await _removeCredentials();
    emit(Unauthenticated(message: "Anda telah logout."));
  }

  Future<void> getCurrentLocation() async {
    // Kirim state Loading
    emit(GetLocationLoading());

    // 1. Cek Izin Lokasi
    var status = await Permission.location.request();
    if (status.isDenied) {
      emit(GetLocationFailure('Izin lokasi ditolak.'));
      return;
    }

    if (status.isPermanentlyDenied) {
      emit(
        GetLocationFailure(
          'Izin lokasi ditolak permanen, buka pengaturan.',
          openSettings: true,
        ),
      );
      return;
    }

    // 2. Cek apakah layanan lokasi GPS di HP aktif
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(GetLocationFailure('Layanan lokasi (GPS) tidak aktif.'));
      return;
    }

    try {
      // 3. Ambil Posisi (GPS)
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 4. Ubah Koordinat menjadi Alamat (Reverse Geocoding)
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address =
            '${place.street}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.postalCode}';

        // 5. Kirim state Sukses beserta alamatnya
        emit(GetLocationSuccess(address));
      } else {
        emit(GetLocationFailure('Tidak dapat menemukan alamat dari lokasi.'));
      }
    } catch (e) {
      emit(GetLocationFailure('Gagal mendapatkan lokasi: $e'));
    }
  }
}
