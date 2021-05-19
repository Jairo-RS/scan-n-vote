import 'package:flutter_test/flutter_test.dart';
import 'package:scan_n_vote/screens/signup/components/signup_body.dart';

//Unit test used to verify validations from all text field
void main() {
  test('title', () {});

  test('empty username return error string', () {
    var result = UsernameFieldValidator.validate('');
    expect(result, 'Entre un nombre de usuario (username)');
  });

  test('username with less than 8 characters return error string', () {
    var result = UsernameFieldValidator.validate('User');
    expect(result, 'Debe tener entre 8 a 16 caracteres de largo');
  });

  test('username with more than 16 characters return error string', () {
    var result = UsernameFieldValidator.validate('ThisUsername_isverylong');
    expect(result, 'Debe tener entre 8 a 16 caracteres de largo');
  });

  test('username with invalid special character return error string', () {
    var result = UsernameFieldValidator.validate('User!');
    expect(result, 'Carácter especial inválido: Aceptable: @/./_ /-/+');
  });

  test('correct username will return null', () {
    var result = UsernameFieldValidator.validate('UserRS12');
    expect(result, null);
  });

  test('empty student number returns error string', () {
    var result = StudentNumberFieldValidator.validate('');
    expect(result, 'Por favor entre su número de estudiante');
  });

  test('character does not match with regular expression returns error string',
      () {
    var result = StudentNumberFieldValidator.validate('8021220c');
    expect(result, 'Debe solo entrar dígitos. Formato: xxxxxxxxx');
  });

  test('lowercase letter in student number returns error string', () {
    var result = StudentNumberFieldValidator.validate('abcd');
    expect(result, 'Debe solo entrar dígitos. Formato: xxxxxxxxx');
  });

  test('uppercase letter in student number returns error string', () {
    var result = StudentNumberFieldValidator.validate('ABCD');
    expect(result, 'Debe solo entrar dígitos. Formato: xxxxxxxxx');
  });

  test('special characters in student number returns error string', () {
    var result = StudentNumberFieldValidator.validate('844!=,.');
    expect(result, 'Debe solo entrar dígitos. Formato: xxxxxxxxx');
  });

  test('less than 9 digits returns error string', () {
    var result = StudentNumberFieldValidator.validate('8441272');
    expect(result, 'Inválido: Debe entrar 9 dígitos. Formato: xxxxxxxxx');
  });

  test('more than 9 digits returns error string', () {
    var result = StudentNumberFieldValidator.validate('84412724012');
    expect(result, 'Inválido: Debe entrar 9 dígitos. Formato: xxxxxxxxx');
  });

  test('correct student number will return null', () {
    var result = StudentNumberFieldValidator.validate('844127240');
    expect(result, null);
  });

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
