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

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}
