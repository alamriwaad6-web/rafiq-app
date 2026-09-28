import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/task_cubit.dart';
import '../cubit/task_state.dart';
import '../models/task.dart';
import 'add_task_screen.dart';
import 'focus_screen.dart';

class HomeScreen extends StatelessWidget {
  final String userName;

  const HomeScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskCubit()..loadTasks(),
      child: _HomeContent(userName: userName),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final String userName;

  const _HomeContent({required this.userName});

  Future<void> _openAddTaskScreen(BuildContext context) async {
    final task = await Navigator.push<Task>(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskScreen()),
    );

    if (!context.mounted || task == null) return;

    await context.read<TaskCubit>().addTask(task);
  }

  void _openFocusScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FocusScreen()),
    );
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
          child: Text('مرحبًا $userName'),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF2F6538),
        foregroundColor: const Color(0xFFFFF2B3),
        onPressed: () => _openAddTaskScreen(context),
        icon: const Icon(Icons.add),
        label: const Text('إضافة مهمة'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        backgroundColor: const Color(0xFFFFF9ED),
        selectedItemColor: const Color(0xFF2F6338),
        unselectedItemColor: const Color(0xFF77736B),
        onTap: (index) {
          if (index == 1) {
            _openAddTaskScreen(context);
          } else if (index == 2) {
            _openFocusScreen(context);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'إضافة مهمة',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer_outlined),
            label: 'التركيز',
          ),
        ],
      ),
      body: BlocListener<TaskCubit, TaskState>(
        listener: (context, state) {
          if (state is TaskError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: BlocBuilder<TaskCubit, TaskState>(
          builder: (context, state) {
            if (state is TaskInitial || state is TaskLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TaskError) {
              return Center(child: Text(state.message));
            }

            final tasks = (state as TaskSuccess).tasks;
            return _buildTaskContent(context, tasks);
          },
        ),
      ),
    );
  }

  Widget _buildTaskContent(BuildContext context, List<Task> tasks) {
    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        Text(
          'أهلًا بك يا $userName في رفيق',
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
            onPressed: () => _openFocusScreen(context),
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
        if (tasks.isEmpty)
          const Text('ما عندك مهام مضافة بعد.')
        else
          ...List.generate(tasks.length, (index) {
            final task = tasks[index];

            return Directionality(
              textDirection: TextDirection.rtl,
              child: Card(
                color: const Color(0xFFFFF2B3),
                child: CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: const Color(0xFFD6A500),
                  value: task.isCompleted,
                  onChanged: (_) {
                    context.read<TaskCubit>().toggleTask(index);
                  },
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
    );
  }
}
