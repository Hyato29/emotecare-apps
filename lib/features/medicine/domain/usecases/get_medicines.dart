// lib/features/medicine/domain/usecases/get_medicines.dart
import 'package:dartz/dartz.dart';
import 'package:emotcare_apps/core/error/failures.dart';
import 'package:emotcare_apps/features/medicine/domain/entities/medicine.dart';
import 'package:emotcare_apps/features/medicine/domain/repositories/medicine_repository.dart';

class GetMedicines {
  final MedicineRepository repository;
  GetMedicines(this.repository);

  // --- PERBARUI FUNGSI INI ---
  Future<Either<Failure, List<Medicine>>> call({
    required String query,
    required String token, // <-- Tambahkan token
  }) async {
    return await repository.getMedicines(query: query, token: token);
  }
}