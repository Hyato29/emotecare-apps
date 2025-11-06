// lib/features/auth/domain/usecases/save_token.dart
import 'package:dartz/dartz.dart';
import 'package:emotcare_apps/core/error/failures.dart';
import 'package:emotcare_apps/features/auth/domain/repositories/auth_repository.dart';

class SaveToken {
  final AuthRepository repository;
  SaveToken(this.repository);

  Future<Either<Failure, void>> call(String token) async {
    return await repository.saveToken(token);
  }
}