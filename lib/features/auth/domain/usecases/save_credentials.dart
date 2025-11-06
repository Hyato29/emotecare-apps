// lib/features/auth/domain/usecases/save_credentials.dart

import 'package:dartz/dartz.dart';
import 'package:emotcare_apps/core/error/failures.dart';
import 'package:emotcare_apps/features/auth/domain/repositories/auth_repository.dart';

class SaveCredentials {
  final AuthRepository repository;
  SaveCredentials(this.repository);

  Future<Either<Failure, void>> call(String email, String password) async {
    return await repository.saveCredentials(email, password);
  }
}