// lib/features/medicine/domain/repositories/medicine_repository.dart
import 'package:dartz/dartz.dart';
import 'package:emotcare_apps/core/error/failures.dart';
import 'package:emotcare_apps/features/medicine/domain/entities/medicine.dart';

abstract class MedicineRepository {
  // --- PERBARUI FUNGSI INI ---
  Future<Either<Failure, List<Medicine>>> getMedicines({
    required String query,
    required String token, // <-- Tambahkan token
  });
}