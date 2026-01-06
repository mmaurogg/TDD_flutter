import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/ui/habit_list_screen.dart';

void main() {
  testWidgets("Renderiza correctamente", (tester) async {
    await tester.pumpWidget(MaterialApp(home: HabitListScreen()));

    expect(find.text("Agrega un habito"), findsOneWidget);
    expect(find.byKey(Key("add_button")), findsOneWidget);
  });

  testWidgets("Agrega correctamente habitos", (tester) async {
    await tester.pumpWidget(MaterialApp(home: HabitListScreen()));

    final addButton = find.byKey(Key("add_button"));
    await tester.tap(addButton);
    await tester.pump();

    expect(find.text("titulo 1"), findsOneWidget);
    expect(find.byKey(Key("habit_switch_1")), findsOneWidget);

    await tester.tap(addButton);
    await tester.pump();

    expect(find.text("titulo 2"), findsOneWidget);
    expect(find.byKey(Key("habit_switch_2")), findsOneWidget);
  });

  testWidgets("El habito debe cambiar a completado al hacer tap en el switch", (
    tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: HabitListScreen()));

    final addButton = find.byKey(Key("add_button"));
    await tester.tap(addButton);
    await tester.pump();
    await tester.tap(addButton);
    await tester.pump();
    await tester.tap(addButton);
    await tester.pump();

    final habitSwitch1 = find.byKey(Key("habit_switch_1"));
    final habitSwitch2 = find.byKey(Key("habit_switch_2"));
    final habitSwitch3 = find.byKey(Key("habit_switch_3"));

    expect(habitSwitch1, findsOneWidget);
    expect(habitSwitch2, findsOneWidget);
    expect(habitSwitch3, findsOneWidget);

    await tester.tap(habitSwitch2);
    await tester.pump();

    expect(tester.widget<Switch>(habitSwitch1).value, isFalse);
    expect(tester.widget<Switch>(habitSwitch2).value, isTrue);
    expect(tester.widget<Switch>(habitSwitch3).value, isFalse);
  });
}
