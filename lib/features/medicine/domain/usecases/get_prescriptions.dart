// lib/features/prescription/domain/usecases/get_prescriptions.dart
import 'package:dartz/dartz.dart';
import 'package:emotcare_apps/core/error/failures.dart';
import 'package:emotcare_apps/features/medicine/domain/entities/prescription.dart';
import 'package:emotcare_apps/features/medicine/domain/repositories/prescription_repository.dart';

class GetPrescriptions {
  final PrescriptionRepository repository;

  GetPrescriptions(this.repository);

  Future<Either<Failure, List<Prescription>>> call({
    required String token,
  }) async {
    return await repository.getPrescriptions(token: token);
  }
}