// lib/features/education/domain/repositories/education_repository.dart
import 'package:dartz/dartz.dart';
import 'package:emotcare_apps/core/error/failures.dart';
import 'package:emotcare_apps/features/video_education/domain/entities/video_education.dart';

abstract class EducationRepository {
  Future<Either<Failure, List<VideoEducation>>> getVideoEducations({
    required String token,
  });

  // --- TAMBAHKAN KONTRAK BARU INI ---
  Future<Either<Failure, void>> markVideoAsWatched({
    required String token,
    required int videoId,
  });
  // ---------------------------------
}
