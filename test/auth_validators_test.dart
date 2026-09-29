import 'package:first_app1/utils/auth_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('email validation rejects empty and malformed addresses', () {
    expect(validateEmail(''), isNotNull);
    expect(validateEmail('student@'), isNotNull);
    expect(validateEmail('student@example.com'), isNull);
  });

  test('registration validates name, password and confirmation', () {
    expect(validateName('  '), isNotNull);
    expect(validateName('ريم'), isNull);
    expect(validateNewPassword('12345'), isNotNull);
    expect(validateNewPassword('123456'), isNull);
    expect(validatePasswordConfirmation('different', '123456'), isNotNull);
    expect(validatePasswordConfirmation('123456', '123456'), isNull);
  });

  test('login only requires a nonempty password', () {
    expect(validateLoginPassword(''), isNotNull);
    expect(validateLoginPassword('old-password'), isNull);
  });
}
