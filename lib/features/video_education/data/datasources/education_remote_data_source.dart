// lib/features/education/data/datasources/education_remote_data_source.dart
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:emotcare_apps/core/error/exceptions.dart';
// --- UBAH IMPORT INI ---
// (Kita sekarang butuh VideoEducationListsModel)
import 'package:emotcare_apps/features/video_education/data/models/video_education_model.dart';
// ----------------------
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

abstract class EducationRemoteDataSource {
  // --- UBAH TIPE KEMBALIAN INI ---
  Future<VideoEducationListsModel> getVideoEducations({required String token});
  // --------------------------------

  Future<void> markVideoAsWatched({
    required String token,
    required int videoId,
  });
}

class EducationRemoteDataSourceImpl implements EducationRemoteDataSource {
  final http.Client client;
  final String _baseUrl = "${dotenv.env['BASE_URL']}/api";

  EducationRemoteDataSourceImpl({required this.client});

  @override
  // --- UBAH TIPE KEMBALIAN DI SINI JUGA ---
  Future<VideoEducationListsModel> getVideoEducations({
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
      'EducationDataSource: Response status: ${response.statusCode}',
      name: 'EducationDebug',
    );

    if (response.statusCode == 200) {
      // --- PERBAIKI LOGIKA PARSING ---
      // 1. Decode response body
      final responseData = json.decode(response.body);

      // 2. Langsung parse JSON object (bukan list)
      //    menggunakan VideoEducationListsModel.fromJson
      return VideoEducationListsModel.fromJson(responseData);
      // -------------------------------
    } else {
      throw ServerException(message: 'Gagal memuat video edukasi');
    }
  }

  @override
  Future<void> markVideoAsWatched({
    required String token,
    required int videoId,
  }) async {
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

    if (response.statusCode != 200) {
      throw ServerException(message: 'Gagal menandai video sebagai ditonton');
    }
  }
}