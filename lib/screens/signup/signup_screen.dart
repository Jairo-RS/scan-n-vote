import 'package:flutter/material.dart';
import 'package:scan_n_vote/repositories/user_repository.dart';
import 'package:scan_n_vote/screens/signup/components/signup_body.dart';

class SignUpScreen extends StatelessWidget {
  final UserRepository userRepository;
  SignUpScreen({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignUpBody(
        userRepository: userRepository,
      ),
    );
  }
}
