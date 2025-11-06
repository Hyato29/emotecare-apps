// lib/features/education/data/repositories/education_repository_impl.dart
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:emotcare_apps/core/error/exceptions.dart';
import 'package:emotcare_apps/core/error/failures.dart';
import 'package:emotcare_apps/features/video_education/data/datasources/education_remote_data_source.dart';
import 'package:emotcare_apps/features/video_education/domain/entities/video_education.dart';
import 'package:emotcare_apps/features/video_education/domain/repositories/education_repository.dart';

class EducationRepositoryImpl implements EducationRepository {
  final EducationRemoteDataSource remoteDataSource;

  EducationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<VideoEducation>>> getVideoEducations({
    required String token,
  }) async {
    try {
      final videos = await remoteDataSource.getVideoEducations(token: token);
      return Right(videos);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return Left(ConnectionFailure('Gagal terhubung ke jaringan'));
    }
  }
}
