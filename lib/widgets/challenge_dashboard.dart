import 'package:flutter/material.dart';

import '../models/task.dart';
import 'rafiq_ui.dart';
import 'challenge_tile.dart';

class ChallengeDashboard extends StatefulWidget {
  final String userName;
  final List<Task> tasks;
  final VoidCallback onAdd;
  final ValueChanged<int> onToggle, onDelete, onFocus;
  const ChallengeDashboard({
    super.key,
    required this.userName,
    required this.tasks,
    required this.onAdd,
    required this.onToggle,
    required this.onDelete,
    required this.onFocus,
  });
  @override
  State<ChallengeDashboard> createState() => _ChallengeDashboardState();
}

class _ChallengeDashboardState extends State<ChallengeDashboard> {
  int _filter = 0;
  @override
  Widget build(BuildContext context) {
    final tasks = widget.tasks;
    final completed = tasks.where((t) => t.isCompleted).length;
    final points = tasks
        .where((t) => t.isCompleted)
        .fold<int>(0, (sum, t) => sum + t.points);
    final next = tasks.indexWhere((t) => !t.isCompleted);
    final visible = tasks
        .asMap()
        .entries
        .where(
          (e) =>
              _filter == 0 ||
              (_filter == 1 ? !e.value.isCompleted : e.value.isCompleted),
        )
        .toList();
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return PageContent(
      bottomPadding: 100,
      maxWidth: 900,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: 'مرحبًا '),
                TextSpan(
                  text: widget.userName,
                  style: TextStyle(color: colors.primary),
                ),
              ],
            ),
            style: text.headlineMedium,
          ),
          Text('خطوة صغيرة اليوم، فرق كبير غدًا.', style: text.bodyMedium),
          const SizedBox(height: 16),
          LevelPanel(points: points),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  value:
                      '${tasks.isEmpty ? 0 : (completed / tasks.length * 100).round()}%',
                  label: 'مهام اليوم',
                  color: colors.error,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _Metric(
                  value: '$points',
                  label: 'نقاطي',
                  color: colors.secondary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _Metric(
                  value: '$completed',
                  label: 'مكتملة',
                  color: colors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (next >= 0) ...[
            const SectionTitle('تحدي اليوم'),
            const SizedBox(height: 10),
            _NextChallenge(
              task: tasks[next],
              onStart: () => widget.onFocus(next),
            ),
            const SizedBox(height: 20),
          ],
          const SectionTitle('تحدياتك'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final entry in [
                'الكل',
                'قيد الإنجاز',
                'المكتملة',
              ].asMap().entries)
                ChoiceChip(
                  label: Text(entry.value),
                  selected: _filter == entry.key,
                  onSelected: (_) => setState(() => _filter = entry.key),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (visible.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/rafiq.png',
                      width: 88,
                      excludeFromSemantics: true,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      tasks.isEmpty
                          ? 'ما هو أول تحدٍ لك؟'
                          : 'لا توجد تحديات هنا بعد',
                      style: text.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      tasks.isEmpty
                          ? 'اختر مهمة واحدة وحدد لها وقتًا. رفيق معك خطوة بخطوة.'
                          : 'غيّر التصفية للاطلاع على بقية تحدياتك.',
                      textAlign: TextAlign.center,
                      style: text.bodyMedium,
                    ),
                    if (tasks.isEmpty) ...[
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: widget.onAdd,
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('أضف أول تحدٍ'),
                      ),
                    ],
                  ],
                ),
              ),
            )
          else
            ...visible.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ChallengeTile(
                  task: e.value,
                  onToggle: () => widget.onToggle(e.key),
                  onDelete: () => widget.onDelete(e.key),
                  onStart: () => widget.onFocus(e.key),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NextChallenge extends StatelessWidget {
  final Task task;
  final VoidCallback onStart;
  const _NextChallenge({required this.task, required this.onStart});
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.outlineVariant),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ابدأ الآن', style: text.bodyMedium),
                    const SizedBox(height: 4),
                    Text(
                      task.title,
                      style: text.titleLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Image.asset(
                'assets/rafiq.png',
                width: 56,
                height: 56,
                excludeFromSemantics: true,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              InfoPill(
                icon: Icons.timer_outlined,
                text: '${task.durationMinutes} دقيقة',
              ),
              InfoPill(
                icon: Icons.bolt_rounded,
                text: '+${task.points} نقطة',
                reward: true,
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onStart,
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('لنبدأ التحدي'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String value, label;
  final Color color;
  const _Metric({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Column(
          children: [
            Text(value, style: text.titleLarge?.copyWith(color: color)),
            Text(label, style: text.bodyMedium?.copyWith(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
