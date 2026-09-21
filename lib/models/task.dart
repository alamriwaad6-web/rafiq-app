class Task {
  final String title;
  final String description;
  final String? category;
  final bool isCompleted;

  Task({
    required this.title,
    required this.description,
    this.category,
    this.isCompleted = false,
  });
}
