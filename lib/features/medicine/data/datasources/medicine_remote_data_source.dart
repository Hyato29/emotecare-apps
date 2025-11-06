// lib/features/medicine/data/datasources/medicine_remote_data_source.dart
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:emotcare_apps/core/error/exceptions.dart';
import 'package:emotcare_apps/features/medicine/data/models/medicine_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev; // <-- Tambahkan import log

abstract class MedicineRemoteDataSource {
  // --- 1. PERBAIKI DEFINISI ABSTRAK ---
  // Ubah dari (String query) menjadi named parameters
  Future<List<MedicineModel>> getMedicines({
    required String query,
    required String token,
  });
}

class MedicineRemoteDataSourceImpl implements MedicineRemoteDataSource {
  final http.Client client;
  final String _baseUrl = "${dotenv.env['BASE_URL']}/api";

  MedicineRemoteDataSourceImpl({required this.client});

  // --- 2. PERBAIKI IMPLEMENTASI FUNGSI ---
  @override
  Future<List<MedicineModel>> getMedicines({
    required String query,
    required String token,
  }) async {
    // Logika URL Anda sudah benar
    Uri url;
    if (query.isEmpty) {
      url = Uri.parse('$_baseUrl/medicines');
    } else {
      url = Uri.parse('$_baseUrl/medicines?search=$query');
    }

    dev.log(
      'MedicineDataSource: Calling API: $url',
      name: 'MedicineDebug',
    );

    http.Response response;
    try {
      response = await client.get(
        url,
        // --- 3. TAMBAHKAN HEADER OTENTIKASI ---
        // Ini adalah alasan kita membutuhkan 'token'
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));
    } on TimeoutException catch (_) {
      throw ServerException(message: 'Request timeout');
    } on SocketException catch (_) {
      throw ServerException(message: 'Koneksi gagal');
    }

    dev.log(
      'MedicineDataSource: Response status: ${response.statusCode}',
      name: 'MedicineDebug',
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final List<dynamic> dataList = responseData['data'];
      return dataList.map((item) => MedicineModel.fromJson(item)).toList();
    } else {
      // Tambahkan log ini agar Anda tahu jika token ditolak
      dev.log(
        'MedicineDataSource: Gagal. Status: ${response.statusCode}, Body: ${response.body}',
        name: 'MedicineDebug',
      );
      throw ServerException(message: 'Gagal memuat data obat. Sesi mungkin habis.');
    }
  }
}