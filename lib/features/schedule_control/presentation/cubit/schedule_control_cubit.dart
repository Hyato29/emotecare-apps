// lib/features/schedule_control/presentation/cubit/schedule_control_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:emotcare_apps/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:emotcare_apps/features/schedule_control/domain/entities/schedule.dart';
import 'package:emotcare_apps/features/schedule_control/domain/usecases/get_schedules.dart';
import 'package:flutter/foundation.dart';

part 'schedule_control_state.dart';

class ScheduleControlCubit extends Cubit<ScheduleControlState> {
  final GetSchedules getSchedules;
  final AuthCubit authCubit;

  ScheduleControlCubit({required this.getSchedules, required this.authCubit})
    : super(ScheduleControlInitial());

  Future<void> fetchSchedules() async {
    final authState = authCubit.state;
    if (authState is! Authenticated) {
      emit(ScheduleControlError("Anda harus login untuk melihat data ini."));
      return;
    }

    emit(ScheduleControlLoading());
    final result = await getSchedules(token: authState.token);

    result.fold((failure) => emit(ScheduleControlError(failure.message)), (
      schedules,
    ) {
      // --- PERBAIKAN LOGIKA FILTER DI SINI ---
      final List<Schedule> upcoming = [];
      final List<Schedule> past = [];

      for (var schedule in schedules) {
        // Gunakan 'scheduled' (untuk Kontrol) dan 'completed' (untuk Riwayat)
        if (schedule.status == 'scheduled') {
          upcoming.add(schedule);
        } else if (schedule.status == 'completed') {
          past.add(schedule);
        }
      }
      // ------------------------------------

      emit(
        ScheduleControlLoaded(upcomingSchedules: upcoming, pastSchedules: past),
      );
    });
  }
}
