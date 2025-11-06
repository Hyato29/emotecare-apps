import 'package:dartz/dartz.dart';
import 'package:emotcare_apps/core/error/failures.dart';
import 'package:emotcare_apps/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResult>> register({
    required String name,
    required String email,
    required String nik,
    required String contact,
    required String gender,
    required String address,
    required String password,
    required String passwordConfirmation,
  });

  Future<Either<Failure, AuthResult>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> saveToken(String token);

  Future<Either<Failure, String?>> getToken();

  Future<Either<Failure, User>> getUserProfile();

  Future<Either<Failure, void>> removeToken();

  Future<Either<Failure, void>> saveCredentials(String email, String password);
  Future<Either<Failure, Map<String, String?>>> getCredentials();
  Future<Either<Failure, void>> removeCredentials();
}
