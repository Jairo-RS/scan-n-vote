import 'package:flutter_test/flutter_test.dart';
import 'package:scan_n_vote/screens/signup/components/signup_body.dart';

void main() {
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
}
