// lib/features/education/data/repositories/education_repository_impl.dart
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:emotcare_apps/core/error/exceptions.dart';
import 'package:emotcare_apps/core/error/failures.dart';
import 'package:emotcare_apps/features/video_education/data/datasources/education_remote_data_source.dart';
// --- UBAH IMPORT INI ---
import 'package:emotcare_apps/features/video_education/domain/entities/video_education.dart';
// ----------------------
import 'package:emotcare_apps/features/video_education/domain/repositories/education_repository.dart';

class EducationRepositoryImpl implements EducationRepository {
  final EducationRemoteDataSource remoteDataSource;

  EducationRepositoryImpl({required this.remoteDataSource});

  @override
  // --- UBAH TIPE KEMBALIAN DI SINI JUGA ---
  @override
  Future<Either<Failure, VideoEducationLists>> getVideoEducations({
    required String token,
  }) async {
    try {
      // 1. Panggil data source (ini mengembalikan Model)
      final videoLists = await remoteDataSource.getVideoEducations(
        token: token,
      );

      // 2. Langsung kembalikan sebagai Entity.
      //    JANGAN taruh logika firstWhere di sini.
      return Right(videoLists);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return Left(ConnectionFailure('Gagal terhubung ke jaringan'));
    }
  }
  // ---------------------------------------

  @override
  Future<Either<Failure, void>> markVideoAsWatched({
    required String token,
    required int videoId,
  }) async {
    try {
      await remoteDataSource.markVideoAsWatched(token: token, videoId: videoId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return Left(ConnectionFailure('Gagal terhubung ke jaringan'));
    }
  }
}
