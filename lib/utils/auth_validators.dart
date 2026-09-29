String? validateName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'أدخلي الاسم';
  }
  return null;
}

String? validateEmail(String? value) {
  final email = value?.trim() ?? '';
  if (email.isEmpty) return 'أدخلي البريد الإلكتروني';
  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
    return 'أدخلي بريدًا إلكترونيًا صحيحًا';
  }
  return null;
}

String? validateLoginPassword(String? value) {
  if (value == null || value.isEmpty) return 'أدخلي كلمة المرور';
  return null;
}

String? validateNewPassword(String? value) {
  if (value == null || value.isEmpty) return 'أدخلي كلمة المرور';
  if (value.length < 6) return 'كلمة المرور يجب أن تكون ٦ أحرف على الأقل';
  return null;
}

String? validatePasswordConfirmation(String? value, String password) {
  if (value == null || value.isEmpty) return 'أكّدي كلمة المرور';
  if (value != password) return 'كلمتا المرور غير متطابقتين';
  return null;
}
