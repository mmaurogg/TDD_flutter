import 'dart:async';

import 'package:flutter/material.dart';
import 'package:habit_tracker/domain/habit.dart';

class HabitListScreen extends StatelessWidget {
  HabitListScreen({super.key});

  final habitListController = HabitListController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit List'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: StreamBuilder<List<Habit>>(
        stream: habitListController.habitListStream,
        builder: (context, snapshotHabitList) {
          if (snapshotHabitList.data == null) {
            return const Center(child: Text("Agrega un habito"));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<Set<FilterType>>(
                stream: habitListController.selectedValueStream,
                builder: (context, snapshotSelected) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SegmentedButton(
                      segments: [
                        const ButtonSegment(
                          value: FilterType.all,
                          label: Text("Todos"),
                        ),
                        const ButtonSegment(
                          value: FilterType.completed,
                          label: Text("Completados"),
                        ),
                        const ButtonSegment(
                          value: FilterType.incomplete,
                          label: Text("Incompletos"),
                        ),
                      ],
                      selected: snapshotSelected.data ?? {FilterType.all},
                      onSelectionChanged: (a) {
                        habitListController.selectedValue = a;
                      },
                    ),
                  );
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: snapshotHabitList.data!.length,
                  itemBuilder: (context, index) {
                    final habit = snapshotHabitList.data![index];
                    return Padding(
                      padding: EdgeInsetsGeometry.all(8),
                      child: ListTile(
                        title: Text(habit.title),
                        trailing: Switch(
                          key: Key("habit_switch_${habit.id}"),
                          value: habit.isCompleted,
                          onChanged: (value) {
                            habitListController.updateHabit(habit);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        key: Key("add_button"),
        onPressed: habitListController.onAddHabit,
        child: const Icon(Icons.add),
      ),
    );
  }
}

enum FilterType { all, completed, incomplete }

class HabitListController {
  HabitListController() {
    selectedValueStream.listen((value) {
      switch (value.first) {
        case FilterType.all:
          _habitListStreamController.add(habitList);
          break;
        case FilterType.completed:
          final filtered = habitList
              .where((element) => element.isCompleted)
              .toList();
          _habitListStreamController.add(filtered);
          break;

        case FilterType.incomplete:
          final filtered = habitList
              .where((element) => !element.isCompleted)
              .toList();
          _habitListStreamController.add(filtered);
          break;
      }
    });
  }

  int id = 0;
  final habitList = <Habit>[];
  final StreamController<List<Habit>> _habitListStreamController =
      StreamController<List<Habit>>.broadcast();

  final StreamController<Set<FilterType>> _selectedValueStreamController =
      StreamController.broadcast();

  Stream<List<Habit>> get habitListStream => _habitListStreamController.stream;

  Stream<Set<FilterType>> get selectedValueStream =>
      _selectedValueStreamController.stream;

  set selectedValue(Set<FilterType> value) {
    _selectedValueStreamController.add(value);
  }

  void onAddHabit() {
    id = ++id;
    final newHabit = Habit(id: id, title: "titulo $id");
    habitList.add(newHabit);
    _habitListStreamController.add(habitList);
  }

  void updateHabit(Habit habit) {
    final updatedHabit = habit.toggle();
    final indexHabit = habitList.indexOf(habit);
    habitList[indexHabit] = updatedHabit;
    _habitListStreamController.add(habitList);
  }
}
