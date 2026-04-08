import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/schedule_item.dart';
import '../data/schedule_repository.dart';

abstract class ScheduleState {}
class ScheduleLoading extends ScheduleState {}
class ScheduleLoaded extends ScheduleState {
  final List<ScheduleItem> items;
  ScheduleLoaded(this.items);
}
class ScheduleError extends ScheduleState {
  final String message;
  ScheduleError(this.message);
}

class ScheduleCubit extends Cubit<ScheduleState> {
  final ScheduleRepository repository;
  ScheduleCubit(this.repository) : super(ScheduleLoading());

  Future<void> loadSchedule() async {
    try {
      emit(ScheduleLoading());
      final items = await repository.fetchSchedule();
      emit(ScheduleLoaded(items));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  Future<void> deleteItem(int id) async {
    final success = await repository.deleteScheduleItem(id);
    if (success) await loadSchedule();
  }

  Future<void> addItem(ScheduleItem item) async {
    final success = await repository.createScheduleItem(item);
    if (success) await loadSchedule();
  }
}