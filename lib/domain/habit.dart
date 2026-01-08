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

  Habit toggle() {
    return copyWith(
      isCompleted: !isCompleted,
      completedAt: isCompleted ? null : DateTime.now(),
    );
  }
}
