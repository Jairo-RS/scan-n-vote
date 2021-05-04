import 'dart:convert' show utf8;

import 'package:flutter/material.dart';
import 'package:scan_n_vote/models/assemblies_model.dart';

class PastAssembliesDetailsScreen extends StatelessWidget {
  final Assemblies pastAssembly;

  const PastAssembliesDetailsScreen({Key key, @required this.pastAssembly})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            pastAssembly.assemblyName,
            style: TextStyle(fontSize: 26),
          ),
          centerTitle: true,
          bottom: TabBar(
            labelStyle: TextStyle(fontSize: 16),
            tabs: <Widget>[
              Tab(
                text: "Motions",
              ),
              Tab(
                text: "Agenda",
              ),
              Tab(
                text: "Quorum",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(
              child: Text('Test: Motions'),
            ),
            Center(
              child: Text(
                "Agenda:\n\n" + utf8.decode(utf8.encode(pastAssembly.agenda)),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Text(
                "The quorum for this assembly was: " +
                    pastAssembly.quorum.toString(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
