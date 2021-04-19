import 'package:flutter_test/flutter_test.dart';
import 'package:scan_n_vote/screens/signup/components/signup_body.dart';

void main() {
  test('empty password returns error string', () {
    var result = PasswordFieldValidator.validate('');
    expect(result, 'Please enter a password');
  });

  test('password does not contain a lowercase letter returns error string', () {
    var result = PasswordFieldValidator.validate('JAIRO.123');
    expect(result, 'Must contain at least one lowercase character');
  });

  test('password does not contain an uppercase letter returns error string',
      () {
    var result = PasswordFieldValidator.validate('jairo.123');
    expect(result, 'Must contain at least one uppercase character');
  });

  test('password does not contain a digit returns error string', () {
    var result = PasswordFieldValidator.validate('Jairo.rosado!');
    expect(result, 'Must contain at least one digit');
  });

  test('password does not contain a special character returns error string',
      () {
    var result = PasswordFieldValidator.validate('JairoRosado1');
    expect(result, 'Must contain at least one special character');
  });

  test(
      'password passes all validations but is less than 8 characters long returns error string',
      () {
    var result = PasswordFieldValidator.validate('Jairo.1');
    expect(result, 'Must be between 8 to 16 characters long');
  });

  test(
      'password passes all validations but is more than 16 characters long returns error string',
      () {
    var result = PasswordFieldValidator.validate('Jairo.Rosado.Soto.EXAM1');
    expect(result, 'Must be between 8 to 16 characters long');
  });

  test('password passes all validations returns null', () {
    var result = PasswordFieldValidator.validate('Jairo.Rosado1');
    expect(result, null);
  });
}
