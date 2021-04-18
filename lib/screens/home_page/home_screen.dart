import 'package:flutter/material.dart';
import 'package:scan_n_vote/repositories/user_repository.dart';
import 'package:scan_n_vote/screens/home_page/components/home_body.dart';

class HomeScreen extends StatelessWidget {
  final UserRepository userRepository;
  HomeScreen({Key key, @required this.userRepository}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeBody(
        userRepository: userRepository,
      ),
    );
  }
}
