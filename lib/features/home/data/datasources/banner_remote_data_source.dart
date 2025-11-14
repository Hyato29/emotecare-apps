// lib/features/home/data/datasources/banner_remote_data_source.dart
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:emotcare_apps/core/error/exceptions.dart';
import 'package:emotcare_apps/features/home/data/models/banner_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

abstract class BannerRemoteDataSource {
  Future<List<BannerModel>> getBanners({required String token});
}

class BannerRemoteDataSourceImpl implements BannerRemoteDataSource {
  final http.Client client;
  final String _baseUrl = "${dotenv.env['BASE_URL']}/api";

  BannerRemoteDataSourceImpl({required this.client});

  @override
  Future<List<BannerModel>> getBanners({required String token}) async {
    final url = Uri.parse('$_baseUrl/information-banners');
    dev.log('BannerDataSource: Calling GET $url', name: 'BannerDebug');

    http.Response response;
    try {
      response = await client.get(
        url,
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
      'BannerDataSource: Response status: ${response.statusCode}',
      name: 'BannerDebug',
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final List<dynamic> dataList = responseData['data'];
      return dataList.map((item) => BannerModel.fromJson(item)).toList();
    } else {
      throw ServerException(message: 'Gagal memuat data banner');
    }
  }
}