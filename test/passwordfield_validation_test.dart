import 'package:flutter_test/flutter_test.dart';
import 'package:scan_n_vote/screens/signup/components/signup_body.dart';

//Unit test to verify password field validations
void main() {
  test('empty password returns error string', () {
    var result = PasswordFieldValidator.validate('');
    expect(result, 'Por favor entre una contraseña');
  });

  test('password does not contain a lowercase letter returns error string', () {
    var result = PasswordFieldValidator.validate('USER_IS_123');
    expect(result, 'Debe contener al menos un carácter en minúscula');
  });

  test('password does not contain an uppercase letter returns error string',
      () {
    var result = PasswordFieldValidator.validate('user_is_123');
    expect(result, 'Debe contener al menos un carácter en mayúscula');
  });

  test('password does not contain a digit returns error string', () {
    var result = PasswordFieldValidator.validate('Testing_pw!');
    expect(result, 'Debe contener al menos un dígito');
  });

  test('password does not contain a special character returns error string',
      () {
    var result = PasswordFieldValidator.validate('Testingthepw1');
    expect(result, 'Debe contener al menos un carácter especial');
  });

  test('password is less than 8 characters long returns error string', () {
    var result = PasswordFieldValidator.validate('Test.1');
    expect(result, 'Debe tener entre 8 y 24 caracteres');
  });

  test('password is more than 24 characters long returns error string', () {
    var result = PasswordFieldValidator.validate(
        'Testing.the.password.EXAM3.Testing.The_length.');
    expect(result, 'Debe tener entre 8 y 24 caracteres');
  });

  test('password passes all validations returns null', () {
    var result = PasswordFieldValidator.validate('Testing_Pw1');
    expect(result, null);
  });
}
