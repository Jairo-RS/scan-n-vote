import 'package:flutter/material.dart';
import 'package:scan_n_vote/repositories/user_repository.dart';
import 'package:scan_n_vote/screens/signup/components/signup_body.dart';

// Class that displays the sign up screen once it is called
class SignUpScreen extends StatelessWidget {
  final UserRepository userRepository;
  SignUpScreen({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

// Builds the sign up screen by calling sign up body
  @override
  Widget build(BuildContext context) {
    // returns a material design visual layout structure
    return Scaffold(
      body: SignUpBody(
        userRepository: userRepository,
      ),
    );
  }
}
