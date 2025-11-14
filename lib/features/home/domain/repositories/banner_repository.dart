// lib/features/home/domain/repositories/banner_repository.dart
import 'package:dartz/dartz.dart';
import 'package:emotcare_apps/core/error/failures.dart';
import 'package:emotcare_apps/features/home/domain/entities/banner.dart';

abstract class BannerRepository {
  Future<Either<Failure, List<BannerEntity>>> getBanners({
    required String token,
  });
}