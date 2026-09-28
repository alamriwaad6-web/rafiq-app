import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task.dart';
import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial());

  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();
  List<Task> _tasks = [];

  Future<void> loadTasks() async {
    emit(TaskLoading());

    try {
      final savedTasks = await _prefs.getStringList('tasks') ?? [];

      _tasks = savedTasks
          .map(
            (item) => Task.fromJson(jsonDecode(item) as Map<String, dynamic>),
          )
          .toList();

      emit(TaskSuccess(List.unmodifiable(_tasks)));
    } catch (_) {
      emit(TaskError('تعذر تحميل المهام'));
    }
  }

  Future<void> addTask(Task task) async {
    final updatedTasks = [..._tasks, task];

    try {
      await _prefs.setStringList(
        'tasks',
        updatedTasks.map((item) => jsonEncode(item.toJson())).toList(),
      );

      _tasks = updatedTasks;
      emit(TaskSuccess(List.unmodifiable(_tasks)));
    } catch (_) {
      emit(TaskError('تعذر حفظ المهمة'));
      emit(TaskSuccess(List.unmodifiable(_tasks)));
    }
  }

  Future<void> toggleTask(int index) async {
    if (index < 0 || index >= _tasks.length) return;

    final task = _tasks[index];
    final updatedTasks = [..._tasks];

    updatedTasks[index] = Task(
      title: task.title,
      description: task.description,
      category: task.category,
      isCompleted: !task.isCompleted,
    );

    try {
      await _prefs.setStringList(
        'tasks',
        updatedTasks.map((item) => jsonEncode(item.toJson())).toList(),
      );

      _tasks = updatedTasks;
      emit(TaskSuccess(List.unmodifiable(_tasks)));
    } catch (_) {
      emit(TaskError('تعذر تحديث المهمة'));
      emit(TaskSuccess(List.unmodifiable(_tasks)));
    }
  }
}
