import 'package:flutter/material.dart';
import 'package:scan_n_vote/models/assemblies_model.dart';
import 'package:scan_n_vote/repositories/user_repository.dart';
import 'package:scan_n_vote/screens/motions/components/motions_body.dart';

class MotionsScreen extends StatelessWidget {
  final UserRepository userRepository;
  final Assemblies currentAssembly;

  MotionsScreen(
      {Key key, @required this.userRepository, @required this.currentAssembly})
      : assert(userRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MotionsBody(
        userRepository: userRepository,
        currentAssembly: currentAssembly,
      ),
    );
  }
}
