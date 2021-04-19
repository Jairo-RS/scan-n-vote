import 'package:flutter_test/flutter_test.dart';
import 'package:scan_n_vote/screens/signup/components/signup_body.dart';

//Unit test used to verify validations from all text field
void main() {
  test('title', () {});

  test('empty username return error string', () {
    var result = UsernameFieldValidator.validate('');
    expect(result, 'Please enter your username');
  });

  test('username with less than 6 characters return error string', () {
    var result = UsernameFieldValidator.validate('Jairo');
    expect(result, 'Enter at least 6 characters');
  });

  test('username with invalid special character return error string', () {
    var result = UsernameFieldValidator.validate('Jairo!');
    expect(result, 'Invalid Special Character: Acceptable: @/./_/-/+');
  });

  test('correct username will return null', () {
    var result = UsernameFieldValidator.validate('JairoRS');
    expect(result, null);
  });

  test('empty student number returns error string', () {
    var result = StudentNumberFieldValidator.validate('');
    expect(result, 'Please enter your student number');
  });

  test('character does not match with regular expression returns error string',
      () {
    var result = StudentNumberFieldValidator.validate('8021220c');
    expect(result, 'Must be only digits. Format: xxxxxxxxx');
  });

  test('lowercase letter in student number returns error string', () {
    var result = StudentNumberFieldValidator.validate('abcd');
    expect(result, 'Must be only digits. Format: xxxxxxxxx');
  });

  test('uppercase letter in student number returns error string', () {
    var result = StudentNumberFieldValidator.validate('ABCD');
    expect(result, 'Must be only digits. Format: xxxxxxxxx');
  });

  test('special characters in student number returns error string', () {
    var result = StudentNumberFieldValidator.validate('844!=,.');
    expect(result, 'Must be only digits. Format: xxxxxxxxx');
  });

  test('less than 9 digits returns error string', () {
    var result = StudentNumberFieldValidator.validate('8441272');
    expect(result, 'Invalid: Must enter 9 digits. Format: xxxxxxxxx');
  });

  test('more than 9 digits returns error string', () {
    var result = StudentNumberFieldValidator.validate('84412724012');
    expect(result, 'Invalid: Must enter 9 digits. Format: xxxxxxxxx');
  });

  test('correct student number will return null', () {
    var result = StudentNumberFieldValidator.validate('844127240');
    expect(result, null);
  });

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

  test('empty password confirmation returns error string', () {
    var result = PasswordConfirmationFieldValidator.validate('');
    expect(result, 'Please enter a password');
  });

  test(
      'password confirmation does not contain a lowercase letter returns error string',
      () {
    var result = PasswordConfirmationFieldValidator.validate('TESTING.123');
    expect(result, 'Must contain at least one lowercase character');
  });

  test(
      'password confirmation does not contain an uppercase letter returns error string',
      () {
    var result = PasswordConfirmationFieldValidator.validate('testing.123');
    expect(result, 'Must contain at least one uppercase character');
  });

  test('password confirmation does not contain a digit returns error string',
      () {
    var result = PasswordConfirmationFieldValidator.validate('Testing.EXAM!');
    expect(result, 'Must contain at least one digit');
  });

  test(
      'password confirmation does not contain a special character returns error string',
      () {
    var result = PasswordConfirmationFieldValidator.validate('TestingforExam1');
    expect(result, 'Must contain at least one special character');
  });

  test(
      'password confirmation passes all validations but is less than 8 characters long returns error string',
      () {
    var result = PasswordConfirmationFieldValidator.validate('Test.1');
    expect(result, 'Must be between 8 to 16 characters long');
  });

  test(
      'password confirmation passes all validations but is more than 16 characters long returns error string',
      () {
    var result =
        PasswordConfirmationFieldValidator.validate('Testing.FOR.this,EXAM2');
    expect(result, 'Must be between 8 to 16 characters long');
  });
}
