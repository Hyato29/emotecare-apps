// lib/features/home/data/repositories/banner_repository_impl.dart
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:emotcare_apps/core/error/exceptions.dart';
import 'package:emotcare_apps/core/error/failures.dart';
import 'package:emotcare_apps/features/home/data/datasources/banner_remote_data_source.dart';
import 'package:emotcare_apps/features/home/domain/entities/banner.dart';
import 'package:emotcare_apps/features/home/domain/repositories/banner_repository.dart';

class BannerRepositoryImpl implements BannerRepository {
  final BannerRemoteDataSource remoteDataSource;

  BannerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<BannerEntity>>> getBanners({
    required String token,
  }) async {
    try {
      final banners = await remoteDataSource.getBanners(token: token);
      return Right(banners);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return Left(ConnectionFailure('Gagal terhubung ke jaringan'));
    }
  }
}