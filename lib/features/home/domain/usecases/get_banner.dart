// lib/features/home/domain/usecases/get_banners.dart
import 'package:dartz/dartz.dart';
import 'package:emotcare_apps/core/error/failures.dart';
import 'package:emotcare_apps/features/home/domain/entities/banner.dart';
import 'package:emotcare_apps/features/home/domain/repositories/banner_repository.dart';

class GetBanners {
  final BannerRepository repository;
  GetBanners(this.repository);

  Future<Either<Failure, List<BannerEntity>>> call({
    required String token,
  }) async {
    return await repository.getBanners(token: token);
  }
}