// lib/features/medicine/presentation/cubit/medicine_search_state.dart
part of 'medicine_cubit.dart';

@immutable
abstract class MedicineState {}

class MedicineInitial extends MedicineState {}
class MedicineLoading extends MedicineState {}
class MedicineLoaded extends MedicineState {
  final List<Medicine> medicines;
  MedicineLoaded(this.medicines);
}
class MedicineError extends MedicineState {
  final String message;
  MedicineError(this.message);
}