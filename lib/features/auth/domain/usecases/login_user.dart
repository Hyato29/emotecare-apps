// lib/features/auth/domain/usecases/login_user.dart
import 'package:dartz/dartz.dart';
import 'package:emotcare_apps/core/error/failures.dart';
import 'package:emotcare_apps/features/auth/domain/entities/user.dart';
import 'package:emotcare_apps/features/auth/domain/repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository repository;
  LoginUser(this.repository);

  Future<Either<Failure, AuthResult>> call({
    required String email,
    required String password,
  }) async {
    return await repository.login(email: email, password: password);
  }
}