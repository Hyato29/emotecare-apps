// lib/features/medicine/presentation/cubit/medicine_search_cubit.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:emotcare_apps/features/medicine/domain/entities/medicine.dart';
import 'package:emotcare_apps/features/medicine/domain/usecases/get_medicines.dart';
import 'package:flutter/foundation.dart';
import 'package:emotcare_apps/features/auth/presentation/cubit/auth/auth_cubit.dart';

part 'medicine_state.dart';

class MedicineCubit extends Cubit<MedicineState> {
  final GetMedicines getMedicines;
  final AuthCubit authCubit;
  Timer? _debouncer;

  MedicineCubit({
    required this.getMedicines,
    required this.authCubit,
  }) : super(MedicineInitial());

  // --- FUNGSI _getToken() SUDAH DIHAPUS KARENA TIDAK DIPERLUKAN LAGI ---

  Future<void> _executeFetch(String query) async {
    final authState = authCubit.state;

    // 1. Cek apakah user sudah login
    if (authState is Authenticated) {
      
      // 2. Ambil token langsung dari state (INI SUDAH BENAR)
      final token = authState.token; 
      
      emit(MedicineLoading());
      
      // 3. Panggil use case dengan token
      final result = await getMedicines(query: query, token: token);
      
      result.fold(
        (failure) => emit(MedicineError(failure.message)),
        (medicines) => emit(MedicineLoaded(medicines)),
      );

    } else {
      // Jika pengguna belum login (Unauthenticated, Initial, dll)
      emit(MedicineError("Anda harus login untuk melihat data obat."));
    }
  }

  // Fungsi ini sudah benar
  Future<void> fetchInitialMedicines() async {
    _executeFetch(""); // Panggil helper
  }

  // Fungsi ini sudah benar
  void searchMedicines(String query) {
    if (_debouncer?.isActive ?? false) _debouncer!.cancel();
    _debouncer = Timer(const Duration(milliseconds: 500), () {
      if (query.isEmpty) {
        fetchInitialMedicines();
      } else {
        _executeFetch(query); // Panggil helper
      }
    });
  }
  
  // Fungsi ini sudah benar
  @override
  Future<void> close() {
    _debouncer?.cancel();
    return super.close();
  }
}