import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/rafiq_ui.dart';

class SettingsScreen extends StatelessWidget {
  final int taskCount, completedCount, points;
  const SettingsScreen({
    super.key,
    required this.taskCount,
    required this.completedCount,
    this.points = 0,
  });
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final name = user?.displayName?.trim();
    return ProfileContent(
      name: name == null || name.isEmpty ? 'صديق رفيق' : name,
      email: user?.email ?? '',
      taskCount: taskCount,
      completedCount: completedCount,
      points: points,
    );
  }
}

class ProfileContent extends StatelessWidget {
  final String name, email;
  final int taskCount, completedCount, points;
  const ProfileContent({
    super.key,
    required this.name,
    required this.email,
    required this.taskCount,
    required this.completedCount,
    required this.points,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PageContent(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 116,
            alignment: AlignmentDirectional.bottomEnd,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE3F3E8), Color(0xFFFFF2CC)],
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd,
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Container(
              width: 74,
              height: 74,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.forest, AppColors.gold],
                ),
                border: Border.all(color: Colors.white, width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                name.isEmpty ? 'ر' : String.fromCharCode(name.runes.first),
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            name,
            textAlign: TextAlign.start,
            style: theme.textTheme.headlineMedium,
          ),
          if (email.isNotEmpty)
            Text(
              email,
              textAlign: TextAlign.start,
              textDirection: TextDirection.ltr,
              style: theme.textTheme.bodyMedium,
            ),
          const SizedBox(height: 24),
          LevelPanel(points: points),
          const SizedBox(height: 28),
          const SectionTitle('تقدّمك الدراسي'),
          const SizedBox(height: 14),
          _InfoRow(
            icon: Icons.task_alt_rounded,
            title: 'خطوات تستحق الفخر',
            description: '$completedCount تحديات مكتملة من أصل $taskCount',
          ),
          const SizedBox(height: 12),
          const _InfoRow(
            icon: Icons.timer_outlined,
            title: 'وقت صغير، إنجاز ملموس',
            description: 'اختر 15 أو 25 أو 45 دقيقة للتحدي حسب مهمتك.',
          ),
          const SizedBox(height: 12),
          const _InfoRow(
            icon: Icons.workspace_premium_outlined,
            title: 'كيف تتقدم؟',
            description: 'كل 100 نقطة تنقلك لمستوى جديد. نقاطك محسوبة من التحديات المكتملة المحفوظة.',
          ),
          const SizedBox(height: 28),
          Text(
            'رفيق للدراسة والتركيز',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            'مهمة واحدة. وقت واضح. خطوة أقرب لهدفك.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title, description;
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.description,
  });
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 26),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
