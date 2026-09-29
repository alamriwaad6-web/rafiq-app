import 'package:flutter/material.dart';

import '../models/task.dart';
import '../widgets/auth_shell.dart';
import '../widgets/rafiq_ui.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});
  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _category;
  int _duration = 25;
  int get _points => _duration <= 15
      ? 10
      : _duration <= 30
      ? 20
      : 35;
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addTask() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      Task(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _category,
        durationMinutes: _duration,
        points: _points,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('تحدٍ جديد')),
      body: SafeArea(
        child: PageContent(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SectionTitle(
                  'ماذا ستنجز اليوم؟',
                  subtitle: 'اجعلها مهمة صغيرة وواضحة. البداية أهم من الكمال.',
                ),
                const SizedBox(height: 26),
                const FieldLabel('عنوان المهمة'),
                TextFormField(
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  maxLength: 120,
                  decoration: const InputDecoration(
                    hintText: 'مثل: مراجعة الفصل الأول',
                    prefixIcon: Icon(Icons.edit_note_rounded),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'اكتب عنوان المهمة'
                      : null,
                ),
                const SizedBox(height: 12),
                const FieldLabel('وصف المهمة (اختياري)'),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'حدّد الجزء الذي تريد الانتهاء منه.',
                  ),
                ),
                const SizedBox(height: 20),
                const FieldLabel('تصنيف المهمة'),
                DropdownButtonFormField<String>(
                  initialValue: _category,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    hintText: 'اختر التصنيف (اختياري)',
                    prefixIcon: Icon(Icons.bookmark_border_rounded),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'مذاكرة', child: Text('مذاكرة')),
                    DropdownMenuItem(value: 'واجب', child: Text('واجب')),
                    DropdownMenuItem(value: 'اختبار', child: Text('اختبار')),
                  ],
                  onChanged: (value) => setState(() => _category = value),
                ),
                const SizedBox(height: 28),
                const SectionTitle(
                  'اختر وقتك',
                  subtitle: 'جلسة قصيرة تساعدك على البدء.',
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final minutes in [15, 25, 45])
                      ChoiceChip(
                        label: Text('$minutes دقيقة'),
                        selected: _duration == minutes,
                        onSelected: (_) => setState(() => _duration = minutes),
                      ),
                  ],
                ),
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.bolt_rounded,
                        color: theme.colorScheme.onSecondaryContainer,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'مكافأتك عند الإكمال: $_points نقطة',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _addTask,
                  icon: const Icon(Icons.add_task_rounded),
                  label: const Text('إضافة التحدي'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
