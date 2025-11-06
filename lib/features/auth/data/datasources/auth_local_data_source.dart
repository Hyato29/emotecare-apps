// lib/features/auth/data/datasources/auth_local_data_source.dart
import 'package:emotcare_apps/core/error/exceptions.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'dart:developer' as dev;

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> removeToken();

  Future<void> saveCredentials(String email, String password);
  Future<Map<String, String?>> getCredentials();
  Future<void> removeCredentials();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage storage;
  final String _tokenKey = 'AUTH_TOKEN';
  // --- TAMBAHKAN INI ---
  final String _emailKey = 'AUTH_EMAIL';
  final String _passwordKey = 'AUTH_PASSWORD';

  AuthLocalDataSourceImpl({required this.storage});

  @override
  Future<String?> getToken() async {
    try {
      dev.log(
        'AuthLocalDataSource: Membaca token dari SecureStorage...',
        name: 'AuthDebug',
      );
      final token = await storage.read(key: _tokenKey);

      if (token != null) {
        dev.log('AuthLocalDataSource: Token ditemukan.', name: 'AuthDebug');
      } else {
        dev.log(
          'AuthLocalDataSource: Token TIDAK ditemukan (null).',
          name: 'AuthDebug',
        );
      }
      return token;
    } catch (e) {
      dev.log(
        'AuthLocalDataSource: GAGAL membaca token: $e',
        name: 'AuthDebug',
      );
      throw CacheException(message: 'Gagal membaca token');
    }
  }

  @override
  Future<void> saveToken(String token) async {
    try {
      dev.log(
        'AuthLocalDataSource: Menyimpan token ke SecureStorage...',
        name: 'AuthDebug',
      );
      await storage.write(key: _tokenKey, value: token);
      dev.log(
        'AuthLocalDataSource: Token berhasil ditulis ke storage.',
        name: 'AuthDebug',
      );
    } catch (e) {
      dev.log(
        'AuthLocalDataSource: GAGAL menulis token ke storage: $e',
        name: 'AuthDebug',
      );
      throw CacheException(message: 'Gagal menyimpan token');
    }
  }

  @override
  Future<void> removeToken() async {
    try {
      await storage.delete(key: _tokenKey);
    } catch (e) {
      throw CacheException(message: 'Gagal menghapus token');
    }
  }

  @override
  Future<void> saveCredentials(String email, String password) async {
    try {
      dev.log(
        'AuthLocalDataSource: Menyimpan email & pass...',
        name: 'AuthDebug',
      );
      await storage.write(key: _emailKey, value: email);
      await storage.write(key: _passwordKey, value: password);
    } catch (e) {
      throw CacheException(message: 'Gagal menyimpan credential');
    }
  }

  @override
  Future<Map<String, String?>> getCredentials() async {
    try {
      dev.log(
        'AuthLocalDataSource: Membaca email & pass...',
        name: 'AuthDebug',
      );
      final email = await storage.read(key: _emailKey);
      final password = await storage.read(key: _passwordKey);
      return {'email': email, 'password': password};
    } catch (e) {
      throw CacheException(message: 'Gagal membaca credential');
    }
  }

  @override
  Future<void> removeCredentials() async {
    try {
      dev.log(
        'AuthLocalDataSource: Menghapus email & pass...',
        name: 'AuthDebug',
      );
      await storage.delete(key: _emailKey);
      await storage.delete(key: _passwordKey);
    } catch (e) {
      throw CacheException(message: 'Gagal menghapus credential');
    }
  }
}
