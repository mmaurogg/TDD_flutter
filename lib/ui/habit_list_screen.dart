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
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Center(child: Text("Agrega un habito"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final habit = snapshot.data![index];
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

class HabitListController {
  int id = 0;
  final habitList = <Habit>[];
  final StreamController<List<Habit>> _habitListStreamController =
      StreamController<List<Habit>>.broadcast();

  get habitListStream => _habitListStreamController.stream;

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
