// lib/features/auth/domain/usecases/get_credentials.dart
import 'package:dartz/dartz.dart';
import 'package:emotcare_apps/core/error/failures.dart';
import 'package:emotcare_apps/features/auth/domain/repositories/auth_repository.dart';

class GetCredentials {
  final AuthRepository repository;
  GetCredentials(this.repository);

  Future<Either<Failure, Map<String, String?>>> call() async {
    return await repository.getCredentials();
  }
}