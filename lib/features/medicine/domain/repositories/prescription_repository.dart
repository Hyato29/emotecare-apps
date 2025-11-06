// lib/features/prescription/domain/repositories/prescription_repository.dart
import 'package:dartz/dartz.dart';
import 'package:emotcare_apps/core/error/failures.dart';
import 'package:emotcare_apps/features/medicine/domain/entities/prescription.dart';

abstract class PrescriptionRepository {
  // Kontrak untuk 'Tambah Pengingat'
  Future<Either<Failure, Prescription>> addPrescription({
    required String token,
    required int medicineId,
    required String dosage,
    required String duration,
    required String frequency,
    required String instructions,
  });

  // Kontrak untuk 'Melihat Daftar Pengingat'
  Future<Either<Failure, List<Prescription>>> getPrescriptions({
    required String token,
  });
}