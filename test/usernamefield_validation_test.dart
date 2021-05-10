import 'package:flutter_test/flutter_test.dart';
import 'package:scan_n_vote/screens/signup/components/signup_body.dart';

//Unit test used to verify username text field validations
void main() {
  test('empty username return error string', () {
    var result = UsernameFieldValidator.validate('');
    expect(result, 'Por favor entre su número de estudiante');
  });

  test('username with less than 8 characters return error string', () {
    var result = UsernameFieldValidator.validate('User');
    expect(result, 'Debe tener entre 8 a 16 caracteres de largo');
  });

  test('username with more than 16 characters return error string', () {
    var result = UsernameFieldValidator.validate('ThisUsername_istoolong');
    expect(result, 'Debe tener entre 8 a 16 caracteres de largo');
  });

  test('username with invalid special character return error string', () {
    var result = UsernameFieldValidator.validate('User!');
    expect(result, 'Carácter especial inválido: Aceptable: @/./_ /-/+');
  });

  test('correct username will return null', () {
    var result = UsernameFieldValidator.validate('UserRS1');
    expect(result, null);
  });
}
