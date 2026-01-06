class Habit {
  String? title;
  bool isCompleted;
  DateTime? completedAt;

  Habit({this.title, this.isCompleted = false, this.completedAt});

  void toggleCompleted() {
    isCompleted = !isCompleted;

    if (isCompleted) {
      completedAt = DateTime.now();
    } else {
      completedAt = null;
    }
  }
}
