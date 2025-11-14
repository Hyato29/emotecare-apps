// lib/features/schedule_control/data/datasources/schedule_remote_data_source.dart
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:emotcare_apps/core/error/exceptions.dart';
import 'package:emotcare_apps/features/schedule_control/data/models/schedule_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

abstract class ScheduleRemoteDataSource {
  Future<List<ScheduleModel>> getSchedules({required String token});
}

class ScheduleRemoteDataSourceImpl implements ScheduleRemoteDataSource {
  final http.Client client;
  final String _baseUrl = dotenv.env['BASE_URL']!;

  ScheduleRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ScheduleModel>> getSchedules({required String token}) async {
    final url = Uri.parse('$_baseUrl/api/checkup-schedules');
    dev.log('ScheduleDataSource: Calling GET $url', name: 'ScheduleDebug');

    http.Response response;
    // ... (try-catch block Anda sudah benar)
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
      'ScheduleDataSource: Response status: ${response.statusCode}',
      name: 'ScheduleDebug',
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      // --- PERBAIKAN DI SINI ---
      // Ubah dari:
      // final List<dynamic> dataList = responseData['data'];

      // Menjadi (ambil list dari 'data' di dalam 'data'):
      final List<dynamic> dataList = responseData['data']['data'];
      // -------------------------

      return dataList.map((item) => ScheduleModel.fromJson(item)).toList();
    } else {
      throw ServerException(message: 'Gagal memuat jadwal kontrol');
    }
  }
}
