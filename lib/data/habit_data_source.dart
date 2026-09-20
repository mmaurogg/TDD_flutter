import 'dart:convert';

import 'package:habit_tracker/data/local_data_source.dart';
import 'package:habit_tracker/domain/habit.dart';
import 'package:habit_tracker/domain/habit_repository.dart';

class HabitDataSource implements HabitRepository {
  final LocalDataSource localDataSource;

  HabitDataSource({required this.localDataSource});

  @override
  Future<List<Habit>> load() async {
    late String? result;

    try {
      result = await localDataSource.get();
    } catch (e) {
      throw Exception();
    }

    if (result == null || result.isEmpty) return [];

    final List habitList = jsonDecode(result);

    return habitList.map((e) => Habit.fromJson(e)).toList();
  }

  @override
  Future<void> save(List<Habit> habits) async {
    final habitMap = habits.map((e) => e.toJson()).toList();
    try {
      final jsonString = jsonEncode(habitMap);
      await localDataSource.set(jsonString);
    } catch (e) {
      throw Exception();
    }
  }
}
