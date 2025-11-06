import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

part 'report_complaint_state.dart';

class ReportComplaintCubit extends Cubit<ReportComplaintState> {
  ReportComplaintCubit() : super(ReportComplaintInitial());

  // Fungsi untuk tombol "Laporkan"
  Future<void> submitReport({
    required String symptom,
    required String frequency,
    required String date,
  }) async {
    // Validasi
    if (symptom.isEmpty || frequency.isEmpty || date.isEmpty) {
      emit(ReportComplaintSubmitFailure("Semua field harus diisi."));
      return;
    }

    emit(ReportComplaintSubmitLoading());
    try {
      // (Simulasi panggilan API)
      await Future.delayed(const Duration(seconds: 2));

      // Kirim state sukses untuk memicu dialog
      emit(ReportComplaintSubmitSuccess());
    } catch (e) {
      emit(ReportComplaintSubmitFailure(e.toString()));
    }
  }

  // Fungsi untuk mengambil data riwayat
  Future<void> fetchHistory() async {
    emit(HistoryLoading());
    try {
      // (Simulasi panggilan API)
      await Future.delayed(const Duration(milliseconds: 800));

      // Data dummy
      final List<ReportComplaintHistory> dummyData = [
        ReportComplaintHistory(
          date: '17 Agustus 2025',
          symptom: 'Kebas di Tangan',
        ),
        ReportComplaintHistory(
          date: '06 Juli 2025',
          symptom: 'Urin Berwarna Merah',
        ),
      ];

      emit(HistoryLoaded(dummyData));
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }
}
