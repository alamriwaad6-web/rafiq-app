import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task.dart';
import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial());

  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();
  List<Task> _tasks = [];

  Future<void> _saveTasks(List<Task> tasks) async {
    await _prefs.setStringList(
      'tasks',
      tasks.map((task) => jsonEncode(task.toJson())).toList(),
    );
    _tasks = tasks;
    emit(TaskSuccess(List.unmodifiable(_tasks)));
  }

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
    try {
      await _saveTasks([..._tasks, task]);
    } catch (_) {
      emit(TaskError('تعذر حفظ المهمة'));
      emit(TaskSuccess(List.unmodifiable(_tasks)));
    }
  }

  Future<void> toggleTask(int index) async {
    if (index < 0 || index >= _tasks.length) return;

    final task = _tasks[index];
    final updatedTasks = [..._tasks];
    updatedTasks[index] = task.copyWith(isCompleted: !task.isCompleted);

    try {
      await _saveTasks(updatedTasks);
    } catch (_) {
      emit(TaskError('تعذر تحديث المهمة'));
      emit(TaskSuccess(List.unmodifiable(_tasks)));
    }
  }

  Future<void> deleteTask(int index) async {
    if (index < 0 || index >= _tasks.length) return;

    final updatedTasks = [..._tasks]..removeAt(index);

    try {
      await _saveTasks(updatedTasks);
    } catch (_) {
      emit(TaskError('تعذر حذف المهمة'));
      emit(TaskSuccess(List.unmodifiable(_tasks)));
    }
  }
}
