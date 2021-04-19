import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scan_n_vote/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:scan_n_vote/bloc/authentication_bloc/authentication_event.dart';
import 'package:scan_n_vote/bloc/authentication_bloc/authentication_state.dart';
import 'package:scan_n_vote/constants.dart';
import 'package:scan_n_vote/repositories/user_repository.dart';
import 'package:scan_n_vote/screens/assemblies/assemblies_screen.dart';
import 'package:scan_n_vote/screens/initial/initial_screen.dart';
import 'constants.dart';

// Class that helps display the transitions, events, and errors
class SimpleBlocDelegate extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}

//Main class that starts the application
void main() {
  Bloc.observer = SimpleBlocDelegate();
  final userRepository = UserRepository();
  runApp(
    BlocProvider(
      create: (context) {
        return AuthenticationBloc(userRepository: userRepository)
          ..add(AppStarted());
      },
      child: MyApp(userRepository: userRepository),
    ),
  );
}

//App class displays the application when it is started
class MyApp extends StatelessWidget {
  final UserRepository userRepository;

  MyApp({Key key, @required this.userRepository}) : super(key: key);

  // TO LOGIN:
  // username: eve.holt@reqres.in
  // password: cityslicka

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scan-N-Vote',
      theme: ThemeData(
        primaryColor: Colors.green,
        scaffoldBackgroundColor: backdropColor,
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          // If current state is authenticated, then display Assemblies screen
          if (state is AuthenticationAuthenticated) {
            return AssembliesScreen(userRepository: userRepository);
          }
          // If current state is unauthenticated, then display Initial screen
          if (state is AuthenticationUnauthenticated) {
            return InitialScreen(userRepository: userRepository);
          }
          // Loading state will display loading indicators
          if (state is AuthenticationLoading) {
            return Scaffold(
              body: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 25.0,
                      width: 25.0,
                      child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.blue),
                        strokeWidth: 4.0,
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          return Scaffold(
            body: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 25.0,
                    width: 25.0,
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.blue),
                      strokeWidth: 4.0,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
