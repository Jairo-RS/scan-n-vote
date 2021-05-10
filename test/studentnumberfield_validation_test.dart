import 'package:flutter_test/flutter_test.dart';
import 'package:scan_n_vote/screens/signup/components/signup_body.dart';

//Unit test used to verify student number text field validations
void main() {
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
    expect(result, 'Debe solo entrar dígitos. Formato: xxxxxxxxx');
  });

  test('more than 9 digits returns error string', () {
    var result = StudentNumberFieldValidator.validate('84412724012');
    expect(result, 'Debe solo entrar dígitos. Formato: xxxxxxxxx');
  });

  test('correct student number will return null', () {
    var result = StudentNumberFieldValidator.validate('844127240');
    expect(result, null);
  });
}
