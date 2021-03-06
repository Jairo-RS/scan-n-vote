import 'package:flutter/material.dart';
import 'package:scan_n_vote/models/assemblies_model.dart';
import 'package:scan_n_vote/repositories/user_repository.dart';
import 'package:scan_n_vote/screens/voting/components/voting_body.dart';

class VotingScreen extends StatelessWidget {
  final UserRepository userRepository;
  final Assemblies currentAssembly;
  VotingScreen(
      {Key key, @required this.userRepository, @required this.currentAssembly})
      : assert(userRepository != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VotingBody(
        userRepository: userRepository,
        currentAssembly: currentAssembly,
      ),
    );
  }
}
