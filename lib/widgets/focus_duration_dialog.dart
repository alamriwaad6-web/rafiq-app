import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FocusDurationDialog extends StatefulWidget {
  final int initialMinutes;

  const FocusDurationDialog({super.key, required this.initialMinutes});

  @override
  State<FocusDurationDialog> createState() => _FocusDurationDialogState();
}

class _FocusDurationDialogState extends State<FocusDurationDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _minutesController;

  @override
  void initState() {
    super.initState();
    _minutesController = TextEditingController(
      text: widget.initialMinutes.toString(),
    );
  }

  @override
  void dispose() {
    _minutesController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(context, int.parse(_minutesController.text));
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('حدّد وقت التركيز'),
    content: Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('اختر المدة التي تناسب مهمتك، من ١ إلى ١٨٠ دقيقة.'),
          const SizedBox(height: 16),
          TextFormField(
            controller: _minutesController,
            autofocus: true,
            keyboardType: TextInputType.number,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: 'الدقائق',
              suffixText: 'دقيقة',
            ),
            validator: (value) {
              final minutes = int.tryParse(value ?? '');
              if (minutes == null || minutes < 1 || minutes > 180) {
                return 'أدخل عددًا بين ١ و١٨٠';
              }
              return null;
            },
            onFieldSubmitted: (_) => _save(),
          ),
          const SizedBox(height: 12),
          Text(
            'تغيير المدة يعيد المؤقّت من البداية.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('إلغاء'),
      ),
      FilledButton(onPressed: _save, child: const Text('حفظ الوقت')),
    ],
  );
}
