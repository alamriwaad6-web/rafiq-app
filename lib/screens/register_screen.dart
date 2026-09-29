import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/auth_validators.dart';
import '../widgets/auth_shell.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _loading = false;
  bool _hidePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    setState(() => _loading = true);
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user?.updateDisplayName(name);
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(userName: name)),
        (_) => false,
      );
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      final message = switch (error.code) {
        'invalid-email' => 'صيغة البريد الإلكتروني غير صحيحة',
        'weak-password' => 'كلمة المرور ضعيفة؛ اختاري كلمة أقوى',
        'email-already-in-use' => 'هذا البريد مسجّل مسبقًا',
        _ => 'تعذر إنشاء الحساب. حاولي مرة أخرى',
      };
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر الاتصال. حاولي مرة أخرى')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => AuthShell(
    title: 'ابدأ رحلتك مع رفيق',
    subtitle: 'أنشئ حسابًا لتحتفظ بتحدياتك وتقدّمك.',
    child: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _field(
            'الاسم',
            'اكتب اسمك',
            _nameController,
            Icons.person_outline_rounded,
            validator: validateName,
          ),
          const SizedBox(height: 18),
          _field(
            'البريد الإلكتروني',
            'name@example.com',
            _emailController,
            Icons.alternate_email_rounded,
            keyboardType: TextInputType.emailAddress,
            ltr: true,
            validator: validateEmail,
          ),
          const SizedBox(height: 18),
          _field(
            'كلمة المرور',
            '••••••••',
            _passwordController,
            Icons.lock_outline_rounded,
            password: true,
            ltr: true,
            validator: validateNewPassword,
          ),
          const SizedBox(height: 18),
          _field(
            'تأكيد كلمة المرور',
            '••••••••',
            _confirmController,
            Icons.verified_user_outlined,
            password: true,
            ltr: true,
            validator: (value) =>
                validatePasswordConfirmation(value, _passwordController.text),
          ),
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: _loading ? null : _register,
            child: _loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  )
                : const Text('إنشاء الحساب'),
          ),
        ],
      ),
    ),
  );

  Widget _field(
    String label,
    String hint,
    TextEditingController controller,
    IconData icon, {
    bool password = false,
    bool ltr = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      FieldLabel(label),
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: password && _hidePassword,
        textDirection: ltr ? TextDirection.ltr : TextDirection.rtl,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon),
          suffixIcon: password
              ? IconButton(
                  tooltip: _hidePassword
                      ? 'إظهار كلمة المرور'
                      : 'إخفاء كلمة المرور',
                  onPressed: () =>
                      setState(() => _hidePassword = !_hidePassword),
                  icon: Icon(
                    _hidePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                )
              : null,
        ),
      ),
    ],
  );
}
