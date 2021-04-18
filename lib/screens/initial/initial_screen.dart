import 'package:flutter/material.dart';
import 'package:scan_n_vote/repositories/user_repository.dart';
import 'package:scan_n_vote/screens/initial/components/initial_body.dart';

class InitialScreen extends StatelessWidget {
  final UserRepository userRepository;
  InitialScreen({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InitialBody(
        userRepository: userRepository,
      ),
    );
  }
}
