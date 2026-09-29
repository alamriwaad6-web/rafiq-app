import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _step = 0;

  void _next() {
    if (_step == 0) {
      setState(() => _step = 1);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final first = _step == 0;
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, box) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 470,
                  minHeight: (box.maxHeight - 48).clamp(0, double.infinity),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      height: box.maxWidth < 360 ? 260 : 330,
                      child: first
                          ? _MascotOrbit(color: colors.primary)
                          : _OnboardingArt(color: colors.primary),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: colors.primaryContainer,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        first ? 'مرحبًا بك' : 'الخطوة ٢ من ٢',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colors.primary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    if (first)
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(text: 'رفيقك الذكي\n'),
                            TextSpan(
                              text: 'للدراسة',
                              style: TextStyle(color: colors.primary),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontSize: 34,
                          height: 1.17,
                        ),
                      )
                    else
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(text: 'اكسب '),
                            TextSpan(
                              text: 'نقاطًا',
                              style: TextStyle(color: colors.primary),
                            ),
                            const TextSpan(text: ' مع كل\nمهمة تنجزها'),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          height: 1.25,
                        ),
                      ),
                    const SizedBox(height: 12),
                    Text(
                      first
                          ? 'حوّل مهامك الدراسية إلى تحديات قصيرة\nتفتخر بإنجازها.'
                          : 'ابدأ بتحدٍ صغير ومؤقّت. كل مهمة تكملها\nتقرّبك من مستواك التالي.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                        height: 1.7,
                      ),
                    ),
                    const SizedBox(height: 36),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < 2; i++)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            height: 7,
                            width: i == _step ? 23 : 7,
                            decoration: BoxDecoration(
                              color: i == _step
                                  ? colors.primary
                                  : AppColors.line,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        if (!first) ...[
                          OutlinedButton(
                            onPressed: () => setState(() => _step = 0),
                            child: const Text('السابق'),
                          ),
                          const SizedBox(width: 10),
                        ],
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _next,
                            icon: const Icon(Icons.arrow_forward_rounded),
                            label: Text(first ? 'ابدأ الآن' : 'متابعة'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MascotOrbit extends StatelessWidget {
  final Color color;
  const _MascotOrbit({required this.color});

  @override
  Widget build(BuildContext context) => Stack(
    alignment: Alignment.center,
    children: [
      Container(
        width: 315,
        height: 315,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.lime.withValues(alpha: .45),
          border: Border.all(color: color.withValues(alpha: .08)),
        ),
      ),
      Container(
        width: 245,
        height: 245,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.gold.withValues(alpha: .13),
          border: Border.all(color: AppColors.gold.withValues(alpha: .55)),
        ),
      ),
      Positioned(
        right: 37,
        top: 110,
        child: CircleAvatar(
          radius: 4,
          backgroundColor: color.withValues(alpha: .3),
        ),
      ),
      const Positioned(
        left: 43,
        bottom: 85,
        child: CircleAvatar(radius: 3, backgroundColor: AppColors.gold),
      ),
      Image.asset(
        'assets/rafiq.png',
        width: 226,
        height: 226,
        semanticLabel: 'رفيق، شخصيتك المرافقة في الدراسة',
      ),
    ],
  );
}

class _OnboardingArt extends StatelessWidget {
  final Color color;
  const _OnboardingArt({required this.color});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppColors.lime.withValues(alpha: .38),
      border: Border.all(color: AppColors.line),
      borderRadius: BorderRadius.circular(26),
    ),
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (final step in [
            ('ابدأ', 'حدّد مهمة صغيرة', Icons.edit_note_rounded),
            ('ركّز', 'اختر وقتك المناسب', Icons.timer_outlined),
            ('أنجز', 'احتفل بنقاطك', Icons.emoji_events_outlined),
          ]) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.line),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(step.$3, color: color, size: 21),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.$1,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        Text(
                          step.$2,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.gold,
                    size: 21,
                  ),
                ],
              ),
            ),
            if (step.$1 != 'أنجز') const SizedBox(height: 8),
          ],
        ],
      ),
    ),
  );
}
