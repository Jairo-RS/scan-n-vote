import 'package:flutter/material.dart';
import 'package:scan_n_vote/repositories/user_repository.dart';
import 'package:scan_n_vote/screens/assemblies/components/assemblies_body.dart';

class AssembliesScreen extends StatelessWidget {
  final UserRepository userRepository;

  AssembliesScreen({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AssembliesBody(
        userRepository: userRepository,
      ),
    );
  }
}
