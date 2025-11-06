// lib/features/video_education/domain/usecases/mark_video_as_watched.dart
import 'package:dartz/dartz.dart';
import 'package:emotcare_apps/core/error/failures.dart';
import 'package:emotcare_apps/features/video_education/domain/repositories/education_repository.dart';

class MarkVideoAsWatched {
  final EducationRepository repository;

  MarkVideoAsWatched(this.repository);

  Future<Either<Failure, void>> call({
    required String token,
    required int videoId,
  }) async {
    return await repository.markVideoAsWatched(
      token: token,
      videoId: videoId,
    );
  }
}