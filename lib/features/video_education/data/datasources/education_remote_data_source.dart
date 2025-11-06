// lib/features/education/data/datasources/education_remote_data_source.dart
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:emotcare_apps/core/error/exceptions.dart';
import 'package:emotcare_apps/features/video_education/data/models/video_education_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

abstract class EducationRemoteDataSource {
  Future<List<VideoEducationModel>> getVideoEducations({required String token});

  // --- 1. TAMBAHKAN FUNGSI BARU INI ---
  Future<void> markVideoAsWatched({
    required String token,
    required int videoId,
  });
  // ---------------------------------
}

class EducationRemoteDataSourceImpl implements EducationRemoteDataSource {
  final http.Client client;
  // --- GANTI IP INI SESUAI IP ANDA ---
  final String _baseUrl = "${dotenv.env['BASE_URL']}/api";

  EducationRemoteDataSourceImpl({required this.client});

  @override
  Future<List<VideoEducationModel>> getVideoEducations({
    required String token,
  }) async {
    final url = Uri.parse('$_baseUrl/video-educations');
    dev.log('EducationDataSource: Calling GET $url', name: 'EducationDebug');

    http.Response response;
    try {
      response = await client
          .get(
            url,
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token', // Wajib mengirim token
            },
          )
          .timeout(const Duration(seconds: 10));
    } on TimeoutException catch (_) {
      throw ServerException(message: 'Request timeout');
    } on SocketException catch (_) {
      throw ServerException(message: 'Koneksi gagal');
    }

    dev.log(
      'EducationDataSource: Response status: ${response.statusCode}',
      name: 'EducationDebug',
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      // Asumsi API Anda mengembalikan list di dalam key 'data'
      final List<dynamic> dataList = responseData;
      return dataList
          .map((item) => VideoEducationModel.fromJson(item))
          .toList();
    } else {
      throw ServerException(message: 'Gagal memuat video edukasi');
    }
  }

  // --- 2. IMPLEMENTASIKAN FUNGSI BARU ---
  @override
  Future<void> markVideoAsWatched({
    required String token,
    required int videoId,
  }) async {
    // Sesuai dengan rute API Anda: video-educations/{video}/watch
    final url = Uri.parse('$_baseUrl/video-educations/$videoId/watch');
    dev.log('EducationDataSource: Calling POST $url', name: 'EducationDebug');

    http.Response response;
    try {
      response = await client
          .post(
            url,
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 10));
    } on TimeoutException catch (_) {
      throw ServerException(message: 'Request timeout');
    } on SocketException catch (_) {
      throw ServerException(message: 'Koneksi gagal');
    }

    dev.log(
      'EducationDataSource: MarkAsWatched status: ${response.statusCode}',
      name: 'EducationDebug',
    );

    // Jika gagal (selain 200 OK), lempar error
    if (response.statusCode != 200) {
      throw ServerException(message: 'Gagal menandai video sebagai ditonton');
    }
    // Jika sukses (200), tidak perlu mengembalikan apa-apa (void)
  }

  // ------------------------------------
}
