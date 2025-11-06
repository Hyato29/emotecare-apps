// lib/features/prescription/data/repositories/prescription_repository_impl.dart
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:emotcare_apps/core/error/exceptions.dart';
import 'package:emotcare_apps/core/error/failures.dart';
import 'package:emotcare_apps/features/medicine/data/datasources/prescription_remote_data_source.dart';
import 'package:emotcare_apps/features/medicine/domain/entities/prescription.dart';
import 'package:emotcare_apps/features/medicine/domain/repositories/prescription_repository.dart';

class PrescriptionRepositoryImpl implements PrescriptionRepository {
  final PrescriptionRemoteDataSource remoteDataSource;

  PrescriptionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Prescription>> addPrescription({
    required String token,
    required int medicineId,
    required String dosage,
    required String duration,
    required String frequency,
    required String instructions,
  }) async {
    try {
      final body = {
        'medicine_id': medicineId,
        'dosage': dosage,
        'duration': duration,
        'frequency': frequency,
        'instructions': instructions,
      };
      final prescription = await remoteDataSource.addPrescription(
        token: token,
        body: body,
      );
      return Right(prescription);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return Left(ConnectionFailure('Gagal terhubung ke jaringan'));
    }
  }

  @override
  Future<Either<Failure, List<Prescription>>> getPrescriptions({
    required String token,
  }) async {
    try {
      final prescriptions = await remoteDataSource.getPrescriptions(
        token: token,
      );
      return Right(prescriptions);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return Left(ConnectionFailure('Gagal terhubung ke jaringan'));
    }
  }
}
