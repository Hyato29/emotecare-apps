// lib/features/schedule_control/presentation/cubit/schedule_control_state.dart
part of 'schedule_control_cubit.dart';

@immutable
abstract class ScheduleControlState {}

class ScheduleControlInitial extends ScheduleControlState {}
class ScheduleControlLoading extends ScheduleControlState {}
class ScheduleControlLoaded extends ScheduleControlState {
  final List<Schedule> upcomingSchedules; // Untuk tab "Kontrol"
  final List<Schedule> pastSchedules;     // Untuk tab "Riwayat"

  ScheduleControlLoaded({
    required this.upcomingSchedules,
    required this.pastSchedules,
  });
}
class ScheduleControlError extends ScheduleControlState {
  final String message;
  ScheduleControlError(this.message);
}