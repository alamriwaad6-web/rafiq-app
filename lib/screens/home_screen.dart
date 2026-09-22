import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task.dart';
import 'add_task_screen.dart';
import 'focus_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;

  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _prefs = SharedPreferencesAsync();
  final List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final savedTasks = await _prefs.getStringList('tasks') ?? [];

    if (!mounted) return;

    setState(() {
      _tasks.addAll(
        savedTasks.map(
          (item) => Task.fromJson(jsonDecode(item) as Map<String, dynamic>),
        ),
      );
    });
  }

  Future<void> _saveTasks() async {
    await _prefs.setStringList(
      'tasks',
      _tasks.map((task) => jsonEncode(task.toJson())).toList(),
    );
  }

  Future<void> _openAddTaskScreen() async {
    final task = await Navigator.push<Task>(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskScreen()),
    );

    if (!mounted || task == null) return;

    setState(() => _tasks.add(task));
    await _saveTasks();
  }

  Future<void> _toggleTask(int index) async {
    final task = _tasks[index];

    setState(() {
      _tasks[index] = Task(
        title: task.title,
        description: task.description,
        category: task.category,
        isCompleted: !task.isCompleted,
      );
    });

    await _saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9ED),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF9ED),
        automaticallyImplyLeading: false,

        title: Align(
          alignment: Alignment.centerRight,
          child: Text('مرحبًا ${widget.userName}'),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF2F6538),
        foregroundColor: const Color(0xFFFFF2B3),
        onPressed: _openAddTaskScreen,
        icon: const Icon(Icons.add),
        label: const Text('إضافة مهمة'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(28),
        children: [
          Text(
            'أهلًا بك يا ${widget.userName} في رفيق',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4B914E),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'جاهزة لبدء جلسة مذاكرة جديدة؟',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Color(0xFF77736B)),
          ),
          const SizedBox(height: 35),
          SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FocusScreen()),
                );
              },
              icon: const Icon(Icons.timer_outlined),
              label: const Text('ابدأ وضع التركيز'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4B914E),
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 35),
          const Text(
            'مهام اليوم',
            textAlign: TextAlign.right,

            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (_tasks.isEmpty)
            const Text('ما عندك مهام مضافة بعد.')
          else
            ...List.generate(_tasks.length, (index) {
              final task = _tasks[index];

              return Directionality(
                textDirection: TextDirection.rtl,
                child: Card(
                  color: const Color(0xFFFFF2B3),
                  child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: const Color(0xFFD6A500),
                    value: task.isCompleted,
                    onChanged: (_) => _toggleTask(index),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (task.description.isNotEmpty) Text(task.description),
                        if (task.category != null) Text(task.category!),
                      ],
                    ),
                  ),
                ),
              );
            }),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
