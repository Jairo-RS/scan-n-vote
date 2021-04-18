import 'package:flutter/material.dart';
import 'package:scan_n_vote/repositories/user_repository.dart';
import 'package:scan_n_vote/screens/waiting/components/waiting_body.dart';

class WaitingScreen extends StatelessWidget {
  final UserRepository userRepository;
  WaitingScreen({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WaitingBody(
        userRepository: userRepository,
      ),
    );
  }
}
