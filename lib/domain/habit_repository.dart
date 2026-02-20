import 'package:habit_tracker/domain/habit.dart';

abstract interface class HabitRepository {
  Future<List<Habit>> load();
  Future<void> save(List<Habit> habits);
}
