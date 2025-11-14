// lib/features/schedule_control/domain/usecases/get_schedules.dart
import 'package:dartz/dartz.dart';
import 'package:emotcare_apps/core/error/failures.dart';
import 'package:emotcare_apps/features/schedule_control/domain/entities/schedule.dart';
import 'package:emotcare_apps/features/schedule_control/domain/repositories/schedule_repository.dart';

class GetSchedules {
  final ScheduleRepository repository;
  GetSchedules(this.repository);

  Future<Either<Failure, List<Schedule>>> call({
    required String token,
  }) async {
    return await repository.getSchedules(token: token);
  }
}