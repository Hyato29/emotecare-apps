// lib/features/prescription/data/datasources/prescription_remote_data_source.dart
import 'dart:convert';
import 'package:emotcare_apps/features/medicine/data/models/prescription_model.dart';
import 'dart:io';
import 'dart:async';
import 'package:emotcare_apps/core/error/exceptions.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

abstract class PrescriptionRemoteDataSource {
  Future<PrescriptionModel> addPrescription({
    required String token,
    required Map<String, dynamic> body,
  });

  Future<List<PrescriptionModel>> getPrescriptions({required String token});
}

class PrescriptionRemoteDataSourceImpl implements PrescriptionRemoteDataSource {
  final http.Client client;
  // GANTI IP INI SESUAI IP ANDA
  final String _baseUrl = "${dotenv.env['BASE_URL']}/api";

  PrescriptionRemoteDataSourceImpl({required this.client});

  @override
  Future<PrescriptionModel> addPrescription({
    required String token,
    required Map<String, dynamic> body,
  }) async {
    // Asumsi endpoint dari file api.php Anda
    final url = Uri.parse('$_baseUrl/prescriptions');
    dev.log('PrescriptionDataSource: Calling $url', name: 'PrescriptionDebug');

    http.Response response;
    try {
      response = await client
          .post(
            url,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode(body),
          )
          .timeout(const Duration(seconds: 10));
    } on TimeoutException catch (_) {
      throw ServerException(message: 'Request timeout');
    } on SocketException catch (_) {
      throw ServerException(message: 'Koneksi gagal');
    }

    dev.log(
      'PrescriptionDataSource: Response status: ${response.statusCode}',
      name: 'PrescriptionDebug',
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return PrescriptionModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException(message: 'Gagal menambah pengingat');
    }
  }

  @override
  Future<List<PrescriptionModel>> getPrescriptions({
    required String token,
  }) async {
    final url = Uri.parse('$_baseUrl/prescriptions');
    dev.log(
      'PrescriptionDataSource: Calling GET $url',
      name: 'PrescriptionDebug',
    );

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
      'PrescriptionDataSource: Response status: ${response.statusCode}',
      name: 'PrescriptionDebug',
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      // Asumsi API Anda mengembalikan list di dalam key 'data' (sesuai API medicines)
      final List<dynamic> dataList = responseData;
      return dataList.map((item) => PrescriptionModel.fromJson(item)).toList();
    } else {
      throw ServerException(message: 'Gagal memuat daftar pengingat');
    }
  }
}
