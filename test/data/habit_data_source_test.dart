import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/data/habit_data_source.dart';
import 'package:habit_tracker/domain/habit.dart';

import '../mock/local_data_source.dart';

void main() {
  test("llama la base de datos local", () async {
    HabitDataSource dataSource = HabitDataSource(
      localDataSource: MockLocalDataSourceSuccess(),
    );

    final result = await dataSource.load();

    expect(result, isA<List<Habit>>());
  });

  test("falla la base de datos local", () async {
    HabitDataSource dataSource = HabitDataSource(
      localDataSource: MockLocalDataSourceError(),
    );

    expect(dataSource.load(), throwsException);
  });

  /*   test("salva en la base de datos local", () async {
    HabitDataSource dataSource = HabitDataSource(
      localDataSource: MockLocalDataSourceError(),
    );

    final habits = <Habit>[];

    await dataSource.save(habits);

    expect(actual, matcher)
  }); */
}
