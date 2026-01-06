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
}
