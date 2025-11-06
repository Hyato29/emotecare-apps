import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'schedule_control_state.dart';

class ScheduleControlCubit extends Cubit<ScheduleControlState> {
  ScheduleControlCubit() : super(ScheduleControlInitial());
}
