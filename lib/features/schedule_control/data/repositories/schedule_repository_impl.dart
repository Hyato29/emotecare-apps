// lib/features/schedule_control/data/repositories/schedule_repository_impl.dart
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:emotcare_apps/features/schedule_control/domain/entities/schedule.dart';
import 'package:emotcare_apps/features/schedule_control/domain/repositories/schedule_repository.dart';
import 'package:emotcare_apps/core/error/exceptions.dart';
import 'package:emotcare_apps/core/error/failures.dart';
import 'package:emotcare_apps/features/schedule_control/data/datasources/schedule_remote_data_source.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteDataSource remoteDataSource;

  ScheduleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Schedule>>> getSchedules({
    required String token,
  }) async {
    try {
      final schedules = await remoteDataSource.getSchedules(token: token);
      return Right(schedules);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return Left(ConnectionFailure('Gagal terhubung ke jaringan'));
    }
  }
}