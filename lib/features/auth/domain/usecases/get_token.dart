// lib/features/auth/domain/usecases/get_token.dart
import 'package:dartz/dartz.dart';
import 'package:emotcare_apps/core/error/failures.dart';
import 'package:emotcare_apps/features/auth/domain/repositories/auth_repository.dart';

class GetToken {
  final AuthRepository repository;
  GetToken(this.repository);

  Future<Either<Failure, String?>> call() async {
    return await repository.getToken();
  }
}