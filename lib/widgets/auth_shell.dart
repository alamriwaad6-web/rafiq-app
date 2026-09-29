import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'rafiq_ui.dart';

class AuthShell extends StatelessWidget {
  final String title, subtitle;
  final Widget child;
  const AuthShell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const RafiqMark()),
    body: SafeArea(
      child: PageContent(
        maxWidth: 440,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 22),
            Center(
              child: Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.lime,
                ),
                child: Image.asset(
                  'assets/rafiq.png',
                  excludeFromSemantics: true,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            AutofillGroup(child: child),
          ],
        ),
      ),
    ),
  );
}

class FieldLabel extends StatelessWidget {
  final String text;
  const FieldLabel(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.only(start: 2, bottom: 8),
    child: Text(text, style: Theme.of(context).textTheme.labelLarge),
  );
}
