import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/ui/habit_list_screen.dart';

void main() {
  testWidgets("Renderiza correctamente", (tester) async {
    await tester.pumpWidget(MaterialApp(home: HabitListScreen()));

    expect(find.text("Agrega un habito"), findsOneWidget);
    expect(find.byKey(Key("add_button")), findsOneWidget);
  });

  testWidgets("Agrega correctamente habitos y activa filtro", (tester) async {
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

    expect(find.text("Todos"), findsOneWidget);
    expect(find.text("Completados"), findsOneWidget);
    expect(find.text("Incompletos"), findsOneWidget);
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

  testWidgets("se puede filtrar por tareas activas", (tester) async {
    await tester.pumpWidget(MaterialApp(home: HabitListScreen()));

    // Agregar items en la lista
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

    //Cambiar  el completed en algunos items
    await tester.tap(habitSwitch2);
    await tester.tap(habitSwitch3);
    await tester.pump();

    // filtrar
    await tester.tap(find.text("Completados"));
    await tester.pump();
    expect(find.byType(ListTile), findsExactly(2));

    await tester.tap(find.text("Incompletos"));
    await tester.pump();
    expect(find.byType(ListTile), findsExactly(1));

    await tester.tap(find.text("Todos"));
    await tester.pump();
    expect(find.byType(ListTile), findsExactly(3));
  });
}
