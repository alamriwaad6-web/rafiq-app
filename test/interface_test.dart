import 'package:first_app1/models/task.dart';
import 'package:first_app1/screens/add_task_screen.dart';
import 'package:first_app1/screens/focus_screen.dart';
import 'package:first_app1/screens/login_screen.dart';
import 'package:first_app1/screens/register_screen.dart';
import 'package:first_app1/screens/settings_screen.dart';
import 'package:first_app1/screens/welcome_screen.dart';
import 'package:first_app1/theme/app_theme.dart';
import 'package:first_app1/widgets/challenge_dashboard.dart';
import 'package:first_app1/widgets/rafiq_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

final tasks = [
  Task(
    title: 'مراجعة هياكل البيانات',
    description: 'الأشجار الثنائية وخوارزميات البحث',
    category: 'مذاكرة',
  ),
  Task(
    title: 'حل تمارين البرمجة',
    description: 'الفصل الثاني',
    category: 'واجب',
    durationMinutes: 15,
    points: 10,
  ),
  Task(title: 'تلخيص المحاضرة', description: '', isCompleted: true),
];

Widget dashboard({ValueChanged<int>? onFocus}) => Scaffold(
  appBar: AppBar(title: const RafiqMark()),
  body: ChallengeDashboard(
    userName: 'وعد',
    tasks: tasks,
    onAdd: () {},
    onToggle: (_) {},
    onDelete: (_) {},
    onFocus: onFocus ?? (_) {},
  ),
  bottomNavigationBar: NavigationBar(
    destinations: const [
      NavigationDestination(
        icon: Icon(Icons.space_dashboard_outlined),
        label: 'اليوم',
      ),
      NavigationDestination(icon: Icon(Icons.person_outline), label: 'ملفي'),
    ],
  ),
);

Widget app(Widget screen, {bool dark = false, double scale = 1}) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: dark ? AppTheme.dark : AppTheme.light,
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
    child: Directionality(textDirection: TextDirection.rtl, child: child!),
  ),
  home: screen,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final loader = FontLoader('Tajawal');
    for (final weight in ['Regular', 'Medium', 'Bold', 'ExtraBold']) {
      loader.addFont(rootBundle.load('assets/fonts/Tajawal-$weight.ttf'));
    }
    await loader.load();
    final icons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();
  });

  final screens = <String, Widget Function()>{
    'welcome': () => const WelcomeScreen(),
    'login': () => const LoginScreen(),
    'register': () => const RegisterScreen(),
    'dashboard': () => dashboard(),
    'add-task': () => const AddTaskScreen(),
    'focus': () => FocusScreen(task: tasks.first),
    'profile': () => const Scaffold(
      body: ProfileContent(
        name: 'وعد',
        email: 'student@example.com',
        taskCount: 3,
        completedCount: 1,
        points: 20,
      ),
    ),
  };

  for (final width in [320.0, 390.0, 800.0]) {
    for (final dark in [false, true]) {
      testWidgets('all screens fit width $width dark=$dark', (tester) async {
        tester.view.physicalSize = Size(width, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        for (final entry in screens.entries) {
          await tester.pumpWidget(
            app(entry.value(), dark: dark, scale: width == 320 ? 1.3 : 1),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull, reason: entry.key);
          expect(
            Directionality.of(tester.element(find.byType(Scaffold).first)),
            TextDirection.rtl,
            reason: '${entry.key} must use right-to-left layout',
          );
          if (const bool.fromEnvironment('CAPTURE_DESIGN') && width == 390) {
            await expectLater(
              find.byType(MaterialApp),
              matchesGoldenFile(
                '../build/design-preview/${entry.key}-${dark ? 'dark' : 'light'}.png',
              ),
            );
          }
        }
      });
    }
  }

  testWidgets('filter preserves original task index for actions', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 1500);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    int? selected;
    await tester.pumpWidget(
      app(dashboard(onFocus: (index) => selected = index)),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('قيد الإنجاز'));
    await tester.tap(find.text('قيد الإنجاز'));
    await tester.pumpAndSettle();
    expect(find.text('تلخيص المحاضرة'), findsNothing);
    final buttons = find.widgetWithText(TextButton, 'ابدأ التركيز');
    await tester.ensureVisible(buttons.last);
    await tester.tap(buttons.last);
    expect(selected, 1);
    await tester.ensureVisible(find.text('المكتملة'));
    await tester.tap(find.text('المكتملة'));
    await tester.pumpAndSettle();
    expect(find.text('تلخيص المحاضرة'), findsOneWidget);
  });

  testWidgets('welcome moves through onboarding to sign in', (tester) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(app(const WelcomeScreen()));
    await tester.tap(find.text('ابدأ الآن'));
    await tester.pumpAndSettle();
    expect(find.text('الخطوة ٢ من ٢'), findsOneWidget);
    if (const bool.fromEnvironment('CAPTURE_DESIGN')) {
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('../build/design-preview/onboarding-light.png'),
      );
    }
    await tester.tap(find.text('متابعة'));
    await tester.pumpAndSettle();
    expect(find.text('تسجيل الدخول'), findsOneWidget);
  });

  testWidgets('top brand has no mascot image', (tester) async {
    await tester.pumpWidget(app(const LoginScreen()));
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: find.byType(AppBar), matching: find.byType(Image)),
      findsNothing,
    );
    expect(
      find.descendant(of: find.byType(AppBar), matching: find.text('رفيق')),
      findsOneWidget,
    );
  });

  testWidgets('login shows validation errors before Firebase request', (
    tester,
  ) async {
    await tester.pumpWidget(app(const LoginScreen()));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'not-an-email');
    await tester.tap(find.text('تسجيل الدخول'));
    await tester.pumpAndSettle();
    expect(find.text('أدخلي بريدًا إلكترونيًا صحيحًا'), findsOneWidget);
    expect(find.text('أدخلي كلمة المرور'), findsOneWidget);
  });

  testWidgets('registration validates password confirmation', (tester) async {
    tester.view.physicalSize = const Size(390, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(app(const RegisterScreen()));
    await tester.pumpAndSettle();
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'ريم');
    await tester.enterText(fields.at(1), 'student@example.com');
    await tester.enterText(fields.at(2), '123456');
    await tester.enterText(fields.at(3), 'different');
    await tester.ensureVisible(find.text('إنشاء الحساب'));
    await tester.tap(find.text('إنشاء الحساب'));
    await tester.pumpAndSettle();
    expect(find.text('كلمتا المرور غير متطابقتين'), findsOneWidget);
  });

  testWidgets('adding a challenge requires a title', (tester) async {
    tester.view.physicalSize = const Size(390, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(app(const AddTaskScreen()));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('إضافة التحدي'));
    await tester.tap(find.text('إضافة التحدي'));
    await tester.pumpAndSettle();
    expect(find.text('اكتب عنوان المهمة'), findsOneWidget);
  });

  testWidgets('focus starts, pauses and resets', (tester) async {
    tester.view.physicalSize = const Size(390, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      app(
        FocusScreen(task: tasks.first, now: () => tester.binding.clock.now()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('25:00'), findsOneWidget);
    await tester.tap(find.text('ابدأ التركيز'));
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('24:58'), findsOneWidget);
    await tester.tap(find.text('إيقاف مؤقت'));
    await tester.pump(const Duration(seconds: 3));
    expect(find.text('24:58'), findsOneWidget);
    await tester.tap(find.text('إعادة ضبط الوقت'));
    await tester.pump();
    expect(find.text('25:00'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('focus duration can be chosen by the student', (tester) async {
    tester.view.physicalSize = const Size(390, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      app(
        FocusScreen(task: tasks.first, now: () => tester.binding.clock.now()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('وقت التركيز: 25 دقيقة'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).last, '0');
    await tester.tap(find.text('حفظ الوقت'));
    await tester.pumpAndSettle();
    expect(find.text('أدخل عددًا بين ١ و١٨٠'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).last, '37');
    await tester.tap(find.text('حفظ الوقت'));
    await tester.pumpAndSettle();
    expect(find.text('37:00'), findsOneWidget);
    await tester.tap(find.text('ابدأ التركيز'));
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('36:58'), findsOneWidget);
    expect(
      tester
          .widget<OutlinedButton>(find.byType(OutlinedButton).first)
          .onPressed,
      isNull,
    );
    await tester.pumpWidget(const SizedBox());
  });
}
