part of 'report_side_effect_cubit.dart';

// Model sederhana untuk data riwayat
class ReportHistory {
  final String date;
  final String symptom;
  ReportHistory({required this.date, required this.symptom});
}

@immutable
abstract class ReportSideEffectState {}

// Keadaan Awal
class ReportSideEffectInitial extends ReportSideEffectState {}

// Keadaan untuk Tombol "Laporkan"
class ReportSubmitLoading extends ReportSideEffectState {}
class ReportSubmitSuccess extends ReportSideEffectState {}
class ReportSubmitFailure extends ReportSideEffectState {
  final String error;
  ReportSubmitFailure(this.error);
}

// Keadaan untuk Panel "Lihat Riwayat"
class HistoryLoading extends ReportSideEffectState {}
class HistoryLoaded extends ReportSideEffectState {
  final List<ReportHistory> historyList;
  HistoryLoaded(this.historyList);
}
class HistoryError extends ReportSideEffectState {
  final String error;
  HistoryError(this.error);
}