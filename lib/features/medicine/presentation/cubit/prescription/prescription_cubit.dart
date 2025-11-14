// lib/features/prescription/presentation/cubit/prescription_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:emotcare_apps/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:emotcare_apps/features/medicine/domain/entities/prescription.dart';
import 'package:emotcare_apps/features/medicine/domain/usecases/add_prescription.dart';
import 'package:flutter/foundation.dart';

part 'prescription_state.dart';

class PrescriptionCubit extends Cubit<PrescriptionState> {
  final AddPrescription addPrescription;
  final AuthCubit authCubit;

  PrescriptionCubit({
    required this.addPrescription,
    required this.authCubit,
  }) : super(PrescriptionInitial());

  Future<void> submitPrescription({
    required int medicineId,
    required String dosage,
    required String duration,
    required String frequency,
    required String instructions,
  }) async {
    final authState = authCubit.state;
    if (authState is! Authenticated) {
      emit(PrescriptionFailure("Sesi Anda telah habis. Silakan login kembali."));
      return;
    }
    
    // Ambil token dari AuthCubit
    final String token = authState.token;
    
    emit(PrescriptionLoading());
    
    final result = await addPrescription(
      token: token,
      medicineId: medicineId,
      dosage: dosage,
      duration: duration,
      frequency: frequency,
      instructions: instructions,
    );

    result.fold(
      (failure) => emit(PrescriptionFailure(failure.message)),
      (prescription) => emit(PrescriptionSuccess(prescription)),
    );
  }
}