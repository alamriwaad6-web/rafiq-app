import 'package:flutter/material.dart';

import '../models/task.dart';

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

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addTask() {
    if (!_formKey.currentState!.validate()) return;

    final task = Task(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _category,
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('تمت إضافة المهمة: ${task.title}')));

    _formKey.currentState!.reset();
    _titleController.clear();
    _descriptionController.clear();
    setState(() => _category = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9ED),
      appBar: AppBar(
        title: const Text('إضافة مهمة'),
        backgroundColor: const Color(0xFFFFF9ED),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'عنوان المهمة',
                    hintText: 'مثال: مراجعة الفصل الأول',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'اكتبي عنوان المهمة';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'وصف المهمة',
                    hintText: 'ماذا تحتاجين أن تنجزي؟',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'تصنيف المهمة',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'مذاكرة', child: Text('مذاكرة')),
                    DropdownMenuItem(value: 'واجب', child: Text('واجب')),
                    DropdownMenuItem(value: 'اختبار', child: Text('اختبار')),
                  ],
                  onChanged: (value) => setState(() => _category = value),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _addTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4B914E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('إضافة المهمة'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
