part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent {
  final String username;
  // final String email;
  final String password;

  const LoginButtonPressed({
    @required this.username,
    // @required this.email,
    @required this.password,
  });

  @override
  // List<Object> get props => [email, password];
  List<Object> get props => [username, password];

  @override
  String toString() =>
      'LoginButtonPressed { email: $username, password: $password }';
}
