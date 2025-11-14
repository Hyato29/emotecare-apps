// lib/features/education/domain/repositories/education_repository.dart
import 'package:dartz/dartz.dart';
import 'package:emotcare_apps/core/error/failures.dart';
// --- UBAH IMPORT INI ---
// (Kita butuh VideoEducationLists)
import 'package:emotcare_apps/features/video_education/domain/entities/video_education.dart';
// ----------------------

abstract class EducationRepository {
  // --- UBAH TIPE KEMBALIAN INI ---
  Future<Either<Failure, VideoEducationLists>> getVideoEducations({
    required String token,
  });
  // --------------------------------

  Future<Either<Failure, void>> markVideoAsWatched({
    required String token,
    required int videoId,
  });
}