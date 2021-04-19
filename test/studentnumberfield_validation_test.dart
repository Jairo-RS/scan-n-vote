import 'package:flutter_test/flutter_test.dart';
import 'package:scan_n_vote/screens/signup/components/signup_body.dart';

void main() {
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
}
