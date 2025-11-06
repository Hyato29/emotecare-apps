// lib/features/auth/domain/usecases/remove_credentials.dart
import 'package:dartz/dartz.dart';
import 'package:emotcare_apps/core/error/failures.dart';
import 'package:emotcare_apps/features/auth/domain/repositories/auth_repository.dart';

class RemoveCredentials {
  final AuthRepository repository;
  RemoveCredentials(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.removeCredentials();
  }
}