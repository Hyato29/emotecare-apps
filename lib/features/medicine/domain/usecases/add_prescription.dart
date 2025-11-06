// lib/features/prescription/domain/usecases/add_prescription.dart
import 'package:dartz/dartz.dart';
import 'package:emotcare_apps/core/error/failures.dart';
import 'package:emotcare_apps/features/medicine/domain/entities/prescription.dart';
import 'package:emotcare_apps/features/medicine/domain/repositories/prescription_repository.dart';

class AddPrescription {
  final PrescriptionRepository repository;

  AddPrescription(this.repository);

  Future<Either<Failure, Prescription>> call({
    required String token,
    required int medicineId,
    required String dosage,
    required String duration,
    required String frequency,
    required String instructions,
  }) async {
    return await repository.addPrescription(
      token: token,
      medicineId: medicineId,
      dosage: dosage,
      duration: duration,
      frequency: frequency,
      instructions: instructions,
    );
  }
}