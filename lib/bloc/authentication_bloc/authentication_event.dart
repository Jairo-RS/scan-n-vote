import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

//Class that contains all the login events
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final String token;
  final String user;

  const LoggedIn({@required this.token, @required this.user});

  //Used to determine if token is equal to the present value
  @override
  List<Object> get props => [token, user];

  //Print Logged in event and stored token
  @override
  String toString() => 'LoggedIn { token: $token , user: $user }';
}

class LoggedOut extends AuthenticationEvent {}
