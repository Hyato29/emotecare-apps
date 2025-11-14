// lib/features/schedule_control/domain/repositories/schedule_repository.dart
import 'package:dartz/dartz.dart';
import 'package:emotcare_apps/core/error/failures.dart';
import 'package:emotcare_apps/features/schedule_control/domain/entities/schedule.dart';

abstract class ScheduleRepository {
  Future<Either<Failure, List<Schedule>>> getSchedules({
    required String token,
  });
}