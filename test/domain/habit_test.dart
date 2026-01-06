import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/domain/habit.dart';

void main() {
  test('toggleCompleted should toggle the isCompleted property', () {
    final habit = Habit(title: 'Test Habit');
    expect(habit.isCompleted, false);
    habit.toggleCompleted();
    expect(habit.isCompleted, true);
  });
}
