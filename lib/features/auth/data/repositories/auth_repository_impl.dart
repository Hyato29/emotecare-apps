// lib/features/auth/data/repositories/auth_repository_impl.dart

import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:emotcare_apps/core/error/exceptions.dart';
import 'package:emotcare_apps/core/error/failures.dart';
import 'package:emotcare_apps/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:emotcare_apps/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:emotcare_apps/features/auth/domain/entities/user.dart';
import 'package:emotcare_apps/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, AuthResult>> register({
    required String name,
    required String email,
    required String nik,
    required String contact,
    required String gender,
    required String address,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final body = {
        'name': name,
        'email': email,
        'nik': nik,
        'contact': contact,
        'gender': gender,
        'address': address,
        'password': password,
        'password_confirmation': passwordConfirmation,
      };
      final result = await remoteDataSource.register(body);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, AuthResult>> login({
    required String email,
    required String password,
  }) async {
    try {
      final body = {'email': email, 'password': password};
      final result = await remoteDataSource.login(body);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String?>> getToken() async {
    try {
      final token = await localDataSource.getToken();
      return Right(token);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> saveToken(String token) async {
    try {
      await localDataSource.saveToken(token);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> getUserProfile() async {
    try {
      // 1. Ambil token dari storage dulu
      final token = await localDataSource.getToken();
      if (token == null) {
        return Left(CacheFailure('Token tidak ditemukan'));
      }
      // 2. Validasi token ke server
      final user = await remoteDataSource.getUserProfile(token);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeToken() async {
    try {
      await localDataSource.removeToken();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Map<String, String?>>> getCredentials() async {
    try {
      final credentials = await localDataSource.getCredentials();
      return Right(credentials);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeCredentials() async {
    try {
      await localDataSource.removeCredentials();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> saveCredentials(
    String email,
    String password,
  ) async {
    try {
      await localDataSource.saveCredentials(email, password);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
