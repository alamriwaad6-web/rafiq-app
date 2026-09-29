import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/task_cubit.dart';
import '../cubit/task_state.dart';
import '../models/task.dart';
import '../widgets/rafiq_ui.dart';
import '../widgets/challenge_dashboard.dart';
import 'add_task_screen.dart';
import 'focus_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  final String userName;
  const HomeScreen({super.key, required this.userName});
  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => TaskCubit()..loadTasks(),
    child: _HomeContent(userName: userName),
  );
}

class _HomeContent extends StatefulWidget {
  final String userName;
  const _HomeContent({required this.userName});
  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  int _tab = 0;
  Future<void> _add() async {
    final task = await Navigator.push<Task>(
      context,
      MaterialPageRoute(builder: (_) => const AddTaskScreen()),
    );
    if (mounted && task != null) await context.read<TaskCubit>().addTask(task);
  }

  Future<void> _focus(Task task, int index) async {
    final done = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => FocusScreen(task: task)),
    );
    if (mounted && done == true && !task.isCompleted) {
      await context.read<TaskCubit>().toggleTask(index);
    }
  }

  Future<void> _delete(int index, String title) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف التحدي'),
        content: Text('هل تريد حذف «$title»؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'حذف',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
    if (mounted && ok == true) {
      await context.read<TaskCubit>().deleteTask(index);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 72,
      title: _tab == 0 ? const RafiqMark() : const Text('ملفي'),
      actions: [
        if (_tab == 0)
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 16),
            child: IconButton.filledTonal(
              tooltip: 'ملفي',
              onPressed: () => setState(() => _tab = 1),
              icon: const Icon(Icons.person_outline_rounded),
            ),
          ),
      ],
    ),
    bottomNavigationBar: NavigationBar(
      selectedIndex: _tab,
      onDestinationSelected: (value) => setState(() => _tab = value),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.space_dashboard_outlined),
          selectedIcon: Icon(Icons.space_dashboard_rounded),
          label: 'اليوم',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline_rounded),
          selectedIcon: Icon(Icons.person_rounded),
          label: 'ملفي',
        ),
      ],
    ),
    floatingActionButton: _tab == 0
        ? FloatingActionButton.extended(
            onPressed: _add,
            icon: const Icon(Icons.add_rounded),
            label: const Text('تحدٍ جديد'),
          )
        : null,
    body: SafeArea(
      top: false,
      child: BlocConsumer<TaskCubit, TaskState>(
        listener: (context, state) {
          if (state is TaskError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is TaskInitial || state is TaskLoading) {
            return const Center(
              child: CircularProgressIndicator(
                semanticsLabel: 'تحميل التحديات',
              ),
            );
          }
          if (state is TaskError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message),
                  TextButton.icon(
                    onPressed: () => context.read<TaskCubit>().loadTasks(),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }
          final tasks = (state as TaskSuccess).tasks;
          final points = tasks
              .where((task) => task.isCompleted)
              .fold<int>(0, (sum, task) => sum + task.points);
          if (_tab == 1) {
            return SettingsScreen(
              taskCount: tasks.length,
              completedCount: tasks.where((t) => t.isCompleted).length,
              points: points,
            );
          }
          return ChallengeDashboard(
            userName: widget.userName,
            tasks: tasks,
            onAdd: _add,
            onToggle: (i) => context.read<TaskCubit>().toggleTask(i),
            onDelete: (i) => _delete(i, tasks[i].title),
            onFocus: (i) => _focus(tasks[i], i),
          );
        },
      ),
    ),
  );
}
