import 'package:flutter_test/flutter_test.dart';
import 'package:scan_n_vote/screens/signup/components/signup_body.dart';

//Unit test to verify password confirmation validations
void main() {
  test('empty password confirmation returns error string', () {
    var result = PasswordConfirmationFieldValidator.validate('');
    expect(result, 'Por favor entre una contraseña');
  });

  test(
      'password confirmation does not contain a lowercase letter returns error string',
      () {
    var result = PasswordConfirmationFieldValidator.validate('TESTING.123');
    expect(result, 'Debe contener al menos un carácter en minúscula');
  });

  test(
      'password confirmation does not contain an uppercase letter returns error string',
      () {
    var result = PasswordConfirmationFieldValidator.validate('testing.123');
    expect(result, 'Debe contener al menos un carácter en mayúscula');
  });

  test('password confirmation does not contain a digit returns error string',
      () {
    var result = PasswordConfirmationFieldValidator.validate('Testing.EXAM!');
    expect(result, 'Debe contener al menos un dígito');
  });

  test(
      'password confirmation does not contain a special character returns error string',
      () {
    var result = PasswordConfirmationFieldValidator.validate('TestingforExam3');
    expect(result, 'Debe contener al menos un carácter especial');
  });

  test(
      'password confirmation is less than 8 characters long returns error string',
      () {
    var result = PasswordConfirmationFieldValidator.validate('Test.1');
    expect(result, 'Debe tener entre 8 y 24 caracteres');
  });

  test(
      'password confirmation is more than 24 characters long returns error string',
      () {
    var result = PasswordConfirmationFieldValidator.validate(
        'Testing.FOR.this,EXAM3.this.confirmation');
    expect(result, 'Debe tener entre 8 y 24 caracteres');
  });
}
