import 'package:flutter/material.dart';
import 'package:scan_n_vote/models/assemblies_model.dart';
import 'package:scan_n_vote/repositories/user_repository.dart';
import 'package:scan_n_vote/screens/results/components/results_body.dart';

class ResultsScreen extends StatelessWidget {
  final UserRepository userRepository;
  final Assemblies currentAssembly;
  ResultsScreen(
      {Key key, @required this.userRepository, @required this.currentAssembly})
      : assert(userRepository != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResultsBody(
        userRepository: userRepository,
        currentAssembly: currentAssembly,
      ),
    );
  }
}
