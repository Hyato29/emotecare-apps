// lib/features/medicine/data/repositories/medicine_repository_impl.dart
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:emotcare_apps/core/error/exceptions.dart';
import 'package:emotcare_apps/core/error/failures.dart';
import 'package:emotcare_apps/features/medicine/data/datasources/medicine_remote_data_source.dart';
import 'package:emotcare_apps/features/medicine/domain/entities/medicine.dart';
import 'package:emotcare_apps/features/medicine/domain/repositories/medicine_repository.dart';

class MedicineRepositoryImpl implements MedicineRepository {
  final MedicineRemoteDataSource remoteDataSource;

  MedicineRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Medicine>>> getMedicines({
    required String query,
    required String token, // <-- Tambahkan token
  }) async {
    try {
      // Teruskan token ke data source
      final medicines = await remoteDataSource.getMedicines(
        query: query,
        token: token,
      );
      return Right(medicines);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return Left(ConnectionFailure('Gagal terhubung ke jaringan'));
    }
  }
}
