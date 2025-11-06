// lib/features/auth/domain/usecases/register_user.dart

import 'package:dartz/dartz.dart';
import 'package:emotcare_apps/core/error/failures.dart';
import 'package:emotcare_apps/features/auth/domain/entities/user.dart';
import 'package:emotcare_apps/features/auth/domain/repositories/auth_repository.dart';

class RegisterUser {
  final AuthRepository repository;

  RegisterUser(this.repository);

  Future<Either<Failure, AuthResult>> call({
    required String name,
    required String email,
    required String nik,
    required String contact,
    required String gender,
    required String address,
    required String password,
    required String passwordConfirmation,
  }) async {
    return await repository.register(
      name: name,
      email: email,
      nik: nik,
      contact: contact,
      gender: gender,
      address: address,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }
}