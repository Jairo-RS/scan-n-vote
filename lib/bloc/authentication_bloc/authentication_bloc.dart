import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:scan_n_vote/bloc/authentication_bloc/authentication_event.dart';
import 'package:scan_n_vote/bloc/authentication_bloc/authentication_state.dart';
import 'package:scan_n_vote/repositories/user_repository.dart';

// This class verifies all authentication states based on the event that is ocurring
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc({@required this.userRepository})
      : assert(userRepository != null),
        super(AuthenticationUninitialized());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    // All state changes when applications starts for the first time
    if (event is AppStarted) {
      final bool hasToken = await userRepository.hasToken();
      if (hasToken) {
        //If token still present then presents authenticated state
        yield AuthenticationAuthenticated();
      } else {
        //If token not present then presents unauthenticated state
        yield AuthenticationUnauthenticated();
      }
    }
    //When login event occurs store token value and present authentication
    if (event is LoggedIn) {
      yield AuthenticationLoading();
      await userRepository.persistToken(event.token);
      yield AuthenticationAuthenticated();
    }
    // When loggedout event happens delete token values and present
    // unathentication
    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await userRepository.deleteToken();
      yield AuthenticationUnauthenticated();
    }
  }
}
