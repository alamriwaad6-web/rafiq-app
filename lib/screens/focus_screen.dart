import 'dart:async';

import 'package:flutter/material.dart';

import '../models/task.dart';
import '../theme/app_theme.dart';
import '../widgets/focus_duration_dialog.dart';
import '../widgets/rafiq_ui.dart';

class FocusScreen extends StatefulWidget {
  final Task? task;
  final DateTime Function()? now;
  const FocusScreen({super.key, this.task, this.now});
  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> with WidgetsBindingObserver {
  Timer? _timer;
  DateTime? _deadline;
  late int _sessionSeconds;
  late int _remainingSeconds;
  bool _isRunning = false;
  DateTime get _now => widget.now?.call() ?? DateTime.now();
  int get _selectedMinutes => _sessionSeconds ~/ 60;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _sessionSeconds = (widget.task?.durationMinutes ?? 25).clamp(1, 180) * 60;
    _remainingSeconds = _sessionSeconds;
  }

  String get _formattedTime =>
      '${(_remainingSeconds ~/ 60).toString().padLeft(2, '0')}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}';
  void _tick() {
    if (!mounted || _deadline == null) return;
    final seconds = (_deadline!.difference(_now).inMilliseconds / 1000)
        .ceil()
        .clamp(0, _sessionSeconds);
    setState(() {
      _remainingSeconds = seconds;
      if (seconds == 0) {
        _timer?.cancel();
        _isRunning = false;
        _deadline = null;
      }
    });
  }

  void _startOrPause() {
    if (_isRunning) {
      _tick();
      _timer?.cancel();
      setState(() {
        _isRunning = false;
        _deadline = null;
      });
    } else {
      _deadline = _now.add(Duration(seconds: _remainingSeconds));
      setState(() => _isRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    }
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _deadline = null;
      _remainingSeconds = _sessionSeconds;
      _isRunning = false;
    });
  }

  Future<void> _chooseDuration() async {
    final minutes = await showDialog<int>(
      context: context,
      builder: (_) => FocusDurationDialog(initialMinutes: _selectedMinutes),
    );
    if (!mounted || minutes == null) return;
    _timer?.cancel();
    setState(() {
      _deadline = null;
      _sessionSeconds = minutes * 60;
      _remainingSeconds = _sessionSeconds;
      _isRunning = false;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isRunning) _tick();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final done = _remainingSeconds == 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('مساحة التركيز'),
        backgroundColor: AppColors.forest,
        foregroundColor: Colors.white,
        titleTextStyle: theme.textTheme.titleLarge?.copyWith(
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: PageContent(
          maxWidth: 520,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.forest,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  children: [
                    Text(
                      widget.task?.category ?? 'جلسة تركيز',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFFDEEFDF),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      done
                          ? 'تحدٍ آخر، وإنجاز جديد!'
                          : widget.task?.title ?? 'وقت لك ولمهمتك',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 23,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.task == null
                          ? 'ابدأ حين تكون جاهزًا'
                          : '$_selectedMinutes دقيقة  ·  +${widget.task!.points} نقطة',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.gold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              InfoPill(
                icon: done
                    ? Icons.workspace_premium_outlined
                    : Icons.bolt_rounded,
                text: widget.task == null
                    ? 'جلسة تركيز حرة'
                    : '+${widget.task!.points} نقطة عند الإكمال',
                reward: true,
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _isRunning || done ? null : _chooseDuration,
                icon: const Icon(Icons.edit_calendar_outlined),
                label: Text('وقت التركيز: $_selectedMinutes دقيقة'),
              ),
              const SizedBox(height: 10),
              Text(
                done
                    ? 'أحسنت. خذ استراحة قصيرة تستحقها.'
                    : 'خذ نفسًا عميقًا. الآن، مهمة واحدة فقط.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 22),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 28,
                    horizontal: 12,
                  ),
                  child: LayoutBuilder(
                    builder: (context, box) {
                      final size = box.maxWidth.clamp(180.0, 230.0);
                      return SizedBox(
                        width: size,
                        height: size,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned.fill(
                              child: CircularProgressIndicator(
                                value: 1 - _remainingSeconds / _sessionSeconds,
                                strokeWidth: 9,
                                strokeCap: StrokeCap.round,
                                color: colors.primary,
                                backgroundColor: colors.primaryContainer,
                                semanticsLabel: 'تقدم جلسة التركيز',
                              ),
                            ),
                            Container(
                              width: size - 30,
                              height: size - 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colors.surface,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  done
                                      ? Icons.check_circle_outline_rounded
                                      : Icons.spa_outlined,
                                  color: colors.primary,
                                  size: 30,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _formattedTime,
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                    fontFamily: 'Tajawal',
                                    fontSize: 45,
                                    height: 1.2,
                                    fontWeight: FontWeight.w700,
                                    color: colors.onSurface,
                                    fontFeatures: const [
                                      FontFeature.tabularFigures(),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  done
                                      ? 'اكتملت الجلسة'
                                      : _isRunning
                                      ? 'أنت تصنع تقدّمًا'
                                      : 'على مهلك، ابدأ حين تكون جاهزًا',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (!done) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_off_outlined,
                      color: colors.onSurfaceVariant,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'اترك المشتتات خارج هذه اللحظة.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: done
                      ? () => Navigator.pop(context, true)
                      : _startOrPause,
                  icon: Icon(
                    done
                        ? Icons.check_rounded
                        : _isRunning
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                  ),
                  label: Text(
                    done
                        ? 'إنهاء الجلسة'
                        : _isRunning
                        ? 'إيقاف مؤقت'
                        : _remainingSeconds == _sessionSeconds
                        ? 'ابدأ التركيز'
                        : 'متابعة التركيز',
                  ),
                ),
              ),
              if (!done) ...[
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: _remainingSeconds == _sessionSeconds && !_isRunning
                      ? null
                      : _reset,
                  icon: const Icon(Icons.restart_alt_rounded),
                  label: const Text('إعادة ضبط الوقت'),
                ),
              ],
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
