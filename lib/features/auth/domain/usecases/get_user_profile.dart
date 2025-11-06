// lib/features/auth/domain/usecases/get_user_profile.dart
import 'package:dartz/dartz.dart';
import 'package:emotcare_apps/core/error/failures.dart';
import 'package:emotcare_apps/features/auth/domain/entities/user.dart';
import 'package:emotcare_apps/features/auth/domain/repositories/auth_repository.dart';

class GetUserProfile {
  final AuthRepository repository;
  GetUserProfile(this.repository);

  Future<Either<Failure, User>> call() async {
    return await repository.getUserProfile();
  }
}