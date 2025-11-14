// lib/features/education/domain/usecases/get_video_educations.dart
import 'package:dartz/dartz.dart';
import 'package:emotcare_apps/core/error/failures.dart';
// --- UBAH IMPORT INI ---
import 'package:emotcare_apps/features/video_education/domain/entities/video_education.dart';
// ----------------------
import 'package:emotcare_apps/features/video_education/domain/repositories/education_repository.dart';

class GetVideoEducations {
  final EducationRepository repository;

  GetVideoEducations(this.repository);

  // --- UBAH TIPE KEMBALIAN DI SINI ---
  Future<Either<Failure, VideoEducationLists>> call({
    required String token,
  }) async {
    return await repository.getVideoEducations(token: token);
  }
  // ------------------------------------
}