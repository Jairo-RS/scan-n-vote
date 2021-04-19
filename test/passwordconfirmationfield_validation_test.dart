import 'package:flutter_test/flutter_test.dart';
import 'package:scan_n_vote/screens/signup/components/signup_body.dart';

//Unit test to verify password confirmation validations
void main() {
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
