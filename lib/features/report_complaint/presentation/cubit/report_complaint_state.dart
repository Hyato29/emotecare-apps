part of 'report_complaint_cubit.dart';

// Model sederhana untuk data riwayat
class ReportComplaintHistory {
  final String date;
  final String symptom;
  ReportComplaintHistory({required this.date, required this.symptom});
}

@immutable
abstract class ReportComplaintState {}

// Keadaan Awal
class ReportComplaintInitial extends ReportComplaintState {}

// Keadaan untuk Tombol "Laporkan"
class ReportComplaintSubmitLoading extends ReportComplaintState {}
class ReportComplaintSubmitSuccess extends ReportComplaintState {}
class ReportComplaintSubmitFailure extends ReportComplaintState {
  final String error;
  ReportComplaintSubmitFailure(this.error);
}

// Keadaan untuk Panel "Lihat Riwayat"
class HistoryLoading extends ReportComplaintState {}
class HistoryLoaded extends ReportComplaintState {
  final List<ReportComplaintHistory> historyList;
  HistoryLoaded(this.historyList);
}
class HistoryError extends ReportComplaintState {
  final String error;
  HistoryError(this.error);
}