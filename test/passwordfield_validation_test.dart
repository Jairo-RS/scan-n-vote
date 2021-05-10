import 'package:flutter_test/flutter_test.dart';
import 'package:scan_n_vote/screens/signup/components/signup_body.dart';

//Unit test to verify password field validations
void main() {
  test('empty password returns error string', () {
    var result = PasswordFieldValidator.validate('');
    expect(result, 'Por favor entre una contraseña');
  });

  test('password does not contain a lowercase letter returns error string', () {
    var result = PasswordFieldValidator.validate('JAIRO.123');
    expect(result, 'Debe contener al menos un carácter en minúscula');
  });

  test('password does not contain an uppercase letter returns error string',
      () {
    var result = PasswordFieldValidator.validate('jairo.123');
    expect(result, 'Debe contener al menos un carácter en mayúscula');
  });

  test('password does not contain a digit returns error string', () {
    var result = PasswordFieldValidator.validate('Jairo.rosado!');
    expect(result, 'Debe contener al menos un dígito');
  });

  test('password does not contain a special character returns error string',
      () {
    var result = PasswordFieldValidator.validate('JairoRosado1');
    expect(result, 'Debe contener al menos un carácter especial');
  });

  test(
      'password passes all validations but is less than 8 characters long returns error string',
      () {
    var result = PasswordFieldValidator.validate('Jairo.1');
    expect(result, 'Debe tener entre 8 y 24 caracteres');
  });

  test(
      'password passes all validations but is more than 16 characters long returns error string',
      () {
    var result = PasswordFieldValidator.validate(
        'Jairo.Rosado.Soto.EXAM3.Testing.The_length.');
    expect(result, 'Debe tener entre 8 y 24 caracteres');
  });

  test('password passes all validations returns null', () {
    var result = PasswordFieldValidator.validate('Jairo.Rosado1');
    expect(result, null);
  });
}
