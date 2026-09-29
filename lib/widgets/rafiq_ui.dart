import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class PageContent extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final double bottomPadding;
  const PageContent({
    super.key,
    required this.child,
    this.maxWidth = 680,
    this.bottomPadding = 32,
  });
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPadding),
    child: Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: SizedBox(width: double.infinity, child: child),
      ),
    ),
  );
}

class RafiqMark extends StatelessWidget {
  const RafiqMark({super.key});
  @override
  Widget build(BuildContext context) => Text(
    'رفيق',
    style: Theme.of(context).textTheme.titleLarge
        ?.copyWith(fontSize: 26, fontWeight: FontWeight.w800),
  );
}

class InfoPill extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool reward;
  const InfoPill({
    super.key,
    required this.icon,
    required this.text,
    this.reward = false,
  });
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final foreground = reward
        ? colors.onSecondaryContainer
        : colors.onPrimaryContainer;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: reward ? colors.secondaryContainer : colors.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17, color: foreground),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: foreground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  const SectionTitle(this.title, {super.key, this.subtitle});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: Theme.of(context).textTheme.titleLarge),
      if (subtitle != null) ...[
        const SizedBox(height: 4),
        Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium),
      ],
    ],
  );
}

class LevelPanel extends StatelessWidget {
  final int points;
  const LevelPanel({super.key, required this.points});
  @override
  Widget build(BuildContext context) {
    final level = points ~/ 100 + 1;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF27884D), Color(0xFF1D6038)],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFDBE9D6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: AppColors.forest,
                  size: 30,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'المستوى $level',
                      style: const TextStyle(
                        fontFamily: 'Tajawal',
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '$points نقطة من تحدياتك المكتملة',
                      style: const TextStyle(
                        fontFamily: 'Tajawal',
                        color: Color(0xFFDFEDE3),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: (points % 100) / 100,
            minHeight: 7,
            borderRadius: BorderRadius.circular(8),
            color: AppColors.gold,
            backgroundColor: const Color(0xFF4A7F69),
            semanticsLabel: 'التقدم إلى المستوى التالي',
          ),
          const SizedBox(height: 10),
          Text(
            'باقي ${100 - points % 100} نقطة للمستوى التالي',
            style: const TextStyle(
              fontFamily: 'Tajawal',
              color: Color(0xFFDFEDE3),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
