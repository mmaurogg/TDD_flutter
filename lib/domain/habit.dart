import 'package:flutter/foundation.dart';

class Habit {
  final int id;
  final String title;
  final bool isCompleted;
  final DateTime? completedAt;

  Habit({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.completedAt,
  });

  Habit copyWith({
    int? id,
    String? title,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt,
    );
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      title: json['title'],
      isCompleted: json['isCompleted'],
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
    );
  }

  Habit toggle() {
    return copyWith(
      isCompleted: !isCompleted,
      completedAt: isCompleted ? null : DateTime.now(),
    );
  }
}
