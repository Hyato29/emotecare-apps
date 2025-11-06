// lib/features/auth/data/datasources/auth_remote_data_source.dart

import 'dart:convert';
import 'package:emotcare_apps/core/error/exceptions.dart';
import 'package:emotcare_apps/features/auth/data/models/user_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';

abstract class AuthRemoteDataSource {
  Future<AuthResultModel> register(Map<String, dynamic> body);
  Future<AuthResultModel> login(Map<String, dynamic> body);
  Future<UserModel> getUserProfile(String token);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  // Pastikan IP ini benar!
  final String _baseUrl = "${dotenv.env['BASE_URL']}/api";

  AuthRemoteDataSourceImpl({required this.client});

  // --- 1. FUNGSI REGISTER (DIPERBAIKI) ---
  @override
  Future<AuthResultModel> register(Map<String, dynamic> body) async {
    final registerUrl = Uri.parse('$_baseUrl/register');
    dev.log(
      'AuthRemoteDataSource: Mencoba register (MODE: JSON)...',
      name: 'AuthDebug',
    );
    dev.log('AuthRemoteDataSource: URL: $registerUrl', name: 'AuthDebug');

    http.Response response;
    try {
      // Mengirim sebagai JSON (sesuai AuthController.php Anda)
      response = await client
          .post(
            registerUrl,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode(body),
          )
          .timeout(const Duration(seconds: 10));
    } on TimeoutException catch (e) {
      dev.log(
        'AuthRemoteDataSource: ERROR - TimeoutException: $e',
        name: 'AuthDebug',
      );
      throw ServerException(message: 'Request timeout. Server tidak merespon.');
    } on SocketException catch (e) {
      dev.log(
        'AuthRemoteDataSource: ERROR - SocketException: $e',
        name: 'AuthDebug',
      );
      throw ServerException(
        message: 'Koneksi gagal. Periksa IP, Port, dan koneksi WiFi Anda.',
      );
    }

    dev.log(
      'AuthRemoteDataSource: Respon register diterima. Status: ${response.statusCode}',
      name: 'AuthDebug',
    );
    final responseData = json.decode(response.body);

    if (response.statusCode == 201 || response.statusCode == 200) {
      dev.log('AuthRemoteDataSource: Register sukses.', name: 'AuthDebug');
      return AuthResultModel.fromJson(responseData);
    } else if (response.statusCode == 422) {
      final errors = responseData['errors'] as Map<String, dynamic>;
      final firstError = errors.values.first[0] as String;
      dev.log(
        'AuthRemoteDataSource: Validation Error (422): $firstError',
        name: 'AuthDebug',
      );
      throw ServerException(message: firstError);
    } else {
      dev.log(
        'AuthRemoteDataSource: Server error: ${responseData['message']}',
        name: 'AuthDebug',
      );
      throw ServerException(
        message: responseData['message'] ?? 'Unknown Server Error',
      );
    }
  }

  // --- 2. FUNGSI LOGIN (DIPERBAIKI) ---
  @override
  Future<AuthResultModel> login(Map<String, dynamic> body) async {
    final loginUrl = Uri.parse('$_baseUrl/login');
    dev.log(
      'AuthRemoteDataSource: Mencoba login (MODE: JSON)...',
      name: 'AuthDebug',
    );
    dev.log('AuthRemoteDataSource: URL: $loginUrl', name: 'AuthDebug');

    http.Response response;
    try {
      // Ganti dari MultipartRequest kembali ke http.post
      response = await client
          .post(
            loginUrl,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode(body), // Kirim sebagai JSON
          )
          .timeout(const Duration(seconds: 10));
    } on TimeoutException catch (_) {
      throw ServerException(message: 'Request timeout. Server tidak merespon.');
    } on SocketException catch (_) {
      throw ServerException(
        message: 'Koneksi gagal. Periksa IP dan WiFi Anda.',
      );
    }

    dev.log(
      'AuthRemoteDataSource: Respon login diterima. Status: ${response.statusCode}',
      name: 'AuthDebug',
    );
    final responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      dev.log('AuthRemoteDataSource: Login sukses.', name: 'AuthDebug');
      return AuthResultModel.fromJson(responseData);
    } else if (response.statusCode == 422 || response.statusCode == 401) {
      final message = 'Email atau password salah';
      dev.log('AuthRemoteDataSource: Login Gagal: $message', name: 'AuthDebug');
      throw ServerException(message: message);
    } else {
      throw ServerException(
        message: responseData['message'] ?? 'Unknown Server Error',
      );
    }
  }

  // --- 3. FUNGSI GET PROFILE (DIPERBAIKI) ---
  @override
  Future<UserModel> getUserProfile(String token) async {
    // Sesuai 'api.php' Anda, endpointnya adalah '/profile'
    final profileUrl = Uri.parse('$_baseUrl/profile');
    dev.log(
      'AuthRemoteDataSource: Memvalidasi token ke /api/profile...',
      name: 'AuthDebug',
    );

    http.Response response;
    try {
      response = await client
          .get(
            profileUrl,
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 10));
    } on TimeoutException catch (e) {
      dev.log(
        'AuthRemoteDataSource: ERROR - TimeoutException: $e',
        name: 'AuthDebug',
      );
      throw ServerException(message: 'Gagal validasi token: Timeout');
    } on SocketException catch (e) {
      dev.log(
        'AuthRemoteDataSource: ERROR - SocketException: $e',
        name: 'AuthDebug',
      );
      throw ServerException(message: 'Gagal validasi token: Koneksi gagal');
    }

    dev.log(
      'AuthRemoteDataSource: Respon profile diterima. Status: ${response.statusCode}',
      name: 'AuthDebug',
    );

    if (response.statusCode == 200) {
      // AuthController@profile Anda mengembalikan user secara langsung
      final responseData = json.decode(response.body);
      return UserModel.fromJson(responseData);
    } else {
      dev.log(
        'AuthRemoteDataSource: Validasi token gagal. Body: ${response.body}',
        name: 'AuthDebug',
      );
      throw ServerException(message: 'Token tidak valid atau kadaluwarsa.');
    }
  }
}
