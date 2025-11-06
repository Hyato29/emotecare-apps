// lib/features/medicine/presentation/cubit/prescription_list_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:emotcare_apps/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:emotcare_apps/features/medicine/domain/entities/prescription.dart';
import 'package:emotcare_apps/features/medicine/domain/usecases/get_prescriptions.dart';
import 'package:flutter/foundation.dart';

part 'prescription_list_state.dart';

class PrescriptionListCubit extends Cubit<PrescriptionListState> {
  final GetPrescriptions getPrescriptions;
  final AuthCubit authCubit;

  PrescriptionListCubit({
    required this.getPrescriptions,
    required this.authCubit,
  }) : super(PrescriptionListInitial());

  Future<void> fetchPrescriptions() async {
    final authState = authCubit.state;
    if (authState is! Authenticated) {
      emit(PrescriptionListError("Anda harus login untuk melihat data ini."));
      return;
    }
    
    emit(PrescriptionListLoading());
    final result = await getPrescriptions(token: authState.token);
    
    result.fold(
      (failure) => emit(PrescriptionListError(failure.message)),
      (prescriptions) => emit(PrescriptionListLoaded(prescriptions)),
    );
  }
}