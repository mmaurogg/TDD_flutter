import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/domain/habit.dart';

void main() {
  test('toggleCompleted should toggle the isCompleted property', () {
    final sut = Habit(id: 1, title: 'Test Habit');

    expect(sut.isCompleted, false);
    final updatedSut = sut.toggle();
    expect(updatedSut.isCompleted, true);
  });
}
