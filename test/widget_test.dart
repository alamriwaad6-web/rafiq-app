import 'package:first_app1/models/task.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Task', () {
    test('keeps challenge duration and points when serialized', () {
      final task = Task(
        title: 'مراجعة الفصل',
        description: 'الفصل الأول',
        category: 'مذاكرة',
        durationMinutes: 45,
        points: 35,
      );
      final restored = Task.fromJson(task.toJson());
      expect(restored.title, task.title);
      expect(restored.durationMinutes, 45);
      expect(restored.points, 35);
    });

    test('loads old saved tasks with safe defaults', () {
      final task = Task.fromJson({
        'title': 'مهمة قديمة',
        'description': '',
        'isCompleted': false,
      });
      expect(task.durationMinutes, 25);
      expect(task.points, 20);
    });

    test('copyWith preserves data and changes completion', () {
      final task = Task(title: 'تحدٍ', description: '');
      final completed = task.copyWith(isCompleted: true);
      expect(completed.isCompleted, isTrue);
      expect(completed.title, task.title);
    });
  });
}
