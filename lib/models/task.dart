class Task {
  final String title;
  final String description;
  final String? category;
  final bool isCompleted;
  final int durationMinutes;
  final int points;

  Task({
    required this.title,
    required this.description,
    this.category,
    this.isCompleted = false,
    this.durationMinutes = 25,
    this.points = 20,
  });

  Task copyWith({
    String? title,
    String? description,
    String? category,
    bool? isCompleted,
    int? durationMinutes,
    int? points,
  }) {
    return Task(
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      points: points ?? this.points,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'isCompleted': isCompleted,
      'durationMinutes': durationMinutes,
      'points': points,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
      durationMinutes: json['durationMinutes'] as int? ?? 25,
      points: json['points'] as int? ?? 20,
    );
  }
}
