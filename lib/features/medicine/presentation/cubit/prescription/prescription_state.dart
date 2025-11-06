// lib/features/prescription/presentation/cubit/prescription_state.dart
part of 'prescription_cubit.dart';

@immutable
abstract class PrescriptionState {}

class PrescriptionInitial extends PrescriptionState {}
class PrescriptionLoading extends PrescriptionState {}
class PrescriptionSuccess extends PrescriptionState {
  final Prescription prescription;
  PrescriptionSuccess(this.prescription);
}
class PrescriptionFailure extends PrescriptionState {
  final String message;
  PrescriptionFailure(this.message);
}