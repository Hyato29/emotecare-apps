// lib/features/medicine/presentation/cubit/prescription_list_state.dart
part of 'prescription_list_cubit.dart';

@immutable
abstract class PrescriptionListState {}

class PrescriptionListInitial extends PrescriptionListState {}
class PrescriptionListLoading extends PrescriptionListState {}
class PrescriptionListLoaded extends PrescriptionListState {
  final List<Prescription> prescriptions;
  PrescriptionListLoaded(this.prescriptions);
}
class PrescriptionListError extends PrescriptionListState {
  final String message;
  PrescriptionListError(this.message);
}