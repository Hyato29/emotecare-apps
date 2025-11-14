// lib/features/schedule_control/domain/entities/schedule.dart
import 'package:equatable/equatable.dart';

class Schedule extends Equatable {
  final int id;
  final String scheduleDate;
  final String scheduleTime;
  final String location;
  final String status; // Misal: 'pending' atau 'completed'

  const Schedule({
    required this.id,
    required this.scheduleDate,
    required this.scheduleTime,
    required this.location,
    required this.status,
  });

  @override
  List<Object?> get props => [id, scheduleDate, scheduleTime, location, status];
}