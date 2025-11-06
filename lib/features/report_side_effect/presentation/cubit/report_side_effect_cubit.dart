import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

part 'report_side_effect_state.dart';

class ReportSideEffectCubit extends Cubit<ReportSideEffectState> {
  ReportSideEffectCubit() : super(ReportSideEffectInitial());

  // Fungsi untuk tombol "Laporkan"
  Future<void> submitReport({
    required String symptom,
    required String frequency,
    required String date,
  }) async {
    // Validasi
    if (symptom.isEmpty || frequency.isEmpty || date.isEmpty) {
      emit(ReportSubmitFailure("Semua field harus diisi."));
      return;
    }
    
    emit(ReportSubmitLoading());
    try {
      // (Simulasi panggilan API)
      await Future.delayed(const Duration(seconds: 2));
      
      // Kirim state sukses untuk memicu dialog
      emit(ReportSubmitSuccess());
    } catch (e) {
      emit(ReportSubmitFailure(e.toString()));
    }
  }

  // Fungsi untuk mengambil data riwayat
  Future<void> fetchHistory() async {
    emit(HistoryLoading());
    try {
      // (Simulasi panggilan API)
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Data dummy
      final List<ReportHistory> dummyData = [
        ReportHistory(date: '17 Agustus 2025', symptom: 'Kebas di Tangan'),
        ReportHistory(date: '06 Juli 2025', symptom: 'Urin Berwarna Merah'),
      ];
      
      emit(HistoryLoaded(dummyData));
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }
}